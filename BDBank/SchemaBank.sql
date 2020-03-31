/* ---------------------------------------------------- */
/*  BANCO BDBANCO                   	                */
/*  sentencias para la creación del esquema             */
/*  Ejecutar usando un usuario DBA como system          */
/* ---------------------------------------------------- */
CREATE TABLESPACE DEF_BDBANCO DATAFILE 'C:/app/ManuelBernal/oradata/orcl/def_bdbanco.DBF' SIZE 5M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE TMP_BDBANCO TEMPFILE 'C:/app/ManuelBernal/oradata/orcl/tmp_bdbanco.DBF' SIZE 2M AUTOEXTEND ON;
CREATE TABLESPACE DEF_USERBDBANCO DATAFILE 'C:/app/ManuelBernal/oradata/orcl/def_userbdbanco.DBF' SIZE 5M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE TMP_USERBDBANCO TEMPFILE 'C:/app/ManuelBernal/oradata/orcl/tmp_userbdbanco.DBF' SIZE 2M AUTOEXTEND ON;

CREATE USER BDBANCO 
IDENTIFIED BY bdbanco
DEFAULT TABLESPACE DEF_BDBANCO
TEMPORARY TABLESPACE TMP_BDBANCO
QUOTA 2M ON DEF_BDBANCO;

GRANT CONNECT,RESOURCE,DBA TO BDBANCO;
