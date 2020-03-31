SET ServerOutput ON
SET Verify OFF

CREATE SEQUENCE SEQ_HISTO
    INCREMENT BY 1
    START WITH 1
    NOCACHE
    NOCYCLE;

-- Totalizar Carrito con IVA
CREATE OR REPLACE PROCEDURE PR_clasificar_Representante(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE)
AS
-- Declaración de variables
    l_aux NUMBER := 0;
    l_clasificacion clasificacion.K_ID%TYPE;
    l_calificacionAsignada clasificacion.K_ID%TYPE;
    l_error EXCEPTION;
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
        SELECT SUM(I.V_PRECIO*V_CANTIDAD) totalito, RP.F_NUMERO_ID, N_NOMBRE
        FROM REP_VENTAS RP, PEDIDO P, DETALLE_PEDIDO DP, INVENTARIO I, PERSONA PE
        WHERE   RP.F_ID_REP_CAPATADOR=PE.K_NUMERO_ID AND
                I.K_ID = DP.F_ID_INVENTARIO AND
                DP.F_N_FACTURA = P.K_N_FACTURA AND 
                RP.F_TIPO_ID_REP_CAPATADOR=PE.K_TIPO_ID
        GROUP BY RP.F_NUMERO_ID, N_NOMBRE;
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
        SELECT CL.N_NOMBRE clasificacion, F_ID_REP_VENTAS, PE.N_NOMBRE nom, N_APELLIDO, V_VENTA_MINIMA, CL.K_ID, HC.F_TIPO_ID
        FROM CLASIFICACION CL, PERSONA PE, REP_VENTAS RV, PEDIDO P, HISTORICO_CLASIFICACION HC, CLIENTE C
        WHERE   PE.K_NUMERO_ID = RV.F_NUMERO_ID AND
                C.F_ID_REP_VENTAS = RV.F_NUMERO_ID AND
                PE.K_TIPO_ID = RV.F_TIPO_ID AND
                CL.K_ID = HC.F_ID_CLASIFICACION AND
                RV.F_NUMERO_ID = HC.F_NUM_ID AND
                d_fecha >= TO_DATE('12.08.2019', 'DD.MM.YYYY') AND d_fecha <= SYSDATE
        GROUP BY F_ID_REP_VENTAS, CL.N_NOMBRE, PE.N_NOMBRE, N_APELLIDO, V_VENTA_MINIMA, CL.K_ID, HC.F_TIPO_ID;
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
        DBMS_OUTPUT.PUT_LINE(lc_captados.totalito||''||lc_captados.F_NUMERO_ID||' - '||lc_captados.N_NOMBRE);
    END LOOP;
    CLOSE c_captados;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');

    -- Cursor para tener el promedio de calificaciones de cada representante
    OPEN c_promedioCalificacion;
    DBMS_OUTPUT.PUT_LINE('Puntuacion | Nombre Representante');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    LOOP
        FETCH c_promedioCalificacion INTO lc_promedio;
        EXIT WHEN c_promedioCalificacion%NOTFOUND;
        IF lc_promedio.cantidadClientes <> 0 THEN
            DBMS_OUTPUT.PUT_LINE(lc_promedio.valoracion/lc_promedio.cantidadClientes||' - '||lc_promedio.N_NOMBRE);
        ELSE
            RAISE l_error;
        END IF;
    END LOOP;
    CLOSE c_promedioCalificacion;

    -- Cursor para redefinir la nueva clasificación de cada representante
    OPEN c_nuevaClasificacion;
    DBMS_OUTPUT.PUT_LINE('Categoria anterior | Categoria asignada | Nombre Representante');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    LOOP
        FETCH c_nuevaClasificacion INTO lc_nuevaClasificacion;
        EXIT WHEN c_nuevaClasificacion%NOTFOUND;
        l_clasificacion := lc_nuevaClasificacion.K_ID;
        IF lc_nuevaClasificacion.V_VENTA_MINIMA < 1000000 THEN -- 1.000.000
            l_calificacionAsignada := lc_nuevaClasificacion.K_ID - 1;
            INSERT INTO HISTORICO_CLASIFICACION VALUES(SEQ_HISTO.NEXTVAL,TO_DATE('12.08.2019', 'DD.MM.YYYY'),SYSDATE,lc_nuevaClasificacion.F_ID_REP_VENTAS,lc_nuevaClasificacion.F_TIPO_ID,l_calificacionAsignada);
        ELSIF lc_nuevaClasificacion.V_VENTA_MINIMA < 500000 THEN -- 500.000
            l_calificacionAsignada := lc_nuevaClasificacion.K_ID - 1;
            INSERT INTO HISTORICO_CLASIFICACION VALUES(SEQ_HISTO.NEXTVAL,TO_DATE('12.08.2019', 'DD.MM.YYYY'),SYSDATE,lc_nuevaClasificacion.F_ID_REP_VENTAS,lc_nuevaClasificacion.F_TIPO_ID,l_calificacionAsignada);
        ELSIF lc_nuevaClasificacion.V_VENTA_MINIMA < 200000 THEN -- 200.000
            l_calificacionAsignada := lc_nuevaClasificacion.K_ID - 1;
            INSERT INTO HISTORICO_CLASIFICACION VALUES(SEQ_HISTO.NEXTVAL,TO_DATE('12.08.2019', 'DD.MM.YYYY'),SYSDATE,lc_nuevaClasificacion.F_ID_REP_VENTAS,lc_nuevaClasificacion.F_TIPO_ID,l_calificacionAsignada);
        ELSE
            l_calificacionAsignada := lc_nuevaClasificacion.K_ID;
        END IF;
        DBMS_OUTPUT.PUT_LINE(l_clasificacion||' '||l_calificacionAsignada||' '||lc_nuevaClasificacion.nom||' '||lc_nuevaClasificacion.N_APELLIDO);
    END LOOP;
    CLOSE c_nuevaClasificacion;
EXCEPTION
    WHEN l_error THEN
        RAISE_APPLICATION_ERROR(-20200,'División por cero');
END PR_clasificar_Representante;
/