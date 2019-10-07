-- Estando conectados a AdminDB
-- Inicio Creación de Roles y asignación de privilegios a dichos roles
CREATE ROLE r_adminAP;
GRANT CONNECT TO r_adminAP;
GRANT CREATE USER TO r_adminAP;
GRANT CREATE VIEW TO  r_adminAP;
GRANT CREATE PUBLIC SYNONYM TO r_adminAP;
GRANT DROP ANY SYNONYM TO r_adminAP;
GRANT CREATE ROLLBACK SEGMENT TO r_adminAP;
GRANT r_adminAP TO natame

CONN natame/natame

CREATE PUBLIC SYNONYM persona FOR natame.persona;
CREATE PUBLIC SYNONYM cliente FOR natame.cliente;
CREATE PUBLIC SYNONYM rep_ventas FOR natame.rep_ventas;
CREATE PUBLIC SYNONYM clasificacion FOR natame.clasificacion;
CREATE PUBLIC SYNONYM pedido FOR natame.pedido;
CREATE PUBLIC SYNONYM calificacion FOR natame.calificacion;
CREATE PUBLIC SYNONYM region FOR natame.region;
CREATE PUBLIC SYNONYM detalle_pedido FOR natame.detalle_pedido;
CREATE PUBLIC SYNONYM inventario FOR natame.inventario;
CREATE PUBLIC SYNONYM producto FOR natame.producto;
CREATE PUBLIC SYNONYM producto_subcategoria FOR natame.producto_subcategoria;
CREATE PUBLIC SYNONYM subcategoria FOR natame.subcategoria;
CREATE PUBLIC SYNONYM categoria FOR natame.categoria;
CREATE PUBLIC SYNONYM v_producto FOR natame.v_producto;

CREATE ROLE r_RepVentasMaster;
GRANT CONNECT TO r_RepVentasMaster;
GRANT SELECT ON region TO r_RepVentasMaster;
GRANT SELECT ON clasificacion TO r_RepVentasMaster;
GRANT SELECT ON categoria TO r_RepVentasMaster;
GRANT SELECT ON subcategoria TO r_RepVentasMaster;
GRANT SELECT ON producto TO r_RepVentasMaster;
GRANT SELECT,INSERT,UPDATE ON pedido TO r_RepVentasMaster;
GRANT SELECT,INSERT,DELETE ON detalle_pedido TO r_RepVentasMaster;
GRANT SELECT ON calificacion TO r_RepVentasMaster;
GRANT SELECT,INSERT ON persona TO r_RepVentasMaster;
GRANT SELECT,INSERT ON cliente TO r_RepVentasMaster;
GRANT SELECT,INSERT ON rep_ventas TO r_RepVentasMaster;
GRANT SELECT,UPDATE (V_DISPONIBILIDAD) ON inventario TO r_RepVentasMaster;
GRANT SELECT ON pedido_seq TO r_RepVentasMaster;
GRANT SELECT ON v_producto TO r_RepVentasMaster;

CREATE ROLE r_RepVentas;
GRANT CONNECT TO r_RepVentas;
GRANT SELECT ON region TO r_RepVentas;
GRANT SELECT ON clasificacion TO r_RepVentas;
GRANT SELECT ON categoria TO r_RepVentas;
GRANT SELECT ON subcategoria TO r_RepVentas;
GRANT SELECT ON producto TO r_RepVentas;
GRANT SELECT,INSERT,UPDATE ON pedido TO r_RepVentas;
GRANT SELECT,INSERT,DELETE ON detalle_pedido TO r_RepVentas;
GRANT SELECT ON calificacion TO r_RepVentas;
GRANT SELECT,INSERT ON persona TO r_RepVentas;
GRANT SELECT,INSERT ON cliente TO r_RepVentas;
GRANT SELECT ON rep_ventas TO r_RepVentas;
GRANT SELECT,UPDATE (V_DISPONIBILIDAD) ON inventario TO r_RepVentas;
GRANT SELECT ON pedido_seq TO r_RepVentas;
GRANT SELECT ON v_producto TO r_RepVentas;

CREATE ROLE r_cliente;
GRANT CONNECT TO r_cliente;
GRANT SELECT,INSERT,UPDATE ON pedido TO r_cliente;
GRANT SELECT,INSERT,DELETE ON detalle_pedido TO r_cliente;
GRANT SELECT ON region TO r_cliente;
GRANT SELECT ON categoria TO r_cliente; 
GRANT SELECT ON subcategoria TO r_cliente; 
GRANT SELECT ON producto TO r_cliente;
GRANT SELECT ON persona TO r_cliente;
GRANT SELECT ON rep_ventas TO r_cliente;
GRANT SELECT ON cliente TO r_cliente;
GRANT SELECT,UPDATE (v_disponibilidad) ON inventario TO r_cliente;
GRANT SELECT,UPDATE ON calificacion TO r_cliente;
GRANT SELECT ON v_producto TO r_cliente;

CREATE ROLE r_visitante;
GRANT SELECT ON region TO r_visitante;
GRANT SELECT ON categoria TO r_visitante; 
GRANT SELECT ON subcategoria TO r_visitante; 
GRANT SELECT ON producto TO r_visitante;
-- Fin Creación de Roles y asignación de privilegios a dichos roles
