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
    /**
     * 
     * @param usr usuario que requiere autenticación
     * @param pass contraseña del usuario que requiere autenticación
     * @return 
     */
    public Mensaje autenticar(String usr,String pass){
        Mensaje ex = new Mensaje();
        //Toma y libera la conexión para verificar un usuario válido
        ServiceLocator service = new ServiceLocator(usr,pass,ex);
        return ex;
    }
}
