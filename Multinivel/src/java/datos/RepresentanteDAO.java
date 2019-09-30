/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import negocio.Clasificacion;
import negocio.Cliente;
import negocio.Representante;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class RepresentanteDAO {
    public void incluirRepresentante(Representante representante){
      try {
        String strSQL = "INSERT INTO \"persona\" VALUES(?,?,?,?,?,?)";
        Connection conexion = ServiceLocator.getInstance().tomarConexion();
        PreparedStatement prepStmt = conexion.prepareStatement("select count(*) from \"persona\" where K_NUMERO_ID=? and K_TIPO_ID=?");
        prepStmt.setString(1, representante.getIdRep());
        prepStmt.setString(2, Character.toString(representante.getTipoId()));
        ResultSet resultado = prepStmt.executeQuery();
        resultado.next();
        if(resultado.getInt(1)==0){
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep()); 
            prepStmt.setString(2, Character.toString(representante.getTipoId())); 
            prepStmt.setString(3, representante.getNombre()); 
            prepStmt.setString(4, representante.getApellido()); 
            prepStmt.setString(5, representante.getDireccion());   
            prepStmt.setString(6, representante.getCiudad());  
            prepStmt.executeUpdate();
        }
        strSQL = "INSERT INTO \"rep_ventas\" VALUES(?,?,?,?,?,?,?,?,?,?,?)";
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setString(1, representante.getIdRep()); 
        prepStmt.setString(2, Character.toString(representante.getTipoId())); 
        prepStmt.setString(3, representante.getCorreo()); 
        prepStmt.setBigDecimal(4, representante.getTelefono()); 
        prepStmt.setString(5, representante.getGenero());   
        prepStmt.setDate(6, java.sql.Date.valueOf(representante.getFechaContrato()));
        prepStmt.setDate(7, java.sql.Date.valueOf(representante.getFechaNacimiento()));
        prepStmt.setInt(8, representante.getClasificacion());
        prepStmt.setString(9, representante.getCaptadorId());
        prepStmt.setString(10, representante.getCaptadorTipo());
        prepStmt.setString(11, representante.getCodigoPostal()); 
        prepStmt.executeUpdate();
        prepStmt.close();
        ServiceLocator.getInstance().commit();
      } catch (SQLException e) {
           System.out.print(e);
      }  finally {
         ServiceLocator.getInstance().liberarConexion();
      }
      
    }
    
    public Representante obtenerRepresentante(String tipoId, String numeroId){
        Representante rep = new Representante();
        rep.setTipoId(tipoId.charAt(0));
        rep.setIdRep(numeroId);
        try{
            String strSQL = "select * from \"persona\" where K_TIPO_ID=? and K_NUMERO_ID=?";
            Connection conexion = ServiceLocator.getInstance().tomarConexion();
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            ResultSet resultado = prepStmt.executeQuery();
            while(resultado.next()){
                rep.setNombre(resultado.getString(3));
                rep.setApellido(resultado.getString(4));
                rep.setDireccion(resultado.getString(5));
                rep.setCiudad(resultado.getString(6));
            }
            
            strSQL = "select * from \"rep_ventas\" where K_TIPO_ID=? and K_NUMERO_ID=?";
            
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            resultado = prepStmt.executeQuery();
            
            while(resultado.next()){
                rep.setCorreo(resultado.getString(3));
                rep.setTelefono(resultado.getBigDecimal(4));
                rep.setGenero(resultado.getString(5));
                rep.setFechaContrato(resultado.getDate(6).toString());
                rep.setFechaNacimiento(resultado.getDate(7).toString());
                rep.setClasificacion(resultado.getInt(8));
                rep.setCaptadorId(resultado.getString(9));
                rep.setCaptadorTipo(resultado.getString(10));
                rep.setCodigoPostal(resultado.getString(11));
            }
            prepStmt.close();
        }catch(SQLException e){
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return rep;
    }
}
