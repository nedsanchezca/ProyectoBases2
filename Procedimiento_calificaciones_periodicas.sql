SET ServerOutput ON
SET Verify OFF

CREATE OR REPLACE PROCEDURE PR_promedio_calificacion(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE)
AS
-- Declaración de variables
lv_repventas REP_VENTAS.F_NUMERO_ID%TYPE;
-- Declaración de Cursores
    ---Promedio de calificaciones
    CURSOR c_promedioCalificacion IS
        SELECT (SUM(CL.V_VALORACION)) valoracion, (COUNT(C.F_ID_REP_VENTAS)) cantidadClientes, F_ID_REP_VENTAS 
        FROM CLIENTE C, REP_VENTAS RP, PEDIDO P, CALIFICACION CL, HISTORICO_CLASIFICACION HC
        WHERE   C.F_ID_REP_VENTAS = RP.F_NUMERO_ID AND 
                C.F_TIPO_ID=RP.F_TIPO_ID AND
                P.F_NUMERO_ID=C.F_NUMERO_ID AND 
                P.F_TIPO_ID=C.F_TIPO_ID AND
                CL.F_N_FACTURA = P.K_N_FACTURA AND 
                HC.F_NUM_ID=RP.F_NUMERO_ID AND
                d_fecha >= TO_DATE(pd_fecha_inicial, 'DD.MM.YYYY') AND d_fecha <= SYSDATE
        GROUP BY F_ID_REP_VENTAS;
    

BEGIN
    FOR lc_totalVentas IN c_promedioCalificacion LOOP 
    	DBMS_OUTPUT.PUT_LINE(lc_totalVentas.valoracion/lc_totalVentas.cantidadClientes);
    END LOOP;
END PR_promedio_calificacion;
/
