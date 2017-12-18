CREATE OR REPLACE PACKAGE pkg_group_dim
AS
  /**===============================================*\
  Name...............:   pkg_group_dim
  Contents...........:   contains procedures for load group into CLS tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_group_dim;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_group_dim;
/ 