
CREATE OR REPLACE PACKAGE body pkg_rest_dim
AS
  /**===============================================*\
  Name...............:   pkg_rest_cls
  Contents...........:   load rest in cls tables
  Author.............:   Nil_Medvedev@epam.com
  Date...............:   3/3/2016
  \*=============================================== */
  /**
  * Constants for logging if needed (Description of each)
  */

/****************************************************/  

  
PROCEDURE load_rest_dim
IS

 CURSOR c_rests IS
     SELECT /*+ PARALLEL(c,2) */  *
         FROM
        (SELECT    nvl2 ( scl.id_src, scl.id_src, dim.id_src ) as id_src
                  ,  nvl2 ( scl.name, scl.name, dim.name) as name
          ,  nvl2 ( scl.group_name, scl.group_name, dim.group_name) as group_name
          ,  nvl2 ( scl.address, scl.address, dim.address ) as address
                    ,  nvl2 ( scl.telephone, scl.telephone, dim.telephone ) as telephone
                          ,  nvl2 ( scl.country, scl.country, dim.country )as country
                                        ,  nvl2 ( scl.city, scl.city, dim.city ) as city
          ,  nvl2 ( scl.state_code, scl.state_code, dim.state_code )as state_code
          ,  nvl2 ( scl.state_name, scl.state_name, dim.state_name ) as state_name
    
          ,  nvl2 ( scl.census_region, scl.census_region, dim.census_region ) as census_region
          ,  nvl2 ( scl.census_region_name, scl.census_region_name, dim.census_region_name ) as census_region_name
          ,  nvl2 ( scl.census_division, scl.census_division, dim.census_division ) as census_division
          , nvl2 ( scl.census_division_name, scl.census_division_name, dim.census_division_name ) as census_division_name
          , CASE
              WHEN scl.id_src IS NOT NULL
              AND dim.id_src  IS NULL
              THEN 'I'
              WHEN scl.id_src IS NULL
              AND dim.id_src  IS NOT NULL
              THEN 'D'
              WHEN scl.id_src                                     IS NOT NULL
              AND dim.id_src                                       IS NOT NULL
              AND ( 
              DECODE ( scl.name, dim.name, 0, 1 ) =1
              OR DECODE ( scl.group_name, dim.group_name, 0, 1 ) = 1
                            OR DECODE ( scl.address, dim.address, 0, 1 ) = 1
                             OR DECODE ( scl.telephone, dim.telephone, 0, 1 ) = 1
              OR DECODE ( scl.country, dim.country, 0, 1 ) = 1
                            OR DECODE ( scl.city, dim.city, 0, 1 ) = 1
                            OR DECODE ( scl.state_code, dim.state_code, 0, 1 )         = 1
              OR DECODE ( scl.state_name, dim.state_name, 0, 1 )
                                                               = 1
              OR DECODE ( scl.CENSUS_REGION, dim.CENSUS_REGION, 0, 1 )
                = 1
              OR DECODE ( scl.CENSUS_REGION_NAME, dim.CENSUS_REGION_NAME, 0, 1
                ) = 1
              OR DECODE ( scl.CENSUS_DIVISION, dim.CENSUS_DIVISION, 0, 1
                ) = 1 
                OR DECODE ( scl.CENSUS_DIVISION_NAME, dim.CENSUS_DIVISION_NAME, 0, 1
                ) = 1 )
              THEN 'U'
              ELSE 'N'
            END AS flag
             FROM u_star_cl.star_cls_rest scl
          FULL OUTER JOIN dim_rest dim
               ON ( scl.id_src = dim.id_src )
        )
      WHERE flag <> 'N';
      

type rests_nt IS TABLE OF c_rests%ROWTYPE;

type rest_id_nt IS TABLE OF pls_integer;

  l_rests rests_nt:=rests_nt();


  rest_id_ins rest_id_nt := rest_id_nt ( ) ;
  rest_id_del rest_id_nt := rest_id_nt ( ) ;
  rest_id_upd rest_id_nt := rest_id_nt ( ) ;

BEGIN
  OPEN c_rests;

  FETCH c_rests bulk collect INTO l_rests;

  CLOSE c_rests;

  FOR i IN 1..l_rests.count
  LOOP

    IF l_rests ( i ) .flag = 'I' THEN
      rest_id_ins.extend;
      rest_id_ins ( rest_id_ins.count ) := i;

    elsif l_rests ( i ) .flag = 'D' THEN
      rest_id_del.extend;
      rest_id_del ( rest_id_del.count ) := i;

    ELSE
      rest_id_upd.extend;
      rest_id_upd ( rest_id_upd.count ) := i;

    END IF;

  END LOOP;
  
  forall i IN VALUES OF rest_id_ins
   INSERT
       INTO dim_rest
       (
  ID_SRC
  ,name
  ,group_name
    ,address
,telephone
  ,COUNTRY
  ,city
    ,STATE_CODE
  ,STATE_NAME
  ,CENSUS_REGION
  ,CENSUS_REGION_NAME
  ,CENSUS_DIVISION
  ,CENSUS_DIVISION_NAME

       )
       VALUES
      (
        l_rests ( i ) .id_src
              , l_rests ( i ) .name
      , l_rests ( i ) .group_name
      , l_rests ( i ) .address
            , l_rests ( i ) .telephone
            , l_rests ( i ) .country
            , l_rests ( i ) .city
            , l_rests ( i ) .state_code
      , l_rests ( i ) .state_name
      , l_rests ( i ) .census_region
      , l_rests ( i ) .census_region_name
      , l_rests ( i ) .census_division
      , l_rests ( i ) .census_division_name
      ) ;

  forall i IN VALUES OF rest_id_del
   DELETE FROM dim_rest WHERE id_src = l_rests ( i ) .id_src;

  forall i IN VALUES OF rest_id_upd
   UPDATE dim_rest
    SET name   = l_rests ( i ) .name
    , group_name      = l_rests ( i ) .group_name
        , address      = l_rests ( i ) .address
        , telephone      = l_rests ( i ) .telephone
                , country      = l_rests ( i ) .country
        , city      = l_rests ( i ) .city

        , state_code          = l_rests ( i ) .state_Code
    , state_name   = l_rests ( i ) .state_name
    , census_region   = l_rests ( i ) .census_region
    , census_region_name  = l_rests ( i ) .census_region_name
    , census_division  = l_rests ( i ) .census_division
    , census_division_name  = l_rests ( i ) .census_division_name
      WHERE id_src   = l_rests ( i ) .id_src;
  
     
  COMMIT;

--EXCEPTION

--WHEN OTHERS THEN
 -- err_log ( ) ;
 -- RAISE;

END load_rest_dim;

END pkg_rest_dim;


--exec pkg_rest_dim.load_rest_dim;
--select count(*) from cls_rest;

  
  
