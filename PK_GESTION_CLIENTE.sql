/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Funciones y procedimientos asociados al módulo de Gestión de clientes.
  Autores    : Nestor Sanchez, Jairo Andrés Romero, Gabriela Ladino, Juan Diego Avila, Cristian Bernal.
--------------------------------------------------------------------------------------*/

/*------------------Package Header-------------------------*/
CREATE OR REPLACE PACKAGE PK_GESTION_CLIENTE AS 

    /*------------------------------------------------------------------------------
    Procedimiento para cambiar el representante de ventas de un cliente. Sele asigna uno del 
    mismo tipo y regional, si no lo hay se le asigna uno del mismo tipo y si no lo hay, se le
    asigna uno de la misma regional
    Parametros de Entrada: pk_tipo_id           Tipo de identificacion del cliente que quiere cambiar.
                           pk_num_id            Número de identificacion del cliente que quiere cambiar.
    Parametros de Salida:  pc_error        = 1 si no existe el cliente ingresado,
                                             2 si no hay nigún representante que cumpla las condiciones,
                                             0, en otro caso.
                           pm_error         Mensaje de error o de exito.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_CAMBIAR_RVENTAS(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
                                 pk_num_id IN CLIENTE.F_NUMERO_ID%TYPE,
                                 pc_error OUT INTEGER,
                                 pm_error OUT VARCHAR);

    /*------------------------------------------------------------------------------
    Procedimiento auxiliar para crear usuarios en el sistema y no conferir directamente el privilegio
    de crear usuarios.
    Parametros de Entrada: pk_tipo_id           Tipo de identificacion del cliente al que corresponde el nuevo usuario.
                           pk_num_id            Número de identificacion del cliente al que corresponde el nuevo usuario.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_CREAR_USUARIO(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
                               pk_num_id IN CLIENTE.F_NUMERO_ID%TYPE);

END PK_GESTION_REPRESENTANTE;

/*------------------Package Body-------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_GESTION_CLIENTE AS 

    /*------------------------------------------------------------------------------
    Procedimiento para cambiar el representante de ventas de un cliente. Sele asigna uno del 
    mismo tipo y regional, si no lo hay se le asigna uno del mismo tipo y si no lo hay, se le
    asigna uno de la misma regional
    Parametros de Entrada: pk_tipo_id           Tipo de identificacion del cliente que quiere cambiar.
                           pk_num_id            Número de identificacion del cliente que quiere cambiar.
    Parametros de Salida:  pc_error        = 1 si no existe el cliente ingresado,
                                             2 si no hay nigún representante que cumpla las condiciones,
                                             0, en otro caso.
                           pm_error         Mensaje de error o de exito.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_CAMBIAR_RVENTAS(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
                                                   pk_num_id IN CLIENTE.F_NUMERO_ID%TYPE,
                                                   pc_error OUT INTEGER,
                                                   pm_error OUT VARCHAR)

    AS
        EX_NO_ENCONTRADO EXCEPTION;
        l_info_repventas V_REPVENTAS_CLAS_REG%ROWTYPE;
        lk_tipo_id_rep REP_VENTAS.F_TIPO_ID%TYPE;
        lk_num_id_rep REP_VENTAS.F_NUMERO_ID%TYPE;
        C_REPVENTAS_REEMPLAZO SYS_REFCURSOR;
    BEGIN
        pc_error:=0;
        SELECT V.* INTO l_info_repventas FROM V_REPVENTAS_CLAS_REG V, CLIENTE C
        WHERE V.F_TIPO_ID = C.F_TIPO_ID_REP_VENTAS AND V.F_NUMERO_ID = C.F_ID_REP_VENTAS
        AND C.F_TIPO_ID = pk_tipo_id AND C.F_NUMERO_ID = pk_num_id;

        OPEN C_REPVENTAS_REEMPLAZO FOR SELECT F_TIPO_ID,F_NUMERO_ID
        FROM V_REPVENTAS_CLAS_REG WHERE F_CODIGO_POSTAL = l_info_repventas.F_CODIGO_POSTAL
        AND F_ID_CLASIFICACION = l_info_repventas.F_ID_CLASIFICACION
        AND (F_TIPO_ID NOT LIKE l_info_repventas.F_TIPO_ID OR F_NUMERO_ID NOT LIKE l_info_repventas.F_NUMERO_ID);

        FETCH C_REPVENTAS_REEMPLAZO INTO lk_tipo_id_rep,lk_num_id_rep;
        
        IF C_REPVENTAS_REEMPLAZO%NOTFOUND THEN
            CLOSE C_REPVENTAS_REEMPLAZO;
            OPEN C_REPVENTAS_REEMPLAZO FOR SELECT F_TIPO_ID,F_NUMERO_ID
            FROM V_REPVENTAS_CLAS_REG WHERE F_ID_CLASIFICACION = l_info_repventas.F_ID_CLASIFICACION
            AND (F_TIPO_ID NOT LIKE l_info_repventas.F_TIPO_ID OR F_NUMERO_ID NOT LIKE l_info_repventas.F_NUMERO_ID);

            FETCH C_REPVENTAS_REEMPLAZO INTO lk_tipo_id_rep,lk_num_id_rep;

            IF C_REPVENTAS_REEMPLAZO%NOTFOUND THEN
                CLOSE C_REPVENTAS_REEMPLAZO;
                OPEN C_REPVENTAS_REEMPLAZO FOR SELECT F_TIPO_ID,F_NUMERO_ID
                FROM V_REPVENTAS_CLAS_REG WHERE F_CODIGO_POSTAL = l_info_repventas.F_CODIGO_POSTAL
                AND (F_TIPO_ID NOT LIKE l_info_repventas.F_TIPO_ID OR F_NUMERO_ID NOT LIKE l_info_repventas.F_NUMERO_ID);

                FETCH C_REPVENTAS_REEMPLAZO INTO lk_tipo_id_rep,lk_num_id_rep;
                
                IF C_REPVENTAS_REEMPLAZO%NOTFOUND THEN
                    CLOSE C_REPVENTAS_REEMPLAZO;
                    RAISE EX_NO_ENCONTRADO;
                END IF;
            END IF;
        END IF;
        IF C_REPVENTAS_REEMPLAZO%ISOPEN THEN
            CLOSE C_REPVENTAS_REEMPLAZO;
        END IF;
        pm_error:=lk_tipo_id_rep||' '||lk_num_id_rep;
        UPDATE CLIENTE SET F_TIPO_ID_REP_VENTAS=lk_tipo_id_rep, F_ID_REP_VENTAS=lk_num_id_rep
        WHERE F_TIPO_ID = pk_tipo_id AND F_NUMERO_ID=pk_num_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            pc_error:=1;
            pm_error:='Cliente no existe';
        WHEN EX_NO_ENCONTRADO THEN
            pc_error:=2;
            pm_error:='Ningun representante cumple con los requisitos';
    END PR_CAMBIAR_RVENTAS;


    /*------------------------------------------------------------------------------
    Procedimiento auxiliar para crear usuarios en el sistema y no conferir directamente el privilegio
    de crear usuarios.
    Parametros de Entrada: pk_tipo_id           Tipo de identificacion del cliente al que corresponde el nuevo usuario.
                           pk_num_id            Número de identificacion del cliente al que corresponde el nuevo usuario.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_CREAR_USUARIO(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
                               pk_num_id IN CLIENTE.F_NUMERO_ID%TYPE)
    AS
        l_statement VARCHAR2(90);
    BEGIN
        l_statement:='CREATE USER '||pk_tipo_id||pk_num_id
        ||' IDENTIFIED BY '||pk_num_id;
        EXECUTE IMMEDIATE l_statement;
        l_statement:='GRANT R_CLIENTE TO '||pk_tipo_id||pk_num_id;
        EXECUTE IMMEDIATE l_statement;
    END PR_CREAR_USUARIO;

END PK_GESTION_REPRESENTANTE;