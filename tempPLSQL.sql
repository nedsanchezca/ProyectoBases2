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
    mensaje VARCHAR2(80):=null;
BEGIN
    FOR rc_item_maximo IN c_item_maximo LOOP
        lv_contador_detalles := rc_item_maximo.maximo;
    END LOOP;
    IF lv_contador_detalles IS NULL THEN
        lv_contador_detalles := 0;
    END IF;
    INSERT INTO DETALLE_PEDIDO VALUES(lv_contador_detalles+1, pv_cantidad,pk_id_pedido,pk_id_inventario);
    mensaje :='jajajaja'||pk_id_pedido;
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

GRANT EXECUTE ON PR_CREAR_USUARIO TO R_REPVENTAS;
GRANT EXECUTE ON PR_BORRAR_PRODUCTO TO R_REPVENTAS;
GRANT EXECUTE ON PR_BORRAR_PRODUCTO TO R_CLIENTE;
GRANT EXECUTE ON PR_AGREGAR_PRODUCTO TO R_REPVENTAS;
GRANT EXECUTE ON PR_AGREGAR_PRODUCTO TO R_CLIENTE;