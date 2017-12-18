--==============================================================
-- User: u_sa_... for the nth source system
--==============================================================

CREATE USER u_src
  IDENTIFIED BY "%123%"
    DEFAULT TABLESPACE ts_u_src;

GRANT CONNECT,RESOURCE TO u_src;



--==============================================================
-- User: u_3nf_cl for the first cleansing layer
--==============================================================
CREATE USER u_3nf_cl
  IDENTIFIED BY "%12345%"
    DEFAULT TABLESPACE ts_3nf_cl;

GRANT CONNECT,RESOURCE TO u_3nf_cl;

--==============================================================
-- User: u_3nf for the 3NF layer
--==============================================================
CREATE USER u_3nf
  IDENTIFIED BY "%12345%"
    DEFAULT TABLESPACE ts_3nf_data;

GRANT CONNECT,RESOURCE TO u_3nf;

--==============================================================
-- User: u_star_cl for the second cleansing layer
--==============================================================
CREATE USER u_star_cl
  IDENTIFIED BY "%12345%"
	DEFAULT TABLESPACE ts_star_cl;
	
GRANT CONNECT,RESOURCE TO u_star_cl;

--==============================================================
-- User: u_star for the Star Layer
--==============================================================
CREATE USER u_star
  IDENTIFIED BY "%12345%"
	DEFAULT TABLESPACE ts_star_data;
	
GRANT CONNECT,RESOURCE TO u_star;

