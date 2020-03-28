/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 13.5 		*/
/*  Created On : 13-feb-2020 22:21:28 				*/
/*  DBMS       : Oracle 						*/
/* ---------------------------------------------------- */

/* Drop Tables */

begin
	EXECUTE IMMEDIATE 'DROP TABLE   calificacion CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   categoria CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   clasificacion CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   cliente CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   detalle_pedido CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   historico_clasificacion CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   inventario CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   pais CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   pedido CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   persona CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   producto CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   region CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
	EXECUTE IMMEDIATE 'DROP TABLE   rep_ventas CASCADE CONSTRAINTS';
	EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

/* Create Tables */

CREATE TABLE  calificacion
(
	K_ID NUMBER(7) NOT NULL,    -- Identificacion de cada una de las calificaciones
	V_VALORACION NUMBER(1) NOT NULL,    -- Valor de la calificaci�n
	N_COMENTARIO VARCHAR(200) NULL,    -- Comentario de la venta
	F_N_FACTURA NUMBER(7) NOT NULL    -- Almacena la llave foranea de la factura
)
;

CREATE TABLE  categoria
(
	K_ID NUMBER(8) NOT NULL,    -- Llave primaria de la subcategoria
	N_NOMBRE VARCHAR(30) NOT NULL,    -- Nombre de la subcategoria
	V_IVA NUMBER(5,2) NULL,
	F_ID NUMBER(8) NULL    -- Llave foranea utilizada para la subcategoria
)
;

CREATE TABLE  clasificacion
(
	K_ID NUMBER(2) NOT NULL,    -- Identificador de la clasificacion de rep. de ventas
	N_NOMBRE VARCHAR(20) NOT NULL,    -- Nombre de la clasificacion del re. de ventas
	V_COMISION NUMBER(5,2) NOT NULL,    -- porcentaje de comision para la clasificacion de rep. de ventas
	V_VENTA_MINIMA NUMBER(9,2) NOT NULL,
	V_CALIFICACION_MINIMA NUMBER(2,1) NOT NULL
)
;

CREATE TABLE  cliente
(
	F_NUMERO_ID VARCHAR(40) NOT NULL,    -- Numero de identificacion del cliente
	F_TIPO_ID CHAR(1) NOT NULL,    -- Tipo de ID 
	T_TELEFONO NUMBER(12) NOT NULL,    -- telefono del cliente
	E_CORREO VARCHAR(50) NOT NULL,    -- Correo del cliente
	F_ID_REP_VENTAS VARCHAR(40) NOT NULL,    -- ID del prepresentante de ventas que lo vinculo
	F_TIPO_ID_REP_VENTAS CHAR(1) NOT NULL    -- Tipo de id del rep de ventas que lo capto
)
;

CREATE TABLE  detalle_pedido
(
	K_ITEM NUMBER(4) NOT NULL,    -- Numero de identificacion del producto
	V_CANTIDAD NUMBER(5) NOT NULL,    -- Indica la candidad comprada de determinado producto
	F_N_FACTURA NUMBER(7) NOT NULL,    -- Relaciona el detalle con la factura a la que pertenece
	F_ID_INVENTARIO NUMBER(8) NOT NULL    -- Relaciona el detalle de cada pedido con el inventario de la regi�n
)
;

CREATE TABLE  historico_clasificacion
(
	K_ID_HISTORICO NUMBER(4) NOT NULL,
	D_FECHA_INICIAL DATE NOT NULL,
	D_FECHA_FINAL DATE NULL,
	F_NUM_ID VARCHAR(40) NULL,
	F_TIPO_ID CHAR(1) NULL,
	F_ID_CLASIFICACION NUMBER(2) NULL
)
;

CREATE TABLE  inventario
(
	K_ID NUMBER(8) NOT NULL,    -- Identificador del inventario de cierto producto en la regional 
	V_PRECIO NUMBER(9,2) NOT NULL,    -- Precio del producto en esa region
	V_DISPONIBILIDAD NUMBER(5) NOT NULL,    -- Disponibilidad del producto en esa region
	F_CODIGO_PRODUCTO NUMBER(8) NOT NULL,    -- Recibe la llave foranea del codigo del producto
	F_CODIGO_POSTAL VARCHAR(7) NOT NULL    -- Recibe la llave foranea del codigo postal de la region
)
;

CREATE TABLE  pais
(
	K_CODIGO_ISO_NUM NUMBER(3) NOT NULL,    -- ISO 3166-1 como parte del est�ndar ISO 3166 proporciona c�digos para los nombres de pa�ses y otras dependencias administrativas. ISO 3166-1 num�rico, sistema de tres d�gitos.
	N_NOMBRE VARCHAR(70) NOT NULL    -- Nombre del pais
)
;

CREATE TABLE  pedido
(
	K_N_FACTURA NUMBER(7) NOT NULL,    -- Llave primaria para identificar la factura
	I_ESTADO CHAR(1) NOT NULL,    -- Permite conocer el estado en el que se encuentra un pedido
	D_FECHA DATE NOT NULL,    -- Fecha en la cual realizo el pedido
	F_NUMERO_ID VARCHAR(40) NOT NULL,    -- Recibe la llave foranea de la tabla cliente
	F_TIPO_ID CHAR(1) NOT NULL    -- Recibe el tipo de ID del cliente
)
;

CREATE TABLE  persona
(
	K_NUMERO_ID VARCHAR(40) NOT NULL,    -- Numero de identificacio de la persona
	K_TIPO_ID CHAR(1) NOT NULL,    -- Tipo de documento de la persona
	N_NOMBRE VARCHAR(25) NOT NULL,    -- Nombre de la persona
	N_APELLIDO VARCHAR(25) NOT NULL,    -- Apellido de la persona
	A_DIRECCION VARCHAR(50) NOT NULL,    -- Direccion de residencia de la persona
	C_CIUDAD VARCHAR(25) NOT NULL    -- Ciudad de la persona
)
;

CREATE TABLE  producto
(
	K_CODIGO_PRODUCTO NUMBER(8) NOT NULL,    -- Codigo identificador del producto
	N_NOMBRE_PRODUCTO VARCHAR(30) NOT NULL,    -- Nombre del producto
	F_ID NUMBER(8) NOT NULL
)
;

CREATE TABLE  region
(
	K_CODIGO_POSTAL VARCHAR(7) NOT NULL,    -- Codigo postal de la region
	N_NOMBRE VARCHAR(30) NOT NULL,    -- nombre de la regional
	F_CODIGO_ISO_NUM NUMBER(3) NOT NULL,    -- Llave foranea que indica el pa�s al cual pertenece la region
	F_NUMERO_ID VARCHAR(40) NULL,
	F_TIPO_ID CHAR(1) NULL
)
;

CREATE TABLE  rep_ventas
(
	F_NUMERO_ID VARCHAR(40) NOT NULL,    -- Identificador de la persona que es representante de ventas
	F_TIPO_ID CHAR(1) NOT NULL,    -- Tipo de ID de la persona
	E_CORREO VARCHAR(50) NOT NULL,    -- Correo del representante de ventas
	T_TELEFONO NUMBER(12) NOT NULL,    -- Telefono del representante de ventas
	I_GENERO CHAR(1) NOT NULL,    -- Genero del representante de ventas
	D_FECHA_CONTRATO DATE NOT NULL,    -- Fecha de contratacion del representante de ventas
	D_FECHA_NACIMIENTO DATE NOT NULL,    -- Fecha de nacimiento del representante de ventas
	F_ID_REP_CAPATADOR VARCHAR(40) NULL,    -- Recible llave foranea de otro representante de ventas que lo ha captado
	F_TIPO_ID_REP_CAPATADOR CHAR(1) NULL,    -- Recible llave foranea de otro representante de ventas que lo ha captado
	F_CODIGO_POSTAL VARCHAR(7) NOT NULL    -- Recible llave foranea de a region a la que pertenece el representante de ventas
)
;

/* Create Comments, Sequences and Triggers for Autonumber Columns */

COMMENT ON TABLE  calificacion IS 'Contiene los registros de cada calificacion a los representantes de ventas por cada uno de los pedidos'
;

COMMENT ON COLUMN  calificacion.K_ID IS 'Identificacion de cada una de las calificaciones'
;

COMMENT ON COLUMN  calificacion.V_VALORACION IS 'Valor de la calificaci�n'
;

COMMENT ON COLUMN  calificacion.N_COMENTARIO IS 'Comentario de la venta'
;

COMMENT ON COLUMN  calificacion.F_N_FACTURA IS 'Almacena la llave foranea de la factura'
;

COMMENT ON TABLE  categoria IS 'Contiene las subcategorias y sus caracteristicas'
;

COMMENT ON COLUMN  categoria.K_ID IS 'Llave primaria de la subcategoria'
;

COMMENT ON COLUMN  categoria.N_NOMBRE IS 'Nombre de la subcategoria'
;

COMMENT ON COLUMN  categoria.F_ID IS 'Llave foranea utilizada para la subcategoria'
;

COMMENT ON TABLE  clasificacion IS 'Contiene las caracteristicas de clasificacion para un representante de ventas'
;

COMMENT ON COLUMN  clasificacion.K_ID IS 'Identificador de la clasificacion de rep. de ventas'
;

COMMENT ON COLUMN  clasificacion.N_NOMBRE IS 'Nombre de la clasificacion del re. de ventas'
;

COMMENT ON COLUMN  clasificacion.V_COMISION IS 'porcentaje de comision para la clasificacion de rep. de ventas'
;

COMMENT ON TABLE  cliente IS 'Tabla con los datos de cada cliente'
;

COMMENT ON COLUMN  cliente.F_NUMERO_ID IS 'Numero de identificacion del cliente'
;

COMMENT ON COLUMN  cliente.F_TIPO_ID IS 'Tipo de ID '
;

COMMENT ON COLUMN  cliente.T_TELEFONO IS 'telefono del cliente'
;

COMMENT ON COLUMN  cliente.E_CORREO IS 'Correo del cliente'
;

COMMENT ON COLUMN  cliente.F_ID_REP_VENTAS IS 'ID del prepresentante de ventas que lo vinculo'
;

COMMENT ON COLUMN  cliente.F_TIPO_ID_REP_VENTAS IS 'Tipo de id del rep de ventas que lo capto'
;

COMMENT ON TABLE  detalle_pedido IS 'Esta tabla contiene detalle de los productos de cada venta.'
;

COMMENT ON COLUMN  detalle_pedido.K_ITEM IS 'Numero de identificacion del producto'
;

COMMENT ON COLUMN  detalle_pedido.V_CANTIDAD IS 'Indica la candidad comprada de determinado producto'
;

COMMENT ON COLUMN  detalle_pedido.F_N_FACTURA IS 'Relaciona el detalle con la factura a la que pertenece'
;

COMMENT ON COLUMN  detalle_pedido.F_ID_INVENTARIO IS 'Relaciona el detalle de cada pedido con el inventario de la regi�n'
;

COMMENT ON TABLE  inventario IS 'Almacena los productos de una region'
;

COMMENT ON COLUMN  inventario.K_ID IS 'Identificador del inventario de cierto producto en la regional '
;

COMMENT ON COLUMN  inventario.V_PRECIO IS 'Precio del producto en esa region'
;

COMMENT ON COLUMN  inventario.V_DISPONIBILIDAD IS 'Disponibilidad del producto en esa region'
;

COMMENT ON COLUMN  inventario.F_CODIGO_PRODUCTO IS 'Recibe la llave foranea del codigo del producto'
;

COMMENT ON COLUMN  inventario.F_CODIGO_POSTAL IS 'Recibe la llave foranea del codigo postal de la region'
;

COMMENT ON TABLE  pais IS 'Pais el cual contiene regiones'
;

COMMENT ON COLUMN  pais.K_CODIGO_ISO_NUM IS 'ISO 3166-1 como parte del est�ndar ISO 3166 proporciona c�digos para los nombres de pa�ses y otras dependencias administrativas. ISO 3166-1 num�rico, sistema de tres d�gitos.'
;

COMMENT ON COLUMN  pais.N_NOMBRE IS 'Nombre del pais'
;

COMMENT ON TABLE  pedido IS 'Esta tabla contiene el encabezado de cada uno de los pedidos'
;

COMMENT ON COLUMN  pedido.K_N_FACTURA IS 'Llave primaria para identificar la factura'
;

COMMENT ON COLUMN  pedido.I_ESTADO IS 'Permite conocer el estado en el que se encuentra un pedido'
;

COMMENT ON COLUMN  pedido.D_FECHA IS 'Fecha en la cual realizo el pedido'
;

COMMENT ON COLUMN  pedido.F_NUMERO_ID IS 'Recibe la llave foranea de la tabla cliente'
;

COMMENT ON COLUMN  pedido.F_TIPO_ID IS 'Recibe el tipo de ID del cliente'
;

COMMENT ON TABLE  persona IS 'Contiene datos generales'
;

COMMENT ON COLUMN  persona.K_NUMERO_ID IS 'Numero de identificacio de la persona'
;

COMMENT ON COLUMN  persona.K_TIPO_ID IS 'Tipo de documento de la persona'
;

COMMENT ON COLUMN  persona.N_NOMBRE IS 'Nombre de la persona'
;

COMMENT ON COLUMN  persona.N_APELLIDO IS 'Apellido de la persona'
;

COMMENT ON COLUMN  persona.A_DIRECCION IS 'Direccion de residencia de la persona'
;

COMMENT ON COLUMN  persona.C_CIUDAD IS 'Ciudad de la persona'
;

COMMENT ON TABLE  producto IS 'Tabla con las caracteristicas de los productos'
;

COMMENT ON COLUMN  producto.K_CODIGO_PRODUCTO IS 'Codigo identificador del producto'
;

COMMENT ON COLUMN  producto.N_NOMBRE_PRODUCTO IS 'Nombre del producto'
;

COMMENT ON TABLE  region IS 'Contiene la informacion de cada una de las regionales'
;

COMMENT ON COLUMN  region.K_CODIGO_POSTAL IS 'Codigo postal de la region'
;

COMMENT ON COLUMN  region.N_NOMBRE IS 'nombre de la regional'
;

COMMENT ON COLUMN  region.F_CODIGO_ISO_NUM IS 'Llave foranea que indica el pa�s al cual pertenece la region'
;

COMMENT ON TABLE  rep_ventas IS 'Informacion sobre los representantes de ventas'
;

COMMENT ON COLUMN  rep_ventas.F_NUMERO_ID IS 'Identificador de la persona que es representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.F_TIPO_ID IS 'Tipo de ID de la persona'
;

COMMENT ON COLUMN  rep_ventas.E_CORREO IS 'Correo del representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.T_TELEFONO IS 'Telefono del representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.I_GENERO IS 'Genero del representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.D_FECHA_CONTRATO IS 'Fecha de contratacion del representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.D_FECHA_NACIMIENTO IS 'Fecha de nacimiento del representante de ventas'
;

COMMENT ON COLUMN  rep_ventas.F_ID_REP_CAPATADOR IS 'Recible llave foranea de otro representante de ventas que lo ha captado'
;

COMMENT ON COLUMN  rep_ventas.F_TIPO_ID_REP_CAPATADOR IS 'Recible llave foranea de otro representante de ventas que lo ha captado'
;

COMMENT ON COLUMN  rep_ventas.F_CODIGO_POSTAL IS 'Recible llave foranea de a region a la que pertenece el representante de ventas'
;

/* Create Primary Keys, Indexes, Uniques, Checks, Triggers */

ALTER TABLE  calificacion 
 ADD CONSTRAINT PK_calificacion
	PRIMARY KEY (K_ID) 
 USING INDEX
;

ALTER TABLE  calificacion 
 ADD CONSTRAINT CK_ID_CALIFICACION CHECK (K_ID>0)
;

ALTER TABLE  calificacion 
 ADD CONSTRAINT CK_VALORACION CHECK (V_VALORACION>0 AND V_VALORACION<5)
;

ALTER TABLE  categoria 
 ADD CONSTRAINT PK_subcategoria
	PRIMARY KEY (K_ID) 
 USING INDEX
;

ALTER TABLE  categoria 
 ADD CONSTRAINT CK_ID_CATEGORIA CHECK (K_ID > 0)
;

ALTER TABLE  categoria 
 ADD CONSTRAINT CK_IVA CHECK (V_IVA > 0 AND V_IVA <100)
;

ALTER TABLE  clasificacion 
 ADD CONSTRAINT PK_clasificacion
	PRIMARY KEY (K_ID) 
 USING INDEX
;

ALTER TABLE  clasificacion 
 ADD CONSTRAINT CK_ID_CLASIFICACION CHECK (K_ID>0)
;

ALTER TABLE  clasificacion 
 ADD CONSTRAINT CK_COMISION CHECK (V_COMISION>=0 and V_COMISION<=100)
;

ALTER TABLE  clasificacion 
 ADD CONSTRAINT CK_V_VENTA_MINIMA CHECK (V_VENTA_MINIMA>0)
;

ALTER TABLE  clasificacion 
 ADD CONSTRAINT CK_V_CALIFICACION_MINIMA CHECK (V_CALIFICACION_MINIMA>0)
;

ALTER TABLE  cliente 
 ADD CONSTRAINT PK_cliente
	PRIMARY KEY (F_NUMERO_ID,F_TIPO_ID) 
 USING INDEX
;

ALTER TABLE  cliente 
 ADD CONSTRAINT CK_TELEFONO CHECK (T_TELEFONO>0)
;

ALTER TABLE  cliente 
 ADD CONSTRAINT CK_REP_VENTAS CHECK ((F_ID_REP_VENTAS NOT LIKE F_NUMERO_ID) OR (F_TIPO_ID_REP_VENTAS NOT LIKE F_TIPO_ID))
;

ALTER TABLE  detalle_pedido 
 ADD CONSTRAINT PK_detalle_pedido
	PRIMARY KEY (K_ITEM,F_N_FACTURA) 
 USING INDEX
;

ALTER TABLE  detalle_pedido 
 ADD CONSTRAINT CK_ID_ITEM CHECK (K_ITEM>0)
;

ALTER TABLE  detalle_pedido 
 ADD CONSTRAINT CK_CANTIDAD CHECK (V_CANTIDAD>0)
;

ALTER TABLE  historico_clasificacion 
 ADD CONSTRAINT PK_historico_cl_01
	PRIMARY KEY (K_ID_HISTORICO) 
 USING INDEX
;

ALTER TABLE  inventario 
 ADD CONSTRAINT PK_inventario
	PRIMARY KEY (K_ID) 
 USING INDEX
;

ALTER TABLE  inventario 
 ADD CONSTRAINT CK_ID CHECK (K_ID>0)
;

ALTER TABLE  inventario 
 ADD CONSTRAINT CK_PRECIO CHECK (V_PRECIO >= 0)
;

ALTER TABLE  inventario 
 ADD CONSTRAINT CK_DISPONIBILIDAD CHECK (V_DISPONIBILIDAD>=0)
;

ALTER TABLE  pais 
 ADD CONSTRAINT PK_pais
	PRIMARY KEY (K_CODIGO_ISO_NUM) 
 USING INDEX
;

ALTER TABLE  pais 
 ADD CONSTRAINT CK_CODIGO_ISO_NUM CHECK (K_CODIGO_ISO_NUM>=0)
;

ALTER TABLE  pedido 
 ADD CONSTRAINT PK_pedido
	PRIMARY KEY (K_N_FACTURA) 
 USING INDEX
;

ALTER TABLE  pedido 
 ADD CONSTRAINT CK_ID_N_FACTURA CHECK (K_N_FACTURA > 0)
;

ALTER TABLE  pedido 
 ADD CONSTRAINT CK_ESTADO CHECK (I_ESTADO = 'C' or I_ESTADO = 'P' or I_ESTADO = 'N')
;

ALTER TABLE  persona 
 ADD CONSTRAINT PK_persona
	PRIMARY KEY (K_NUMERO_ID,K_TIPO_ID) 
 USING INDEX
;

ALTER TABLE  persona 
 ADD CONSTRAINT CK_TIPO_ID CHECK (K_TIPO_ID = 'T' or K_TIPO_ID = 'P' or K_TIPO_ID = 'C')
;

ALTER TABLE  persona 
 ADD CONSTRAINT CK_NUMERO_ID CHECK (K_NUMERO_ID >= 0)
;

ALTER TABLE  producto 
 ADD CONSTRAINT PK_producto
	PRIMARY KEY (K_CODIGO_PRODUCTO) 
 USING INDEX
;

ALTER TABLE  producto 
 ADD CONSTRAINT CK_ID_PRODUCTO CHECK (K_CODIGO_PRODUCTO>0)
;

ALTER TABLE  region 
 ADD CONSTRAINT PK_region
	PRIMARY KEY (K_CODIGO_POSTAL) 
 USING INDEX
;

ALTER TABLE  rep_ventas 
 ADD CONSTRAINT PK_rep_ventas
	PRIMARY KEY (F_NUMERO_ID,F_TIPO_ID) 
 USING INDEX
;

ALTER TABLE  rep_ventas 
 ADD CONSTRAINT CK_GENERO CHECK (I_GENERO = 'M' or I_GENERO = 'F' or I_GENERO = 'O')
;

/* Create Foreign Key Constraints */

ALTER TABLE  calificacion 
 ADD CONSTRAINT FK_calificacion_pedido
	FOREIGN KEY (F_N_FACTURA) REFERENCES  pedido (K_N_FACTURA)
;

ALTER TABLE  categoria 
 ADD CONSTRAINT FK_categoria_categoria
	FOREIGN KEY (F_ID) REFERENCES  categoria (K_ID)
;

ALTER TABLE  cliente 
 ADD CONSTRAINT FK_cliente_persona
	FOREIGN KEY (F_NUMERO_ID,F_TIPO_ID) REFERENCES  persona (K_NUMERO_ID,K_TIPO_ID)
;

ALTER TABLE  cliente 
 ADD CONSTRAINT FK_cliente_rep_ventas
	FOREIGN KEY (F_ID_REP_VENTAS,F_TIPO_ID_REP_VENTAS) REFERENCES  rep_ventas (F_NUMERO_ID,F_TIPO_ID)
;

ALTER TABLE  detalle_pedido 
 ADD CONSTRAINT FK_detalle_pedido_inventario
	FOREIGN KEY (F_ID_INVENTARIO) REFERENCES  inventario (K_ID)
;

ALTER TABLE  detalle_pedido 
 ADD CONSTRAINT FK_detalle_pedido_pedido
	FOREIGN KEY (F_N_FACTURA) REFERENCES  pedido (K_N_FACTURA)
;

ALTER TABLE  historico_clasificacion 
 ADD CONSTRAINT FK_historico_cl_clasificaci_01
	FOREIGN KEY (F_ID_CLASIFICACION) REFERENCES  clasificacion (K_ID)
;

ALTER TABLE  historico_clasificacion 
 ADD CONSTRAINT FK_historico_cla_rep_ventas_01
	FOREIGN KEY (F_NUM_ID,F_TIPO_ID) REFERENCES  rep_ventas (F_NUMERO_ID,F_TIPO_ID)
;

ALTER TABLE  inventario 
 ADD CONSTRAINT FK_inventario_producto
	FOREIGN KEY (F_CODIGO_PRODUCTO) REFERENCES  producto (K_CODIGO_PRODUCTO)
;

ALTER TABLE  inventario 
 ADD CONSTRAINT FK_inventario_region
	FOREIGN KEY (F_CODIGO_POSTAL) REFERENCES  region (K_CODIGO_POSTAL)
;

ALTER TABLE  pedido 
 ADD CONSTRAINT FK_pedido_cliente
	FOREIGN KEY (F_NUMERO_ID,F_TIPO_ID) REFERENCES  cliente (F_NUMERO_ID,F_TIPO_ID)
;

ALTER TABLE  producto 
 ADD CONSTRAINT FK_producto_categoria
	FOREIGN KEY (F_ID) REFERENCES  categoria (K_ID)
;

ALTER TABLE  region 
 ADD CONSTRAINT FK_region_pais
	FOREIGN KEY (F_CODIGO_ISO_NUM) REFERENCES  pais (K_CODIGO_ISO_NUM)
;

ALTER TABLE  region 
 ADD CONSTRAINT FK_region_rep_ventas
	FOREIGN KEY (F_NUMERO_ID,F_TIPO_ID) REFERENCES  rep_ventas (F_NUMERO_ID,F_TIPO_ID)
;

ALTER TABLE  rep_ventas 
 ADD CONSTRAINT FK_rep_ventas_persona
	FOREIGN KEY (F_NUMERO_ID,F_TIPO_ID) REFERENCES  persona (K_NUMERO_ID,K_TIPO_ID)
;

ALTER TABLE  rep_ventas 
 ADD CONSTRAINT FK_rep_ventas_region
	FOREIGN KEY (F_CODIGO_POSTAL) REFERENCES  region (K_CODIGO_POSTAL)
;

ALTER TABLE  rep_ventas 
 ADD CONSTRAINT FK_rep_ventas_rep_ventas
	FOREIGN KEY (F_ID_REP_CAPATADOR,F_TIPO_ID_REP_CAPATADOR) REFERENCES  rep_ventas (F_NUMERO_ID,F_TIPO_ID)
;

CREATE SEQUENCE PEDIDO_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;
