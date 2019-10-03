/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package datos;

import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author Nestor
 */
public class AutenticacionDAO {
    public Mensaje autenticar(String usr,String pass){
        Mensaje ex = new Mensaje();
        ServiceLocator.getInstance().tomarConexion(usr,pass,ex);
        ServiceLocator.getInstance().liberarConexion();
        return ex;
    }
}
