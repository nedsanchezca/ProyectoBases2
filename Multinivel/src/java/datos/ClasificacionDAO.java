/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import negocio.Clasificacion;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class ClasificacionDAO {
    private ServiceLocator locator;
    
    public ClasificacionDAO(){
        
    }
    
    /**
     * 
     * @param codigo llave primaria de la clasificación
     * @param ex variable auxiliar para mensajes de error
     * @return 
     */
    public Clasificacion obtenerClasificacion(int codigo, Mensaje ex){
        Clasificacion clasificacion = new Clasificacion();
        try{
            //Conexión con el usuario actual
            Connection conexion = locator.getConexion();
            //Ejecución de la sentencia SQL
            String strSQL = "select N_NOMBRE,V_COMISION from clasificacion where K_ID=?";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setInt(1, codigo);
            ResultSet resultado = prepStmt.executeQuery();
            
            //Se crea un objeto de tipo clasificación y se configura
            while(resultado.next()){
                clasificacion.setNombre(resultado.getString(1));
                clasificacion.setComision(resultado.getDouble(2));
            }
            prepStmt.close();
        }catch(SQLException e){
            //Si hay un error, se configura el mensaje y se retorna nulo
            ex.setMensaje(e.getLocalizedMessage());
            return null;
        }finally{
            this.locator=null;
        }
        
        //Si no hay errores, se retorna la clasificación
        return clasificacion;
    }
    
    public void setLocator(ServiceLocator locator){
        this.locator = locator;
    }
}
