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
import negocio.Pedido;
import util.Mensaje;
import util.ServiceLocator;

/**
 *
 * @author Manuel Bernal
 */
public class pagoPedido extends HttpServlet {

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
        Mensaje ex = new Mensaje();
        PedidoDAO pedDAO = new PedidoDAO();
        pedDAO.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
        double monto = pedDAO.totalPedido(Integer.parseInt(request.getParameter("pag")), new Mensaje());
        pedDAO.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
        pedDAO.pagarPedido(Integer.parseInt(request.getParameter("pag")),Integer.parseInt(request.getParameter("N_COMENTARIO")),monto);
        pedDAO.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
        pedDAO.generarFactura(Integer.parseInt(request.getParameter("pag")), new Mensaje());
        response.sendRedirect("/Multinivel/paginaEstadoPedido.jsp");
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
