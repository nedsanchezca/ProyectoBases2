package util;

import java.sql.Connection;
import java.sql.*;
import java.sql.SQLException;

/**
 * Recursos Humanos
 * @author Alba Consuelo Nieto
 */
public class ServiceLocator {

	/**
	 * Conexion compartida a la Base de Datos
	 */
	private Connection conexion = null;


	/**
	 * @throws Exception
	 *             dice si no se pudo crear la conexion
	 */
	public ServiceLocator(){
	    try {
                DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
                conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:49161:xe","natame","natame");
	        conexion.setAutoCommit(false);
	    } catch (Exception e) {
                System.out.print(e);
	    }
	}
        
	/**
	 * @throws Exception
	 *             dice si no se pudo crear la conexion
	 */
	public ServiceLocator(String usr, String pass,Mensaje mensaje){
	    try {
                DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
                conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:49161:xe",usr,pass);
	        conexion.setAutoCommit(false);
	    } catch (Exception e) {
                mensaje.setMensaje(e.getLocalizedMessage());
	    }
	}

	/**
	 * Cierra la conexion a la base de datos cuando se termina de
	 * ejecutar el programa
	 */
	public void close() {
	    try {
		conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
	}

	/**
	 * Realiza los cambios en la base de datos. Con este metodo
	 * se asegura que no halla inconsitencias en el modelo relacional
	 * de la Base de datos.
	 * 
	 * Se utiliza cuando el procedimiento de insercion es terminado
	 * correctamente y se asegura que los datos en el modelo estan bien
	 * relacionados.
	 */
	public void commit() {
            try {
		conexion.commit();
            } catch (SQLException e) {
		e.printStackTrace();
            }
	}

	/**
	 * Deshace los cambios en la base de datos. Con este metodo
	 * se asegura que no halla inconsitencias en el modelo relacional
	 * de la Base de datos.
	 * 
	 * Se utiliza por lo general cuando se devuelve una Exepcion.
	 * Los procedimientos intermedios no deberia quedar almacenados en la
	 * base de datos. 
	 */

	public void rollback() {
            try {
            	conexion.rollback();
            } catch (SQLException e) {
            	e.printStackTrace();
            }
	}
        
        public Connection getConexion(){
            return conexion;
        }
}
