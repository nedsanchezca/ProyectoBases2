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
                </tr>
            </thead>
            <tbody>
                <%
                    Representante rep = (Representante) request.getSession().getAttribute("rep");
                    Cliente cli = (Cliente) request.getSession().getAttribute("cli");
                    PedidoDAO dao = new PedidoDAO((String) request.getSession().getAttribute("usr"), (String) request.getSession().getAttribute("pass"));
                    ClienteDAO dao1 = new ClienteDAO((String) request.getSession().getAttribute("usr"), (String) request.getSession().getAttribute("pass"));
                    ArrayList<Cliente> clientes = new ArrayList<Cliente>();
                    ArrayList<Pedido> pedidos = new ArrayList<Pedido>();
                    if (rep.getIdRep() != null) {
                        clientes = dao1.obtenerClientes(rep, new Mensaje());
                    }
                    if (cli.getIdCliente() != null) {
                        clientes.add(cli);
                    }
                    for (Cliente c : clientes) {
                        pedidos.addAll(dao.obtenerPedidos(c, "N", new Mensaje()));
                    }
                    int i = 0;
                    for (Pedido ped : pedidos) {
                        System.out.println("Llegué al for de muestra");
                        out.println("<tr>");
                        out.println("<th scope=\"row\">" + (i + 1) + "</th>");
                        out.println("<td>" + ped.getIdFactura() + "</td>");
                        out.println("<td>" + ped.getFecha() + "</td>");
                        out.println("<td>" + ped.getEstado() + "</td>");
                        out.println("<td>" + ped.getCliente().getNombre() + "</td>");
                        out.println("<td>");
                        out.println("<form action=\"formulario_Venta.jsp\">");
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
                        out.println("</tr>");
                        i++;
                    }
                    request.getSession().setAttribute("arrPed", pedidos);
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