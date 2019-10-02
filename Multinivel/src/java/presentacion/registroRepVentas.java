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
import java.math.BigDecimal;
import java.util.Date;
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
public class registroRepVentas extends HttpServlet {

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
        Representante rep = (Representante)request.getSession().getAttribute("rep");
        System.out.println(rep.getPass()+"lalalalaa");
        System.out.print(rep.getPass());
        Representante repI = new Representante();
        RepresentanteDAO repD = new RepresentanteDAO(Character.toString(rep.getTipoId())+rep.getIdRep(),rep.getPass());
        
        Date fecha = new Date();
        repI.setTipoId(request.getParameter("K_TIPO_ID").charAt(0));
        repI.setIdRep(request.getParameter("K_NUMERO_ID"));
        repI.setApellido(request.getParameter("N_APELLIDO"));
        repI.setNombre(request.getParameter("N_NOMBRE"));
        repI.setCiudad(request.getParameter("C_CIUDAD"));
        repI.setCorreo(request.getParameter("E_CORREO"));
        repI.setGenero(request.getParameter("I_GENERO").substring(0, 1));
        repI.setTelefono(new BigDecimal(request.getParameter("TEL")));
        repI.setFechaNacimiento(request.getParameter("D_FECHA_NACIMIENTO"));
        repI.setFechaContrato(fecha.getYear()+"-"+fecha.getMonth()+"-"+fecha.getDay());
        repI.setDireccion(request.getParameter("A_DIRECCION"));
        repI.setCodigoPostal(rep.getCodigoPostal());
        repI.setCaptadorId(rep.getIdRep());
        repI.setCaptadorTipo(Character.toString(rep.getTipoId()));
        repI.setClasificacion(1);
        SQLException ex = repD.incluirRepresentante(repI);
        if(ex==null){
            request.getSession().setAttribute("rep", rep);
            response.sendRedirect("/Multinivel/formulario_Nuevo_Rep.html");
        }else{
            try (PrintWriter out = response.getWriter()) {
                /* TODO output your page here. You may use following sample code. */
                out.println("<meta http-equiv='refresh' content='3;URL=pagina_Lobby.jsp'>");
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
