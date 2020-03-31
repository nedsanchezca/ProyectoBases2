/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Funciones y procedimientos asociados al m�dulo de Gesti�n de pedidos.
  Autores    : Nestor Sanchez, Jairo Andr�s Romero, Gabriela Ladino, Juan Diego Avila, Cristian Bernal.
--------------------------------------------------------------------------------------*/

/*------------------Package Header-------------------------*/
CREATE OR REPLACE PACKAGE PK_GESTION_PEDIDO AS 

    /*------------------------------------------------------------------------------
    Procedimiento para agregar un producto en el inventario y una cantidad a una factura 
    determinada, se asegura de que los items de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     C�digo del producto para ubicarlo en el inventario.
                           pv_cantidad          Cantidad del producto que se desea en la factura.
                           pk_id_pedido         N�mero del pedido donde se van a agregar los productos.
    Reporta las excepciones cuando falla la inserci�n o cuando no el producto o la factura de ventas.
    */
    PROCEDURE PR_AGREGAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                  pv_cantidad IN DETALLE_PEDIDO.V_CANTIDAD%TYPE,
                                  pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE);

    /*------------------------------------------------------------------------------
    Procedimiento para borrar un producto de una factura determinada, se asegura de que los items 
    de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     C�digo del producto para ubicarlo en la factura.
                           pk_id_pedido         N�mero del pedido donde se va a borrar el productos.
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_BORRAR_PRODUCTO(pk_id_inventario IN INVENTARIO.K_ID%TYPE,
                                 pk_id_pedido IN PEDIDO.K_N_FACTURA%TYPE);
    
    /*
         FU_totalizarCarrito 
         Totaliza el valor del pedido dada un número de factura
         Parámetros de entrada: pk_n_factura
         RETORNA: l_total El valor junto con el iva del valor para el pedido
         EXCEPTION: Si no encuentra la factura
     */
    FUNCTION FU_totalizarCarrito(pk_n_factura pedido.k_n_factura%TYPE) RETURN NUMBER;

    /*------------------------------------------------------------------------------
    Procedimiento para generar una factura de un pedido en un fotmato .txt lo calizado en el disco c:.
    Parametros de Entrada: pk_n_factura     Numero de la factura
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_generar_factura(pk_n_factura pedido.k_n_factura%TYPE);

END PK_GESTION_PEDIDO;
/

/*------------------Package Body-------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_GESTION_PEDIDO AS

    /*------------------------------------------------------------------------------
    Procedimiento para agregar un producto en el inventario y una cantidad a una factura 
    determinada, se asegura de que los items de la factura sean secuenciales.
    Parametros de Entrada: pk_id_inventario     C�digo del producto para ubicarlo en el inventario.
                           pv_cantidad          Cantidad del producto que se desea en la factura.
                           pk_id_pedido         N�mero del pedido donde se van a agregar los productos.
    Reporta las excepciones cuando falla la inserci�n o cuando no el producto o la factura de ventas.
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
    Parametros de Entrada: pk_id_inventario     C�digo del producto para ubicarlo en la factura.
                           pk_id_pedido         N�mero del pedido donde se va a borrar el productos.
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

    /*
         FU_totalizarCarrito 
         Totaliza el valor del pedido dada un número de factura
         Parámetros de entrada: pk_n_factura
         RETORNA: l_total El valor junto con el iva del valor para el pedido
         EXCEPTION: Si no encuentra la factura
     */
    FUNCTION FU_totalizarCarrito(pk_n_factura pedido.k_n_factura%TYPE) RETURN NUMBER
    AS
    -- Declaración de variables
        l_total NUMBER;
        l_aux NUMBER := 0;
        l_valor_cantidad_invalido EXCEPTION;
        l_subTotal NUMBER;
        l_IVA NUMBER;

        /* Cursor para devolver el precio del pedido con IVA */
        CURSOR c_precioPedido IS
            SELECT v_precio, v_iva, v_cantidad
            FROM pedido p, persona pe, cliente cl, detalle_pedido dp, producto pr, inventario i, categoria c
            WHERE   pe.k_numero_id = cl.f_numero_id AND
                    cl.f_numero_id = p.f_numero_id AND
                    pe.k_tipo_id = cl.f_tipo_id AND
                    p.k_n_factura = dp.f_n_factura AND
                    dp.f_id_inventario = i.k_id AND
                    i.f_codigo_producto = pr.k_codigo_producto AND
                    c.k_id = pr.f_id AND
                    p.k_n_factura = pk_n_factura;
        lc_precioPedido c_precioPedido%ROWTYPE;
    BEGIN
        /* Cursor para devolver el precio del pedido con IVA */
        OPEN c_precioPedido;
        LOOP
            FETCH c_precioPedido INTO lc_precioPedido;
            EXIT WHEN c_precioPedido%NOTFOUND;
            IF lc_precioPedido.v_precio < 0 OR lc_precioPedido.v_cantidad < 0 THEN
                RAISE l_valor_cantidad_invalido;
            ELSE
                l_subTotal := (lc_precioPedido.v_precio*lc_precioPedido.v_cantidad);
                l_IVA := l_subTotal*(lc_precioPedido.v_iva/100);
                l_total := l_aux + (l_subTotal + l_IVA);
                l_aux := l_total;
            END IF;
        END LOOP;
        CLOSE c_precioPedido;
        RETURN l_total;
    EXCEPTION
        WHEN l_valor_cantidad_invalido THEN
            RAISE_APPLICATION_ERROR(-20111, 'Valor o cantidad invalida (números negativos)');
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20112, 'Registro no encontrado');
    END FU_totalizarCarrito;

    
    /*------------------------------------------------------------------------------
    Procedimiento para generar una factura de un pedido en un fotmato .txt lo calizado en el disco c:.
    Parametros de Entrada: pk_n_factura     Numero de la factura
    Reporta las excepciones cuando no existe la factura o el producto ingresado.
    */
    PROCEDURE PR_generar_factura(pk_n_factura pedido.k_n_factura%TYPE) AS
    -- Declaración de variables
    l_total NUMBER;
    l_aux NUMBER := 0;
    l_subTotal NUMBER;
    l_acumulado NUMBER :=0;
    l_IVA NUMBER;
    l_acumulado_iva NUMBER :=0;
    encabezado VARCHAR(100);
    v_archivo UTL_FILE.FILE_TYPE;
    le_facturaInvalida EXCEPTION;

    CURSOR c_datosCliente IS
        SELECT n_nombre||' '||n_apellido n_nomCompleto, k_numero_id, t_telefono, p.d_fecha
        FROM pedido p, persona pe, cliente c
        WHERE   pe.k_numero_id = c.f_numero_id AND
                pe.k_tipo_id = c.f_tipo_id AND
                c.f_numero_id = p.f_numero_id AND
                p.k_n_factura = pk_n_factura;
    lc_datosCliente c_datosCliente%ROWTYPE;


     /* Cursor para devolver los productos (Con su cantidad) del pedido */
    CURSOR c_productosPedido IS
        SELECT n_nombre_producto producto, v_cantidad, i.V_precio, (v_cantidad*i.V_precio) monto
        FROM pedido p, detalle_pedido dp, producto pr, persona pe, cliente c, inventario i
        WHERE   pe.k_numero_id = c.f_numero_id AND
                c.f_numero_id = p.f_numero_id AND
                p.k_n_factura = dp.f_n_factura AND
                pe.k_tipo_id = c.f_tipo_id AND
                pr.k_codigo_producto = dp.f_id_inventario AND 
                i.k_id = dp.f_id_inventario AND
                p.k_n_factura = pk_n_factura;
    lc_productosPedido c_productosPedido%ROWTYPE;

     /* Cursor para devolver el precio del pedido con IVA */
    CURSOR c_precioPedido IS
        SELECT v_precio, v_iva, v_cantidad
        FROM pedido p, persona pe, cliente cl, detalle_pedido dp, producto pr, inventario i, categoria c
        WHERE   pe.k_numero_id = cl.f_numero_id AND
                pe.k_tipo_id = cl.f_tipo_id AND
                cl.f_numero_id = p.f_numero_id AND
                p.k_n_factura = dp.f_n_factura AND
                dp.f_id_inventario = i.k_id AND
                i.f_codigo_producto = pr.k_codigo_producto AND
                c.k_id = pr.f_id AND
                p.k_n_factura = pk_n_factura;
    lc_precioPedido c_precioPedido%ROWTYPE;

BEGIN
    -- En este ejemplo añado una cadena de caracteres al fichero prueba.txt
    
    
    -- ENCABEZADO
    encabezado := '          NATAME';

    -- Abro fichero para añadir (Append)
    v_archivo := UTL_FILE.FOPEN('DIR_ARCHIVOS','Factura'||pk_n_factura||'.txt','w');

    -- Escribo ENCABEZADO en el fichero
    UTL_FILE.put_line(v_archivo,encabezado);
    UTL_FILE.put_line(v_archivo,'________________________________________________________________________________');

    /* Cursor para devolver datos del cliente */
    OPEN c_datosCliente;
    LOOP
        FETCH c_datosCliente INTO lc_datosCliente;
        EXIT WHEN c_datosCliente%NOTFOUND;
        UTL_FILE.put_line(v_archivo, 'Nombre del Cliente: '||lc_datosCliente.n_nomCompleto||'      Documento: '||lc_datosCliente.k_numero_id);
        UTL_FILE.put_line(v_archivo, 'Telefono: '||lc_datosCliente.t_telefono);
        UTL_FILE.put_line(v_archivo,'________________________________________________________________________________');
        UTL_FILE.put_line(v_archivo, '');
        UTL_FILE.put_line(v_archivo, 'No. Factura: '||pk_n_factura||'       Fecha de venta: '||TO_CHAR(lc_datosCliente.d_fecha));
        
    END LOOP;
    
    CLOSE c_datosCliente;
    

    /* Cursor para devolver los productos (con su cantidad) del pedido */
    OPEN c_productosPedido;
    UTL_FILE.put_line(v_archivo,'________________________________________________________________________________');
    UTL_FILE.PUT_LINE(v_archivo,'   Producto       |    Cantidad      |    Precio Unitario  |       Monto');
    UTL_FILE.put_line(v_archivo,'________________________________________________________________________________');
    LOOP
        FETCH c_productosPedido INTO lc_productosPedido;
        EXIT WHEN c_productosPedido%NOTFOUND;
        UTL_FILE.PUT_LINE(v_archivo,lc_productosPedido.producto||'         |    '||lc_productosPedido.v_cantidad||'         |    '||lc_productosPedido.v_precio||'         |         '||lc_productosPedido.monto);
    END LOOP;
    CLOSE c_productosPedido;

    /* Cursor para devolver el precio del pedido con IVA */
    OPEN c_precioPedido;
    UTL_FILE.put_line(v_archivo,'________________________________________________________________________________');
    LOOP
        FETCH c_precioPedido INTO lc_precioPedido;
        EXIT WHEN c_precioPedido%NOTFOUND;
        l_subTotal := (lc_precioPedido.v_precio*lc_precioPedido.v_cantidad);
        l_acumulado:=l_acumulado+l_subTotal;
        l_IVA := l_subTotal*(lc_precioPedido.v_iva/100);
        l_acumulado_iva :=l_acumulado_iva+l_IVA;
    END LOOP;
    CLOSE c_precioPedido;
    l_total:=l_acumulado+l_acumulado_iva;
    UTL_FILE.put_line(v_archivo,'Subtotal: '||l_acumulado||'         IVA: '||l_acumulado_iva||'            '||'Total a pagar: '||l_total);


    -- Cierro fichero
    UTL_FILE.FCLOSE(v_archivo);

    dbms_output.put_line('Escritura correcta, información añadida');

    EXCEPTION
    WHEN le_facturaInvalida THEN
        RAISE_APPLICATION_ERROR(-20634, 'Error factura invalida');

END PR_generar_factura;


END PK_GESTION_PEDIDO;
/