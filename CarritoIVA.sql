SET ServerOutput ON
SET Verify OFF
-- Totalizar Carrito con IVA
CREATE OR REPLACE PROCEDURE PR_totalizarCarrito(pk_n_factura pedido.k_n_factura%TYPE)
AS
-- Declaración de variables
    l_total NUMBER;
    l_aux NUMBER := 0;

-- Declaración del cursor
    /* Cursor para devolver datos del cliente */
    CURSOR c_datosCliente IS
        SELECT n_nombre||' '||n_apellido n_nomCompleto
        FROM pedido p, persona pe, cliente c
        WHERE   pe.k_numero_id = c.f_numero_id AND
                c.f_numero_id = p.f_numero_id AND
                p.k_n_factura = pk_n_factura;
    lc_datosCliente c_datosCliente%ROWTYPE;

    /* Cursor para devolver los productos (Con su cantidad) del pedido */
    CURSOR c_productosPedido IS
        SELECT n_nombre_producto producto, v_cantidad
        FROM pedido p, detalle_pedido dp, producto pr, persona pe, cliente c
        WHERE   pe.k_numero_id = c.f_numero_id AND
                c.f_numero_id = p.f_numero_id AND
                p.k_n_factura = dp.f_n_factura AND
                pr.k_codigo_producto = dp.f_id_inventario AND 
                p.k_n_factura = pk_n_factura;
    lc_productosPedido c_productosPedido%ROWTYPE;

    /* Cursor para devolver el precio del pedido con IVA */
    CURSOR c_precioPedido IS
        SELECT v_precio, v_iva, v_cantidad
        FROM pedido p, persona pe, cliente cl, detalle_pedido dp, producto pr, inventario i, categoria c
        WHERE   pe.k_numero_id = cl.f_numero_id AND
                cl.f_numero_id = p.f_numero_id AND
                p.k_n_factura = dp.f_n_factura AND
                dp.f_id_inventario = i.k_id AND
                i.f_codigo_producto = pr.k_codigo_producto AND
                c.k_id = pr.f_id AND
                p.k_n_factura = pk_n_factura;
    lc_precioPedido c_precioPedido%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('No. Factura: '||pk_n_factura);

    /* Cursor para devolver datos del cliente */
    OPEN c_datosCliente;
    LOOP
        FETCH c_datosCliente INTO lc_datosCliente;
        EXIT WHEN c_datosCliente%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nombre del Cliente: '||lc_datosCliente.n_nomCompleto);
    END LOOP;
    CLOSE c_datosCliente;

    /* Cursor para devolver los productos (con su cantidad) del pedido */
    OPEN c_productosPedido;
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('Producto    |    Cantidad');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    LOOP
        FETCH c_productosPedido INTO lc_productosPedido;
        EXIT WHEN c_productosPedido%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lc_productosPedido.producto||'    |    '||lc_productosPedido.v_cantidad);
    END LOOP;
    CLOSE c_productosPedido;

    /* Cursor para devolver el precio del pedido con IVA */
    OPEN c_precioPedido;
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    LOOP
        FETCH c_precioPedido INTO lc_precioPedido;
        EXIT WHEN c_precioPedido%NOTFOUND;
        l_total:= l_aux + (lc_precioPedido.v_precio*lc_precioPedido.v_cantidad);
        --l_total := l_aux + (lc_precioPedido.v_precio*(lc_precioPedido.v_iva/100));
        l_aux := l_total;
    END LOOP;
    CLOSE c_precioPedido;
    l_total := l_total + l_total*(lc_precioPedido.v_iva/100);
    DBMS_OUTPUT.PUT_LINE('Total Carrito: '||l_total);
    DBMS_OUTPUT.PUT_LINE('--------------------------');
END PR_totalizarCarrito;
/