SET ServerOutput ON
SET Verify OFF
-- Totalizar Carrito con IVA
CREATE OR REPLACE PROCEDURE PR_clasificarRepresentante(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE)
AS
-- Declaración de variables
    l_aux NUMBER := 0;
-- Declaración de Cursores
    -- Cursor para consultar el total de ventas de cada representante
    CURSOR c_totalVentas IS
        SELECT SUM(I.V_PRECIO*V_CANTIDAD) total, F_ID_REP_VENTAS, N_NOMBRE, N_APELLIDO
        FROM CLIENTE C, REP_VENTAS RP, PEDIDO P, DETALLE_PEDIDO DP, INVENTARIO I, PERSONA PE
        WHERE   C.F_ID_REP_VENTAS = RP.F_NUMERO_ID AND
                C.F_ID_REP_VENTAS = PE.K_NUMERO_ID AND
                P.F_NUMERO_ID = C.F_NUMERO_ID AND 
                DP.F_N_FACTURA = P.K_N_FACTURA AND 
                I.K_ID = DP.F_ID_INVENTARIO AND
                d_fecha >= TO_DATE('12.08.2019', 'DD.MM.YYYY') AND d_fecha <= SYSDATE
        GROUP BY F_ID_REP_VENTAS, N_NOMBRE, N_APELLIDO;
    lc_totalVentas c_totalVentas%ROWTYPE;

    -- Cursor para consultar a los representantes a cargo en el resumen
    CURSOR c_captados IS
        SELECT /*N_NOMBRE, N_APELLIDO,*/ RV.F_NUMERO_ID
        FROM PERSONA P, REP_VENTAS RV, PEDIDO PE
        WHERE   p.k_numero_id = rv.f_numero_id AND
                d_fecha >= TO_DATE('12.08.2019', 'DD.MM.YYYY') AND d_fecha <= SYSDATE
        GROUP BY RV.F_NUMERO_ID/*, N_NOMBRE, N_APELLIDO*/;
    lc_captados c_captados%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('RESUMEN PERIODICO DE VENTAS');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    -- Cursor para consultar el total de ventas de cada representante
    OPEN c_totalVentas;
    DBMS_OUTPUT.PUT_LINE('Total Ventas | Nombre Representante');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    LOOP
        FETCH c_totalVentas INTO lc_totalVentas;
        EXIT WHEN c_totalVentas%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lc_totalVentas.total||' - '||lc_totalVentas.N_NOMBRE||' '||lc_totalVentas.N_APELLIDO);
        --DBMS_OUTPUT.PUT_LINE(lc_totalVentas.n_nombre);
    END LOOP;
    CLOSE c_totalVentas;
END PR_clasificarRepresentante;
/

