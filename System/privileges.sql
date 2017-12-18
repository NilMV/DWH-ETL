CREATE TABLESPACE ts_part_fact_f_1
DATAFILE 'ts_part_fact_f_1.dat'
SIZE 200M
AUTOEXTEND ON NEXT 100M
SEGMENT SPACE MANAGEMENT AUTO;
   
CREATE TABLESPACE ts_part_fact_f_2
DATAFILE 'ts_part_fact_f_2.dat'
SIZE 200M
AUTOEXTEND ON NEXT 100M
SEGMENT SPACE MANAGEMENT AUTO;
   
CREATE TABLESPACE ts_part_fact_f_3
DATAFILE 'ts_part_fact_f_3.dat'
SIZE 200M
AUTOEXTEND ON NEXT 100M
SEGMENT SPACE MANAGEMENT AUTO;
   
CREATE TABLESPACE ts_part_fact_f_4
DATAFILE 'ts_part_fact_f_4.dat'
SIZE 200M
AUTOEXTEND ON NEXT 100M
SEGMENT SPACE MANAGEMENT AUTO;
   
   
ALTER USER u_star DEFAULT TABLESPACE ts_part_fact_f_1 quota unlimited on ts_part_fact_f_1;
ALTER USER u_star DEFAULT TABLESPACE ts_part_fact_f_2 quota unlimited on ts_part_fact_f_2;
ALTER USER u_star DEFAULT TABLESPACE ts_part_fact_f_3 quota unlimited on ts_part_fact_f_3;
ALTER USER u_star DEFAULT TABLESPACE ts_part_fact_f_4 quota unlimited on ts_part_fact_f_4;






GRANT ALL ON u_src.src_clients TO U_3NF_CL ;
GRANT ALL ON u_src.src_menu TO U_3NF_CL ;
GRANT ALL ON u_src.src_addresses TO U_3NF_CL ;
GRANT ALL ON u_src.src_employees TO U_3NF_CL ;

GRANT ALL ON u_src.src_group TO U_3NF_CL ;

GRANT ALL ON u_3nf_cl.cls_clients TO U_3NF ;
GRANT ALL ON u_3nf_cl.cls_menu TO U_3NF ;
GRANT ALL ON u_3nf_cl.cls_addresses TO U_3NF ;
GRANT ALL ON u_3nf_cl.cls_employees TO U_3NF ;
GRANT ALL ON u_3nf_cl.cls_clients TO U_3NF ;
GRANT ALL ON u_3nf_cl.cls_groups TO U_3NF ;

GRANT ALL ON u_star.dim_time TO U_SRC ;
GRANT ALL ON u_src.src_facts_2 TO U_STAR ;


GRANT ALL ON u_3nf_cl.cls_clients TO U_STAR_CL ;
GRANT ALL ON u_3nf_cl.cls_employees TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_clients_census_division TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_clients_census_region TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_clients_country TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_clients_personal TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_clients_state_inf TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_employees_census_division TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_employees_census_region TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_employees_country TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_employees_personal TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_employees_state_inf TO U_STAR_CL ;

GRANT ALL ON u_3nf.t_rest_census_division TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_rest_census_region TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_rest_country TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_rest_personal TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_rest_state_inf TO U_STAR_CL ;


GRANT ALL ON u_3nf.t_menu TO U_STAR_CL ;
GRANT ALL ON u_3nf.t_groups TO U_STAR_CL ;


GRANT ALL ON u_3nf_cl.cls_groups TO U_STAR_CL ;
GRANT ALL ON u_3nf_cl.cls_menu TO U_STAR_CL ;


GRANT ALL ON u_star_cl.star_cls_Clients TO U_STAR ;
GRANT ALL ON u_star_cl.star_cls_Employees TO U_STAR ;
GRANT ALL ON u_star_cl.star_cls_Menu TO U_STAR ;
GRANT ALL ON u_star_cl.star_cls_Groups TO U_STAR ;
GRANT ALL ON u_star_cl.star_cls_Rest TO U_STAR ;

GRANT ALL ON u_star.dim_time TO U_3nf ;
GRANT ALL ON u_star.fct_sales_r TO U_3nf ;
GRANT ALL ON u_src.src_facts_2 TO U_3nf ;


GRANT ALL ON u_src.src_facts TO U_STAR ;


ALTER USER u_star DEFAULT TABLESPACE TS_STAR_DATA quota unlimited on TS_STAR_DATA;


ALTER USER u_star_cl DEFAULT TABLESPACE TS_STAR_CL quota unlimited on TS_STAR_CL;





