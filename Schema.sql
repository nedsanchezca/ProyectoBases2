/* ---------------------------------------------------- */
/*  ESQUEMA VENTAS MULTINIVEL NATAME:	                */
/*  sentencias para la creación del esquema             */
/*  Ejecutar usando un usuario DBA como system          */
/* ---------------------------------------------------- */

/*Creación de los tablespaces para el usuario (esquema) propietario de la BD*/

CREATE TABLESPACE DEF_NATAME
DATAFILE 'C:/oraclexe/app/oracle/oradata/XE/def_natame.dbf'
SIZE 2M
AUTOEXTEND ON;

CREATE TEMPORARY TABLESPACE TMP_NATAME
TEMPFILE 'C:/oraclexe/app/oracle/oradata/XE/tmp_natame.dbf'
SIZE 2M
AUTOEXTEND ON;

/*Creación del esquema propietario de las tablas de la BD y asociación con los tablespaces anteriores*/

CREATE USER NATAME
IDENTIFIED BY natame
DEFAULT TABLESPACE DEF_NATAME
TEMPORARY TABLESPACE TMP_NATAME
QUOTA 2M ON DEF_NATAME;

GRANT CONNECT,RESOURCE,DBA TO NATAME;