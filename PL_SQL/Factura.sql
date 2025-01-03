/*
hacer programas plsql para crear facturas a partir de otra tabla que tiene en cada registro la información
de la cabecera y su correspondiente detalle. Validar que tenga cabecera y detalle

'NUMERO_FACTURA;DOCUMENTO DEL CLIENTE;ID DEL PRODUCTO;VALOR;CANTIDAD'

SELECT SUBSTR('ABCDEFG',3,4) "Substring"
 FROM DUAL;
Substring
---------
CDEF
*/

CREATE TABLE DATOS_FACTURA_CARGADA (
ID NUMBER(20) NOT NULL,
TEXTO VARCHAR2(4000) NOT NULL
);

INSERT INTO DATOS_FACTURA_CARGADA
(ID, TEXTO)
VALUES (1,'555;900100100;56;1000000;1');

INSERT INTO DATOS_FACTURA_CARGADA
(ID, TEXTO)
VALUES (2,'455;999100100;66;1000670;15');

CREATE TABLE DATOS_FACTURA(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NUMERO_FACTURA NUMBER(20) NOT NULL,
    DOCUMENTO_CLIENTE NUMBER(20) NOT NULL,
    ID_PRODUCTO NUMBER(20) NOT NULL,
    VALOR NUMBER(20) NOT NULL,
    CANTIDAD NUMBER(20) NOT NULL
);

--SET SERVEROUTPUT ON;

--LLAMA A TODOS LOS REGISTROS
CREATE OR REPLACE PROCEDURE P_LEER_DATOS(
	V_DETALLES VARCHAR2) IS
	CURSOR CU_DATOS IS 
		SELECT *
		FROM DATOS_FACTURA_CARGADA 
		ORDER BY ID;
	--NO ES NECESARIO USAR DECLARE YA QUE DENTRO DEL PROCEDIMIENTO SE DEFINE
	N_NUMERO_FACTURA NUMBER(20);
    N_DOCUMENTO_CLIENTE NUMBER(20);
    N_ID_PRODUCTO NUMBER(20);
    N_VALOR NUMBER(20);
    N_CANTIDAD NUMBER(20);
BEGIN
    FOR R_DATOS IN CU_DATOS LOOP
        IF LENGTH(R_DATOS.TEXTO) >= 26 THEN
            BEGIN
                N_NUMERO_FACTURA := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 1, 3));
                N_DOCUMENTO_CLIENTE := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 5, 9));
                N_ID_PRODUCTO := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 15, 2));
                N_VALOR := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 18, 7));
                N_CANTIDAD := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 26, 2));

                INSERT INTO DATOS_FACTURA 
                    (NUMERO_FACTURA, DOCUMENTO_CLIENTE, ID_PRODUCTO, VALOR, CANTIDAD) 
                VALUES (N_NUMERO_FACTURA, N_DOCUMENTO_CLIENTE, N_ID_PRODUCTO, N_VALOR, N_CANTIDAD);
				DBMS_OUTPUT.PUT_LINE('Datos insertados:' || N_DOCUMENTO_CLIENTE|| 'PRUEBA');
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error procesando ID ' || R_DATOS.ID || ': ' || SQLERRM);
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Texto inválido para ID ' || R_DATOS.ID);
        END IF;
    END LOOP;
END P_LEER_DATOS;

--Al llamar al procedimiento el argumento que le pase no importa en este caso ya que se ejecuta para todos los registros
EXEC P_LEER_DATOS('PRUEBA');

--LLAMA A UN REGISTRO ESPECIFICO
CREATE OR REPLACE PROCEDURE P_LEER_DATOS(
	N_ID_DATOS NUMBER) IS
	CURSOR CU_DATOS IS 
		SELECT *
		FROM DATOS_FACTURA_CARGADA DT
		WHERE DT.ID= N_ID_DATOS;
	--NO ES NECESARIO USAR DECLARE YA QUE DENTRO DEL PROCEDIMIENTO SE DEFINE
	N_NUMERO_FACTURA NUMBER(20);
    N_DOCUMENTO_CLIENTE NUMBER(20);
    N_ID_PRODUCTO NUMBER(20);
    N_VALOR NUMBER(20);
    N_CANTIDAD NUMBER(20);
BEGIN
    FOR R_DATOS IN CU_DATOS LOOP
        IF LENGTH(R_DATOS.TEXTO) >= 26 THEN
            BEGIN
                N_NUMERO_FACTURA := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 1, 3));
                N_DOCUMENTO_CLIENTE := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 5, 9));
                N_ID_PRODUCTO := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 15, 2));
                N_VALOR := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 18, 7));
                N_CANTIDAD := TO_NUMBER(SUBSTR(R_DATOS.TEXTO, 26, 2));

                INSERT INTO DATOS_FACTURA 
                    (NUMERO_FACTURA, DOCUMENTO_CLIENTE, ID_PRODUCTO, VALOR, CANTIDAD) 
                VALUES (N_NUMERO_FACTURA, N_DOCUMENTO_CLIENTE, N_ID_PRODUCTO, N_VALOR, N_CANTIDAD);
				DBMS_OUTPUT.PUT_LINE('Datos insertados:' || N_DOCUMENTO_CLIENTE|| 'PRUEBA');
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error procesando ID ' || R_DATOS.ID || ': ' || SQLERRM);
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Texto inválido para ID ' || R_DATOS.ID);
        END IF;
    END LOOP;
END P_LEER_DATOS;

--Ejecuta el procedimiento para el registro seleccionado por id
EXEC P_LEER_DATOS(1);