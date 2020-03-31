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

  

END PK_GESTION_REPRESENTANTE;
/

/*------------------Package Body-------------------------*/
CREATE OR REPLACE PACKAGE BODY PK_GESTION_REPRESENTANTE AS 

  
END PK_GESTION_REPRESENTANTE;
/