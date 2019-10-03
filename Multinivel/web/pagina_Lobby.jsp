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

    body {
        background: #F1F3FA;
    }

    /* Profile container */
    .profile {
        margin: 20px 0;
    }

    /* Profile sidebar */
    .profile-sidebar {
        padding: 20px 0 10px 0;
        background: #fff;
    }

    .profile-userpic img {
        float: none;
        margin: 0 auto;
        width: 50%;
        height: 50%;
        -webkit-border-radius: 50% !important;
        -moz-border-radius: 50% !important;
        border-radius: 50% !important;
    }

    .profile-usertitle {
        text-align: center;
        margin-top: 20px;
    }

    .profile-usertitle-name {
        color: #5a7391;
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 7px;
    }

    .profile-usertitle-job {
        text-transform: uppercase;
        color: #5b9bd1;
        font-size: 12px;
        font-weight: 600;
        margin-bottom: 15px;
    }

    .profile-userbuttons {
        text-align: center;
        margin-top: 10px;
    }

    .profile-userbuttons .btn {
        text-transform: uppercase;
        font-size: 11px;
        font-weight: 600;
        padding: 6px 15px;
        margin-right: 5px;
    }

    .profile-userbuttons .btn:last-child {
        margin-right: 0px;
    }

    .profile-usermenu {
        margin-top: 30px;
    }

    .profile-usermenu ul li {
        border-bottom: 1px solid #f0f4f7;
    }

    .profile-usermenu ul li:last-child {
        border-bottom: none;
    }

    .profile-usermenu ul li a {
        color: #93a3b5;
        font-size: 14px;
        font-weight: 400;
    }

    .profile-usermenu ul li a i {
        margin-right: 8px;
        font-size: 14px;
    }

    .profile-usermenu ul li a:hover {
        background-color: #fafcfd;
        color: #5b9bd1;
    }

    .profile-usermenu ul li.active {
        border-bottom: none;
    }

    .profile-usermenu ul li.active a {
        color: #5b9bd1;
        background-color: #f6f9fb;
        border-left: 2px solid #5b9bd1;
        margin-left: -2px;
    }

    /* Profile Content */
    .profile-content {
        padding: 20px;
        background: #fff;
        min-height: 460px;
    }
</style>

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
                              System.out.println(cli+"fdsaf");
                              Clasificacion cla = (Clasificacion)request.getSession().getAttribute("cla");
                              String nombre="";
                              String clasificacion="";
                              if(rep!=null&&cli!=null){
                                  nombre = rep.getNombre();
                                  clasificacion = "Rep:"+cla.getNombre()+" & Cliente";
                              }else if(rep!=null){
                                  nombre = rep.getNombre();
                                  clasificacion = "Rep:"+cla.getNombre();
                              }else if(cli!=null){
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
                                    <i class="glyphicon glyphicon-home"></i>
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
                <div class="profile-content">
                    Contenido a futuro
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