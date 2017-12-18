CREATE OR REPLACE PACKAGE body pkg_menu_3nf
AS
  /**===============================================*\
  Name...............:   pkg_menu_3nf
  Contents...........:   load menu in 3nf tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  /****************************************************/
  PROCEDURE load_menu_3nf
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_menu_3nf' ) ;
  BEGIN

     UPDATE t_menu
      SET is_valid = 'N'
        WHERE id_src NOT IN
        ( SELECT id_src FROM u_3nf_cl.cls_menu
        ) ;

    merge INTO t_menu t USING
    ( SELECT id_src, group_name, position_name, price FROM u_3nf_cl.cls_menu
    ) cls ON
    (
      t.id_src = cls.id_src
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        (
          id_src
        , group_name
        , position_name
        , price
        , IS_VALID
        )
        VALUES
        (
          cls.id_src
        , cls.group_name
        , cls.position_name
        , cls.price
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_menu_3nf;

END pkg_menu_3nf;
--EXEC pkg_menu_3nf.load_menu_3nf;
--SELECT * FROM T_menu;
