 CREATE TABLE star_cls_rest AS
 SELECT * FROM u_3nf_cl.cls_Addresses WHERE id_src = 0 ;
/*
SELECT   * BULK COLLECT
INTO l_objects
FROM u_3nf.t_rest_country c_con
, u_3nf.t_rest_census_region c_reg
, u_3nf.t_rest_census_division c_div
, u_3nf.t_rest_state_inf c_st
, u_3nf.t_rest_personal c_pers
WHERE c_con.country = c_reg.country
AND c_div.census_region = c_reg.census_region
AND c_div.census_division = c_st.census_division
AND c_st.state_code = c_pers.state_code
AND c_con.is_valid = 'Y'
AND c_reg.is_valid = 'Y'
AND c_div.is_valid = 'Y'
AND c_st.is_valid = 'Y'
AND c_pers.is_valid = 'Y'*/