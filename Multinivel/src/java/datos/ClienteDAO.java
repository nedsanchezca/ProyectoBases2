/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import java.math.BigDecimal;
import java.sql.CallableStatement;
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

    private ServiceLocator locator;
    

    public ClienteDAO(){

    }
    
    
    /**
     * Guarda un cliente, basado en un objeto cliente
     * @param cliente Objeto con los datos del cliente a almacenar
     * @param ex Auxiliar para retornar mensaje de error
     */
    public void incluirCliente(Cliente cliente,Mensaje ex){
      try {
        //Toma la conexión con el usuario actual
        Connection conexion = locator.getConexion();
        
        //Ejecución de la sentencia SQL
        String strSQL = "INSERT INTO persona VALUES(?,?,?,?,?,?)";
        PreparedStatement prepStmt = conexion.prepareStatement("select count(*) from persona where K_NUMERO_ID=? and K_TIPO_ID=?");
        prepStmt.setString(1, cliente.getIdCliente());
        prepStmt.setString(2, Character.toString(cliente.getTipoId()));
        ResultSet resultado = prepStmt.executeQuery();
        resultado.next();
        
        //Si ya existe una persona con este id, no se llena la tabla persona
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
        
        //Ejecución de la sentencia de inserción
        strSQL = "INSERT INTO cliente VALUES(?,?,?,?,?,?)";
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setString(1, cliente.getIdCliente()); 
        prepStmt.setString(2, Character.toString(cliente.getTipoId())); 
        prepStmt.setBigDecimal(3, cliente.getTelefono()); 
        prepStmt.setString(4, cliente.getCorreo()); 
        prepStmt.setString(5, cliente.getIdRep());   
        prepStmt.setString(6, cliente.getTipoIdRep());
        prepStmt.executeUpdate();
        prepStmt.close();

        String prStatement = "{ call PR_CREAR_USUARIO(?, ?) }";
        CallableStatement caStatement = conexion.prepareCall(prStatement);
        caStatement.setString(1, Character.toString(cliente.getTipoId()));
        caStatement.setString(2, cliente.getIdCliente());
        caStatement.execute();

        locator.commit();
      } catch (SQLException e) {
          //Si hay un error, se actualiza el mensaje de error
          locator.rollback();
          ex.setMensaje(e.getLocalizedMessage());
      }  finally {
          //Siempre se libera la conexión
         this.locator = null;
      }
    }
    
    /**
     * Obtiene un cliente a partir de su id
     * @param tipoId tipo de id del cliente
     * @param numeroId id del cliente
     * @param ex auxiliar para mensajes de error
     * @return 
     */
    public Cliente obtenerCliente(String tipoId, String numeroId,Mensaje ex){
        
      //Declaraciones iniciales
      int contador=0;
      Cliente cliente = new Cliente();
      cliente.setTipoId(tipoId.charAt(0));
      cliente.setIdCliente(numeroId);
      try{
          
            //Toma la conexión para el usuario actual
            Connection conexion = locator.getConexion();
            
            //Ejecución de la sentencia SQL de persona
            String strSQL = "select * from persona where K_TIPO_ID=? and K_NUMERO_ID=?";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            ResultSet resultado = prepStmt.executeQuery();
            
            //Configuración del objeto cliente
            while(resultado.next()){
                cliente.setNombre(resultado.getString(3));
                cliente.setApellido(resultado.getString(4));
                cliente.setDireccion(resultado.getString(5));
                cliente.setCiudad(resultado.getString(6));
            }
            
            //Ejecución de la sentencia SQL
            strSQL = "select * from cliente where F_TIPO_ID=? and F_NUMERO_ID=?";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            resultado = prepStmt.executeQuery();
            
            //Configuración del objeto cliente
            while(resultado.next()){
                cliente.setTelefono(resultado.getBigDecimal(3));
                cliente.setCorreo(resultado.getString(4));
                cliente.setIdRep(resultado.getString(5));
                cliente.setTipoIdRep(resultado.getString(6));
                contador++;
            }
            prepStmt.close();
            
        }catch(SQLException e){
            //Se configura el mensaje de error
            ex.setMensaje(e.getLocalizedMessage());
            return null;
        }finally{
            //Se libera la conexión siempre
            this.locator = null;
        }
        
        //Una consulta vacía no genera error, pero debe manejarse
        if(contador==0){
            cliente = null;
        }
        
        //Se retorna el objeto cliente
        return cliente;
    }

    /**
     * Se obtiene un arreglo de clientes que están a cargo de un representante
     * @param rep representante a consultar
     * @param ex auxiliar para mensajes de error
     * @return 
     */
    public ArrayList<Cliente> obtenerClientes(Representante rep,Mensaje ex){
      ArrayList<Cliente> clientes = new ArrayList<Cliente>();
      try{
            //Tomar la conexión
            Connection conexion = locator.getConexion();
            
            //Ejecución de la sentencia SQL
            String strSQL = "select p.N_NOMBRE, p.N_APELLIDO, p.A_DIRECCION, p.C_CIUDAD, c.* from persona p, cliente c "
                    + "where p.K_TIPO_ID=c.F_TIPO_ID and p.K_NUMERO_ID=c.F_NUMERO_ID and c.F_TIPO_ID_REP_VENTAS=? and c.F_ID_REP_VENTAS=?";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, Character.toString(rep.getTipoId()));
            prepStmt.setString(2, rep.getIdRep());
            ResultSet resultado = prepStmt.executeQuery();
            
            //configuración del objeto cliente con el resultado de la búsqueda.
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
            //Mensaje de error
            ex.setMensaje(e.getLocalizedMessage());
        }catch(NullPointerException e){
            //Mensaje de error
            ex.setMensaje(e.getLocalizedMessage());
        }finally{
            //Se libera siempre la conexión
            this.locator = null;
        }
        return clientes;
    }
    
    public void setLocator(ServiceLocator locator){
        this.locator=locator;
    }
}
