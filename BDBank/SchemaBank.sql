/* ---------------------------------------------------- */
/*  BANCO BDBANCO                   	                */
/*  sentencias para la creación del esquema             */
/*  Ejecutar usando un usuario DBA como system          */
/* ---------------------------------------------------- */
CREATE TABLESPACE DEF_BDBANCO DATAFILE 'C:/oraclexe/app/oracle/oradata/XE/def_bdbanco.DBF' SIZE 5M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE TMP_BDBANCO TEMPFILE 'C:/oraclexe/app/oracle/oradata/XE/tmp_bdbanco.DBF' SIZE 2M AUTOEXTEND ON;
CREATE TABLESPACE DEF_USERBDBANCO DATAFILE 'C:/oraclexe/app/oracle/oradata/XE/def_userbdbanco.DBF' SIZE 5M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE TMP_USERBDBANCO TEMPFILE 'C:/oraclexe/app/oracle/oradata/XE/tmp_userbdbanco.DBF' SIZE 2M AUTOEXTEND ON;

CREATE USER BDBANCO 
IDENTIFIED BY bdbanco
DEFAULT TABLESPACE DEF_BDBANCO
TEMPORARY TABLESPACE TMP_BDBANCO
QUOTA 2M ON BANCO

GRANT CONNECT,RESOURCE,DBA TO BDBANCO;
