 SELECT   gr_nm
  , YEAR
  , SUM ( amount_sold ) AS amount_sold
     FROM
    (SELECT   f.group_id          AS gr_id
      , dim_group.group_name      AS gr_nm
      , dim_time.year_value       AS YEAR
      , f.amount * dim_menu.price AS amount_sold
         FROM fct_sales_f f
      , dim_group
      , dim_time
      , dim_menu
        WHERE f.group_id = dim_group.group_id
        AND f.time_id = dim_time.time_id
        AND f.position_id = dim_menu.position_id
    ) set_1
 GROUP BY gr_nm
  , YEAR ;

 SELECT   COUNT ( * ) AS cnt_all
  , gr_nm
  , YEAR
     FROM
    (SELECT   f.group_id     AS gr_id
      , dim_group.group_name AS gr_nm
      , dim_time.year_value  AS YEAR
         FROM fct_sales_fnl f
      , dim_group
      , dim_time
      , dim_menu
        WHERE f.group_id = dim_group.group_id
        AND f.time_id = dim_time.time_id
        AND f.position_id = dim_menu.position_id
    ) set_1
 GROUP BY gr_nm
  , YEAR ;

CREATE MATERIALIZED VIEW LOG ON DIM_CLIENTS
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DIM_GROUP
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DIM_EMPLOYEES
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DIM_REST
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON DIM_TIME
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON FCT_SALES_F
WITH ROWID, SEQUENCE INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW REPORT2 REFRESH ON COMMIT
WITH ROWID ENABLE QUERY REWRITE AS
 SELECT   gr_nm
  , YEAR
  , SUM ( amount_sold ) AS amount_sold
     FROM
    (SELECT   f.group_id          AS gr_id
      , dim_group.group_name      AS gr_nm
      , dim_time.year_value       AS YEAR
      , f.amount * dim_menu.price AS amount_sold
         FROM fct_sales_f f
      , dim_group
      , dim_time
      , dim_menu
        WHERE f.group_id = dim_group.group_id
        AND f.time_id = dim_time.time_id
        AND f.position_id = dim_menu.position_id
    ) set_1
 GROUP BY gr_nm
  , YEAR ;
  /

  SELECT MVIEW_NAME,LAST_REFRESH_TYPE, TO_CHAR (LAST_REFRESH_DATE, 'HH24:MI:SS') FROM user_mviews;
  EXEC DBMS_MVIEW.REFRESH('REPORT1','F');
  
   CREATE TABLE fct_sales_f_mini
    (
      ID_SRC        NUMBER NOT NULL
    , EMPLOYEE_ID   NUMBER NOT NULL
    , CLIENT_ID     NUMBER NOT NULL
    , POSITION_ID   NUMBER NOT NULL
    , RESTAURANT_ID NUMBER NOT NULL
    , GROUP_ID      NUMBER NOT NULL
    , TIME_ID       NUMBER NOT NULL
    , AMOUNT        NUMBER NOT NULL
    , TIMESTMP      TIMESTAMP NOT NULL
    )
 PARTITION BY HASH(GROUP_ID)
       (PARTITION p5 TABLESPACE ts_part_fact_f_1)
       ;
       /
       
  ALTER TABLE fct_sales_f_mini
  EXCHANGE PARTITION p5 WITH TABLE fct_sales_f
  ;
       
select * from fct_sales_f_mini_2;
       
       SELECT MAX(TIMESTMP) FROM fct_sales_f PARTITION (sys_p747) ;
   
   
        CREATE TABLE fct_sales_f
    (
      ID_SRC        NUMBER NOT NULL
    , EMPLOYEE_ID   NUMBER NOT NULL
    , CLIENT_ID     NUMBER NOT NULL
    , POSITION_ID   NUMBER NOT NULL
    , RESTAURANT_ID NUMBER NOT NULL
    , GROUP_ID      NUMBER NOT NULL
    , TIME_ID       NUMBER NOT NULL
    , AMOUNT        NUMBER NOT NULL
    , TIMESTMP      TIMESTAMP NOT NULL
    )
    PARTITION BY RANGE
    (
      TIMESTMP
    )
    INTERVAL
    (
      NUMTOYMINTERVAL ( 1, 'MONTH' )
    )
    SUBPARTITION BY hash
    (
      group_id
    )
    SUBPARTITION template
    (
      SUBPARTITION p1 TABLESPACE ts_part_fact_f_1
    , SUBPARTITION p2 TABLESPACE ts_part_fact_f_2
    , SUBPARTITION p3 TABLESPACE ts_part_fact_f_3
    , SUBPARTITION P4 TABLESPACE ts_part_fact_f_4
    )
    (
      PARTITION before_2015 VALUES LESS THAN ( TO_DATE ( '01-JAN-2015', 'dd-MON-yyyy' ) )
    )
    PARALLEL;
    /
        
    ---
    ----
    -----exp tablespaces
    
    
CREATE PUBLIC DATABASE LINK vasya
CONNECT TO hr IDENTIFIED BY hr
USING '//192.168.56.101:1521/vd01dw';
/

select * from all_db_links
;

    
CREATE TABLESPACE ts_exp
DATAFILE 'ts_exp.dat'
SIZE 200M
AUTOEXTEND ON NEXT 100M
SEGMENT SPACE MANAGEMENT AUTO;
    /
    
    commit;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ----
    
