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
import negocio.DetallePedido;
import negocio.Pedido;
import util.Mensaje;

/**
 *
 * @author thrash
 */
public class modificacionPedido extends HttpServlet {

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
        ArrayList<DetallePedido> detalles = (ArrayList<DetallePedido>)request.getSession().getAttribute("det");
        Pedido pedido = (Pedido)request.getSession().getAttribute("pedidoMod");
        pedido.setItems(detalles);
        PedidoDAO dao = new PedidoDAO((String)request.getSession().getAttribute("usr"),(String)request.getSession().getAttribute("pass"));
        dao.modificarPedido(pedido,ex);
        if(ex.getMensaje()==null){
            request.getSession().setAttribute("det", null);
            request.getSession().setAttribute("pro", null);
            request.getSession().setAttribute("arrPed", null);
            request.getSession().setAttribute("modificado", false);
            response.sendRedirect("/Multinivel/formulario_Venta.jsp");
        }else{
            try (PrintWriter out = response.getWriter()) {
                out.println("<meta http-equiv='refresh' content='3;URL=formulario_Venta.jsp'>");
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
