CREATE TABLE cls_Clients as
select 
ID_SRC
,trim(GIVENNAME) as givenname
,trim(SURNAME) as surname
,trim(EMP_STATE_CODE) as state_code
,trim(EMP_STATE_NAME) as state_name
,trim(EMP_COUNTRY) as country
,trim(EMAILADDRESS) as email
,trim(USERNAME) as username
,trim(AGE) as age
,trim(GROUP_CARD_ID) as group_card_id
,trim(PRC_BONUS) as prc_bonus
,trim(STANDARD_FEDERAL_REGION) as standard_federal_region
,trim(CENSUS_REGION) as census_region
,trim(CENSUS_REGION_NAME) as census_region_name
,trim(CENSUS_DIVISION) as census_division
,trim(CENSUS_DIVISION_NAME) as census_division_name
from u_src.src_clients
where id_src = 0
;

