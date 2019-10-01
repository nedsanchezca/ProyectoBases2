/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import datos.AutenticacionDAO;
import datos.RepresentanteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import negocio.Representante;

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
        String usr = request.getParameter("email");
        String pass = request.getParameter("pass");
        AutenticacionDAO dao = new AutenticacionDAO();
        RepresentanteDAO repD = new RepresentanteDAO(usr,pass);
        Representante rep = repD.obtenerRepresentante(usr.substring(0, 1), usr.substring(1));
        rep.setPass(pass);
        System.out.print(usr.substring(0, 1)+" "+usr.substring(1));
        SQLException ex= dao.autenticar(usr, pass);
        if(ex==null){
            request.getSession().setAttribute("rep", rep);
            response.sendRedirect("/Multinivel/pagina_Lobby.jsp");
        }else{
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<meta http-equiv='refresh' content='3;URL=login.html'>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Servlet testing</title>");            
                out.println("</head>");
                out.println("<body>");
                out.println("<h1>Servlet testing at " + ex+ "</h1>");
                out.println("</body>");
                out.println("</html>");
            }
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
