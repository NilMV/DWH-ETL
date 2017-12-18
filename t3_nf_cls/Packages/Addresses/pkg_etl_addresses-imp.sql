CREATE OR REPLACE PACKAGE body pkg_addresses_cls
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
  PROCEDURE load_cls_addresses
  IS
    c_procedure_name    CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_cls_addresses' ) ;
    v_addr_parse_string VARCHAR2 ( 200 ) ;
    v_array apex_application_global.vc_arr2;
  type obj_nt
IS
  TABLE OF cls_Addresses%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 5000;
BEGIN
  EXECUTE IMMEDIATE 'truncate table cls_addresses';

   SELECT * BULK COLLECT INTO l_objects FROM u_src.src_Addresses ;

  FORALL x IN l_objects.First..l_objects.count

   INSERT
       INTO cls_addresses VALUES
      (
        l_objects ( x ) .id_src
      , l_objects ( x ) .NAME
      , l_objects ( x ) .GROUP_NAME
      , l_objects ( x ) .ADDRESS
      , l_objects ( x ) .TELEPHONE
      , l_objects ( x ) .COUNTRY
      , l_objects ( x ) .CITY
      , l_objects ( x ) .STATE_CODE
      , l_objects ( x ) .STATE_NAME
      , l_objects ( x ) .CENSUS_REGION
      , l_objects ( x ) .CENSUS_REGION_NAME
      , l_objects ( x ) .CENSUS_DIVISION
      , l_objects ( x ) .CENSUS_DIVISION_NAME
      ) ;
  -- FETCH get_address bulk collect INTO l_objects;
  COMMIT;
  NULL;

EXCEPTION

WHEN OTHERS THEN
  err_log ( ) ;
  RAISE;

END load_cls_addresses ;

END pkg_addresses_cls;
--exec PKG_addresses_cls.LOAD_cls_addresses;
--select * from cls_addresses; 