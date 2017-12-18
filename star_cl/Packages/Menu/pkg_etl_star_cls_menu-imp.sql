CREATE OR REPLACE PACKAGE body pkg_menu_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_addresses_cls
  Contents...........:   load in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_star_cls_menu
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_menu_starcls' ) ;
  type obj_nt
IS
  TABLE OF u_star_cl.star_cls_menu%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 20000; -- with 5000 - 458 sec, 10000 - 250 sec, 20000 - 164 sec!
BEGIN

  --EXECUTE IMMEDIATE 'truncate table cls_employees';

   SELECT   ID_SRC
    , GROUP_NAME
    , position_name
    , price BULK COLLECT
       INTO l_objects
       FROM u_3nf.t_menu
      WHERE t_menu.is_valid = 'Y' ;

  FORALL x IN l_objects.First..l_objects.count

   INSERT
       INTO star_cls_menu VALUES
      (
        l_objects ( x ) .ID_SRC
      , l_objects ( x ) .GROUP_NAME
      , l_objects ( x ) .POSITION_NAME
      , l_objects ( x ) .PRICE
      ) ;
  -- FETCH get_address bulk collect INTO l_objects;
  COMMIT;
  NULL;
  --  EXCEPTION
  --WHEN OTHERS THEN
  -- err_log ( ) ;
  --  RAISE;

END load_star_cls_menu ;

END pkg_menu_star_cls;
--exec pkg_menu_star_cls.load_star_cls_menu;
