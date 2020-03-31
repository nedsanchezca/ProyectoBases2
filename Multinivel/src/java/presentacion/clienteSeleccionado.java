/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import datos.PedidoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import negocio.Cliente;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author Manuel Bernal
 */
public class clienteSeleccionado extends HttpServlet {

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
        ArrayList<Cliente> aClientes = (ArrayList<Cliente>)request.getSession().getAttribute("aclientes");
        request.getSession().setAttribute("cliente_actual", aClientes.get(Integer.parseInt(request.getParameter("cliente"))));
        PedidoDAO dao = new PedidoDAO();
        Mensaje ex = new Mensaje();
        dao.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
        int id = dao.registrarPedido(aClientes.get(Integer.parseInt(request.getParameter("cliente"))), ex);
        if(ex.getMensaje()==null){
            request.getSession().setAttribute("cliente_actual", aClientes.get(Integer.parseInt(request.getParameter("cliente"))));
            request.getSession().setAttribute("pedido_actual",id);
            response.sendRedirect("/Multinivel/formulario_Venta.jsp");
        }else{
            request.getSession().setAttribute("anterior", "formulario_Venta.jsp");
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
