<%-- 
    Document   : newjsp
    Created on : 29/09/2019, 10:17:32 p. m.
    Author     : thrash
--%>

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

    </head>
    <style type="text/css">
        .navbar {
            background-color: #373846;
        }

        .navbar .navbar-brand {
            color: #050505;
        }

        .navbar .navbar-brand:hover,
        .navbar .navbar-brand:focus {
            color: #744ba2;
        }

        .navbar .navbar-text {
            color: #050505;
        }

        .navbar .navbar-nav .nav-link {
            color: #050505;
            border-radius: .25rem;
            margin: 0 0.25em;
        }

        .navbar .navbar-nav .nav-link:not(.disabled):hover,
        .navbar .navbar-nav .nav-link:not(.disabled):focus {
            color: #744ba2;
        }

        .navbar .navbar-nav .nav-item.active .nav-link,
        .navbar .navbar-nav .nav-item.active .nav-link:hover,
        .navbar .navbar-nav .nav-item.active .nav-link:focus,
        .navbar .navbar-nav .nav-item.show .nav-link,
        .navbar .navbar-nav .nav-item.show .nav-link:hover,
        .navbar .navbar-nav .nav-item.show .nav-link:focus {
            color: #744ba2;
            background-color: #b390c2;
        }

        .navbar .navbar-toggle {
            border-color: #b390c2;
        }

        .navbar .navbar-toggle:hover,
        .navbar .navbar-toggle:focus {
            background-color: #b390c2;
        }

        .navbar .navbar-toggle .navbar-toggler-icon {
            color: #050505;
        }

        .navbar .navbar-collapse,
        .navbar .navbar-form {
            border-color: #050505;
        }

        .navbar .navbar-link {
            color: #050505;
        }

        .navbar .navbar-link:hover {
            color: #744ba2;
        }

        @media (max-width: 575px) {
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #050505;
            }

            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #744ba2;
            }

            .navbar-expand-sm .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #744ba2;
                background-color: #b390c2;
            }
        }

        @media (max-width: 767px) {
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #050505;
            }

            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #744ba2;
            }

            .navbar-expand-md .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #744ba2;
                background-color: #b390c2;
            }
        }

        @media (max-width: 991px) {
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #050505;
            }

            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #744ba2;
            }

            .navbar-expand-lg .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #744ba2;
                background-color: #b390c2;
            }
        }

        @media (max-width: 1199px) {
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item {
                color: #050505;
            }

            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item:hover,
            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item:focus {
                color: #744ba2;
            }

            .navbar-expand-xl .navbar-nav .show .dropdown-menu .dropdown-item.active {
                color: #744ba2;
                background-color: #b390c2;
            }
        }

        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item {
            color: #050505;
        }

        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item:hover,
        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item:focus {
            color: #744ba2;
        }

        .navbar-expand .navbar-nav .show .dropdown-menu .dropdown-item.active {
            color: #744ba2;
            background-color: #b390c2;
        }

    </style>

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
                        <a class="nav-link" href="#">Estadisticas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" href="formulario_Venta.jsp">Venta</a>
                    </li>
                </ul>
            </div>
        </nav>
        <div class="container">
            <h1>Ingreso de pedido de productos</h1>
        </div>

        <form>
            <div class="container">
                <div class="row" id = "header-ingreso-producto">
                    <div class = "column">
                        <h3>Código del producto</h3>
                    </div>
                    <div class="column">
                        <input type="text" name="codigo">
                    </div>
                    <div class="column">
                        <h3>Cantidad</h3>
                    </div>
                    <div class="column">
                        <input type="text" name="cantidad">
                    </div>
                    <div class="column">
                        <h3>Region</h3>
                    </div>
                    <div class="column">
                        <input type="text" name="region">
                    </div>
                    <div class="column">
                        <input type="submit" value="Agregar" class="btn btn-dark">
                    </div>    
                </div>
            </div>
        </form>

        <table class="table">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Codigo</th>
                    <th scope="col">Producto</th>
                    <th scope="col">Cantidad</th>
                    <th scope="col">Precio neto</th>
                    <th scope="col">Iva</th>
                    <th scope="col">Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Representante rep = (Representante) request.getSession().getAttribute("rep");
                    InventarioDAO inv = new InventarioDAO(rep.getTipoId() + rep.getIdRep(), rep.getPass());
                    ArrayList<DetallePedido> arr = (ArrayList<DetallePedido>) request.getSession().getAttribute("det");
                    ArrayList<ProductoInventario> prod = (ArrayList<ProductoInventario>) request.getSession().getAttribute("pro");
                    if (arr == null) {
                        arr = new ArrayList<DetallePedido>();
                        prod = new ArrayList<ProductoInventario>();
                    }
                    int cantidad = 0;
                    int codigo = 0;

                    Mensaje ex = new Mensaje();
                    ProductoInventario producto = null;
                    try {
                        cantidad = Integer.parseInt(request.getParameter("cantidad"));
                        codigo = Integer.parseInt(request.getParameter("codigo"));
                        producto = inv.obtenerProducto(codigo, ex);
                    } catch (NumberFormatException e) {

                    }

                    if (producto != null) {
                        prod.add(producto);
                        DetallePedido detalle = new DetallePedido();
                        detalle.setCantidad(cantidad);
                        detalle.setProducto(codigo);
                        arr.add(detalle);
                    }
                    
                    request.getSession().setAttribute("det", arr);
                    request.getSession().setAttribute("pro", prod);
                    int i = 1;
                    for (DetallePedido deta : arr) {
                        deta.setItem(i);
                        out.println("<tr>");
                        out.println("<th scope=\"row\">" + i + "</th>");
                        out.println("<td>" + deta.getProducto() + "</td>");
                        out.println("<td>" + prod.get(i - 1).getNombreProducto() + "</td>");
                        out.println("<td>" + deta.getCantidad() + "</td>");
                        out.println("<td>" + deta.getCantidad() * prod.get(i - 1).getPrecio() + "</td>");
                        out.println("<td>" + prod.get(i - 1).getIva() + "</td>");
                        out.println("<td>" + deta.getCantidad() * prod.get(i - 1).getPrecio() * (1 + prod.get(i - 1).getIva() / 100) + "</td>");
                        out.println("<td><form action = borradoProducto><input type=\"submit\" name=\"borrar\" value = \"borrar" + i + "\" class=\"btn btn-dark\"></form></td>");
                        out.println("</tr>");
                        i++;
                    }

                %>
            </tbody>
            <tfoot>
            <th scope="col">Total</th>
            <th scope="col"> $ 0.00</th>
        </tfoot>
    </table>
    <form action=registroPedido>
    <div class="form-group">
        <label for="K_TIPO_ID">Cliente: </label>
        <select class="form-control" id="cliente" name="cliente">
            <%;
            ClienteDAO dao1 = new ClienteDAO(rep.getTipoId() + rep.getIdRep(), rep.getPass());
            ArrayList<Cliente> clientes = dao1.obtenerClientes(rep, new Mensaje());
            i=0;
            for(Cliente c:clientes){
                out.println("<option value=\""+i+"\">"+c.getTipoId()+c.getIdCliente()+" "+c.getNombre()+"</option>");
                i++;
            }
            request.getSession().setAttribute("aclientes", clientes);
            %>
        </select>
    </div>
        <input type="submit" value = "enviar" class="btn btn-dark">
    </form>
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