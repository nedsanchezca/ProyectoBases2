/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Funciones y procedimientos asociados al módulo de Gestión de pedidos.
  Autores    : Nestor Sanchez, Jairo Andrés Romero, Gabriela Ladino, Juan Diego Avila, Cristian Bernal.
--------------------------------------------------------------------------------------*/

/*------------------Package Header-------------------------*/
CREATE OR REPLACE PACKAGE PK_GESTION_PEDIDO AS 

    /*------------------------------------------------------------------------------
    Procedimiento para agregar un producto en el inventario y una cantidad a una factura 
    determinada, se asegura de que los items de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en el inventario.
                           pv_cantidad          Cantidad del producto que se desea en la factura.
                           pk_id_pedido         Número del pedido donde se van a agregar los productos.
    Reporta las excepciones cuando falla la inserción o cuando no el producto o la factura de ventas.
    */
    PROCEDURE PR_AGREGAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                  pv_cantidad IN DETALLE_PEDIDO.V_CANTIDAD%TYPE,
                                  pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE);

    /*------------------------------------------------------------------------------
    Procedimiento para borrar un producto de una factura determinada, se asegura de que los items 
    de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en la factura.
                           pk_id_pedido         Número del pedido donde se va a borrar el productos.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_BORRAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                 pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE);

END PK_GESTION_PEDIDO;
/

/*------------------Package Body-------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_GESTION_PEDIDO AS

    /*------------------------------------------------------------------------------
    Procedimiento para agregar un producto en el inventario y una cantidad a una factura 
    determinada, se asegura de que los items de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en el inventario.
                           pv_cantidad          Cantidad del producto que se desea en la factura.
                           pk_id_pedido         Número del pedido donde se van a agregar los productos.
    Reporta las excepciones cuando falla la inserción o cuando no el producto o la factura de ventas.
    */
    PROCEDURE PR_AGREGAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
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
        SET TRANSACTION NAME 'T_AGREGAR_PRODUCTO';
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


    /*------------------------------------------------------------------------------
    Procedimiento para borrar un producto de una factura determinada, se asegura de que los items 
    de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     Código del producto para ubicarlo en la factura.
                           pk_id_pedido         Número del pedido donde se va a borrar el productos.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_BORRAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                 pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE)
    AS 
        lv_contador_detalles DETALLE_PEDIDO.K_ITEM%type := 0;    
        cursor c_items is SELECT K_ITEM
                        FROM DETALLE_PEDIDO
                        WHERE F_N_FACTURA=pk_id_pedido;
    BEGIN
        SET TRANSACTION NAME 'T_BORRAR_PRODUCTO';
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

END PK_GESTION_PEDIDO;
/