 CREATE TABLE t_employees_country
    (
      COUNTRY  VARCHAR ( 20 ) NOT NULL
    , is_valid VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_employees_census_region
    (
      country            VARCHAR ( 20 ) NOT NULL
    , census_region      VARCHAR2 ( 10 ) NOT NULL
    , census_region_name VARCHAR2 ( 50 ) NOT NULL
    , is_valid           VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_employees_census_division
    (
      census_region        VARCHAR ( 10 ) NOT NULL
    , census_division      VARCHAR2 ( 10 ) NOT NULL
    , census_division_name VARCHAR2 ( 50 ) NOT NULL
    , is_valid             VARCHAR ( 1 ) NOT NULL
    ) ;

 CREATE TABLE t_employees_state_inf
    (
      census_division VARCHAR ( 10 ) NOT NULL
    , state_code      VARCHAR2 ( 2 ) NOT NULL
    , state_name      VARCHAR2 ( 50 ) NOT NULL
    , is_valid        VARCHAR ( 1 ) NOT NULL
    ) ;

--drop table t_clients_personal  purge
--;

 CREATE TABLE t_employees_personal
    (
      id_src              NUMBER NOT NULL
    , givenname           VARCHAR2 ( 50 ) NOT NULL
    , surname             VARCHAR2 ( 50 ) NOT NULL
    , email               VARCHAR2 ( 50 ) NOT NULL
    , age                 VARCHAR ( 50 ) NOT NULL
    , salary              NUMBER ( 8 ) NOT NULL
    , prc_bonus_to_salary NUMBER ( 2 ) NOT NULL
    , ccnumber            VARCHAR2 ( 50 ) NOT NULL
    , cctype              VARCHAR2 ( 50 ) NOT NULL
    , state_code          VARCHAR ( 2 ) NOT NULL
    , is_valid            VARCHAR ( 1 ) NOT NULL
    ) ;
