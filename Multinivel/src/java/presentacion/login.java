/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import datos.AutenticacionDAO;
import datos.ClasificacionDAO;
import datos.ClienteDAO;
import datos.RepresentanteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import negocio.Clasificacion;
import negocio.Cliente;
import negocio.Representante;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author Nestor
 */
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        //Obtener las entradas del formulario
        String usr = request.getParameter("email");
        String pass = request.getParameter("pass");
        Mensaje ex;
        
        //Autenticar al usuario
        AutenticacionDAO dao = new AutenticacionDAO();
        ex = dao.autenticar(usr, pass);

        if(ex.getMensaje()==null){
            //Obtener datos del usuario autenticado
            ServiceLocator locator = new ServiceLocator(usr,pass,ex);
            RepresentanteDAO repD = new RepresentanteDAO();
            
            repD.setLocator(locator);
            ClienteDAO cliD = new ClienteDAO();
            cliD.setLocator(locator);
            ClasificacionDAO claD = new ClasificacionDAO();
            claD.setLocator(locator);
            Clasificacion cla = null;
            
            Representante rep = repD.obtenerRepresentante(usr.substring(0, 1), usr.substring(1),ex);
            Cliente cli = cliD.obtenerCliente(usr.substring(0, 1), usr.substring(1),ex);
            
            if(rep!=null){
                cla = claD.obtenerClasificacion(rep, ex);
            }else{
                rep = new Representante();
            }
            
            if(cli ==null){
                cli = new Cliente();
            }

            request.getSession().setAttribute("rep", rep);
            request.getSession().setAttribute("cli", cli);
            request.getSession().setAttribute("usr", usr);
            request.getSession().setAttribute("pass", pass);
            request.getSession().setAttribute("cla", cla);
            request.getSession().setAttribute("conexion", locator);
            request.getSession().setAttribute("pedido_actual", 0);
            response.sendRedirect("/Multinivel/pagina_Lobby.jsp");
        }else{
            request.getSession().setAttribute("anterior", "login.html");
            request.getSession().setAttribute("mensajeError", ex);
            response.sendRedirect("/Multinivel/pagina_Error.jsp");
        }
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
