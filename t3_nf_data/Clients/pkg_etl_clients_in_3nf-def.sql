CREATE OR REPLACE PACKAGE pkg_clients_3nf
AS
  /**===============================================*\
  Name...............:   pkg_clients_3nf
  Contents...........:   contains procedures for load clients into CLS tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_clients_3nf_country;

  PROCEDURE load_clients_3nf_region;

  PROCEDURE load_clients_3nf_division;

  PROCEDURE load_clients_3nf_state_inf;

  PROCEDURE load_clients_3nf_personal;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_clients_3nf;
/ 