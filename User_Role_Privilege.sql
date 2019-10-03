-- Estando conectados a System
CREATE USER natame IDENTIFIED BY natame;
GRANT DBA TO natame; -- Otorgamos todos los permisos a AdminBD
CONN natame/natame --Conectar al Admin de la BD para crear usuarios dentro de este

-- Estando conectados a AdminDB
-- Inicio Creación de Roles y asignación de privilegios a dichos roles
CREATE ROLE r_adminAP;
GRANT CONNECT TO r_adminAP;
GRANT CREATE USER TO r_adminAP;
GRANT CREATE VIEW TO  r_adminAP;
GRANT CREATE SYNONYM TO r_adminAP;
GRANT DROP ANY SYNONYM TO r_adminAP;
GRANT CREATE ROLLBACK SEGMENT TO r_adminAP;

CREATE ROLE r_RepVentasMaster;
GRANT CONNECT TO r_RepVentasMaster;
GRANT SELECT ON natame."region" TO r_RepVentasMaster;
GRANT SELECT ON natame."categoria" TO r_RepVentasMaster;
GRANT SELECT ON natame."subcategoria" TO r_RepVentasMaster;
GRANT SELECT ON natame."producto" TO r_RepVentasMaster;
GRANT SELECT ON natame."pedido" TO r_RepVentasMaster;
GRANT SELECT ON natame."detalle_pedido" TO r_RepVentasMaster;
GRANT SELECT ON natame."calificacion" TO r_RepVentasMaster;
GRANT INSERT ON natame."persona" TO r_RepVentasMaster;
GRANT INSERT ON natame."cliente" TO r_RepVentasMaster;
GRANT INSERT ON natame."rep_ventas" TO r_RepVentasMaster;

CREATE ROLE r_RepVentas;
GRANT CONNECT TO r_RepVentas;
GRANT SELECT ON natame."region" TO r_RepVentas;
GRANT SELECT ON natame."categoria" TO r_RepVentas;
GRANT SELECT ON natame."subcategoria" TO r_RepVentas;
GRANT SELECT ON natame."producto" TO r_RepVentas;
GRANT SELECT ON natame."pedido" TO r_RepVentas;
GRANT SELECT ON natame."detalle_pedido" TO r_RepVentas;
GRANT SELECT ON natame."calificacion" TO r_RepVentas;
GRANT INSERT ON natame."persona" TO r_RepVentas;
GRANT INSERT ON natame."cliente" TO r_RepVentas;
GRANT UPDATE (v_disponibilidad) ON natame."inventario" TO r_RepVentas;

CREATE ROLE r_cliente;
GRANT CONNECT TO r_cliente;
GRANT SELECT ON natame."region" TO r_cliente;
GRANT SELECT ON natame."categoria" TO r_cliente; 
GRANT SELECT ON natame."subcategoria" TO r_cliente; 
GRANT SELECT ON natame."producto" TO r_cliente;
GRANT UPDATE (v_disponibilidad) ON natame."inventario" TO r_cliente;
GRANT UPDATE (n_comentario) ON natame."calificacion" TO r_cliente;

CREATE ROLE r_visitante;
GRANT SELECT ON natame."region" TO r_visitante;
GRANT SELECT ON natame."categoria" TO r_visitante; 
GRANT SELECT ON natame."subcategoria" TO r_visitante; 
GRANT SELECT ON natame."producto" TO r_visitante;
-- Fin Creación de Roles y asignación de privilegios a dichos roles

-- Inicio de creación de usuarios y asignación de respectivos roles
CREATE USER AdminAP IDENTIFIED BY AdminAP;
GRANT r_adminAP TO AdminAP;

CREATE USER Rep_Ventas_Master IDENTIFIED BY Rep_Ventas_Master;
GRANT r_RepVentasMaster TO Rep_Ventas_Master;

CREATE USER Rep_Ventas IDENTIFIED BY Rep_Ventas;
GRANT r_RepVentas TO Rep_Ventas;

CREATE USER Cliente IDENTIFIED BY Cliente;
GRANT r_cliente TO Cliente;

CREATE USER Visitante IDENTIFIED BY Visitante;
GRANT r_visitante TO Visitante;
-- Fin de creación de usuarios y asignación de respectivos roles
