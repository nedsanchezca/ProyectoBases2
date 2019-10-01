package util;

import java.sql.Connection;
import java.sql.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * Recursos Humanos
 * @author Alba Consuelo Nieto
 */
public class ServiceLocator {

	/**
	 * Instancia del ServiceLocator
	 */
	private static ServiceLocator instance = null;

	/**
	 * Conexion compartida a la Base de Datos
	 */
	private Connection conexion = null;

	/**
	 * Bandera que indica el estado de la conexion
	 */
	private boolean conexionLibre = true;

	/**
	 * @return instancia del ServiceLocator para el manejo de la conexion
	 */
	public static ServiceLocator getInstance() {
		if (instance == null) {
			try {
				instance = new ServiceLocator();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return instance;
	}

	/**
	 * @throws Exception
	 *             dice si no se pudo crear la conexion
	 */
	private ServiceLocator() throws Exception {
		try {
                     DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
                     conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","natame","natame");
		     conexion.setAutoCommit(false);
		} catch (Exception e) {
                    System.out.print(e);
		}
	}

	/**
	 * Toma la conexion para que ningun otro proceso la puedan utilizar
	 * @return da la conexion a la base de datos
	 */
	public synchronized Connection tomarConexion() {
		while (!conexionLibre) {
			try {
			  wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		conexionLibre = false;
		notify();
		return conexion;
	}

	/**
	 * Libera la conexion de la bases de datos para que ningun otro
	 * proceso la pueda utilizar
	 */
	public synchronized void liberarConexion() {
		while (conexionLibre) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		conexionLibre = true;
		notify();
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
        
        public SQLException cambiarConexion(String user,String pass){
            try {
                System.out.println("Estoy hasta la madreeeee");
                conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe",user,pass);
                System.out.println("Estoy hasta la madreeeee2");
                conexion.setAutoCommit(false);
                System.out.println("Estoy hasta la madreeeee3");
                return null;
            } catch (SQLException ex) {
                System.out.println("Estoy hasta la madreeeee4");
                return ex;
            }
        }
        
        public void restaurarConexion(){
            try {
                conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","natame","natame");
                conexion.setAutoCommit(false);
            } catch (SQLException ex) {
                System.out.print(ex);
            }
        }
}
