CREATE OR REPLACE PACKAGE pkg_groups_star_cls
AS
  /**===============================================*\
  Name...............:   pkg_groups_star_cls
  Contents...........:   contains procedures for load into star CLS tables
  Author.............:   Nil_Medvedev
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Package constants if needed (Description of each)
  */
  /**
  * Description for procedure
  */
  PROCEDURE load_star_cls_groups;
  /**
  * Description for procedure
  */
  -- PROCEDURE load_t_addresses;

END pkg_groups_star_cls;