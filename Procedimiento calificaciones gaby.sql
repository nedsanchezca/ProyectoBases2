---PROCEDIMIENTO PARA PROMEDIO DE CALIFICACION---
CREATE OR REPLACE PROCEDURE PR_PROMEDIO_CALIFICACION (pn_factura IN pedido.k_n_factura%TYPE) AS
CURSOR C_PEDIDO IS
SELECT c.v_valoracion 
FROM pedido p, calificacion c
WHERE p.k_n_factura=c.f_n_factura AND p.k_n_factura=pn_factura;
CURSOR C_FACTURA IS
SELECT p.k_n_factura 
FROM pedido p
WHERE p.k_n_factura=pn_factura;
CONTADOR NUMBER:=0;
BEGIN
FOR variable1 in C_FACTURA LOOP
DBMS_OUTPUT.PUT_LINE('Número de factura: '|| variable1.k_n_factura);
CONTADOR:=CONTADOR+1;
END LOOP;
FOR variable2 in C_PEDIDO LOOP
DBMS_OUTPUT.PUT_LINE('Calificación promedio: '|| variable2.v_valoracion/CONTADOR);
END LOOP;
END PR_PROMEDIO_CALIFICACION;





