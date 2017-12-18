CREATE OR REPLACE PACKAGE body pkg_rest_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_rest_cls
  Contents...........:   load rest in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_rest_star_cls
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_rest__starcls' ) ;
  type obj_nt
IS
  TABLE OF star_cls_rest%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 20000; -- with 5000 - 458 sec, 10000 - 250 sec, 20000 - 164 sec!
BEGIN

  --EXECUTE IMMEDIATE 'truncate table cls_rest';

   SELECT
      /*+ PARALLEL(c,2) */
      c_pers.ID_SRC
    , c_pers.NAME
    , c_pers.GROUP_NAME
    , c_pers.ADDRESS
    , c_pers.TELEPHONE
    , c_con.COUNTRY
    , c_pers.CITY
    , c_pers.STATE_CODE
    , c_st.STATE_NAME
    , c_div.CENSUS_DIVISION
    , c_div.CENSUS_DIVISION_NAME
    , c_reg.CENSUS_REGION
    , c_reg.CENSUS_REGION_NAME BULK COLLECT
       INTO l_objects
       FROM u_3nf.t_rest_country c_con
    , u_3nf.t_rest_census_region c_reg
    , u_3nf.t_rest_census_division c_div
    , u_3nf.t_rest_state_inf c_st
    , u_3nf.t_rest_personal c_pers
      WHERE c_con.country = c_reg.country
      AND c_div.census_region = c_reg.census_region
      AND c_div.census_division = c_st.census_division
      AND c_st.state_code = c_pers.state_code
      AND c_con.is_valid = 'Y'
      AND c_reg.is_valid = 'Y'
      AND c_div.is_valid = 'Y'
      AND c_st.is_valid = 'Y'
      AND c_pers.is_valid = 'Y' ;

  FORALL x IN l_objects.First..l_objects.count

   INSERT
       INTO star_cls_rest VALUES
      (
        l_objects ( x ) .ID_SRC
      , l_objects ( x ) .NAME
      , l_objects ( x ) .GROUP_NAME
      , l_objects ( x ) .ADDRESS
      , l_objects ( x ) .TELEPHONE
      , l_objects ( x ) .COUNTRY
      , l_objects ( x ) .CITY
      , l_objects ( x ) .STATE_CODE
      , l_objects ( x ) .STATE_NAME
      , l_objects ( x ) .CENSUS_DIVISION
      , l_objects ( x ) .CENSUS_DIVISION_NAME
      , l_objects ( x ) .CENSUS_REGION
      , l_objects ( x ) .CENSUS_REGION_NAME
      ) ;
  -- FETCH get_address bulk collect INTO l_objects;
  COMMIT;
  NULL;
  --  EXCEPTION
  --WHEN OTHERS THEN
  -- err_log ( ) ;
  --  RAISE;

END load_rest_star_cls ;

END pkg_rest_star_cls;
--exec pkg_rest_star_cls.load_rest_star_cls;
--select count(*) from cls_rest;
