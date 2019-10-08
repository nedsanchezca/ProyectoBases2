/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentacion;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import negocio.DetallePedido;
import negocio.ProductoInventario;

/**
 *
 * @author thrash
 */
public class borradoProducto extends HttpServlet {

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
        
        //Se obtienen los arreglos con los detalles de productos hasta el momento
        ArrayList<DetallePedido> detalles = (ArrayList<DetallePedido>)request.getSession().getAttribute("det");
        ArrayList<ProductoInventario> productos = (ArrayList<ProductoInventario>)request.getSession().getAttribute("pro");
        
        //Se obtiene el número del detalle a borrar
        int borrado = Integer.parseInt(request.getParameter("borrar").substring(6));
        
        //Se remueve el detalle del arreglo
        detalles.remove(borrado-1);
        productos.remove(borrado-1);
        
        //Se guardan los nuevos arreglos
        request.getSession().setAttribute("det", detalles);
        request.getSession().setAttribute("pro", productos);
        
        //Se redirecciona al formulario de venta
        response.sendRedirect("/Multinivel/formulario_Venta.jsp");
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
