<%-- 
    Document   : newjsp
    Created on : 29/09/2019, 10:17:32 p. m.
    Author     : thrash
--%>

<%@page import="datos.PedidoDAO"%>
<%@page import="negocio.Pedido"%>
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
            <h1>Ingreso de pedido de productos</h1>
        </div>

        <form action=agregadoProducto>
            <div class="container">
                <div class="row" id = "header-ingreso-producto">
                    <div class = "column">
                        <h4>Código del producto</h4>
                    </div>
                    <div class="column">
                        <input type="text" name="codigo" required>
                    </div>
                    <div class="column">
                        <h4>Cantidad</h4>
                    </div>
                    <div class="column">
                        <input type="text" name="cantidad" required>
                    </div>
                    <div class="column">
                        <input type="submit" value="Agregar" class="btn btn-dark">
                    </div>    
                </div>
            </div>
        </form>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Codigo</th>
                    <th scope="col">Producto</th>
                    <th scope="col">Cantidad</th>
                    <th scope="col">Precio neto</th>
                    <th scope="col">Iva</th>
                    <th scope="col">Total</th>
                    <th scope="col">      </th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(request.getParameter("terminar")!=null){
                        request.getSession().setAttribute("pedido_actual", 0);
                        request.getSession().setAttribute("cliente_actual", null);
                    }
                    if((Integer)request.getSession().getAttribute("pedido_actual")!=0){
                        PedidoDAO objPedidoDAO = new PedidoDAO();
                        objPedidoDAO.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                        InventarioDAO objInventarioDAO = new InventarioDAO();
                        Pedido pedido = objPedidoDAO.obtenerPedidos((Integer)request.getSession().getAttribute("pedido_actual"), new Mensaje());
                        int i = 1;
                        for (DetallePedido deta : pedido.getItems()) { 
                            objInventarioDAO.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                            ProductoInventario prod = objInventarioDAO.obtenerProducto(deta.getProducto(), new Mensaje());
                            out.println("<tr>");
                            out.println("<th scope=\"row\">" + i + "</th>");
                            out.println("<td>" + deta.getProducto() + "</td>");
                            out.println("<td>" + prod.getNombreProducto() + "</td>");
                            out.println("<td>" + deta.getCantidad() + "</td>");
                            out.println("<td>" + deta.getCantidad() * prod.getPrecio() + "</td>");
                            out.println("<td>" + prod.getIva() + "</td>");
                            out.println("<td>" + deta.getCantidad() * prod.getPrecio() * (1 + prod.getIva() / 100) + "</td>");
                            out.println("<td><form action = borradoProducto>");
                            out.println("<input type=\"hidden\" name=\"borrar\" value=\"" + deta.getProducto() + "\" class=\"btn btn-dark\">");
                            out.println("<input type=\"submit\" name=\"borrarb\" value=\"Borrar\" class=\"btn btn-dark\">");
                            out.println("</form></td>");
                            out.println("</tr>");
                            i++;
                        }
                    }
                %>
            </tbody>
            <tfoot>
            <th scope="col">Total</th>
            <th scope="col"> $ 0.00</th>
        </tfoot>
    </table>
    <form action=clienteSeleccionado>
    <div class="form-group">
            <%;
            if(((Cliente)request.getSession().getAttribute("cliente_actual"))==null){
                ClienteDAO dao1 = new ClienteDAO();
                ArrayList<Cliente> clientes = new ArrayList();
                Representante rep = (Representante) request.getSession().getAttribute("rep");
                Cliente cli = (Cliente) request.getSession().getAttribute("cli");
                dao1.setLocator((ServiceLocator)request.getSession().getAttribute("conexion"));
                int i=0;
                if(cli.getNombre() != null){
                    clientes.add(cli);
                }
                clientes.addAll(dao1.obtenerClientes(rep, new Mensaje()));
                out.println("<label for=\"K_TIPO_ID\">Cliente: </label>");
                out.println("<select class=\"form-control\" id=\"cliente\" name=\"cliente\">");
                for(Cliente c: clientes){
                    out.println("<option value=\""+i+"\">"+c.getTipoId()+c.getIdCliente()+" "+c.getNombre()+"</option>");
                    i++;
                }
                out.println("</select>");
                out.println("<input type=\"submit\" value = \"Crear Pedido\" class=\"btn btn-dark\">");
                request.getSession().setAttribute("aclientes", clientes);
            }
            %>        
    </div>
    </form>
    <%if(((Cliente)request.getSession().getAttribute("cliente_actual"))!=null){%>
    <form>
        <input type="submit" name = "terminar" value = "Terminar" class="btn btn-dark">
    </form>
    <%}%>
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
