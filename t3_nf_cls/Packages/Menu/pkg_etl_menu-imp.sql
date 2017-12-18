CREATE OR REPLACE PACKAGE body pkg_menu_cls
AS
  /**===============================================*\
  Name...............:   pkg_menu_cls
  Contents...........:   load in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_cls_menu
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_cls_menu' ) ;

    CURSOR get_menu
    IS

       SELECT * FROM u_src.src_menu ;

  type obj_nt
IS
  TABLE OF cls_menu%ROWTYPE;
  l_objects obj_nt;
  --fetch_size NUMBER := 5000;
  /* v_addr_parse_string varchar2(200);
  v_array apex_application_global.vc_arr2;
  type obj_nt IS TABLE OF cls_Addresses%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 5000;
  */
BEGIN
  EXECUTE IMMEDIATE 'truncate table cls_menu';
  /*cursor for menu*/
  OPEN get_menu;

  FETCH get_menu bulk collect INTO l_objects;

  CLOSE get_menu;
  forall i IN 1..l_objects.count

   INSERT
       INTO cls_Menu VALUES
      (
        l_objects ( i ) .id_src
      , l_objects ( i ) .GROUP_NAME
      , l_objects ( i ) .POSITION_NAME
      , l_objects ( i ) .PRICE
      ) ;
  COMMIT;

EXCEPTION

WHEN OTHERS THEN
  err_log ( ) ;
  RAISE;

END load_cls_menu ;

END pkg_menu_cls;
--EXEC pkg_menu_cls.load_cls_menu;
