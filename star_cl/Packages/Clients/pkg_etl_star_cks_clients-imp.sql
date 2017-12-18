CREATE OR REPLACE PACKAGE body pkg_clients_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_clients_cls
  Contents...........:   load clients in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_clients_star_cls
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients__starcls' ) ;
  type obj_nt
IS
  TABLE OF star_cls_Clients%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 20000; -- with 5000 - 458 sec, 10000 - 250 sec, 20000 - 164 sec!
BEGIN

  --EXECUTE IMMEDIATE 'truncate table cls_clients';

   SELECT   c_pers.ID_SRC
    , c_pers.GIVENNAME
    , c_pers.SURNAME
    , c_pers.STATE_CODE
    , c_st.STATE_NAME
    , c_con.COUNTRY
    , c_pers.EMAIL
    , c_pers.AGE
    , c_pers.GROUP_CARD_ID
    , c_pers.PRC_BONUS
    , c_div.CENSUS_DIVISION
    , c_div.CENSUS_DIVISION_NAME
    , c_reg.CENSUS_REGION
    , c_reg.CENSUS_REGION_NAME BULK COLLECT
       INTO l_objects
       FROM u_3nf.t_clients_country c_con
    , u_3nf.t_clients_census_region c_reg
    , u_3nf.t_clients_census_division c_div
    , u_3nf.t_clients_state_inf c_st
    , u_3nf.t_clients_personal c_pers
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
       INTO star_cls_clients VALUES
      (
        l_objects ( x ) .ID_SRC
      , l_objects ( x ) .GIVENNAME
      , l_objects ( x ) .SURNAME
      , l_objects ( x ) .STATE_CODE
      , l_objects ( x ) .STATE_NAME
      , l_objects ( x ) .COUNTRY
      , l_objects ( x ) .EMAIL
      , l_objects ( x ) .AGE
      , l_objects ( x ) .GROUP_CARD_ID
      , l_objects ( x ) .PRC_BONUS
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

END load_clients_star_cls ;

END pkg_clients_star_cls;
--exec pkg_clients_star_cls.load_clients_star_cls;
--select count(*) from cls_clients;
