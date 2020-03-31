SET ServerOutput ON
SET Verify OFF
-- Realizar pago del banco
CREATE OR REPLACE PROCEDURE PR_pagoBanco(pfk_cuentaorigen pago.fk_cuentaorigen%TYPE,
                                        pfk_cuentadestino pago.fk_cuentadestino%TYPE,
                                        pn_montopago pago.n_montopago%TYPE)
AS
-- Declaración de variables
    l_noDatos EXCEPTION;
-- Declaración de cursores
    CURSOR c_pagoBanco IS
        SELECT K_CUENTA
        FROM CUENTA C, CLIENTE CE
        WHERE C.FK_CLIENTE = CE.K_CLIENTE;
    lc_pagoBanco c_pagoBanco%ROWTYPE;
BEGIN
    OPEN c_pagoBanco;
    LOOP
        FETCH c_pagoBanco INTO lc_pagoBanco;
        EXIT WHEN c_pagoBanco%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Correcto');
    END LOOP;
    CLOSE c_pagoBanco;

    IF lc_pagoBanco.K_CUENTA <> pfk_cuentaorigen THEN
        RAISE l_noDatos;
    END IF;
EXCEPTION
    WHEN l_noDatos THEN
        RAISE_APPLICATION_ERROR(-20113,'No se encontró una cuenta asociada al banco');
END PR_pagoBanco;
/