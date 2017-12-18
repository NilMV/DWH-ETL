CREATE OR REPLACE PACKAGE pkg_clients_dim
AS
  /**===============================================*\
  Name...............:   pkg_cls
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
  PROCEDURE load_clients_dim;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_clients_dim;
/ 