/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import java.math.BigDecimal;
import negocio.Cliente;
import util.ServiceLocator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import negocio.Representante;
import util.Mensaje;

/**
 *
 * @author thrash
 */
public class ClienteDAO {
    
    String usr;
    String pass;
    
    public ClienteDAO(String usr, String pass){
        this.usr = usr;
        this.pass = pass;
    }
    
    public void incluirCliente(Cliente cliente,Mensaje ex){
      try {
        String strSQL = "INSERT INTO natame.\"persona\" VALUES(?,?,?,?,?,?)";
        Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
        PreparedStatement prepStmt = conexion.prepareStatement("select count(*) from natame.\"persona\" where K_NUMERO_ID=? and K_TIPO_ID=?");
        prepStmt.setString(1, cliente.getIdCliente());
        prepStmt.setString(2, Character.toString(cliente.getTipoId()));
        ResultSet resultado = prepStmt.executeQuery();
        resultado.next();
        if(resultado.getInt(1)==0){
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, cliente.getIdCliente()); 
            prepStmt.setString(2, Character.toString(cliente.getTipoId())); 
            prepStmt.setString(3, cliente.getNombre()); 
            prepStmt.setString(4, cliente.getApellido()); 
            prepStmt.setString(5, cliente.getDireccion());   
            prepStmt.setString(6, cliente.getCiudad());  
            prepStmt.executeUpdate();
        }
        strSQL = "INSERT INTO natame.\"cliente\" VALUES(?,?,?,?,?,?)";
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setString(1, cliente.getIdCliente()); 
        prepStmt.setString(2, Character.toString(cliente.getTipoId())); 
        prepStmt.setBigDecimal(3, cliente.getTelefono()); 
        prepStmt.setString(4, cliente.getCorreo()); 
        prepStmt.setString(5, cliente.getIdRep());   
        prepStmt.setString(6, Character.toString(cliente.getTipoId()));
        prepStmt.executeUpdate();
        prepStmt.close();
        ServiceLocator.getInstance().commit();
      } catch (SQLException e) {
          ex.setMensaje(e.getLocalizedMessage());
      }  finally {
         ServiceLocator.getInstance().liberarConexion();
      }
    }
    
    public Cliente obtenerCliente(String tipoId, String numeroId,Mensaje ex){
      int contador=0;
      Cliente cliente = new Cliente();
      cliente.setTipoId(tipoId.charAt(0));
      cliente.setIdCliente(numeroId);
      try{
            String strSQL = "select * from natame.\"persona\" where K_TIPO_ID=? and K_NUMERO_ID=?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                cliente.setNombre(resultado.getString(3));
                cliente.setApellido(resultado.getString(4));
                cliente.setDireccion(resultado.getString(5));
                cliente.setCiudad(resultado.getString(6));
            }
            
            strSQL = "select * from natame.\"cliente\" where F_TIPO_ID=? and F_NUMERO_ID=?";
            
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            resultado = prepStmt.executeQuery();
            
            while(resultado.next()){
                cliente.setTelefono(resultado.getBigDecimal(3));
                cliente.setCorreo(resultado.getString(4));
                cliente.setIdRep(resultado.getString(5));
                cliente.setTipoIdRep(resultado.getString(6));
                contador++;
            }
            prepStmt.close();
        }catch(SQLException e){
            System.out.print(e);
            return null;
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        if(contador==0){
            cliente = null;
        }
        return cliente;
    }

    public ArrayList<Cliente> obtenerClientes(Representante rep,Mensaje ex){
      ArrayList<Cliente> clientes = new ArrayList<Cliente>();
      try{
            String strSQL = " select p.N_NOMBRE, p.N_APELLIDO, p.A_DIRECCION, p.C_CIUDAD, c.* from natame.\"persona\" p, natame.\"cliente\" c "
                    + "where p.K_TIPO_ID=c.F_TIPO_ID and p.K_NUMERO_ID=c.F_NUMERO_ID and c.F_TIPO_ID_REP_VENTAS=? and c.F_ID_REP_VENTAS=?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, Character.toString(rep.getTipoId()));
            prepStmt.setString(2, rep.getIdRep());
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                Cliente cliente = new Cliente();
                cliente.setNombre(resultado.getString(1));
                cliente.setApellido(resultado.getString(2));
                cliente.setDireccion(resultado.getString(3));
                cliente.setCiudad(resultado.getString(4));
                cliente.setIdCliente(resultado.getString(5));
                cliente.setTipoId(resultado.getString(6).charAt(0));
                cliente.setTelefono(new BigDecimal(resultado.getString(7)));
                cliente.setCorreo(resultado.getString(8));
                cliente.setIdRep(rep.getIdRep());
                cliente.setTipoIdRep(Character.toString(rep.getTipoId()));
                clientes.add(cliente);
            }
            prepStmt.close();
        }catch(SQLException e){
            System.out.print(e);
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return clientes;
    }
}
