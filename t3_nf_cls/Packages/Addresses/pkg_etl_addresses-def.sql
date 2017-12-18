
CREATE OR REPLACE PACKAGE pkg_addresses_cls
AS
  /**===============================================*\
  Name...............:   pkg_addresses_cls
  Contents...........:   contains procedures for load addresses into CLS tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_cls_addresses;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_addresses_cls;
/