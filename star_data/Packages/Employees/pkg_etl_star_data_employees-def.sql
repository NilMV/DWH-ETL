CREATE OR REPLACE PACKAGE pkg_employees_dim
AS
  /**===============================================*\
  Name...............:   pkg_employees_dim
  Contents...........:   contains procedures for load employees into dim tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_employees_dim;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_employees_dim;
/ 