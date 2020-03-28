package datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import negocio.Representante;
import util.Mensaje;
import util.ServiceLocator;

/**
 * Clase para operar datos sobre representantes de ventas
 * en la base de datos
 * 
 * @author thrash
 */
public class RepresentanteDAO {

    ServiceLocator locator;
            
    public RepresentanteDAO() {
    }
    
    /**
     * Incluye un nuevo representante en la base de datos y crea un usuario
     * en la base de datos para el mismo
     *
     * @param representante objeto con los datos del representanta a almacenar
     * @return un Mensaje de error solo en caso de error, null en otro caso
     */
    public Mensaje incluirRepresentante(Representante representante) {
        Mensaje mensaje = new Mensaje();
        Connection conexion = locator.getConexion();
        try {
            /*Se evalúa la sentencia SQL para determinar si ya hay una persona
            con esta identificación.*/
            String strSQL = "SELECT COUNT(*) "
                          + "FROM PERSONA "
                          + "WHERE K_NUMERO_ID=? "
                          + "AND K_TIPO_ID=?";
            PreparedStatement prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            ResultSet resultado = prepStmt.executeQuery();
            resultado.next();
            
            /*Si no hay ninguna persona registrada con esta identificación
            se agrega*/
            if (resultado.getInt(1) == 0) {
                strSQL = "INSERT INTO PERSONA VALUES(?,?,?,?,?,?)";
                prepStmt = conexion.prepareStatement(strSQL);
                prepStmt.setString(1, representante.getIdRep());
                prepStmt.setString(2, Character.toString(representante.getTipoId()));
                prepStmt.setString(3, representante.getNombre());
                prepStmt.setString(4, representante.getApellido());
                prepStmt.setString(5, representante.getDireccion());
                prepStmt.setString(6, representante.getCiudad());
                prepStmt.executeUpdate();
            }

            /*Ingresa los datos del nuevo representante de ventas*/
            strSQL = "INSERT INTO rep_ventas VALUES(?,?,?,?,?,sysdate,?,?,?,?)";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            prepStmt.setString(3, representante.getCorreo());
            prepStmt.setBigDecimal(4, representante.getTelefono());
            prepStmt.setString(5, representante.getGenero());
            prepStmt.setDate(6, java.sql.Date.valueOf(representante.getFechaNacimiento()));
            prepStmt.setString(7, representante.getCaptadorId());
            prepStmt.setString(8, representante.getCaptadorTipo());
            prepStmt.setString(9, representante.getCodigoPostal());
            prepStmt.executeUpdate();
            
            /*Agrega una entrada en el histórico de clasificación con la
            clasificación beginner (1) durante 1 mes*/
            strSQL = "INSERT INTO HISTORICO_CLASIFICACION "
                   + "VALUES("
                   + "NATAME.PEDIDO_SEQ.NEXTVAL,"
                   + "SYSDATE,SYSDATE + numtoyminterval(1, 'MONTH')-1,"
                   + "?,?,1)";
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.setString(1, representante.getIdRep());
            prepStmt.setString(2, Character.toString(representante.getTipoId()));
            prepStmt.executeUpdate();
            
            /*Crea un usuario en la base de datos para el nuevo representante*/
            strSQL = "CREATE USER " + representante.getTipoId() + representante.getIdRep() 
                   + " IDENTIFIED BY " + representante.getIdRep();
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.execute();
            
            /*Asigna el rol de repventas al nuevo*/
            strSQL = "GRANT R_REPVENTAS TO " + representante.getTipoId() + representante.getIdRep();
            prepStmt = conexion.prepareStatement(strSQL);
            prepStmt.execute();
            
            /*Cierra y hace efectivos los cambios*/
            prepStmt.close();
            locator.commit();
            mensaje.setMensaje(null);
        } catch (SQLException e) {
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
                rep.setCaptadorId(resultado.getString(8));
                rep.setCaptadorTipo(resultado.getString(9));
                rep.setCodigoPostal(resultado.getString(10));
                contador++;
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
