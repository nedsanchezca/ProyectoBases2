/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import negocio.Pedido;
import util.ServiceLocator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import negocio.Cliente;
import negocio.DetallePedido;
import util.Mensaje;

/**
 *
 * @author thrash
 */
public class PedidoDAO {
    private String usr;
    private String pass;
    
    public PedidoDAO(String usr,String pass){
        this.usr = usr;
        this.pass = pass;
    }
    
    public void registrarPedido(Pedido nuevo,Mensaje ex){
      try {
        String strSQL = "INSERT INTO natame.\"pedido\" VALUES(natame.pedido_seq.nextval,'N',sysdate,?,?)";
        Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
        PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setString(1, nuevo.getCliente().getIdCliente()); 
        prepStmt.setString(2, Character.toString(nuevo.getCliente().getTipoId()));   
        prepStmt.executeUpdate();
        
        strSQL = "INSERT INTO natame.\"detalle_pedido\" VALUES(?,?,natame.pedido_seq.currval,?)";
        String strSQL2 = "UPDATE natame.\"inventario\" SET V_DISPONIBILIDAD = ? WHERE K_ID = ?";
        String strSQL3 = "SELECT V_DISPONIBILIDAD FROM natame.\"inventario\" WHERE K_ID = ?";
        
        for(DetallePedido detalle:nuevo.getItems()){
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setInt(1, detalle.getItem()); 
            prepStmt.setInt(2, detalle.getCantidad());
            prepStmt.setInt(3, detalle.getProducto());
            prepStmt.executeUpdate();
            
            prepStmt = conexion.prepareStatement(strSQL3);
            prepStmt.setInt(1, detalle.getProducto());
            ResultSet valor = prepStmt.executeQuery();
            valor.next();
            int disponibilidad = valor.getInt(1);
            
            prepStmt = conexion.prepareStatement(strSQL2);
            prepStmt.setInt(1, disponibilidad-detalle.getCantidad()); 
            prepStmt.setInt(2, detalle.getProducto());
            prepStmt.executeUpdate();
        }
        
        prepStmt.close();
        ServiceLocator.getInstance().commit();
        ex = null;
      } catch (SQLException e) {
        ServiceLocator.getInstance().rollback();
        ex.setMensaje(e.getLocalizedMessage());
      }  finally {
        ServiceLocator.getInstance().liberarConexion();
      }
    }
    
    public void cancelarPedido(Pedido pedido, Mensaje ex){
      try {
        String strSQL = "UPDATE natame.\"pedido\" SET I_ESTADO=\'C\' WHERE K_N_FACTURA=?";
        Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
        PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setInt(1, pedido.getIdFactura()); 
        prepStmt.executeUpdate();
        
        strSQL = "UPDATE natame.\"inventario\" "
                + "SET V_DISPONIBILIDAD = (SELECT V_DISPONIBILIDAD FROM natame.\"inventario\" WHERE K_ID = ?)+? "
                + "WHERE K_ID = ?";
        prepStmt = conexion.prepareStatement(strSQL);
        
        
        for(DetallePedido det:pedido.getItems()){
            prepStmt.setInt(1, det.getProducto());
            prepStmt.setInt(2, det.getCantidad());
            prepStmt.setInt(3, det.getProducto());
            prepStmt.executeUpdate();
        }
        
        prepStmt.close();
        ServiceLocator.getInstance().commit();
      } catch (SQLException e) {
        ServiceLocator.getInstance().rollback();
          System.out.println(e);
      }  finally {
        ServiceLocator.getInstance().liberarConexion();
      }
    }
    
    public void modificarPedido(Pedido modificado,Mensaje ex){
      try {

        
        Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
        PreparedStatement prepStmt = null;
        
        //Sentencias SQL empleadas
        String strDel = "DELETE FROM natame.\"detalle_pedido\" WHERE F_N_FACTURA = ?";
        String strSQL = "INSERT INTO natame.\"detalle_pedido\" VALUES(?,?,?,?)";
        String strSQL2 = "UPDATE natame.\"inventario\" "
                + "SET V_DISPONIBILIDAD = (SELECT V_DISPONIBILIDAD FROM natame.\"inventario\" WHERE K_ID = ?)+? "
                + "WHERE K_ID = ?";
        String strObt = "SELECT F_ID_INVENTARIO,V_CANTIDAD FROM natame.\"detalle_pedido\" WHERE F_N_FACTURA=?";
        
        prepStmt = conexion.prepareStatement(strObt);
        prepStmt.setInt(1, modificado.getIdFactura());
        ResultSet antiguos = prepStmt.executeQuery();
        
        while(antiguos.next()){
            prepStmt = conexion.prepareStatement(strSQL2);
            prepStmt.setInt(1, antiguos.getInt(1));
            prepStmt.setInt(2, antiguos.getInt(2));
            prepStmt.setInt(3, antiguos.getInt(1));
            prepStmt.executeUpdate();
        }
        
        prepStmt = conexion.prepareStatement(strDel);
        prepStmt.setInt(1, modificado.getIdFactura());
        prepStmt.executeUpdate();
        
        for(DetallePedido detalle:modificado.getItems()){
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setInt(1, detalle.getItem()); 
            prepStmt.setInt(2, detalle.getCantidad()); 
            prepStmt.setInt(3, modificado.getIdFactura()); 
            prepStmt.setInt(4, detalle.getProducto());
            prepStmt.executeUpdate();
            
            prepStmt = conexion.prepareStatement(strSQL2);
            prepStmt.setInt(1, detalle.getProducto());
            prepStmt.setInt(2, -1*detalle.getCantidad());
            prepStmt.setInt(3, detalle.getProducto());
            prepStmt.executeUpdate();
        }
        
        prepStmt.close();
        ServiceLocator.getInstance().commit();
      } catch (SQLException e) {
        ServiceLocator.getInstance().rollback();
        JOptionPane.showMessageDialog(null, e);
      }  finally {
        ServiceLocator.getInstance().liberarConexion();
      }
    }
    
    public ArrayList<Pedido> obtenerPedidos(Cliente cliente, String estado, Mensaje ex){
        ArrayList<Pedido> pedidos = new ArrayList<Pedido>();
        try{
            String strSQL = "SELECT * FROM natame.\"pedido\" WHERE F_NUMERO_ID=? AND F_TIPO_ID=? AND I_ESTADO = ?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1,cliente.getIdCliente());
            prepStmt.setString(2,Character.toString(cliente.getTipoId()));
            prepStmt.setString(3,estado);
            ResultSet pedido = prepStmt.executeQuery();
            strSQL = "SELECT * FROM natame.\"detalle_pedido\" WHERE F_N_FACTURA=?";
            
            while(pedido.next()){
                ArrayList<DetallePedido> detLeidos = new ArrayList<DetallePedido>();
                Pedido leido = new Pedido();
                leido.setIdFactura(pedido.getInt(1));
                leido.setEstado(pedido.getString(2).charAt(0));
                leido.setFecha(pedido.getDate(3).toString());
                leido.setCliente(cliente);
                prepStmt = conexion.prepareStatement(strSQL);
                prepStmt.setInt(1,leido.getIdFactura());
                ResultSet detalle = prepStmt.executeQuery();
                while(detalle.next()){
                    DetallePedido detLeido = new DetallePedido();
                    detLeido.setItem(detalle.getInt(1));
                    detLeido.setCantidad(detalle.getInt(2));
                    detLeido.setProducto(detalle.getInt(4));
                    detLeidos.add(detLeido);
                }
                leido.setItems(detLeidos);
                pedidos.add(leido);
            }
            prepStmt.close();
        }catch(SQLException e){
            //JOptionPane.showMessageDialog(null, e);
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return pedidos;
    }
}