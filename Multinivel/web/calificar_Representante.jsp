<%-- 
    Document   : newjsp
    Created on : 29/09/2019, 10:17:32 p. m.
    Author     : thrash
--%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Calificar Representante</title>
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
        <button class="navbar-toggler toggler-example" type="button" data-toggle="collapse" data-target="#navbarNatame"
        aria-controls="navbarNatame" aria-expanded="false" aria-label="Toggle navigation">
            <span class="dark-blue-text">
                <i class="fas fa-bars fa-1x">

                </i>
            </span>
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

    <div class="limiter">
        <section class="container">
            <h3 class="text-uppercase text-center">Calificación del representante de ventas. </h3>
            <p class="lead text-center">Diligencie la siguiente información para evaluar a su representante de ventas</p>
            <form action=calificarRepVentas class="">
                <%out.println("<input type=\"hidden\" name = \"pedcal\" value = \""+request.getParameter("pedcal")+"\">");%>
                <div class="form-group">
                    <label for="V_VALORACION">Calificación </label>
                    <select class="form-control" id="K_TIPO_ID" name="V_VALORACION">
                        <option value="5">5</option>
                        <option value="4">4</option>
                        <option value="3">3</option>
                        <option value="2">2</option>
                        <option value="1">1</option>
                        <option value="0">0</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="K_NUMERO_ID"> Recomendación </label>
                    <input class="form-control" name="N_COMENTARIO" type="text" placeholder="Comentario">
                </div>

                <button class="btn btn-primary">Registrar</button>
            </form>
        </section>
    </div>
</body>
</html>