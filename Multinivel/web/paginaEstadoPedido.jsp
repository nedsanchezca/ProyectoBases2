<%-- 
    Document   : newjsp
    Created on : 29/09/2019, 10:17:32 p. m.
    Author     : thrash
--%>

<%@page import="negocio.Pedido"%>
<%@page import="datos.PedidoDAO"%>
<%@page import="negocio.Cliente"%>
<%@page import="datos.ClienteDAO"%>
<%@page import="util.Mensaje"%>
<%@page import="util.ServiceLocator"%>
<%@page import="negocio.ProductoInventario"%>
<%@page import="datos.InventarioDAO"%>
<%@page import="negocio.Representante"%>
<%@page import="negocio.DetallePedido"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>NatAmE</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image/png" href="images/icons/favicon.ico" />
        <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
        <link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
        <link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
        <link rel="stylesheet" type="text/css" href="vendor/animsition/css/animsition.min.css">
        <link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
        <link rel="stylesheet" type="text/css" href="vendor/daterangepicker/daterangepicker.css">
        <link rel="stylesheet" type="text/css" href="css/util.css">
        <link rel="stylesheet" type="text/css" href="css/main.css">
        <link rel="stylesheet" type="text/css" href="css/estilo.css">
    </head>

    <body>
        <nav class="navbar navbar-expand-lg">
            <a class="navbar-brand" href="pagina_Lobby.jsp">NatAmE</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item ">
                        <a class="nav-link" href="formulario_Nuevo_Rep.html"> Ingresar Representante <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="formulario_Cliente.html"> Ingresar Cliente <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" href="formulario_Venta.jsp">Venta</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href = "paginaEstadoPedido.jsp">Estado pedido</a>
                    </li>
                    <li class="nav-item">
                        <form action=logout><input type="submit" class="nav-link" value="Salir"></form>
                    </li>
                </ul>
            </div>
        </nav>
        <div class="container">
            <h1 class="display-1">Estado de los pedidos</h1>
        </div>
        
        <p class="lead text-center">Pedidos sin pagar</p>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Pedido</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Estado</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Modificar</th>
                    <th scope="col">Cancelar</th>
                    <th scope="col">Pagar</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Representante rep = (Representante) request.getSession().getAttribute("rep");
                    Cliente cli = (Cliente) request.getSession().getAttribute("cli");
                    PedidoDAO dao = new PedidoDAO();
                    dao.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                    ClienteDAO dao1 = new ClienteDAO();
                    dao1.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                    ArrayList<Cliente> clientes = new ArrayList();
                    ArrayList<Pedido> pedidos = new ArrayList();
                    if (rep.getIdRep() != null) {
                        clientes = dao1.obtenerClientes(rep, new Mensaje());
                    }
                    if (cli.getIdCliente() != null) {
                        clientes.add(cli);
                    }
                    for (Cliente c : clientes) {
                        dao.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                        pedidos.addAll(dao.obtenerPedidos(c, "N", new Mensaje()));
                    }
                    int i = 0;
                    for (Pedido ped : pedidos) {
                        out.println("<tr>");
                        out.println("<th scope=\"row\">" + (i + 1) + "</th>");
                        out.println("<td>" + ped.getIdFactura() + "</td>");
                        out.println("<td>" + ped.getFecha() + "</td>");
                        out.println("<td>" + ped.getEstado() + "</td>");
                        out.println("<td>" + ped.getCliente().getNombre() + "</td>");
                        out.println("<td>");
                        out.println("<form action=modificacionPedido>");
                        out.println("<input type=\"hidden\" name=\"mod\" value=\"" + i + "\">");
                        out.println("<input type=\"submit\" value=\"Modificar\" class=\"btn btn-dark\">");
                        out.println("</form>");
                        out.println("</td>");
                        out.println("<td>");
                        out.println("<form action=cancelacionPedido>");
                        out.println("<input type=\"hidden\" name=\"can\" value=\"" + i + "\">");
                        out.println("<input type=\"image\" value=\"Cancelar\" class=\"btn btn-dark\">");
                        out.println("</form>");
                        out.println("</td>");
                        out.println("<td>");
                        out.println("<form action=pagoPedido>");
                        out.println("<input type=\"hidden\" name=\"pag\" value=\"" + ped.getIdFactura() + "\">");
                        out.println("<input type=\"image\" value=\"Pagar\" class=\"btn btn-dark\">");
                        out.println("</form>");
                        out.println("</td>");
                        out.println("</tr>");
                        i++;
                    }
                    request.getSession().setAttribute("arrPed", pedidos);
                %>
            </tbody>
        </table>

        <p class="lead text-center">Pedidos pagos sin calificar</p>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Pedido</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Estado</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Calificar</th>
                </tr>
            </thead>
            <tbody>
                <%
                    dao.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                    ArrayList<Pedido> pedidosCal = new ArrayList<Pedido>();
                    if(cli.getIdCliente() != null){
                        Mensaje e = new Mensaje();
                        pedidosCal.addAll(dao.obtenerPedidos(cli,"P", e));
                        out.println(e.getMensaje());
                    }
                    i = 0;
                    for (Pedido ped : pedidosCal) {
                        out.println("<tr>");
                        out.println("<th scope=\"row\">" + (i + 1) + "</th>");
                        out.println("<td>" + ped.getIdFactura() + "</td>");
                        out.println("<td>" + ped.getFecha() + "</td>");
                        out.println("<td>" + ped.getEstado() + "</td>");
                        out.println("<td>" + ped.getCliente().getNombre() + "</td>");
                        out.println("<td>");
                        out.println("<form action=calificar_Representante.jsp>");
                        out.println("<input type=\"hidden\" name=\"pedcal\" value=\"" + ped.getIdFactura() + "\">");
                        out.println("<input type=\"submit\" value=\"Calificar\" class=\"btn btn-dark\">");
                        out.println("</form>");
                        out.println("</td>");
                        out.println("</tr>");
                        i++;
                    }
                    request.getSession().setAttribute("arrPedCal", pedidosCal);
                %>
            </tbody>
        </table>
            
        <script src="vendor/jquery/jquery-3.2.1.min.js"></script>
        <script src="vendor/animsition/js/animsition.min.js"></script>
        <script src="vendor/bootstrap/js/popper.js"></script>
        <script src="vendor/bootstrap/js/bootstrap.min.js"></script>
        <script src="vendor/select2/select2.min.js"></script>
        <script src="vendor/daterangepicker/moment.min.js"></script>
        <script src="vendor/daterangepicker/daterangepicker.js"></script>
        <script src="vendor/countdowntime/countdowntime.js"></script>
        <script src="js/main.js"></script>
    </body>

</html>