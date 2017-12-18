CREATE OR REPLACE PACKAGE body pkg_employees_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_employees_cls
  Contents...........:   load employees in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_employees_star_cls
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_employees__starcls' ) ;
  type obj_nt
IS
  TABLE OF star_cls_employees%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 20000; -- with 5000 - 458 sec, 10000 - 250 sec, 20000 - 164 sec!
BEGIN

  --EXECUTE IMMEDIATE 'truncate table cls_employees';

   SELECT   e_pers.ID_SRC
    , e_pers.GIVENNAME
    , e_pers.SURNAME
    , e_pers.STATE_CODE
    , e_st.STATE_NAME
    , e_con.COUNTRY
    , e_pers.EMAIL
    , e_pers.AGE
    , e_pers.SALARY
    , e_pers.PRC_BONUS_TO_SALARY
    , e_pers.CCNUMBER
    , e_pers.CCTYPE
    , e_div.CENSUS_DIVISION
    , e_div.CENSUS_DIVISION_NAME
    , e_reg.CENSUS_REGION
    , e_reg.CENSUS_REGION_NAME BULK COLLECT
       INTO l_objects
       FROM u_3nf.t_employees_country e_con
    , u_3nf.t_employees_census_region e_reg
    , u_3nf.t_employees_census_division e_div
    , u_3nf.t_employees_state_inf e_st
    , u_3nf.t_employees_personal e_pers
      WHERE e_con.country = e_reg.country
      AND e_div.census_region = e_reg.census_region
      AND e_div.census_division = e_st.census_division
      AND e_st.state_code = e_pers.state_code
      AND e_con.is_valid = 'Y'
      AND e_reg.is_valid = 'Y'
      AND e_div.is_valid = 'Y'
      AND e_st.is_valid = 'Y'
      AND e_pers.is_valid = 'Y' ;

  FORALL x IN l_objects.First..l_objects.count

   INSERT
       INTO star_cls_employees VALUES
      (
        l_objects ( x ) .ID_SRC
      , l_objects ( x ) .GIVENNAME
      , l_objects ( x ) .SURNAME
      , l_objects ( x ) .STATE_CODE
      , l_objects ( x ) .STATE_NAME
      , l_objects ( x ) .COUNTRY
      , l_objects ( x ) .EMAIL
      , l_objects ( x ) .AGE
      , l_objects ( x ) .SALARY
      , l_objects ( x ) .PRC_BONUS_TO_SALARY
      , l_objects ( x ) .CCNUMBER
      , l_objects ( x ) .CCTYPE
      , l_objects ( x ) .CENSUS_REGION
      , l_objects ( x ) .CENSUS_REGION_NAME
      , l_objects ( x ) .CENSUS_DIVISION
      , l_objects ( x ) .CENSUS_DIVISION_NAME
      ) ;
  -- FETCH get_address bulk collect INTO l_objects;
  COMMIT;
  NULL;
  --  EXCEPTION
  --WHEN OTHERS THEN
  -- err_log ( ) ;
  --  RAISE;

END load_employees_star_cls ;

END pkg_employees_star_cls;
--EXEC pkg_employees_star_cls.load_employees_star_cls;