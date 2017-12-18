CREATE TABLE t_clients_country
(
COUNTRY varchar(20) NOT NULL,
is_valid varchar(1) NOT NULL
)
;

CREATE TABLE t_clients_census_region
(
country varchar(20) NOT NULL,
census_region varchar2(10) NOT NULL,
census_region_name varchar2(50) NOT NULL,
is_valid varchar(1) NOT NULL
)
;


CREATE TABLE t_clients_census_division
(
census_region varchar(10) NOT NULL,
census_division varchar2(10) NOT NULL,
census_division_name varchar2(50) NOT NULL,
is_valid varchar(1) NOT NULL
)
;


CREATE TABLE t_clients_state_inf
(
census_division varchar(10) NOT NULL,
state_code varchar2(2) NOT NULL,
state_name varchar2(50) NOT NULL,
is_valid varchar(1) NOT NULL
)
;

drop table t_clients_personal  purge 
;
CREATE TABLE t_clients_personal
(
id_src number not null,
givenname varchar2(50) NOT NULL,
surname varchar2(50) NOT NULL,
email varchar2(50) NOT NULL,
age varchar(50) NOT NULL,
prc_bonus number(2) NOT NULL,
group_card_id varchar2(50) NOT NULL,
state_code varchar(2) NOT NULL,
is_valid varchar(1) NOT NULL
)
;







