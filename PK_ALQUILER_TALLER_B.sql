/*-----------------------------------------------------------------------------------
  Proyecto   : Reservas de vehículos. Curso BDII
  Descripcion: Implementación de los procedimientos y funciones declarados en la cabecera
  				del paquete pk_reservas_taller
  Autor: Cristian Manuel Bernal Bernal.
--------------------------------------------------------------------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_RESERVAS_TALLER AS

     /*------------------------------------------------------------------------------
     Procedimiento para buscar un cliente
     Parametros de Entrada: pk_nit           Número de identificación del cliente a buscar
     Parametros de Salida: pr_cliente        Registro con los datos básicos del cliente
                           pc_error        = 1 si no existe,
                                             0, en caso contrario
                           pm_error         Mensaje de error si hay error o null en caso contrario
    */
    PROCEDURE PR_BUSCAR_CLIENTE(pk_nit      IN cliente.k_nit%TYPE,
                                pr_cliente  OUT gtr_cliente,
                                pc_error    OUT NUMBER,
                                pm_error    OUT VARCHAR2(10))
    AS
    	SELECT k_nit, n_nomcliente, n_apecliente INTO pr_cliente
    	WHERE k_nit=pk_nit;
    	pc_error := 0;
    	pm_error := null;
    EXCEPTION
    	WHEN NOT_DATA_FOUND THEN
    		pc_error:= 1;
    		pm_error:= 'Cliente solicitado no se encuentra, intente más tarde';
    END PR_BUSCAR_CLIENTE;

     /*------------------------------------------------------------------------------
     Función para buscar el nombre del cliente
     Parametros de Entrada: pk_nit           Número de identificación del cliente a buscar
     Parametros de Salida: pc_error        = 1 si no existe,
                                             0, en caso contrario
                           pm_error         Mensaje de error si hay error o null en caso contrario
     Retorna : Nombre completo del cliente de tipo VARCHAR
    */            
    FUNCTION FU_BUSCAR_CLIENTE(pk_nit        IN cliente.k_nit%TYPE,
                               pc_error    OUT NUMBER,
                               pm_error    OUT VARCHAR2) RETURN VARCHAR
    l_nomcompleto VARCHAR(60);
    AS
    	SELECT n_nomcliente||' '||n_apecliente INTO l_nomcompleto
    	WHERE k_nit=pk_nit;
    	pc_error := 0;
    	pm_error := null;
    	RETURN l_nomcompleto;
    EXCEPTION
    	WHEN NOT_DATA_FOUND THEN
    		pc_error := 1;
    		pm_error := 'Cliente solicitado no se encuentra, intente más tarde'; 	
    END FU_BUSCAR_CLIENTE;
                                  
    /*-----------------------------------------------------------------------------------------
     Procedimiento para listar las reservas de un cliente.
     Debe mostrar la identificación,
     nombre y apellido del cliente. Para cada reserva se debe mostrar el código, fecha y valor
     de la reserva, y para cada reserva se muestran los vehículos reservados: matrícula, fecha 
     de inicio y fin, y el indicador de si ya fue entregado.
     Parametros de Entrada: pk_nit           Número de identificación del cliente
     Parametros de Salida:  
                            pc_error       = 1 si no existe el cliente,
                                             0, en caso contrario
                            pm_error         Mensaje de error si hay error o null en caso contrario
   */
    PROCEDURE PR_LISTAR_RESERVAS(pk_nit IN cliente.k_nit%TYPE, 
   		   						 pc_error OUT NUMBER, 
   		 						 pm_error OUT VARCHAR)
    lk_reserva reserva.k_reserva%TYPE;
    lc_error NUMBER;
    lm_error VARCHAR(50);
    CURSOR C_RESERVAS IS
    	SELECT k_reserva, f_reserva, v_total
    	WHERE k_nit = pk_nit;

    CURSOR C_VEHICULOS IS
    	SELECT k_matricula, f_inicio, f_fin, i_entregado
    	WHERE k_reserva = lk_reserva;
    AS
    	PR_BUSCAR_CLIENTE(pk_nit, gr_cliente, lc_error,lm_error);
    	IF lc_error<>0 THEN
    		RAISE EX_NOT_FOUND;
    	END IF;
    	DBMS_OUT.PUT_LINE(gr_cliente.k_nit||' '||gr_cliente.n_nomcliente||' '||gr_cliente.n_apecliente)
    	FOR  RC_RESERVA IN C_RESERVAS LOOP
    		DBMS_OUT.PUT_LINE(RC_RESERVA.k_reserva||' '||RC_RESERVA.f_reserva||' '||RC_RESERVA.v_total);
    		lk_reserva = RC_RESERVA.k_reserva;
    		FOR  RC_VEHICULO IN C_VEHICULOS LOOP
    			DBMS_OUT.PUT_LINE(RC_VEHICULO.k_matricula||' '||RC_VEHICULO.f_inicio||' '||RC_VEHICULO.f_fin||' '||RC_VEHICULO.i_entregado);
    		END LOOP;
    	END LOOP;
    EXCEPTION
    	WHEN EX_NOT_FOUND THEN
    		pc_error := lc_error;
    		pm_error := lm_error;
    END PR_LISTAR_RESERVAS;

    /*-----------------------------------------------------------------------------------------
     Función que determina  si un vehículo está disponible para reserva en una fecha dada.

     Parametros de Entrada: pk_matricula    Número de matrícula del vehículo solicitado
     						pf_reserva		Fecha para la que se solicita saber la consulta.
     Parametros de Salida:  
                            pc_error       = 1 si no existe el vehículo,
                                             0, en caso contrario
                            pm_error         Mensaje de error si hay error o null en caso contrario
   */
    FUNCTION FU_VEHICULO_DISPONIBLE (pk_matricula vehiculo.k_matricula%TYPE,
   									pf_reserva date,
   									pc_error OUT NUMBER, 
   		 						 	pm_error OUT VARCHAR)  RETURN BOOLEAN
    CURSOR C_VEHICULOS IS
    	SELECT f_inicio,f_fin 
    	FROM RESERVA_VEHICULO
    	WHERE k_matricula = pk_matricula; 
    AS
    	FOR RC_VEHICULO IN C_VEHICULOS LOOP
    		IF RC_VEHICULO.f_inicio<=pf_reserva AND RC_VEHICULO.f_fin>=pf_reserva THEN
    			RETURN FALSE;
    		END IF;
    	END LOOP;
    	RETURN TRUE;
    END FU_VEHICULO_DISPONIBLE
	
END PK_RESERVAS_TALLER;