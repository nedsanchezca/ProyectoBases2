/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

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
        RepresentanteDAO dao = new RepresentanteDAO("C1070983623","contra");
        Representante rep = dao.obtenerRepresentante("C", "1070983623");
        System.out.println(Character.toString(rep.getTipoId())+rep.getIdRep());
    }
    
}
