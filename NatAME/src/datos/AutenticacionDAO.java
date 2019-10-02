/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import java.sql.SQLException;
import util.ServiceLocator;

/**
 *
 * @author Nestor
 */
public class AutenticacionDAO {
    public SQLException autenticar(String usr,String pass){
        SQLException ex;
        ServiceLocator.getInstance().tomarConexion();
        ex = ServiceLocator.getInstance().cambiarConexion(usr, pass);
        ServiceLocator.getInstance().restaurarConexion();
        ServiceLocator.getInstance().liberarConexion();
        return ex;
    }
}
