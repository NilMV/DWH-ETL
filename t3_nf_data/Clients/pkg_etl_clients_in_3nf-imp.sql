CREATE OR REPLACE PACKAGE body pkg_clients_3nf
AS
  /**===============================================*\
  Name...............:   pkg_clients_cls
  Contents...........:   load clients in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  /****************************************************/
  PROCEDURE load_clients_3nf_country
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients_3nf_country' ) ;
  BEGIN

     UPDATE t_clients_country
      SET is_valid = 'N'
        WHERE country NOT IN
        ( SELECT DISTINCT country FROM u_3nf_cl.cls_clients
        ) ;

    merge INTO t_clients_country t USING
    ( SELECT DISTINCT country FROM u_3nf_cl.cls_Clients
    ) cls ON
    (
      t.country = cls.country
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        ( country, IS_VALID
        ) VALUES
        ( cls.country, 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_clients_3nf_country;
/*****************************************/
/****************************************************/

  PROCEDURE load_clients_3nf_region
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients_3nf_region' ) ;
  BEGIN

     UPDATE t_clients_census_region
      SET is_valid = 'N'
        WHERE census_region NOT IN
        ( SELECT DISTINCT census_region FROM u_3nf_cl.cls_clients
        ) ;

    merge INTO t_clients_census_region t USING
    ( SELECT DISTINCT country
      , census_region
      , census_region_name
         FROM u_3nf_cl.cls_Clients
    ) cls ON
    (
      t.census_region = cls.census_region
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        (
          country
        , census_region
        , census_region_name
        , IS_VALID
        )
        VALUES
        (
          cls.country
        , cls.census_region
        , cls.census_region_name
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_clients_3nf_region;
/****************************************/

  PROCEDURE load_clients_3nf_division
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients_3nf_division' ) ;
  BEGIN

     UPDATE t_clients_census_division
      SET is_valid = 'N'
        WHERE census_region NOT IN
        ( SELECT DISTINCT census_division FROM u_3nf_cl.cls_clients
        ) ;

    merge INTO t_clients_census_division t USING
    ( SELECT DISTINCT census_region
      , census_division
      , census_division_name
         FROM u_3nf_cl.cls_Clients
    ) cls ON
    (
      t.census_division = cls.census_division
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        (
          census_region
        , census_division
        , census_division_name
        , IS_VALID
        )
        VALUES
        (
          cls.census_region
        , cls.census_division
        , cls.census_division_name
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_clients_3nf_division;
/****************************************/

  PROCEDURE load_clients_3nf_state_inf
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients_3nf_state_inf' ) ;
  BEGIN

     UPDATE t_clients_state_inf
      SET is_valid = 'N'
        WHERE state_code NOT IN
        ( SELECT DISTINCT state_code FROM u_3nf_cl.cls_clients
        ) ;

    merge INTO t_clients_state_inf t USING
    ( SELECT DISTINCT census_division
      , state_code
      , state_name
         FROM u_3nf_cl.cls_Clients
    ) cls ON
    (
      t.state_code = cls.state_code
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        (
          census_division
        , state_code
        , state_name
        , IS_VALID
        )
        VALUES
        (
          cls.census_division
        , cls.state_code
        , cls.state_name
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_clients_3nf_state_inf;
/****************************************/

  PROCEDURE load_clients_3nf_personal
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_clients_3nf_personal' ) ;
  BEGIN

     UPDATE t_clients_personal
      SET is_valid = 'N'
        WHERE id_src NOT IN
        ( SELECT id_src FROM u_3nf_cl.cls_clients
        ) ;

    merge INTO t_clients_personal t USING
    (SELECT   id_src
      , givenname
      , surname
      , email
      , age
      , prc_bonus
      , group_card_id
      , state_code
         FROM u_3nf_cl.cls_Clients
    ) cls ON
    (
      t.id_src = cls.id_src
    )
  WHEN matched THEN
     UPDATE SET
        -- t.country = cls.country,
        is_valid = 'Y' WHEN NOT matched THEN
     INSERT
        (
          id_src
        , givenname
        , surname
        , email
        , age
        , prc_bonus
        , group_card_id
        , state_code
        , IS_VALID
        )
        VALUES
        (
          cls.id_src
        , cls.givenname
        , cls.surname
        , cls.email
        , cls.age
        , cls.prc_bonus
        , cls.group_card_id
        , cls.state_code
        , 'Y'
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    RAISE;

  END load_clients_3nf_personal;

END pkg_clients_3nf;
/
--exec pkg_clients_3nf.load_clients_3nf_country;
--select * from T_CLIENTS_COUNTRY;
--exec pkg_clients_3nf.load_clients_3nf_region;
--select * from T_CLIENTS_CENSUS_REGION;
--exec PKG_CLIENTS_3NF.LOAD_CLIENTS_3NF_DIVISION;
--select * from T_CLIENTS_CENSUS_division;
--exec PKG_CLIENTS_3NF.LOAD_CLIENTS_3NF_state_inf;
--select * from T_CLIENTS_state_inf;
--exec PKG_CLIENTS_3NF.LOAD_CLIENTS_3NF_personal;
--select * from T_CLIENTS_personal;
--select count(*) from cls_clients;
