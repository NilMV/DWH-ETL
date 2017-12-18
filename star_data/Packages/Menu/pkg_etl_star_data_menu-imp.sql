CREATE OR REPLACE PACKAGE body pkg_menu_dim
AS
  /**===============================================*\
  Name...............:   pkg_menu_dim
  Contents...........:   load menu in dim tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_menu_dim
  IS

    CURSOR c_menu
    IS

       SELECT
          /*+ PARALLEL(c,2) */
          *
           FROM
          (SELECT   nvl2 ( scl.id_src, scl.id_src, dim.id_src )                AS id_src
            , nvl2 ( scl.group_name, scl.group_name, dim.group_name )          AS group_name
            , nvl2 ( scl.position_name, scl.position_name, dim.position_name ) AS position_name
            , nvl2 ( scl.price, scl.price, dim.price )                         AS price
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
                    OR DECODE ( scl.position_name, dim.position_name, 0, 1 ) = 1
                    OR DECODE ( scl.price, dim.price, 0, 1 ) = 1
                  )
                THEN 'U'
                ELSE 'N'
              END AS flag
               FROM u_star_cl.star_cls_menu scl
            FULL OUTER JOIN dim_menu dim
                 ON
              (
                scl.id_src = dim.id_src
              )
          )
        WHERE flag <> 'N';

  type menus_nt
IS
  TABLE OF c_menu%ROWTYPE;
type menu_id_nt
IS
  TABLE OF pls_integer;
  l_menus menus_nt := menus_nt ( ) ;
  menu_id_ins menu_id_nt := menu_id_nt ( ) ;
  menu_id_del menu_id_nt := menu_id_nt ( ) ;
  menu_id_upd menu_id_nt := menu_id_nt ( ) ;
BEGIN
  OPEN c_menu;

  FETCH c_menu bulk collect INTO l_menus;

  CLOSE c_menu;

  FOR i IN 1..l_menus.count
  LOOP

    IF l_menus ( i ) .flag = 'I' THEN
      menu_id_ins.extend;
      menu_id_ins ( menu_id_ins.count ) := i;

    elsif l_menus ( i ) .flag = 'D' THEN
      menu_id_del.extend;
      menu_id_del ( menu_id_del.count ) := i;

    ELSE
      menu_id_upd.extend;
      menu_id_upd ( menu_id_upd.count ) := i;

    END IF;

  END LOOP;
forall i IN VALUES OF menu_id_ins

 INSERT
     INTO dim_menu
    (
      ID_SRC
    , GROUP_NAME
    , POSITION_NAME
    , PRICE
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_menus ( i ) .id_src
    , l_menus ( i ) .group_name
    , l_menus ( i ) .position_name
    , l_menus ( i ) .price
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;

forall i IN VALUES OF menu_id_del

 DELETE FROM dim_menu WHERE id_src = l_menus ( i ) .id_src;

forall i IN VALUES OF menu_id_upd

 UPDATE dim_menu
  SET group_name = l_menus ( i ) .group_name
  , position_name = l_menus ( i ) .position_name
  , price = l_menus ( i ) .price
  , end_date = sysdate
  , is_current = 'invalide'
    WHERE id_src = l_menus ( i ) .id_src;

forall i IN VALUES OF menu_id_upd

 INSERT
     INTO dim_menu
    (
      ID_SRC
    , GROUP_NAME
    , POSITION_NAME
    , PRICE
    , START_DATE
    , END_DATE
    , IS_CURRENT
    )
    VALUES
    (
      l_menus ( i ) .id_src
    , l_menus ( i ) .group_name
    , l_menus ( i ) .position_name
    , l_menus ( i ) .price
    , sysdate
    , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
    , 'valide'
    ) ;
COMMIT;
--EXCEPTION
--WHEN OTHERS THEN
-- err_log ( ) ;
-- RAISE;

END load_menu_dim;

END pkg_menu_dim;
--exec pkg_menu_dim.load_menu_dim;
--select count(*) from cls_clients;
