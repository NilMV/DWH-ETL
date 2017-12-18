CREATE OR REPLACE PACKAGE body pkg_clients_dim
AS
  /**===============================================*\
  Name...............:   pkg_clients_cls
  Contents...........:   load clients in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */
  /****************************************************/
  PROCEDURE load_clients_dim
  IS

    CURSOR c_clnts
    IS

       SELECT   *
           FROM
          (SELECT   nvl2 ( scl.id_src, scl.id_src, dim.id_src )                                     AS id_src
            , nvl2 ( scl.givenname, scl.givenname, dim.givenname )                                  AS givenname
            , nvl2 ( scl.surname, scl.surname, dim.surname )                                        AS surname
            , nvl2 ( scl.state_code, scl.state_code, dim.state_code )                               AS state_code
            , nvl2 ( scl.state_name, scl.state_name, dim.state_name )                               AS state_name
            , nvl2 ( scl.country, scl.country, dim.country )                                        AS country
            , nvl2 ( scl.email, scl.email, dim.email )                                              AS email
            , nvl2 ( scl.age, scl.age, dim.age )                                                    AS age
            , nvl2 ( scl.group_card_id, scl.group_card_id, dim.group_card_id )                      AS group_card_id
            , nvl2 ( scl.prc_bonus, scl.prc_bonus, dim.prc_bonus )                                  AS prc_bonus
            , nvl2 ( scl.census_region, scl.census_region, dim.census_region )                      AS census_region
            , nvl2 ( scl.census_region_name, scl.census_region_name, dim.census_region_name )       AS census_region_name
            , nvl2 ( scl.census_division, scl.census_division, dim.census_division )                AS census_division
            , nvl2 ( scl.census_division_name, scl.census_division_name, dim.census_division_name ) AS census_division_name
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
                    DECODE ( scl.givenname, dim.surname, 0, 1 ) = 1
                    OR DECODE ( scl.surname, dim.surname, 0, 1 ) = 1
                    OR DECODE ( scl.state_code, dim.state_code, 0, 1 ) = 1
                    OR DECODE ( scl.state_name, dim.state_name, 0, 1 ) = 1
                    OR DECODE ( scl.country, dim.country, 0, 1 ) = 1
                    OR DECODE ( scl.email, dim.email, 0, 1 ) = 1
                    OR DECODE ( scl.age, dim.age, 0, 1 ) = 1
                    OR DECODE ( scl.GROUP_CARD_ID, dim.GROUP_CARD_ID, 0, 1 ) = 1
                    OR DECODE ( scl.PRC_BONUS, dim.PRC_BONUS, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_REGION, dim.CENSUS_REGION, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_REGION_NAME, dim.CENSUS_REGION_NAME, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_DIVISION, dim.CENSUS_DIVISION, 0, 1 ) = 1
                    OR DECODE ( scl.CENSUS_DIVISION_NAME, dim.CENSUS_DIVISION_NAME, 0, 1 ) = 1
                  )
                THEN 'U'
                ELSE 'N'
              END AS flag
               FROM u_star_cl.star_cls_Clients scl
            FULL OUTER JOIN dim_Clients dim
                 ON
              (
                scl.id_src = dim.id_src
              )
          )
        WHERE flag <> 'N';

  type clnts_nt
IS
  TABLE OF c_clnts%ROWTYPE;
type clnt_id_nt
IS
  TABLE OF pls_integer;
  l_clnts clnts_nt := clnts_nt ( ) ;
  clnt_id_ins clnt_id_nt := clnt_id_nt ( ) ;
  clnt_id_del clnt_id_nt := clnt_id_nt ( ) ;
  clnt_id_upd clnt_id_nt := clnt_id_nt ( ) ;
BEGIN
  OPEN c_clnts;
  LOOP

    FETCH c_clnts bulk collect INTO l_clnts LIMIT 1000000;
    EXIT
  WHEN l_clnts.count = 0;

    FOR i IN 1..l_clnts.count
    LOOP

      IF l_clnts ( i ) .flag = 'I' THEN
        clnt_id_ins.extend;
        clnt_id_ins ( clnt_id_ins.count ) := i;

      elsif l_clnts ( i ) .flag = 'D' THEN
        clnt_id_del.extend;
        clnt_id_del ( clnt_id_del.count ) := i;

      ELSE
        clnt_id_upd.extend;
        clnt_id_upd ( clnt_id_upd.count ) := i;

      END IF;

    END LOOP;
    forall i IN VALUES OF clnt_id_ins

     INSERT
         INTO dim_clients
        (
          ID_SRC
        , GIVENNAME
        , SURNAME
        , STATE_CODE
        , STATE_NAME
        , COUNTRY
        , EMAIL
        , AGE
        , GROUP_CARD_ID
        , PRC_BONUS
        , CENSUS_REGION
        , CENSUS_REGION_NAME
        , CENSUS_DIVISION
        , CENSUS_DIVISION_NAME
        , START_DATE
        , END_DATE
        , IS_CURRENT
        )
        VALUES
        (
          l_clnts ( i ) .id_src
        , l_clnts ( i ) .givenname
        , l_clnts ( i ) .surname
        , l_clnts ( i ) .state_code
        , l_clnts ( i ) .state_name
        , l_clnts ( i ) .country
        , l_clnts ( i ) .email
        , l_clnts ( i ) .age
        , l_clnts ( i ) .group_card_id
        , l_clnts ( i ) .prc_bonus
        , l_clnts ( i ) .census_region
        , l_clnts ( i ) .census_region_name
        , l_clnts ( i ) .census_division
        , l_clnts ( i ) .census_division_name
        , sysdate
        , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
        , 'valide'
        ) ;

    forall i IN VALUES OF clnt_id_del

     DELETE FROM dim_clients WHERE id_src = l_clnts ( i ) .id_src;

    forall i IN VALUES OF clnt_id_upd

     UPDATE dim_clients
      SET givenname = l_clnts ( i ) .givenname
      , surname = l_clnts ( i ) .surname
      , state_code = l_clnts ( i ) .state_Code
      , state_name = l_clnts ( i ) .state_name
      , country = l_clnts ( i ) .country
      , email = l_clnts ( i ) .email
      , age = l_clnts ( i ) .age
      , group_card_id = l_clnts ( i ) .group_card_id
      , prc_bonus = l_clnts ( i ) .prc_bonus
      , census_region = l_clnts ( i ) .census_region
      , census_region_name = l_clnts ( i ) .census_region_name
      , census_division = l_clnts ( i ) .census_division
      , census_division_name = l_clnts ( i ) .census_division_name
      , end_date = sysdate
      , is_current = 'invalide'
        WHERE id_src = l_clnts ( i ) .id_src;

    forall i IN VALUES OF clnt_id_upd

     INSERT
         INTO dim_clients
        (
          ID_SRC
        , GIVENNAME
        , SURNAME
        , STATE_CODE
        , STATE_NAME
        , COUNTRY
        , EMAIL
        , AGE
        , GROUP_CARD_ID
        , PRC_BONUS
        , CENSUS_REGION
        , CENSUS_REGION_NAME
        , CENSUS_DIVISION
        , CENSUS_DIVISION_NAME
        , START_DATE
        , END_DATE
        , IS_CURRENT
        )
        VALUES
        (
          l_clnts ( i ) .id_src
        , l_clnts ( i ) .givenname
        , l_clnts ( i ) .surname
        , l_clnts ( i ) .state_code
        , l_clnts ( i ) .state_name
        , l_clnts ( i ) .country
        , l_clnts ( i ) .email
        , l_clnts ( i ) .age
        , l_clnts ( i ) .group_card_id
        , l_clnts ( i ) .prc_bonus
        , l_clnts ( i ) .census_region
        , l_clnts ( i ) .census_region_name
        , l_clnts ( i ) .census_division
        , l_clnts ( i ) .census_division_name
        , sysdate
        , TO_DATE ( '01/01/9999', 'DD/MM/YYYY' )
        , 'valide'
        ) ;

  END LOOP;
CLOSE c_clnts;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
err_log ( ) ;
RAISE;

END load_clients_dim;

END pkg_clients_dim;
--exec pkg_clients_dim.load_clients_dim;
--select count(*) from cls_clients;
