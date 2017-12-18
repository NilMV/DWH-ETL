CREATE OR REPLACE PACKAGE body pkg_employees_cls
AS
  /**===============================================*\
  Name...............:   pkg_employee_cls
  Contents...........:   load employees in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_employees_cls
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_employees_cls' ) ;
  type obj_nt
IS
  TABLE OF cls_Employees%ROWTYPE;
  l_objects obj_nt;
  fetch_size NUMBER := 20000; -- with 5000 - 458 sec, 10000 - 250 sec, 20000 - 164 sec!

  CURSOR employees
  IS

     SELECT
        /*+ PARALLEL(c,2) */
        ID_SRC
      , trim ( GIVENNAME )
      , trim ( SURNAME )
      , trim ( EMP_STATE_CODE )
      , trim ( EMP_STATE_NAME )
      , trim ( EMP_COUNTRY )
      , trim ( EMAILADDRESS )
      , trim ( AGE )
      , trim ( SALARY )
      , trim ( PRC_BONUS_TO_SALARY )
      , trim ( CCNUMBER )
      , trim ( CCTYPE )
      , trim ( STANDARD_FEDERAL_REGION )
      , trim ( CENSUS_REGION )
      , trim ( CENSUS_REGION_NAME )
      , trim ( CENSUS_DIVISION )
      , trim ( CENSUS_DIVISION_NAME )
        --BULK COLLECT INTO l_objects
         FROM u_src.src_employees cl ;
BEGIN
  EXECUTE IMMEDIATE 'truncate table cls_employees';
  OPEN employees;
  LOOP

    FETCH employees BULK COLLECT INTO l_objects LIMIT 1000000;
    EXIT
  WHEN l_objects.count = 0;
    FORALL x IN l_objects.First..l_objects.count

     INSERT
         INTO cls_employees VALUES
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
        , l_objects ( x ) .STANDARD_FEDERAL_REGION
        , l_objects ( x ) .CENSUS_REGION
        , l_objects ( x ) .CENSUS_REGION_NAME
        , l_objects ( x ) .CENSUS_DIVISION
        , l_objects ( x ) .CENSUS_DIVISION_NAME
        ) ;

  END LOOP;
CLOSE employees;
-- FETCH get_address bulk collect INTO l_objects;
COMMIT;
NULL;

EXCEPTION

WHEN OTHERS THEN
  err_log ( ) ;
  RAISE;

END load_employees_cls ;

END pkg_employees_cls;
--exec pkg_employees_cls.load_employees_cls;
--select count(*) from cls_clients;