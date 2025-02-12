DROP ROLE USUARIOBANCO;
DROP USER USUARIO01;
---SYNONYM
CREATE PUBLIC SYNONYM CUENTA FOR BDBANCO.CUENTA;
CREATE PUBLIC SYNONYM CLIENTEBANCO FOR BDBANCO.CLIENTE;
CREATE PUBLIC SYNONYM PAGO FOR BDBANCO.PAGO;

---ROLES
CREATE ROLE USUARIOBANCO;
GRANT EXECUTE ON PR_pagoBanco TO R_REPVENTAS;
GRANT EXECUTE ON PR_pagoBanco TO R_CLIENTE;
GRANT CONNECT,RESOURCE,CREATE USER TO USUARIOBANCO;
GRANT SELECT,INSERT,UPDATE,DELETE ON CUENTA TO USUARIOBANCO;
GRANT SELECT,INSERT,UPDATE ON CLIENTEBANCO TO USUARIOBANCO;
GRANT SELECT,INSERT ON PAGO TO USUARIOBANCO;
CREATE USER USUARIO01 IDENTIFIED BY usuario01 DEFAULT TABLESPACE DEF_USERBDBANCO TEMPORARY TABLESPACE TMP_USERBDBANCO QUOTA 2M ON DEF_USERBDBANCO;
GRANT USUARIOBANCO TO USUARIO01;

