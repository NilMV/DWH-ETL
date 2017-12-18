CREATE OR REPLACE PACKAGE pkg_employees_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_employees_star_cls
  Contents...........:   contains procedures for load clients into star CLS tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_employees_star_cls;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_employees_star_cls;
/ 