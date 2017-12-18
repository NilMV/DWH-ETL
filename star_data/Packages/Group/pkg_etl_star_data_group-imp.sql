CREATE OR REPLACE PACKAGE body pkg_group_dim
AS
  /**===============================================*\
  Name...............:   pkg_group_dim
  Contents...........:   load group in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_group_dim
  IS

    CURSOR c_group
    IS

       SELECT
          /*+ PARALLEL(c,2) */
          *
           FROM
          (SELECT   nvl2 ( scl.id_src, scl.id_src, dim.id_src )       AS id_src
            , nvl2 ( scl.group_name, scl.group_name, dim.group_name ) AS group_name
            , CASE
                WHEN scl.id_src IS NOT NULL
                  AND dim.id_src IS NULL
                THEN 'I'
                WHEN scl.id_src IS NULL
                  AND dim.id_src IS NOT NULL
                THEN 'D'
                WHEN scl.id_src IS NOT NULL
                  AND dim.id_src IS NOT NULL
                  AND
                  (
                    DECODE ( scl.id_src, dim.id_src, 0, 1 ) = 1
                    OR DECODE ( scl.group_name, dim.group_name, 0, 1 ) = 1
                  )
                THEN 'U'
                ELSE 'N'
              END AS flag
               FROM u_star_cl.star_cls_groups scl
            FULL OUTER JOIN dim_group dim
                 ON
              (
                scl.id_src = dim.id_src
              )
          )
        WHERE flag <> 'N';

  type groups_nt
IS
  TABLE OF c_group%ROWTYPE;
type group_id_nt
IS
  TABLE OF pls_integer;
  l_groups groups_nt := groups_nt ( ) ;
  group_id_ins group_id_nt := group_id_nt ( ) ;
  group_id_del group_id_nt := group_id_nt ( ) ;
  group_id_upd group_id_nt := group_id_nt ( ) ;
BEGIN
  OPEN c_group;

  FETCH c_group bulk collect INTO l_groups;

  CLOSE c_group;

  FOR i IN 1..l_groups.count
  LOOP

    IF l_groups ( i ) .flag = 'I' THEN
      group_id_ins.extend;
      group_id_ins ( group_id_ins.count ) := i;

    elsif l_groups ( i ) .flag = 'D' THEN
      group_id_del.extend;
      group_id_del ( group_id_del.count ) := i;

    ELSE
      group_id_upd.extend;
      group_id_upd ( group_id_upd.count ) := i;

    END IF;

  END LOOP;
forall i IN VALUES OF group_id_ins

 INSERT
     INTO dim_group
    (
      ID_SRC
    , GROUP_NAME
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_groups ( i ) .id_src
    , l_groups ( i ) .group_name
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;

forall i IN VALUES OF group_id_del

 DELETE FROM dim_group WHERE id_src = l_groups ( i ) .id_src;

forall i IN VALUES OF group_id_upd

 UPDATE dim_group
  SET group_name = l_groups ( i ) .group_name
  , end_date = sysdate
  , is_current = 'invalide'
    WHERE id_src = l_groups ( i ) .id_src;

forall i IN VALUES OF group_id_upd

 INSERT
     INTO dim_group
    (
      ID_SRC
    , GROUP_NAME
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_groups ( i ) .id_src
    , l_groups ( i ) .group_name
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;
COMMIT;
--EXCEPTION
--WHEN OTHERS THEN
-- err_log ( ) ;
-- RAISE;

END load_group_dim;

END pkg_group_dim;
--exec pkg_group_dim.load_group_dim;
--select count(*) from cls_clients;
