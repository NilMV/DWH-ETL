CREATE TABLE cls_Employees as
select 
ID_SRC
,trim(GIVENNAME) as givenname
,trim(SURNAME) as surname
,trim(EMP_STATE_CODE) as state_code
,trim(EMP_STATE_NAME) as state_name
,trim(EMP_COUNTRY) as country
,trim(EMAILADDRESS) as email
,trim(AGE) as age
,trim(SALARY) as salary
,trim(PRC_BONUS_TO_SALARY) as prc_bonus_to_salary
,trim(CCNUMBER) as ccnumber
,trim(CCTYPE) as cctype
,trim(STANDARD_FEDERAL_REGION) as standard_federal_region
,trim(CENSUS_REGION) as census_region
,trim(CENSUS_REGION_NAME) as census_region_name
,trim(CENSUS_DIVISION) as census_division
,trim(CENSUS_DIVISION_NAME) as census_division_name
from u_src.src_employees
where id_src = 0
;

