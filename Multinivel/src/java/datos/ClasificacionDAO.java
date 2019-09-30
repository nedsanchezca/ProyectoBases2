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
import java.util.ArrayList;
import negocio.Clasificacion;
import negocio.Region;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class ClasificacionDAO {
    public ArrayList<Clasificacion> obtenerClasificacion(){
        ArrayList<Clasificacion> clasificaciones = new ArrayList<Clasificacion>();
        try{
            String strSQL = "select * from \"clasificacion\"";
            Connection conexion = ServiceLocator.getInstance().tomarConexion();
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                Clasificacion leido = new Clasificacion();
                leido.setIdClasificacion(resultado.getInt(1));
                leido.setNombre(resultado.getString(2));
                leido.setComision(resultado.getDouble(3));
                clasificaciones.add(leido);
            }
            prepStmt.close();
            
        }catch(SQLException e){
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return clasificaciones;
    }
}
