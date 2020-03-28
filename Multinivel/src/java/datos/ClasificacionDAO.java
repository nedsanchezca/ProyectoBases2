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
import negocio.Representante;
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
     * @param rep representante del que se desea saber la clasificacion
     * @param ex variable auxiliar para mensajes de error
     * @return 
     */
    public Clasificacion obtenerClasificacion(Representante rep, Mensaje ex){
        Clasificacion clasificacion = new Clasificacion();
        try{
            //Conexión con el usuario actual
            Connection conexion = locator.getConexion();
            //Ejecución de la sentencia SQL
            String strSQL = "select n_nombre,v_comision "
                          + "from historico_clasificacion hc, clasificacion c "
                          + "where f_id_clasificacion=k_id and f_tipo_id = ? "
                          + "and f_num_id = ? order by d_fecha_inicial desc";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, Character.toString(rep.getTipoId()));
            prepStmt.setString(2, rep.getIdRep());
            ResultSet resultado = prepStmt.executeQuery();
            
            //Se crea un objeto de tipo clasificación y se configura
            if(resultado.next()){
                clasificacion.setNombre(resultado.getString(1));
                clasificacion.setComision(resultado.getDouble(2));
            }
            prepStmt.close();
        }catch(SQLException e){
            //Si hay un error, se configura el mensaje y se retorna nulo
            ex.setMensaje(e.getLocalizedMessage());
            System.out.println(e.getLocalizedMessage());
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
