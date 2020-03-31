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
        SELECT F_NUMERO_ID, N_NOMBRE
        FROM REP_VENTAS RP, PERSONA P
        WHERE   RP.F_ID_REP_CAPATADOR=P.K_NUMERO_ID AND
                RP.F_TIPO_ID_REP_CAPATADOR=P.K_TIPO_ID;
    lc_captados c_captados%ROWTYPE;

    -- Cursor para tener el promedio de calificaciones de cada representante
    CURSOR c_promedioCalificacion IS
        SELECT (SUM(CL.V_VALORACION)) valoracion, (COUNT(C.F_ID_REP_VENTAS)) cantidadClientes, F_ID_REP_VENTAS, N_NOMBRE
        FROM CLIENTE C, REP_VENTAS RP, PEDIDO P, CALIFICACION CL, HISTORICO_CLASIFICACION HC, PERSONA PE
        WHERE   C.F_ID_REP_VENTAS = RP.F_NUMERO_ID AND 
                PE.K_NUMERO_ID = RP.F_NUMERO_ID AND
                C.F_TIPO_ID=RP.F_TIPO_ID AND
                P.F_NUMERO_ID=C.F_NUMERO_ID AND 
                P.F_TIPO_ID=C.F_TIPO_ID AND
                CL.F_N_FACTURA = P.K_N_FACTURA AND 
                HC.F_NUM_ID=RP.F_NUMERO_ID AND
                d_fecha >= TO_DATE('12.08.2019', 'DD.MM.YYYY') AND d_fecha <= SYSDATE
        GROUP BY F_ID_REP_VENTAS, N_NOMBRE;
    lc_promedio c_promedioCalificacion%ROWTYPE;

    -- Cursor para redefinir la nueva clasificación de cada representante
    CURSOR c_nuevaClasificacion IS
        SELECT
        FROM
        WHERE
    lc_nuevaClasificacion c_nuevaClasificacion%ROWTYPE;

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
    END LOOP;
    CLOSE c_totalVentas;

    -- Cursor para consultar los representantes que tiene a cargo un representante de ventas
    OPEN c_captados;
    DBMS_OUTPUT.PUT_LINE('Captados | Nombre Representante');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    LOOP
        FETCH c_captados INTO lc_captados;
        EXIT WHEN c_captados%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lc_captados.F_NUMERO_ID||' - '||lc_captados.N_NOMBRE);
    END LOOP;
    CLOSE c_captados;

    -- Cursor para tener el promedio de calificaciones de cada representante
    OPEN c_promedioCalificacion;
    DBMS_OUTPUT.PUT_LINE('Puntuacion | Nombre Representante');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    LOOP
        FETCH c_promedioCalificacion INTO lc_promedio;
        EXIT WHEN c_promedioCalificacion%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lc_promedio.valoracion/lc_promedio.cantidadClientes||' - '||lc_promedio.N_NOMBRE);
    END LOOP;
    CLOSE c_promedioCalificacion;
END PR_clasificarRepresentante;
/

