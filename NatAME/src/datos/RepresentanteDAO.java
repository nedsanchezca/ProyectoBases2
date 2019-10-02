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
    
    String usr;
    String pass;
    
    public RepresentanteDAO(String usr,String pass){
        this.usr = usr;
        this.pass = pass;
    }

    public RepresentanteDAO() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public SQLException incluirRepresentante(Representante representante){
        ServiceLocator.getInstance().cambiarConexion(usr, pass);
        Connection conexion = ServiceLocator.getInstance().tomarConexion();
        try {
        String strSQL = "INSERT INTO natame.\"persona\" VALUES(?,?,?,?,?,?)";
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
        strSQL = "INSERT INTO natame.\"rep_ventas\" VALUES(?,?,?,?,?,sysdate,?,?,?,?,?)";
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.setString(1, representante.getIdRep()); 
        prepStmt.setString(2, Character.toString(representante.getTipoId())); 
        prepStmt.setString(3, representante.getCorreo()); 
        prepStmt.setBigDecimal(4, representante.getTelefono()); 
        prepStmt.setString(5, representante.getGenero());
        prepStmt.setDate(6, java.sql.Date.valueOf(representante.getFechaNacimiento()));
        prepStmt.setInt(7, representante.getClasificacion());
        System.out.print("Aquiiiii");
        prepStmt.setString(8, representante.getCaptadorId());
        prepStmt.setString(9, representante.getCaptadorTipo());
        prepStmt.setString(10, representante.getCodigoPostal()); 
        prepStmt.executeUpdate();
        
        ServiceLocator.getInstance().commit();
        ServiceLocator.getInstance().restaurarConexion();
        strSQL = "CREATE USER "+ representante.getTipoId() + representante.getIdRep() + " IDENTIFIED BY " + representante.getIdRep();
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.execute();
        strSQL = "GRANT r_repVentas TO " + representante.getTipoId() + representante.getIdRep();
        prepStmt = conexion.prepareStatement(strSQL);
        prepStmt.execute();
        prepStmt.close();
        return null;
      } catch (SQLException e) {
          return e;
      }  finally {
         ServiceLocator.getInstance().restaurarConexion();
         ServiceLocator.getInstance().liberarConexion();
      }
      
    }
    
    public Representante obtenerRepresentante(String tipoId, String numeroId){
        Representante rep = new Representante();
        rep.setTipoId(tipoId.charAt(0));
        rep.setIdRep(numeroId);
        try{
            String strSQL = "select * from natame.\"persona\" where K_TIPO_ID=? and K_NUMERO_ID=?";
            ServiceLocator.getInstance().cambiarConexion(usr, pass);
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
            
            strSQL = "select * from natame.\"rep_ventas\" where F_TIPO_ID=? and F_NUMERO_ID=?";
            
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
                System.out.println(resultado.getString(11)+"lkajflkdfjladksfjhola");
            }
            ServiceLocator.getInstance().restaurarConexion();
            prepStmt.close();
        }catch(SQLException e){
        }finally{
            ServiceLocator.getInstance().liberarConexion();
        }
        return rep;
    }
}
