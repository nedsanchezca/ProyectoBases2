/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Funciones y procedimientos asociados al m�dulo de Gesti�n de representantes.
  Autores    : Nestor Sanchez, Jairo Andr�s Romero, Gabriela Ladino, Juan Diego Avila, Cristian Bernal.
--------------------------------------------------------------------------------------*/

/*------------------Package Header-------------------------*/
CREATE OR REPLACE PACKAGE PK_GESTION_REPRESENTANTE AS 
  /*
  FU_GANANCIA_DIRECTA regresa las ganancias directas generadas de un representante de ventas en un periodo dado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar sus ganancias
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
  FUNCTION FU_GANANCIA_DIRECTA(pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                                            pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                                            pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                                            ) RETURN NUMBER;

  /*
  FU_GANANCIA regresa las ganancias generadas de un representante de ventas en un periodo dado, esta es una funcion recursiva
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar laS ganancias
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
    FUNCTION FU_GANANCIA(pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                        pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                        pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                        ) RETURN NUMBER;

    /*------------------------------------------------------------------------------
    Procedimiento para clasificar al representante de ventas y generar un resumen con los datos correspondientes al total
    de ventas de cada representante, representantes a cargo y acumulado de ventas de cada uno, promedio de calificacion
    categoría anterior y categoría asignada
    Parametros de Entrada: pd_fecha_inicial     Fecha del inicio del periodo
    */
    PROCEDURE PR_clasificar_Representante(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE);

END PK_GESTION_REPRESENTANTE;
/


/*------------------Package Body-------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_GESTION_REPRESENTANTE AS 


/*
  FU_GANANCIA_DIRECTA regresa las ganancias generadas de un representante de ventas en un periodo dado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar sus ganancias
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
  FUNCTION FU_GANANCIA_DIRECTA(pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                                            pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                                            pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                                            ) RETURN NUMBER
AS
---DECLARO LO QUE VOY A RETORNAR
lc_gananciaAcumulada NUMBER:=0;
-- Declaración de variables
-- Declaración de Cursores
---Totaliza las ventas directas de un representante
    CURSOR c_totalVentas IS
        SELECT (SUM(I.V_PRECIO*V_CANTIDAD)) VENTAS , V_COMISION
        FROM CLIENTE C, REP_VENTAS RP, PEDIDO P, DETALLE_PEDIDO DP, INVENTARIO I, HISTORICO_CLASIFICACION HC, CLASIFICACION CLA
        WHERE   C.F_ID_REP_VENTAS=pn_idRepVentas AND 
                P.F_NUMERO_ID=C.F_NUMERO_ID AND
                P.F_TIPO_ID=C.F_TIPO_ID AND 
                DP.F_N_FACTURA = P.K_N_FACTURA AND 
                I.K_ID=DP.F_ID_INVENTARIO AND
                RP.F_NUMERO_ID=pn_idRepVentas AND
                HC.F_NUM_ID=pn_idRepVentas AND
                HC.F_TIPO_ID=pc_tipoIdRep AND
                C.F_TIPO_ID_REP_VENTAS=pc_tipoIdRep AND
                CLA.K_ID=HC.F_ID_CLASIFICACION AND
                d_fecha >= TO_DATE(pd_fecha_inicial, 'DD.MM.YYYY') AND d_fecha <= SYSDATE
                GROUP BY V_COMISION;
BEGIN
---SE DEBE RETORNAR
FOR dataRep IN c_totalVentas LOOP
    lc_gananciaAcumulada:=(dataRep.ventas*(dataRep.V_COMISION/100));
END LOOP;
RETURN lc_gananciaAcumulada;
END FU_GANANCIA_DIRECTA;



  /*
  FU_GANANCIA regresa las ganancias generadas de un representante de ventas en un periodo dado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar laS ganancias
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
    FUNCTION FU_GANANCIA(     pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                                            pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                                            pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                                            ) RETURN NUMBER
    AS
    ---DECLARO LO QUE VOY A RETORNAR
    lc_gananciaAcumulada NUMBER:=0;
    -- Declaración de variables
    -- Declaración de Cursores
    ---Totaliza las ventas directas de un representante
        CURSOR c_repHijos IS
            SELECT F_NUMERO_ID,F_TIPO_ID 
            FROM REP_VENTAS RP
            WHERE   RP.F_ID_REP_CAPATADOR=pn_idRepVentas AND
                    RP.F_TIPO_ID_REP_CAPATADOR=pc_tipoIdRep;

    BEGIN
    ---SE DEBE RETORNAR
    lc_gananciaAcumulada:=lc_gananciaAcumulada+FU_GANANCIA_DIRECTA(pn_idRepVentas, pc_tipoIdRep,pd_fecha_inicial);
    FOR dataRep IN c_repHijos LOOP
        IF(c_repHijos%NOTFOUND) THEN
            RETURN lc_gananciaAcumulada;
        ELSE
            lc_gananciaAcumulada:=lc_gananciaAcumulada+(FU_GANANCIA(dataRep.F_NUMERO_ID,dataRep.F_TIPO_ID,pd_fecha_inicial));
        END IF;
    END LOOP;
    RETURN lc_gananciaAcumulada;
    END FU_GANANCIA;

    -- Totalizar Carrito con IVA
  PROCEDURE PR_clasificar_Representante(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE)
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
END PK_GESTION_REPRESENTANTE;
/