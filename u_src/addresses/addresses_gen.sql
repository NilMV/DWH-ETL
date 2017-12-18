drop table src_Addresses purge;

CREATE TABLE src_Addresses 
(
 ID_SRC NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1000 INCREMENT BY 1,
  NAME varchar(150) NOT NULL,
  GROUP_NAME varchar2(50) NOT NULL,
  ADDRESS varchar2(150) NOT NULL,
  TELEPHONE varchar2(20) NOT NULL,
  COUNTRY varchar(20) NOT NULL,
  CITY varchar2(100) NOT NULL,
  STATE_CODE varchar(2) NOT NULL,
  STATE_NAME varchar2(100) NOT NULL,
  CENSUS_REGION varchar2(10) NOT NULL,
  CENSUS_REGION_NAME varchar2(100) NOT NULL,
  CENSUS_DIVISION varchar2(10) NOT NULL,
  CENSUS_DIVISION_NAME varchar2(100) NOT NULL
  )
  ;

  

INSERT INTO src_Addresses (
name,
group_name,
address, 
telephone, 
country,
city, 
state_code, 
state_name, 
census_region,
census_region_name,
census_division,
census_division_name
)
(
SELECT
addr.name,
addr.group_name, 
addr.address,
addr.telephone,
'United States' as country,
addr.city,
addr.state_code,
geo.name as state_name, 
geo.census_region,
geo.census_region_name ,
geo.census_division as census_division,
geo.census_division_name as census_division_name

--BULK COLLECT INTO l_objects
FROM
(
  SELECT NAME, 
  'McDonalds' as group_name,
     TRIM(regexp_substr(address, '[^,]+', 1, 1)) as address,
       TRIM(regexp_substr(address, '[^,]+', 1, 2)) as city, 
       TRIM(SUBSTR(regexp_substr(address, '[^,]+', 1, 3), 1, 2)) as state_code,
       TRIM(NVL(regexp_substr(address, '[^,]+', 1, 4), 'n/a')) as telephone
      --  BULK COLLECT INTO l_objects
   FROM 
    MC_ADDRESSES
   
   UNION
  SELECT NAME, 'KFC' as group_name,
     TRIM(regexp_substr(address, '[^,]+', 1, 1)) as address,
       TRIM(regexp_substr(address, '[^,]+', 1, 2)) as city, 
       TRIM(SUBSTR(regexp_substr(address, '[^,]+', 1, 3), 1, 2)) as state_code,
        TRIM(NVL(regexp_substr(address, '[^,]+', 1, 4), 'n/a')) as telephone
      --  BULK COLLECT INTO l_objects
   FROM 
   KFC_ADDRESSES
   
   UNION
  SELECT NAME, 'Taco Bell' as group_name,
     TRIM(regexp_substr(address, '[^,]+', 1, 1)) as address,
       TRIM(regexp_substr(address, '[^,]+', 1, 2)) as city, 
       TRIM(SUBSTR(regexp_substr(address, '[^,]+', 1, 3), 1, 2)) as state_code,
    TRIM(NVL(regexp_substr(address, '[^,]+', 1, 4), 'n/a')) as telephone
      --  BULK COLLECT INTO l_objects
   FROM 
    TACOBELL_ADDRESSES
  
 /* UNION
  SELECT NAME, 'Starbucks' as group_name,
     TRIM(regexp_substr(address, '[^,]+', 1, 1)) as address,
       TRIM(regexp_substr(address, '[^,]+', 1, 2)) as city, 
       TRIM(SUBSTR(regexp_substr(address, '[^,]+', 1, 3), 1, 4)) as state_code,
        TRIM(NVL(regexp_substr(address, '[^,]+', 1, 4), 'n/a')) as telephone
      --  BULK COLLECT INTO l_objects
   FROM 
  STARBUCKS_ADDRESSES */
   ) addr INNER JOIN STATE_TABLE geo on addr.state_code = geo.ABBREVIATION  
   )
   ;
   
   
   
   
   
   --------MENU_GEN
   
   CREATE TABLE src_Menu
(
ID NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1000 INCREMENT BY 1,
 GROUP_NAME varchar(10) NOT NULL,
  POSITION_NAME varchar(100) NOT NULL,
  PRICE number(8,2) NOT NULL
  )
  ;
  
   INSERT INTO src_Menu ( group_name, position_name, price)
   (
   select group_name, position_name, price
   from(
       SELECT 'Taco Bell' as group_name,
            TACO_BELL as position_name,
            PRICE 
     FROM TACOBELL_MENU
     UNION 
     SELECT 'KFC' as group_name,
            KFC as position_name,
            PRICE
     FROM KFC_MENU
     UNION
     SELECT 'McDonalds' as group_name,
              MC_DONALDS as position_name,
              PRICE
     FROM MC_MENU
     )
     )
     ;
     
     
     -----
     ------generate clients

     
     
     
     create table  src_Clients 
     as
     select *
     from (
     SELECT 
     set1.givenname,
     set2.surname,
     set1.state as emp_state_code,
     set1.statefull as emp_state_name,
     set1.countryfull as emp_country,
   substr(set1.emailaddress, 1, 3)||substr(set2.emailaddress, 3, 40) as emailaddress, 
     substr(set1.username, 1, 3)||substr(set2.username, 3, 40) as username, 
     set1.age as age,
    substr(set1.ccnumber,1,5)||substr(set2.ccnumber,1,5) as group_card_id,
      1 as prc_bonus
     FROM 
     US_NAME_1 set1, US_NAME_4 set2
     WHERE 
     set1.gender = set2.gender and 
     ROWNUM < 5500000) set_emp  INNER JOIN STATE_TABLE geo on set_emp.emp_state_code = geo.ABBREVIATION 
     ;
     
     insert into src_Clients(
GIVENNAME,
SURNAME,
EMP_STATE_CODE,
EMP_STATE_NAME,
EMP_COUNTRY,
EMAILADDRESS,
USERNAME,
AGE,
GROUP_CARD_ID
,
PRC_BONUS
,ID
,NAME
,ABBREVIATION
,COUNTRY
,TYPE
,SORT
,STATUS
,OCCUPIED
,NOTES
,FIPS_STATE
,ASSOC_PRESS
,STANDARD_FEDERAL_REGION
,CENSUS_REGION
,CENSUS_REGION_NAME
,CENSUS_DIVISION
,CENSUS_DIVISION_NAME
,CIRCUIT_COURT)
(
 select *
     from (
     SELECT 
     set1.givenname,
     set2.surname,
     set1.state as emp_state_code,
     set1.statefull as emp_state_name,
     set1.countryfull as emp_country,
   substr(set1.emailaddress, 1, 3)||substr(set2.emailaddress, 3, 40) as emailaddress, 
     substr(set1.username, 1, 3)||substr(set2.username, 3, 40) as username, 
     set1.age as age,
    substr(set1.ccnumber,1,5)||substr(set2.ccnumber,1,5) as group_card_id,
      1 as prc_bonus
     FROM 
     US_NAME_1 set1, US_NAME_4 set2
     WHERE 
     set1.gender = set2.gender and 
     ROWNUM < 5500000) set_emp  INNER JOIN STATE_TABLE geo on set_emp.emp_state_code = geo.ABBREVIATION )
     ;
     
   
     
     ---
     ---
     ---generate employee
     
    create table emp_geo_3
    as
    select *
     from (
     SELECT 
     set1.givenname,
     set2.surname,
     set1.state as emp_state_code,
     set1.statefull as emp_state_name,
     set1.countryfull as emp_country,
   substr(set1.emailaddress, 1, 3)||substr(set2.emailaddress, 3, 40) as emailaddress, 
     set1.username, 
     set1.age,
    substr(set1.ccnumber,1,5)||substr(set2.ccnumber,1,5) as ccnumber,
    set1.cvv2,
    set2.cctype,
    40000 as salary,
    1 as prc_bonus_to_salary
     FROM 
     us_name_4 set1, US_NAME_5 set2
     WHERE 
     set1.gender = set2.gender and 
     ROWNUM < 3600) set_emp  INNER JOIN STATE_TABLE geo on set_emp.emp_state_code = geo.ABBREVIATION;
    
    
    select count(*)
    from
    (
    select emp_geo_1.*, addr.id as id_restaurant
    from 
    emp_geo_1 INNER JOIN SRC_ADDRESSES addr on addr.state_code = emp_geo_1.emp_state_code
    )
    ;
    
    
    
    select distinct emp_geo_2.*, addr.id, addr.state_code
    from emp_geo_2,SRC_ADDRESSES addr
    WHERE addr.state_code = emp_geo_2.emp_state_code
     ;
     
     select * 
     from (
            select distinct addr.id, emp_geo_2.* 
            from emp_geo_2 inner join  SRC_ADDRESSES addr on emp_geo_2.emp_state_code = addr.state_code
            where id_restaurant  is null  
     ) as t
     where t.rownum < 100
     ;
     
      select distinct addr.id, emp_geo_2.* 
      from emp_geo_2 inner join  SRC_ADDRESSES addr on emp_geo_2.emp_state_code = addr.state_code
      where id_restaurant  is null  
            ;
            
            ---
            ----
            -----
          ----fact generation
     
  
CREATE TABLE src_Group
(
 ID_SRC NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1000 INCREMENT BY 1,
  GROUP_NAME varchar2(50) NOT NULL
  )
  ;
  
INSERT INTO SRC_GROUP(GROUP_NAME)
     VALUES('McDonalds');
     
INSERT INTO SRC_GROUP(GROUP_NAME)
     VALUES('KFC');
     
     INSERT INTO SRC_GROUP(GROUP_NAME)
     VALUES('Taco Bell');
     
     
        
     

     
  