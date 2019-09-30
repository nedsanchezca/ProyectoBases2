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
import negocio.DetallePedido;
import negocio.Pedido;
import negocio.ProductoInventario;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class InventarioDAO {
    public ArrayList<ProductoInventario> obtenerInventario(String codPostal){
        ArrayList<ProductoInventario> inventario = new ArrayList<ProductoInventario>();
        try{
            String strSQL = "select p.K_CODIGO_PRODUCTO,p.N_NOMBRE_PRODUCTO "
                    + "from \"inventario\" i,\"producto\" p "
                    + "GROUP BY i.F_CODIGO_POSTAL,p.N_NOMBRE_PRODUCTO,i.F_CODIGO_PRODUCTO,p.K_CODIGO_PRODUCTO "
                    + "HAVING i.F_CODIGO_PRODUCTO=p.K_CODIGO_PRODUCTO and i.F_CODIGO_POSTAL=?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion();
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1,codPostal);
            ResultSet inventarioSQL = prepStmt.executeQuery();
            while(inventarioSQL.next()){
                ProductoInventario leido = new ProductoInventario();
                leido.setIdProducto(inventarioSQL.getInt(1));
                leido.setNombreProducto(inventarioSQL.getString(2));
                inventario.add(leido);
            }
            prepStmt.close();
        }catch(SQLException e){
            
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return inventario;
    }
}
