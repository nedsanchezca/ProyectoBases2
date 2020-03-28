CREATE OR REPLACE PROCEDURE PR_AGREGAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
						   					   	pv_cantidad IN DETALLE_PEDIDO.V_CANTIDAD%TYPE,
						   					   	pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE)
AS
	PRODUCTO_AGOTADO EXCEPTION;
	lv_disponibilidad INVENTARIO.V_DISPONIBILIDAD%TYPE;
	lv_contador_detalles DETALLE_PEDIDO.K_ITEM%type := 0;
	cursor c_items is SELECT K_ITEM
    				FROM DETALLE_PEDIDO
    				WHERE F_N_FACTURA=pk_id_pedido;
BEGIN
    SELECT V_DISPONIBILIDAD INTO lv_disponibilidad
    FROM INVENTARIO WHERE K_ID=pk_id_inventario;

    lv_disponibilidad:=lv_disponibilidad-pv_cantidad;

    IF lv_disponibilidad<0 THEN
    	RAISE PRODUCTO_AGOTADO;
    END IF;

    UPDATE INVENTARIO SET V_DISPONIBILIDAD=lv_disponibilidad 
    WHERE K_ID=pk_id_inventario;

    INSERT INTO DETALLE_PEDIDO VALUES(detalle_seq.nextval, pv_cantidad,pk_id_pedido,pk_id_inventario);

    FOR rc_item IN c_items LOOP
    	lv_contador_detalles := lv_contador_detalles+1;
    	UPDATE DETALLE_PEDIDO SET K_ITEM = lv_contador_detalles WHERE K_ITEM = rc_item.K_ITEM AND F_ID_INVENTARIO=pk_id_inventario;
    END LOOP;

    COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20001,'Producto no existe');
	WHEN PRODUCTO_AGOTADO THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20002,'Producto agotado');
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20003,'Pedido no valido');
END PR_AGREGAR_PRODUCTO;
/

CREATE OR REPLACE PROCEDURE PR_BORRAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
						   					   pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE)
AS
	lv_disponibilidad INVENTARIO.V_DISPONIBILIDAD%TYPE;
	lv_contador_detalles DETALLE_PEDIDO.K_ITEM%type := 0;
	cursor c_items is SELECT K_ITEM
    				FROM DETALLE_PEDIDO
    				WHERE F_N_FACTURA=pk_id_pedido;
BEGIN

    SELECT V_DISPONIBILIDAD INTO lv_disponibilidad
    FROM INVENTARIO WHERE K_ID=pk_id_inventario;

    UPDATE INVENTARIO 
    SET V_DISPONIBILIDAD=lv_disponibilidad+(SELECT V_CANTIDAD 
    										FROM DETALLE_PEDIDO 
    										WHERE F_N_FACTURA = pk_id_pedido 
    										AND F_ID_INVENTARIO = pk_id_inventario) 
    WHERE K_ID=pk_id_inventario;

    DELETE DETALLE_PEDIDO WHERE F_N_FACTURA = pk_id_pedido AND F_ID_INVENTARIO=pk_id_inventario;

    FOR rc_item IN c_items LOOP
    	lv_contador_detalles := lv_contador_detalles+1;
    	UPDATE DETALLE_PEDIDO SET K_ITEM = lv_contador_detalles WHERE K_ITEM = rc_item.K_ITEM AND F_ID_INVENTARIO=pk_id_inventario;
    END LOOP;

    COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20001,'Producto no existe');
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR(-20003,'Pedido no valido');
END PR_BORRAR_PRODUCTO;
/

