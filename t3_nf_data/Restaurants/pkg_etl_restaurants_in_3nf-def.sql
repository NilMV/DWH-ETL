CREATE OR REPLACE PACKAGE pkg_rest_3nf
AS
  /**===============================================*\
  Name...............:   pkg_rest_3nf
  Contents...........:   contains procedures for load rest into 3nf tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_rest_3nf_country;

  PROCEDURE load_rest_3nf_region;

  PROCEDURE load_rest_3nf_division;

  PROCEDURE load_rest_3nf_state_inf;

  PROCEDURE load_rest_3nf_personal;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_rest_3nf;
/ 