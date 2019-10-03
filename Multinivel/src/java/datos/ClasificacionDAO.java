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
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class ClasificacionDAO {
    private String usr;
    private String pass;
    
    public ClasificacionDAO(String usr, String pass){
        this.usr = usr;
        this.pass = pass;
    }
    
    public Clasificacion obtenerClasificacion(int codigo, Mensaje ex){
        Clasificacion clasificacion = new Clasificacion();
        try{
            String strSQL = "select N_NOMBRE,V_COMISION from natame.\"clasificacion\" where K_ID=?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setInt(1, codigo);
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                clasificacion.setNombre(resultado.getString(1));
                clasificacion.setComision(resultado.getDouble(2));
            }
            prepStmt.close();
        }catch(SQLException e){
            ex.setMensaje(e.getLocalizedMessage());
            return null;
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return clasificacion;
    }
}
