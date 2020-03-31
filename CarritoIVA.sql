SET ServerOutput ON
SET Verify OFF
-- Totalizar Carrito con IVA
CREATE OR REPLACE FUNCTION FU_totalizarCarrito(pk_n_factura pedido.k_n_factura%TYPE) RETURN NUMBER
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
/