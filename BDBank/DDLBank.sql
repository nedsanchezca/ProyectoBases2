--  Drop Tables 
DROP TABLE Cuenta CASCADE CONSTRAINTS
;
DROP TABLE Cliente CASCADE CONSTRAINTS
;
DROP TABLE Pago CASCADE CONSTRAINTS
;

--  Create Tables 
CREATE TABLE Cuenta ( 
	K_CUENTA NUMBER(10) NOT NULL,    --  Llave primaria tabla de cuenta 
	FK_CLIENTE NUMBER(10) NOT NULL,    --  Llave foranea del cliente a a la que pertenece la cuenta 
	N_NUMCUENTA CHAR(10) NOT NULL,    --  Numero de cuenta de 10 digitos  
	N_SALDO NUMBER(20) NOT NULL		-- Saldo en la cuenta
)
;
COMMENT ON TABLE Cuenta IS 'Tabla que maneja las cuentas del cliente';
COMMENT ON COLUMN Cuenta.K_CUENTA IS 'Llave primaria tabla de cuenta';
COMMENT ON COLUMN Cuenta.FK_CLIENTE IS 'Llave foranea de la empresa a la que pertenece la cuenta';
COMMENT ON COLUMN Cuenta.N_NUMCUENTA IS 'Numero de cuenta de 10 digitos ';
COMMENT ON COLUMN Cuenta.N_SALDO IS 'Saldo del cliente en la cuenta';

CREATE TABLE Cliente ( 
	K_Cliente NUMBER(10) NOT NULL,    --  Llave primaria tabla cliente 
	N_NOMBRE VARCHAR(100) NOT NULL,    --  Nombre del cliente
	N_APELLIDO VARCHAR(100) NOT NULL,	--  Apellido del cliente
	N_ID CHAR(10) NOT NULL,    --  ID cliente
	N_TIPOID CHAR(1) NOT NULL -- Tipo del ID del cliente
)
;
COMMENT ON TABLE Cliente IS 'Clientes asociadas al banco';
COMMENT ON COLUMN Cliente.K_CLIENTE IS 'Llave primaria tabla cliente';
COMMENT ON COLUMN Cliente.N_NOMBRE IS 'Nombre del cliente';
COMMENT ON COLUMN Cliente.N_APELLIDO IS 'Apellido del cliente';
COMMENT ON COLUMN Cliente.N_ID IS 'ID asosiado al cliente';
COMMENT ON COLUMN Cliente.N_TIPOID IS 'Tipo de ID asosiado al cliente';

CREATE TABLE Pago ( 
	K_PAGO NUMBER(10) NOT NULL,    --  Llave primaria de la tabla 
	N_MONTOPAGO NUMBER(20) NOT NULL, 		-- 	Sumatoria de todos los pagos realizados
	FK_CUENTAORIGEN NUMBER(10) NOT NULL,    --  Llave foranea cuenta que hace el pago 
	FK_CUENTADESTINO NUMBER(10) NOT NULL    --  Llave foranea cuenta a la cual se le hace le pago 
)
;
COMMENT ON TABLE Pago IS 'Tabla que maneja los pagos hechos a diferentes cuentas' ;
COMMENT ON COLUMN Pago.K_PAGO IS 'Llave primaria de la tabla';
COMMENT ON COLUMN Pago.N_MONTOPAGO IS 'Llave primaria de la tabla';
COMMENT ON COLUMN Pago.FK_CUENTAORIGEN IS 'Llave foranea cuenta que hace el pago';
COMMENT ON COLUMN Pago.FK_CUENTADESTINO IS 'Llave foranea cuenta a la cual se le hace le pago';


--  Create Primary Key Constraints 
ALTER TABLE Cuenta ADD CONSTRAINT PK_Cuenta 
	PRIMARY KEY (K_CUENTA)
;

ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente
	PRIMARY KEY (K_CLIENTE)
;

ALTER TABLE Pago ADD CONSTRAINT PK_Pago 
	PRIMARY KEY (K_PAGO)
;

--  Create Indexes 
ALTER TABLE Cuenta
	ADD CONSTRAINT UK_NUMCUENTA UNIQUE (N_NUMCUENTA)
;

ALTER TABLE Cliente
	ADD CONSTRAINT UK_QID UNIQUE (N_ID)
;

--  Create Foreign Key Constraints 
ALTER TABLE Cuenta ADD CONSTRAINT FK_Cuenta_Cliente 
	FOREIGN KEY (FK_CLIENTE) REFERENCES Cliente (K_CLIENTE)
;

ALTER TABLE Pago ADD CONSTRAINT FK_Pago_CuentaOr 
	FOREIGN KEY (FK_CUENTAORIGEN) REFERENCES Cuenta (K_CUENTA)
;

ALTER TABLE Pago ADD CONSTRAINT FK_Pago_CuentaDes 
	FOREIGN KEY (FK_CUENTADESTINO) REFERENCES Cuenta (K_CUENTA)
;