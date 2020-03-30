SET ServerOutput ON
SET Verify OFF
-- Realizar pago del banco
CREATE OR REPLACE PROCEDURE PR_pagoBanco(pfk_cuentaorigen pago.fk_cuentaorigen%TYPE,
                                        pfk_cuentadestino pago.fk_cuentadestino%TYPE,
                                        pn_montopago pago.n_montopago%TYPE)
AS
-- Declaración de variables
-- Declaración de cursores
BEGIN
    INSERT 
END PR_pagoBanco;