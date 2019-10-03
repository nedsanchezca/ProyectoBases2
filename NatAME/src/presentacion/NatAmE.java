/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import util.Mensaje;
import datos.RepresentanteDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.util.Date;
import negocio.Representante;
import util.ServiceLocator;

/**
 *
 * @author thrash
 */
public class NatAmE {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException, SQLException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        hola(in);
    }
    
    public static int hola(BufferedReader in){
        int a = 0;
        try{
            a = Integer.parseInt(in.readLine());
        }catch(Exception e){
            System.out.println("Holis");
            return 0;
        }finally{
            System.out.println("Entré al finally");
        }
        return a;
    }
    
}
