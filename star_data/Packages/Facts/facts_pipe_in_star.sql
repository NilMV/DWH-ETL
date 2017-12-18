CREATE OR REPLACE PROCEDURE load_facts_parallel
IS
  start_date DATE;
  end_date   DATE ;
BEGIN
  start_date := TO_DATE ( '01-JAN-2015', 'dd-MON-yyyy' ) ;
  end_date := TO_DATE ( '31-DEC-2016', 'dd-MON-yyyy' ) ;
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

   INSERT
      /*+ PARALLEL(t, 2) */
       INTO fct_sales_f t
      (
        id_src
      , employee_id
      , client_id
      , position_id
      , restaurant_id
      , group_id
      , time_id
      , amount
      , TIMESTMP
      )
      (SELECT   id_src
          , employee_id
          , client_id
          , position_id
          , restaurant_id
          , group_id
          , time_id
          , amount
          , TIMESTMP
             FROM TABLE ( get_facts_p ( CURSOR
            (SELECT
                /*+ PARALLEL(s, 2) */
                id_src
              , employee_id
              , client_id
              , position_id
              , restaurant_id
              , group_id
              , time_id
              , amount
              , TIMESTMP
                 FROM u_src.src_facts_2
                WHERE TIMESTMP BETWEEN start_date AND end_date
            ) ) )
      ) ;
  COMMIT;

END load_facts_parallel;
/
EXEC load_facts_parallel;



--creating type

--DROP type fact_tab ;

--DROP type fact_row ;

CREATE type fact_row
AS
  OBJECT
  (
    ID_SRC        NUMBER,
    EMPLOYEE_ID   NUMBER,
    CLIENT_ID     NUMBER,
    POSITION_ID   NUMBER,
    RESTAURANT_ID NUMBER,
    GROUP_ID      NUMBER,
    TIME_ID       NUMBER,
    AMOUNT        NUMBER,
    TIMESTMP      TIMESTAMP ) ;
  /
  --creating type

CREATE type fact_tab
AS
  TABLE OF fact_row ;
  /

CREATE OR REPLACE FUNCTION get_facts_p (
  p_cur sys_refcursor )
RETURN fact_tab pipelined
IS
  ID_SRC        NUMBER ;
  EMPLOYEE_ID   NUMBER ;
  CLIENT_ID     NUMBER ;
  POSITION_ID   NUMBER ;
  RESTAURANT_ID NUMBER ;
  GROUP_ID      NUMBER;
  TIME_ID       NUMBER;
  AMOUNT        NUMBER;
  TIMESTMP      TIMESTAMP;
BEGIN
  LOOP

    FETCH p_cur
         INTO id_src
      , employee_id
      , client_id
      , position_id
      , restaurant_id
      , group_id
      , time_id
      , amount
      , TIMESTMP;
    EXIT
  WHEN p_cur%NOTFOUND;
    pipe row ( fact_row ( id_src, employee_id, client_id, position_id, restaurant_id, group_id, time_id, amount, TIMESTMP ) ) ;
    -- pipe row ( distinct_rate_row( rate_id, TRIM ( UPPER ( rate ) ), cost_per_first_mile, cost_per_next_mile ) ) ;

  END LOOP;

END ;
/


"CHAIN_LOG_ID="22268", STEP_NAME="DIM_EMPLOYEES", ORA-04036: PGA memory used by the instance exceeds PGA_AGGREGATE_LIMIT
ORA-06512: at "U_STAR.PKG_EMPLOYEES_DIM", line 89
"

CHAIN_LOG_ID="22268",STEP_NAME="T_CLNT_PERS", ORA-27457: argument 3 of job "SYS"."NU_DAVAI_JOB" has no value