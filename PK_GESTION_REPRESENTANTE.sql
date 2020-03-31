/*-----------------------------------------------------------------------------------
  Proyecto   : Ventas multinivel NATAME. Curso BDII
  Descripcion: Funciones y procedimientos asociados al m�dulo de Gesti�n de representantes.
  Autores    : Nestor Sanchez, Jairo Andr�s Romero, Gabriela Ladino, Juan Diego Avila, Cristian Bernal.
--------------------------------------------------------------------------------------*/

/*------------------Package Header-------------------------*/
CREATE OR REPLACE PACKAGE PK_GESTION_REPRESENTANTE AS 

  /*
         PR_clasificarRepresentante
         Clasificar a los representantes de ventas periodicamente y genera un resumen con los datos correspondientes al total
         de ventas de cada representante, representantes a cargo y acumulado de ventas de cada uno, promedio de calificación
         categoria anterior y categoría asignada.
         el total de la reserva con el valor calculado.
         Parámetros de entrada: pd_fecha_inicial : Dada la fecha inicial de un periodo, arroja el resumen de cada representante
         Parámetros de salida:   pc_error = 1, si el proceso termina exitosamente, 0 en caso contrario
                                 pm_error = null, si el proceso termina exitosamente, mensaje de error en caso contrario         
     */
  PR_clasificarRepresentante(pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE);

  /*
  FU_GANANCIA_DIRECTA regresa las ganancias generadas de un representante de ventas en un periodo dado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar sus ganancias
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
  FUNCTION FU_GANANCIA_DIRECTA(pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                                            pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                                            pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                                            ) RETURN NUMBER;

  /*
  FU_GANANCIA_HIJOS regresa las ganancias generadas por los representantes de ventas inferiores al representante de ventas ingresado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar la ganancias de los inferiores
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias de los inferiores
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
  FUNCTION FU_GANANCIA_HIJOS(
                              pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
                              pc_tipoIdRep REP_VENTAS.F_TIPO_ID%TYPE,
                              pd_fecha_inicial historico_clasificacion.d_fecha_inicial%TYPE
                              ) RETURN NUMBER;


END PK_GESTION_REPRESENTANTE;




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
    lc_gananciaAcumulada:=lc_gananciaAcumulada+(FU_GANANCIA_HIJOS(pn_idRepVentas,pc_tipoIdRep,pd_fecha_inicial)*(dataRep.V_COMISION/100));
END LOOP;
RETURN lc_gananciaAcumulada;
END FU_GANANCIA_DIRECTA;


  /*
  FU_GANANCIA_HIJOS regresa las ganancias generadas por los representantes de ventas inferiores al representante de ventas ingresado
        Parametros de entrada: pn_idRepVentas No de identificacion del representante de ventas al que se va a consultar la ganancias de los inferiores
                                pc_tipoIdRep Tipo de identificación del representante de ventas al que se va a consultar sus ganancias de los inferiores
                                pd_fecha_inicial Fecha desde la que se quiere realizar el calculo
  */
  FUNCTION FU_GANANCIA_HIJOS(
                                            pn_idRepVentas REP_VENTAS.F_NUMERO_ID%TYPE,
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
                --d_fecha >= TO_DATE(pd_fecha_inicial, 'DD.MM.YYYY') AND d_fecha <= SYSDATE
BEGIN
---SE DEBE RETORNAR
FOR dataRep IN c_repHijos LOOP
    IF(c_repHijos%NOTFOUND) THEN
        RETURN lc_gananciaAcumulada;
    ELSE
        lc_gananciaAcumulada:=lc_gananciaAcumulada+FU_GANANCIA_DIRECTA(dataRep.F_NUMERO_ID, dataRep.F_TIPO_ID,pd_fecha_inicial);
    END IF;
END LOOP;
RETURN lc_gananciaAcumulada;
END FU_GANANCIA_HIJOS;
/

END PK_GESTION_REPRESENTANTE;