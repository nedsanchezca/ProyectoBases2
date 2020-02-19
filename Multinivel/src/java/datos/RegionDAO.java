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
import negocio.ProductoInventario;
import negocio.Region;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class RegionDAO {
    private ServiceLocator locator;
    public ArrayList<Region> obtenerInventario(){
        ArrayList<Region> regiones = new ArrayList<Region>();
        try{
            String strSQL = "select * from region";
            Connection conexion = locator.getConexion();
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                Region leido = new Region();
                leido.setCodigoPostal(resultado.getString(1));
                leido.setNombreRegion(resultado.getString(2));
                regiones.add(leido);
            }
            prepStmt.close();
            
        }catch(SQLException e){
        }finally{
            this.locator=null;
        }
        return regiones;
    }
    
    public void setLocator(ServiceLocator locator){
        this.locator=locator;
    }
}
