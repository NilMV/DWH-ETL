CREATE OR REPLACE PACKAGE body pkg_groups_3nf
AS
  /**===============================================*\
  Name...............:   pkg_groups_3nf
  Contents...........:   load groups in t tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  /****************************************************/
  PROCEDURE load_groups_3nf
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_groups_3nf' ) ;
  BEGIN

     UPDATE t_groups
      SET is_valid = 'N'
        WHERE id_src NOT IN
        ( SELECT id_src FROM u_3nf_cl.cls_groups
        ) ;

    merge INTO t_groups t USING
    ( SELECT id_src, group_name FROM u_3nf_cl.cls_groups
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
        , IS_VALID
        )
        VALUES
        (
          cls.id_src
        , cls.group_name
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_groups_3nf;

END pkg_groups_3nf;
--exec pkg_groups_3nf.load_groups_3nf;
--select * from T_groups;
