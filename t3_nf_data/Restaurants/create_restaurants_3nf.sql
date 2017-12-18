 CREATE TABLE t_rest_country
    (
      COUNTRY  VARCHAR ( 20 ) NOT NULL
    , is_valid VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_rest_census_region
    (
      country            VARCHAR ( 20 ) NOT NULL
    , census_region      VARCHAR2 ( 10 ) NOT NULL
    , census_region_name VARCHAR2 ( 50 ) NOT NULL
    , is_valid           VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_rest_census_division
    (
      census_region        VARCHAR ( 10 ) NOT NULL
    , census_division      VARCHAR2 ( 10 ) NOT NULL
    , census_division_name VARCHAR2 ( 50 ) NOT NULL
    , is_valid             VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_rest_state_inf
    (
      census_division VARCHAR ( 10 ) NOT NULL
    , state_code      VARCHAR2 ( 2 ) NOT NULL
    , state_name      VARCHAR2 ( 50 ) NOT NULL
    , is_valid        VARCHAR ( 1 ) NOT NULL
    ) ;

DROP TABLE t_rest_personal;

 CREATE TABLE t_rest_personal
    (
      id_src     NUMBER NOT NULL
    , name       VARCHAR2 ( 150 ) NOT NULL
    , group_name VARCHAR2 ( 50 ) NOT NULL
    , address    VARCHAR2 ( 150 ) NOT NULL
    , telephone  VARCHAR ( 100 ) NOT NULL
    , city       VARCHAR ( 100 ) NOT NULL
    , state_code VARCHAR ( 2 ) NOT NULL
    , is_valid   VARCHAR ( 1 ) NOT NULL
    ) ;
