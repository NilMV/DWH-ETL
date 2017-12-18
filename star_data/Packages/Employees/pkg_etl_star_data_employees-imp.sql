CREATE OR REPLACE PACKAGE body pkg_employees_dim
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
  PROCEDURE load_employees_dim
  IS

    CURSOR c_emps
    IS

       SELECT   *
           FROM
          (SELECT   nvl2 ( scl.id_src, scl.id_src, dim.id_src )                                     AS id_src
            , nvl2 ( scl.givenname, scl.givenname, dim.givenname )                                  AS givenname
            , nvl2 ( scl.surname, scl.surname, dim.surname )                                        AS surname
            , nvl2 ( scl.state_code, scl.state_code, dim.state_code )                               AS state_code
            , nvl2 ( scl.state_name, scl.state_name, dim.state_name )                               AS state_name
            , nvl2 ( scl.country, scl.country, dim.country )                                        AS country
            , nvl2 ( scl.email, scl.email, dim.email )                                              AS email
            , nvl2 ( scl.age, scl.age, dim.age )                                                    AS age
            , nvl2 ( scl.salary, scl.salary, dim.salary )                                           AS salary
            , nvl2 ( scl.prc_bonus_to_salary, scl.prc_bonus_to_salary, dim.prc_bonus_to_salary )    AS prc_bonus_to_salary
            , nvl2 ( scl.ccnumber, scl.ccnumber, dim.ccnumber )                                     AS ccnumber
            , nvl2 ( scl.cctype, scl.cctype, dim.cctype )                                           AS cctype
            , nvl2 ( scl.census_region, scl.census_region, dim.census_region )                      AS census_region
            , nvl2 ( scl.census_region_name, scl.census_region_name, dim.census_region_name )       AS census_region_name
            , nvl2 ( scl.census_division, scl.census_division, dim.census_division )                AS census_division
            , nvl2 ( scl.census_division_name, scl.census_division_name, dim.census_division_name ) AS census_division_name
            , CASE
                WHEN scl.id_src IS NOT NULL
                  AND dim.id_src IS NULL
                THEN 'I'
                WHEN scl.id_src IS NULL
                  AND dim.id_src IS NOT NULL
                THEN 'D'
                WHEN scl.id_src IS NOT NULL
                  AND dim.id_src IS NOT NULL
                  AND
                  (
                    DECODE ( scl.givenname, dim.surname, 0, 1 ) = 1
                    OR DECODE ( scl.surname, dim.surname, 0, 1 ) = 1
                    OR DECODE ( scl.state_code, dim.state_code, 0, 1 ) = 1
                    OR DECODE ( scl.state_name, dim.state_name, 0, 1 ) = 1
                    OR DECODE ( scl.country, dim.country, 0, 1 ) = 1
                    OR DECODE ( scl.email, dim.email, 0, 1 ) = 1
                    OR DECODE ( scl.age, dim.age, 0, 1 ) = 1
                    OR DECODE ( scl.SALARY, dim.SALARY, 0, 1 ) = 1
                    OR DECODE ( scl.PRC_BONUS_TO_SALARY, dim.PRC_BONUS_TO_SALARY, 0, 1 ) = 1
                    OR DECODE ( scl.CCNUMBER, dim.CCNUMBER, 0, 1 ) = 1
                    OR DECODE ( scl.CCTYPE, dim.CCTYPE, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_REGION, dim.CENSUS_REGION, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_REGION_NAME, dim.CENSUS_REGION_NAME, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_DIVISION, dim.CENSUS_DIVISION, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_DIVISION_NAME, dim.CENSUS_DIVISION_NAME, 0, 1 ) = 1
                  )
                THEN 'U'
                ELSE 'N'
              END AS flag
               FROM u_star_cl.star_cls_employees scl
            FULL OUTER JOIN dim_employees dim
                 ON
              (
                scl.id_src = dim.id_src
              )
          )
        WHERE flag <> 'N';

  type emps_nt
IS
  TABLE OF c_emps%ROWTYPE;
type emp_id_nt
IS
  TABLE OF pls_integer;
  l_emps emps_nt := emps_nt ( ) ;
  emp_id_ins emp_id_nt := emp_id_nt ( ) ;
  emp_id_del emp_id_nt := emp_id_nt ( ) ;
  emp_id_upd emp_id_nt := emp_id_nt ( ) ;
BEGIN
  OPEN c_emps;
  LOOP

  FETCH c_emps bulk collect INTO l_emps LIMIT 1000000;
      EXIT
  WHEN l_emps.count = 0;



  FOR i IN 1..l_emps.count
  LOOP

    IF l_emps ( i ) .flag = 'I' THEN
      emp_id_ins.extend;
      emp_id_ins ( emp_id_ins.count ) := i;

    elsif l_emps ( i ) .flag = 'D' THEN
      emp_id_del.extend;
      emp_id_del ( emp_id_del.count ) := i;

    ELSE
      emp_id_upd.extend;
      emp_id_upd ( emp_id_upd.count ) := i;

    END IF;

  END LOOP;
forall i IN VALUES OF emp_id_ins

 INSERT
     INTO dim_employees
    (
      ID_SRC
    , GIVENNAME
    , SURNAME
    , STATE_CODE
    , STATE_NAME
    , COUNTRY
    , EMAIL
    , AGE
    , SALARY
    , PRC_BONUS_TO_SALARY
    , CCNUMBER
    , CCTYPE
    , CENSUS_REGION
    , CENSUS_REGION_NAME
    , CENSUS_DIVISION
    , CENSUS_DIVISION_NAME
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_emps ( i ) .id_src
    , l_emps ( i ) .givenname
    , l_emps ( i ) .surname
    , l_emps ( i ) .state_code
    , l_emps ( i ) .state_name
    , l_emps ( i ) .country
    , l_emps ( i ) .email
    , l_emps ( i ) .age
    , l_emps ( i ) .SALARY
    , l_emps ( i ) .PRC_BONUS_TO_SALARY
    , l_emps ( i ) .CCNUMBER
    , l_emps ( i ) .CCTYPE
    , l_emps ( i ) .census_region
    , l_emps ( i ) .census_region_name
    , l_emps ( i ) .census_division
    , l_emps ( i ) .census_division_name
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;

forall i IN VALUES OF emp_id_del

 DELETE FROM dim_employees WHERE id_src = l_emps ( i ) .id_src;

forall i IN VALUES OF emp_id_upd

 UPDATE dim_employees
  SET givenname = l_emps ( i ) .givenname
  , surname = l_emps ( i ) .surname
  , state_code = l_emps ( i ) .state_Code
  , state_name = l_emps ( i ) .state_name
  , country = l_emps ( i ) .country
  , email = l_emps ( i ) .email
  , age = l_emps ( i ) .age
  , salary = l_emps ( i ) .salary
  , prc_bonus_to_salary = l_emps ( i ) .prc_bonus_to_salary
  , ccnumber = l_emps ( i ) .ccnumber
  , cctype = l_emps ( i ) .cctype
  , census_region = l_emps ( i ) .census_region
  , census_region_name = l_emps ( i ) .census_region_name
  , census_division = l_emps ( i ) .census_division
  , census_division_name = l_emps ( i ) .census_division_name
  , end_date = sysdate
  , is_current = 'invalide'
    WHERE id_src = l_emps ( i ) .id_src;

forall i IN VALUES OF emp_id_upd

 INSERT
     INTO dim_employees
    (
      ID_SRC
    , GIVENNAME
    , SURNAME
    , STATE_CODE
    , STATE_NAME
    , COUNTRY
    , EMAIL
    , AGE
    , SALARY
    , PRC_BONUS_TO_SALARY
    , CCNUMBER
    , CCTYPE
    , CENSUS_REGION
    , CENSUS_REGION_NAME
    , CENSUS_DIVISION
    , CENSUS_DIVISION_NAME
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_emps ( i ) .id_src
    , l_emps ( i ) .givenname
    , l_emps ( i ) .surname
    , l_emps ( i ) .state_code
    , l_emps ( i ) .state_name
    , l_emps ( i ) .country
    , l_emps ( i ) .email
    , l_emps ( i ) .age
    , l_emps ( i ) .salary
    , l_emps ( i ) .prc_bonus_to_salary
    , l_emps ( i ) .ccnumber
    , l_emps ( i ) .cctype
    , l_emps ( i ) .census_region
    , l_emps ( i ) .census_region_name
    , l_emps ( i ) .census_division
    , l_emps ( i ) .census_division_name
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;
    END LOOP;
  CLOSE c_emps;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
err_log ( ) ;
RAISE;

END load_employees_dim;

END pkg_employees_dim;
--exec pkg_employees_dim.load_employees_dim;
--select count(*) from dim_employees;
