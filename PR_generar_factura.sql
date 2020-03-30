--- Creamos el directorio para almacenar las facturas en C
CREATE OR REPLACE DIRECTORY dir_archivos
  AS  'C:\';

CREATE OR REPLACE PROCEDURE PR_generar_factura(pk_n_factura pedido.k_n_factura%TYPE) AS
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

    /*IF c_datosCliente%NOTFOUND THEN
            RAISE le_facturaInvalida;
        ELSE
*/
    -- Declaración del cursor
    /* Cursor para devolver datos del cliente */
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
/