--  Drop Tables 
DROP TABLE Cuenta CASCADE CONSTRAINTS
;
DROP TABLE Empresa CASCADE CONSTRAINTS
;
DROP TABLE Pago CASCADE CONSTRAINTS
;

--  Create Tables 
CREATE TABLE Cuenta ( 
	K_CUENTA NUMBER(10) NOT NULL,    --  Llave primaria tabla de cuenta 
	FK_EMPRESA NUMBER(10) NOT NULL,    --  Llave foranea de la empresa a la que pertenece la cuenta 
	N_NUMCUENTA CHAR(10) NOT NULL    --  Numero de cuenta de 10 digitos  
)
;
COMMENT ON TABLE Cuenta IS 'Tabla que maneja las cuentas de la empresa';
COMMENT ON COLUMN Cuenta.K_CUENTA IS 'Llave primaria tabla de cuenta';
COMMENT ON COLUMN Cuenta.FK_EMPRESA IS 'Llave foranea de la empresa a la que pertenece la cuenta';
COMMENT ON COLUMN Cuenta.N_NUMCUENTA IS 'Numero de cuenta de 10 digitos ';

CREATE TABLE Empresa ( 
	K_EMPRESA NUMBER(10) NOT NULL,    --  Llave primaria tabla empresa 
	N_NOMBRE VARCHAR(100) NOT NULL,    --  Nombre de la empresa 
	N_NIT CHAR(10) NOT NULL    --  NIT asosiado a la empresa 
)
;
COMMENT ON TABLE Empresa IS 'Empresas asociadas al banco';
COMMENT ON COLUMN Empresa.K_EMPRESA IS 'Llave primaria tabla empresa';
COMMENT ON COLUMN Empresa.N_NOMBRE IS 'Nombre de la empresa';
COMMENT ON COLUMN Empresa.N_NIT IS 'NIT asosiado a la empresa';

CREATE TABLE Pago ( 
	K_PAGO NUMBER(10) NOT NULL,    --  Llave primaria de la tabla 
	FK_CUENTAORIGEN NUMBER(10) NOT NULL,    --  Llave foranea cuenta que hace el pago 
	FK_CUENTADESTINO NUMBER(10) NOT NULL    --  Llave foranea cuenta a la cual se le hace le pago 
)
;
COMMENT ON TABLE Pago IS 'Tabla que maneja los pagos hechos a diferentes cuentas' ;
COMMENT ON COLUMN Pago.K_PAGO IS 'Llave primaria de la tabla';
COMMENT ON COLUMN Pago.FK_CUENTAORIGEN IS 'Llave foranea cuenta que hace el pago';
COMMENT ON COLUMN Pago.FK_CUENTADESTINO IS 'Llave foranea cuenta a la cual se le hace le pago';


--  Create Primary Key Constraints 
ALTER TABLE Cuenta ADD CONSTRAINT PK_Cuenta 
	PRIMARY KEY (K_CUENTA)
;

ALTER TABLE Empresa ADD CONSTRAINT PK_Empresa 
	PRIMARY KEY (K_EMPRESA)
;

ALTER TABLE Pago ADD CONSTRAINT PK_Pago 
	PRIMARY KEY (K_PAGO)
;

--  Create Indexes 
ALTER TABLE Cuenta
	ADD CONSTRAINT UK_NUMCUENTA UNIQUE (N_NUMCUENTA)
;

ALTER TABLE Empresa
	ADD CONSTRAINT UK_QNIT UNIQUE (N_NIT)
;

--  Create Foreign Key Constraints 
ALTER TABLE Cuenta ADD CONSTRAINT FK_Cuenta_Empresa 
	FOREIGN KEY (FK_EMPRESA) REFERENCES Empresa (K_EMPRESA)
;

ALTER TABLE Pago ADD CONSTRAINT FK_Pago_CuentaOr 
	FOREIGN KEY (FK_CUENTAORIGEN) REFERENCES Cuenta (K_CUENTA)
;

ALTER TABLE Pago ADD CONSTRAINT FK_Pago_CuentaDes 
	FOREIGN KEY (FK_CUENTADESTINO) REFERENCES Cuenta (K_CUENTA)
;