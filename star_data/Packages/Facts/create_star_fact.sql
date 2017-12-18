



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
    
    

