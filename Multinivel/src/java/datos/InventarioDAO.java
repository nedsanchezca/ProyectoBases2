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
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class InventarioDAO {
    String usr;
    String pass;
    
    public InventarioDAO(String usr, String pass){
        this.usr = usr;
        this.pass = pass;
    }
    
    /**
     * Obtención del inventario de una región
     * @param codPostal
     * @param ex
     * @return 
     */
    public ArrayList<ProductoInventario> obtenerInventario(String codPostal,Mensaje ex){
        ArrayList<ProductoInventario> inventario = new ArrayList<ProductoInventario>();
        try{
            //Tomar la conexión para el usuario actual
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            
            //Ejecución de la sentencia SQL
            String strSQL = "select p.K_CODIGO_PRODUCTO,p.N_NOMBRE_PRODUCTO "
                    + "from inventario i,producto p "
                    + "GROUP BY i.F_CODIGO_POSTAL,p.N_NOMBRE_PRODUCTO,i.F_CODIGO_PRODUCTO,p.K_CODIGO_PRODUCTO "
                    + "HAVING i.F_CODIGO_PRODUCTO=p.K_CODIGO_PRODUCTO and i.F_CODIGO_POSTAL=?";
            
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1,codPostal);
            ResultSet inventarioSQL = prepStmt.executeQuery();
            
            //Construir el inventario de la región
            while(inventarioSQL.next()){
                ProductoInventario leido = new ProductoInventario();
                leido.setIdProducto(inventarioSQL.getInt(1));
                leido.setNombreProducto(inventarioSQL.getString(2));
                inventario.add(leido);
            }
            
            prepStmt.close();
        }catch(SQLException e){
            //Mensaje de error
            ex.setMensaje(e.getLocalizedMessage());
        }finally{
            //Siempre se libera la conexión
            ServiceLocator.getInstance().liberarConexion();
        }
        return inventario;
    }
    
    /**
     * Se obtiene un producto de unventario basado en su código
     * @param idProd
     * @param ex
     * @return 
     */
    public ProductoInventario obtenerProducto(int idProd,Mensaje ex){
        ProductoInventario leido = null;
        try{
            //Tomar conexión para el usuario actual
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            
            //Ejecución de la sentencia SQL
            String strSQL = "select * from v_producto where K_ID=?";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setInt(1,idProd);
            ResultSet inventarioSQL = prepStmt.executeQuery();
            
            //Configurar los inventarios deacuerdo a la búsqueda
            while(inventarioSQL.next()){
                leido = new ProductoInventario();
                leido.setIdProducto(inventarioSQL.getInt(1));
                leido.setPrecio(inventarioSQL.getDouble(2));
                leido.setNombreProducto(inventarioSQL.getString(3));
                leido.setIva(inventarioSQL.getDouble(5));
            }
            prepStmt.close();
        }catch(SQLException e){
            //Mensaje de error
            ex.setMensaje(e.getLocalizedMessage());
        }finally{
            //Liberar la conexión
            ServiceLocator.getInstance().liberarConexion();
        }
        return leido;
    }
}
