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
import negocio.Representante;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class RepresentanteDAO {

    ServiceLocator locator;
            
    public RepresentanteDAO() {
    }

    public Mensaje incluirRepresentante(Representante representante) {
        Mensaje mensaje = new Mensaje();
        Connection conexion = locator.getConexion();
        try {
            String strSQL = "INSERT INTO persona VALUES(?,?,?,?,?,?)";
            PreparedStatement prepStmt = conexion.prepareStatement("select count(*) from persona where K_NUMERO_ID=? and K_TIPO_ID=?");
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            ResultSet resultado = prepStmt.executeQuery();
            resultado.next();
            
            if (resultado.getInt(1) == 0) {
                prepStmt = conexion.prepareStatement(strSQL);
                prepStmt.setString(1, representante.getIdRep());
                prepStmt.setString(2, Character.toString(representante.getTipoId()));
                prepStmt.setString(3, representante.getNombre());
                prepStmt.setString(4, representante.getApellido());
                prepStmt.setString(5, representante.getDireccion());
                prepStmt.setString(6, representante.getCiudad());
                prepStmt.executeUpdate();
            }
            System.out.println("Superé la persona yeih");
            strSQL = "INSERT INTO rep_ventas VALUES(?,?,?,?,?,sysdate,?,?,?,?)";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            prepStmt.setString(3, representante.getCorreo());
            prepStmt.setBigDecimal(4, representante.getTelefono());
            prepStmt.setString(5, representante.getGenero());
            System.out.println("Antes de la fecha");
            prepStmt.setDate(6, java.sql.Date.valueOf(representante.getFechaNacimiento()));
            System.out.println("Después de la fecha");
            prepStmt.setString(7, representante.getCaptadorId());
            prepStmt.setString(8, representante.getCaptadorTipo());
            prepStmt.setString(9, representante.getCodigoPostal());
            prepStmt.executeUpdate();
            
            strSQL = "INSERT INTO HISTORICO_CLASIFICACION VALUES(natame.pedido_seq.nextval,SYSDATE,SYSDATE + numtoyminterval(1, 'MONTH')-1,?,?,1)";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            prepStmt.executeUpdate();
            System.out.println("Pase primera parte");
            
            strSQL = "CREATE USER " + representante.getTipoId() + representante.getIdRep() + " IDENTIFIED BY " + representante.getIdRep();
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.execute();
            strSQL = "GRANT R_REPVENTAS TO " + representante.getTipoId() + representante.getIdRep();
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.execute();
            prepStmt.close();
            locator.commit();
            mensaje.setMensaje(null);
        } catch (Exception e) {
            locator.rollback();
            mensaje.setMensaje(e.getLocalizedMessage());
            System.out.println(e);
        } finally {
            locator = null;
            return mensaje;
        }

    }

    public Representante obtenerRepresentante(String tipoId, String numeroId, Mensaje m) {
        int contador=0;
        Representante rep = new Representante();
        rep.setTipoId(tipoId.charAt(0));
        rep.setIdRep(numeroId);
        try {
            String strSQL = "select * from persona where K_TIPO_ID=? and K_NUMERO_ID=?";
            Connection conexion = locator.getConexion();
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            ResultSet resultado = prepStmt.executeQuery();
            while (resultado.next()) {
                rep.setNombre(resultado.getString(3));
                rep.setApellido(resultado.getString(4));
                rep.setDireccion(resultado.getString(5));
                rep.setCiudad(resultado.getString(6));
            }

            strSQL = "select * from rep_ventas where F_TIPO_ID=? and F_NUMERO_ID=?";

            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, tipoId);
            prepStmt.setString(2, numeroId);
            resultado = prepStmt.executeQuery();

            while (resultado.next()) {
                rep.setCorreo(resultado.getString(3));
                rep.setTelefono(resultado.getBigDecimal(4));
                rep.setGenero(resultado.getString(5));
                rep.setFechaContrato(resultado.getDate(6).toString());
                rep.setFechaNacimiento(resultado.getDate(7).toString());
                System.out.println(rep.getClasificacion());
                rep.setCaptadorId(resultado.getString(8));
                rep.setCaptadorTipo(resultado.getString(9));
                rep.setCodigoPostal(resultado.getString(10));
                contador++;
            }
            strSQL = "select c.k_id from clasificacion c,historico_clasificacion hc "
                    + "where c.k_id=hc.f_id_clasificacion and hc.f_num_id=? "
                    + "and hc.f_tipo_id=? and hc.d_fecha_inicial<=SYSDATE and hc.d_fecha_final>=sysdate";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, numeroId);
            prepStmt.setString(2, tipoId);
            resultado = prepStmt.executeQuery();
            if (resultado.next()) {
                rep.setClasificacion(resultado.getInt(1));
            }
            prepStmt.close();
            m.setMensaje(null);
        } catch (SQLException e) {
            System.out.println(e.getLocalizedMessage());
            m.setMensaje(e.getLocalizedMessage());
            return null;
        } finally {
            locator = null;
        }
        if(contador == 0){
            rep=null;
        }
        return rep;
    }
    
    public void setLocator(ServiceLocator locator){
        this.locator = locator;
    }
}
