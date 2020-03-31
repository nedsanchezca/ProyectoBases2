/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import datos.ClienteDAO;
import datos.RepresentanteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import negocio.Cliente;
import negocio.Representante;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author Manuel Bernal
 */
public class registroCliente extends HttpServlet {

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
        
        //Rep ventas logueado
        Representante rep = (Representante)request.getSession().getAttribute("rep");
        ClienteDAO cliD = new ClienteDAO();
        cliD.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
        //Obtener valores del formulario
        Cliente clienteI = new Cliente();
        clienteI.setTipoId(request.getParameter("K_TIPO_ID").charAt(0));
        clienteI.setIdCliente(request.getParameter("K_NUMERO_ID"));
        clienteI.setApellido(request.getParameter("N_APELLIDO"));
        clienteI.setNombre(request.getParameter("N_NOMBRE"));
        clienteI.setCiudad(request.getParameter("C_CIUDAD"));
        clienteI.setDireccion(request.getParameter("A_DIRECCION"));
        clienteI.setCorreo(request.getParameter("E_CORREO"));
        clienteI.setTelefono(new BigDecimal(request.getParameter("TEL")));
        
        if(rep.getIdRep()!=null){
            clienteI.setIdRep(rep.getIdRep());
            clienteI.setTipoIdRep(Character.toString(rep.getTipoId()));
        }
        Mensaje ex = new Mensaje();
        cliD.incluirCliente(clienteI, ex);
        
        if(ex.getMensaje()==null){
            request.getSession().setAttribute("rep", rep);
            response.sendRedirect("/Multinivel/formulario_Nuevo_Rep.html");
        }else{
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
