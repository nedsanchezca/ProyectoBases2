<%-- 
    Document   : newjsp
    Created on : 30-sep-2019, 15:09:12
    Author     : Nestor
--%>

<%@page import="negocio.Clasificacion"%>
<%@page import="negocio.Cliente"%>
<%@page import="negocio.Representante"%>
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
        <a class="navbar-brand" href="#">NatAmE</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item ">
                    <a class="nav-link" href="formulario_Nuevo_Rep.html"> Ingresar Representante <span
                            class="sr-only">(current)</span></a>
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
        <div class="row profile">
            <div class="col-md-3">
                <div class="profile-sidebar">
                    <div class="profile-userpic">
                        <img src="" class="img-responsive" alt="">
                    </div>
                    <div class="profile-usertitle">
                        <div class="profile-usertitle-name">
                            <%Representante rep = (Representante)request.getSession().getAttribute("rep");
                              Cliente cli = (Cliente)request.getSession().getAttribute("cli");
                              Clasificacion cla = (Clasificacion)request.getSession().getAttribute("cla");
                              String nombre="";
                              String clasificacion="";
                              if(rep.getIdRep()!=null&&cli.getIdCliente()!=null){
                                  nombre = rep.getNombre();
                                  clasificacion = "Rep:"+cla.getNombre()+" & Cliente";
                              }else if(rep.getIdRep()!=null){
                                  nombre = rep.getNombre();
                                  clasificacion = "Rep:"+cla.getNombre();
                              }else if(cli.getIdCliente()!=null){
                                  nombre = cli.getNombre();
                                  clasificacion = "Cliente";
                              }
                           out.println(nombre);%>
                        </div>
                        <div class="profile-usertitle-job">
                            <%out.println(clasificacion);%>
                        </div>
                    </div>
                    <div class="profile-userbuttons">
                        <button type="button" class="btn btn-success btn-sm">Cartera</button>
                        <button type="button" class="btn btn-danger btn-sm">Catalogo</button>
                    </div>
                    <div class="profile-usermenu">
                        <ul class="nav">
                            <li class="active">
                                <a href="#">
                                    <i class="zmdi zmdi-card-travelt"></i>
                                    Cambiar datos </a>
                            </li>
                            
                            <li>
                                <a href="#">
                                    <i class="glyphicon glyphicon-flag"></i>
                                    Ayuda </a>
                            </li>
                        </ul>
                    </div>
                    <!-- END MENU -->
                </div>
            </div>
                <div class="col-md-9">
                    <div class="card-deck">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Productos del mes</h5>
                                <p class="card-text">Trapero: $15.000</p>
                                <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Cliente con mas pedidos</h5>
                                <p class="card-text">El cliente con mas pedidos</p>
                                <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Venta acumulada</h5>
                                <p class="card-text">Hasta el momento llevamos valiendo muchas hectareas</p>
                                <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <br>
    <br>

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