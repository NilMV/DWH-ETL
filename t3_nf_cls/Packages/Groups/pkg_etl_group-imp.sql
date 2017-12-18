CREATE OR REPLACE PACKAGE body pkg_group_cls
AS
  /**===============================================*\
  Name...............:   pkg_group_cls
  Contents...........:   load in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_cls_group
  IS
    c_procedure_name CONSTANT VARCHAR2 ( 30 ) := UPPER ( 'load_groups' ) ;
  BEGIN
    EXECUTE IMMEDIATE 'truncate table cls_groups';

    /*cursor for group*/

     INSERT
         INTO cls_groups
        (
         id_src, GROUP_NAME
        )
        (SELECT
              /*+ PARALLEL(c,2) */
              id_src,
              trim ( group_name ) AS group_name
               FROM u_src.src_group
        ) ;
    COMMIT;

  EXCEPTION

  WHEN OTHERS THEN
    err_log ( ) ;
    RAISE;

  END load_cls_group ;

END pkg_group_cls;
--exec pkg_group_cls.load_cls_group;
