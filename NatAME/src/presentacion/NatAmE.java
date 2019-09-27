/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
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
        ServiceLocator.getInstance().cambiarConexion(in.readLine(), in.readLine());
        Connection conexion = ServiceLocator.getInstance().tomarConexion();
        System.out.println("Ejecute una sentencia sql");
        PreparedStatement prepStmt=conexion.prepareStatement(in.readLine());
        ResultSet rs = prepStmt.executeQuery();
        rs.next();
        System.out.println(rs.getInt(1));
        ServiceLocator.getInstance().liberarConexion();
    }
    
}
