/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Paquete que contiene las variables globales, funciones y procedimientos
               asociados al módulo de Reservas
  Autores: Cristian Bernal, Nestor Sanchez, .
--------------------------------------------------------------------------------------*/
begin
    EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM PR_CREAR_USUARIO';
    EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
    EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM PR_BORRAR_PRODUCTO';
    EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
    EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM PR_AGREGAR_PRODUCTO';
    EXCEPTION WHEN OTHERS THEN NULL;
end;  
/

begin
    EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM PR_CAMBIAR_RVENTAS';
    EXCEPTION WHEN OTHERS THEN NULL;
end;  
/


/*------------------------------------------------------------------------------
Procedimiento para agregar un producto en el inventario y una cantidad a una factura 
determinada, se asegura de que los items de la factura sean secuenciales.
Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en el inventario.
                       pv_cantidad          Cantidad del producto que se desea en la factura.
                       pk_id_pedido         Número del pedido donde se van a agregar los productos.
Reporta las excepciones cuando falla la inserción o cuando no el producto o la factura de ventas.
*/
CREATE OR REPLACE PROCEDURE PR_AGREGAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                                pv_cantidad IN DETALLE_PEDIDO.V_CANTIDAD%TYPE,
                                                pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE)
AS
    lv_contador_detalles DETALLE_PEDIDO.K_ITEM%type := 0;
    cursor c_item_maximo is SELECT MAX(K_ITEM) maximo
                    FROM DETALLE_PEDIDO
                    WHERE F_N_FACTURA=pk_id_pedido;    
    cursor c_items is SELECT K_ITEM
                    FROM DETALLE_PEDIDO
                    WHERE F_N_FACTURA=pk_id_pedido;
BEGIN
    
    FOR rc_item_maximo IN c_item_maximo LOOP
        lv_contador_detalles := rc_item_maximo.maximo;
    END LOOP;
    IF lv_contador_detalles IS NULL THEN
        lv_contador_detalles := 0;
    END IF;
    INSERT INTO DETALLE_PEDIDO VALUES(lv_contador_detalles+1, pv_cantidad,pk_id_pedido,pk_id_inventario);
    lv_contador_detalles := 0;
    FOR rc_item IN c_items LOOP
        lv_contador_detalles := lv_contador_detalles+1;
        UPDATE DETALLE_PEDIDO SET K_ITEM = lv_contador_detalles
        WHERE K_ITEM = rc_item.K_ITEM
        AND F_N_FACTURA=pk_id_pedido;
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE = -1400 THEN
            RAISE_APPLICATION_ERROR(-20001,'Pedido no valido');
        ELSIF SQLCODE = -2291 THEN
            RAISE_APPLICATION_ERROR(-20002,'Producto no existe');
        ELSE
            RAISE_APPLICATION_ERROR(-20003,'Unidades insuficientes');
        END IF;
END PR_AGREGAR_PRODUCTO;
/

/*------------------------------------------------------------------------------
Procedimiento para borrar un producto de una factura determinada, se asegura de que los items 
de la factura sean secuenciales.
Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en la factura.
                       pk_id_pedido         Número del pedido donde se va a borrar el productos.
Reporta las excepciones cuando no existe la factura o el producto ingresado.
*/
CREATE OR REPLACE PROCEDURE PR_BORRAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                               pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE)
AS 
    lv_contador_detalles DETALLE_PEDIDO.K_ITEM%type := 0;    
    cursor c_items is SELECT K_ITEM
                    FROM DETALLE_PEDIDO
                    WHERE F_N_FACTURA=pk_id_pedido;
BEGIN
    DELETE DETALLE_PEDIDO WHERE F_N_FACTURA = pk_id_pedido AND F_ID_INVENTARIO=pk_id_inventario;
    FOR rc_item IN c_items LOOP
        lv_contador_detalles := lv_contador_detalles+1;
        UPDATE DETALLE_PEDIDO SET K_ITEM = lv_contador_detalles 
        WHERE K_ITEM = rc_item.K_ITEM
        AND F_N_FACTURA=pk_id_pedido;
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE = -1400 THEN
            RAISE_APPLICATION_ERROR(-20001,'Pedido no valido');
        ELSE
            RAISE_APPLICATION_ERROR(-20002,'Producto no existe');
        END IF;
END PR_BORRAR_PRODUCTO;
/


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
CREATE OR REPLACE PROCEDURE PR_CAMBIAR_RVENTAS(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
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
/


/*------------------------------------------------------------------------------
Procedimiento auxiliar para crear usuarios en el sistema y no conferir directamente el privilegio
de crear usuarios.
Parametros de Entrada: pk_tipo_id           Tipo de identificacion del cliente al que corresponde el nuevo usuario.
                       pk_num_id            Número de identificacion del cliente al que corresponde el nuevo usuario.
Reporta las excepciones cuando no existe la factura o el producto ingresado.
*/
CREATE OR REPLACE PROCEDURE PR_CREAR_USUARIO(pk_tipo_id IN CLIENTE.F_TIPO_ID%TYPE,
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
/


/*------------------------------------------------------------------------------
Trigger que se encarga de sumar o restar el stock asociado a un producto cuando se borra
o se agrega una entrada con este producto a la tabla detalle_pedido.
*/
CREATE OR REPLACE TRIGGER TG_STOCK_PRODUCTO
    BEFORE INSERT OR DELETE ON DETALLE_PEDIDO
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE INVENTARIO SET V_DISPONIBILIDAD=V_DISPONIBILIDAD-:NEW.V_CANTIDAD
        WHERE K_ID=:NEW.F_ID_INVENTARIO;
    ELSE
        UPDATE INVENTARIO SET V_DISPONIBILIDAD=V_DISPONIBILIDAD+:OLD.V_CANTIDAD
        WHERE K_ID=:OLD.F_ID_INVENTARIO;
    END IF;
END TG_STOCK_PRODUCTO;
/


CREATE PUBLIC SYNONYM PR_CREAR_USUARIO FOR natame.PR_CREAR_USUARIO;
CREATE PUBLIC SYNONYM PR_BORRAR_PRODUCTO FOR natame.PR_BORRAR_PRODUCTO;
CREATE PUBLIC SYNONYM PR_AGREGAR_PRODUCTO FOR natame.PR_AGREGAR_PRODUCTO;
CREATE PUBLIC SYNONYM PR_CAMBIAR_RVENTAS FOR natame.PR_CAMBIAR_RVENTAS;


GRANT EXECUTE ON PR_CREAR_USUARIO TO R_REPVENTAS;
GRANT EXECUTE ON PR_BORRAR_PRODUCTO TO R_REPVENTAS;
GRANT EXECUTE ON PR_BORRAR_PRODUCTO TO R_CLIENTE;
GRANT EXECUTE ON PR_AGREGAR_PRODUCTO TO R_REPVENTAS;
GRANT EXECUTE ON PR_AGREGAR_PRODUCTO TO R_CLIENTE;
GRANT EXECUTE ON PR_CAMBIAR_RVENTAS TO R_CLIENTE;