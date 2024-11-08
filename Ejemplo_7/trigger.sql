--TRIGGER MODIFICACION DE TOTAL EN FACTURA

CREATE OR REPLACE TRIGGER ACTUALIZAR_VALOR_TOTAL_FACTURA
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_FACTURA_CLIENTE
BEGIN
    UPDATE FACTURA
    SET VALOR_TOTAL = (
        SELECT SUM(SUBTOTAL)
        FROM DETALLE_FACTURA_CLIENTE
        WHERE FACTURA_ID = FACTURA.ID
    )
    WHERE ID IN (
        SELECT DISTINCT FACTURA_ID
        FROM DETALLE_FACTURA_CLIENTE
    );
END;

CREATE OR REPLACE TRIGGER ACTUALIZAR_VALOR_TOTAL_FACTURA_INGREDIENTE
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_FACTURA_INGREDIENTE
BEGIN
    UPDATE FACTURA
    SET VALOR_TOTAL = (
        SELECT SUM(SUBTOTAL)
        FROM DETALLE_FACTURA_INGREDIENTE
        WHERE FACTURA_ID = FACTURA.ID
    )
    WHERE ID IN (
        SELECT DISTINCT FACTURA_ID
        FROM DETALLE_FACTURA_INGREDIENTE
    );
END;

--TRIGGER MODIFICACION DE SUBTOTAL EN DETALLE_FACTURA

CREATE OR REPLACE TRIGGER MODIFICACION_SUBTOTAL
BEFORE INSERT OR UPDATE ON DETALLE_FACTURA_INGREDIENTE
FOR EACH ROW
DECLARE
    v_precio_LIBRA NUMBER(20);
BEGIN
    -- Obtener el precio LIBRA del producto
    SELECT PRECIO_LIBRA
    INTO v_precio_LIBRA
    FROM INGREDIENTE
    WHERE ID = :NEW.INGREDIENTE_ID;

    -- Calcular el subtotal como cantidad * precio LIBRA
    :NEW.SUBTOTAL := :NEW.CANTIDAD_INGREDIENTE * v_precio_LIBRA;
END;

CREATE OR REPLACE TRIGGER MODIFICACION_SUBTOTAL_CLIENTE
BEFORE INSERT OR UPDATE ON DETALLE_FACTURA_CLIENTE
FOR EACH ROW
DECLARE
    v_precio_unitario NUMBER(20);
BEGIN
    -- Obtener el precio unitario del producto
    SELECT PRECIO_UNITARIO
    INTO v_precio_unitario
    FROM PRODUCTO
    WHERE ID = :NEW.PRODUCTO_ID;

    -- Calcular el subtotal como cantidad * precio unitario
    :NEW.SUBTOTAL := :NEW.CANTIDAD_PRODUCTO * v_precio_unitario;
END;

-- TRIGGER CALCULO DEL PRECIO_PRODUCCION AL ACTUALIZAR PRECIO_LIBRA, EL OF ES DE ORACLE SQL

--COMO NO TIENE FOR EACH ROW, SE EJECUTA UNA VEZ PARA TODA LA TABLA
CREATE OR REPLACE TRIGGER ACTUALIZAR_PRECIO_PRODUCCION
AFTER UPDATE OF PRECIO_LIBRA ON INGREDIENTE
BEGIN
    -- Actualizar el PRECIO_PRODUCCION en PRODUCTO_INGREDIENTE
    UPDATE PRODUCTO_INGREDIENTE PI
    SET PI.PRECIO_PRODUCCION = PI.FRACCION_LIBRA * 
                               (SELECT i.PRECIO_LIBRA 
                                FROM INGREDIENTE i 
                                WHERE i.ID = PI.INGREDIENTE_ID)
    WHERE pi.INGREDIENTE_ID IN (SELECT ID FROM INGREDIENTE);
END;

--TRIGGER CALCULO AUTOMATICO PRECIO_PRODUCCION

CREATE OR REPLACE TRIGGER CALCULAR_PRECIO_PRODUCCION
BEFORE INSERT OR UPDATE ON PRODUCTO_INGREDIENTE
FOR EACH ROW
DECLARE
    v_precio_libra NUMBER(20);
BEGIN
    -- Obtener el precio por libra del ingrediente
    SELECT PRECIO_LIBRA
    INTO v_precio_libra
    FROM INGREDIENTE
    WHERE ID = :NEW.INGREDIENTE_ID;

    -- Calcular el precio de producción como fracción de libra por precio por libra
    :NEW.PRECIO_PRODUCCION := :NEW.FRACCION_LIBRA * v_precio_libra;
END;

--TRIGGER CALCULO AUTOMATICO PRECIO PRODUCTO

--OPCION DE TRIGGER A NIVEL DE STATEMENT
CREATE OR REPLACE TRIGGER CALCULAR_PRECIO_UNITARIO_PRODUCTO
AFTER INSERT OR UPDATE ON PRODUCTO_INGREDIENTE
DECLARE
BEGIN
    -- Actualizar el precio unitario del producto en la tabla PRODUCTO
    UPDATE PRODUCTO
    SET PRECIO_UNITARIO = (
        SELECT COALESCE(SUM(PRECIO_PRODUCCION), 0) * 2
        FROM PRODUCTO_INGREDIENTE
        WHERE PRODUCTO_ID = PRODUCTO.ID
    )
    WHERE ID IN (
        SELECT DISTINCT PRODUCTO_ID
        FROM PRODUCTO_INGREDIENTE
    );
END;

--OPCION DE TRIGGER CON TABLA TEMPORAL
CREATE GLOBAL TEMPORARY TABLE TEMP_PRODUCTO_IDS (
    PRODUCTO_ID NUMBER(20) PRIMARY KEY
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE TRIGGER ADD_TO_TEMP_PRODUCTO_IDS
AFTER INSERT OR UPDATE ON PRODUCTO_INGREDIENTE
FOR EACH ROW
BEGIN
    BEGIN
        -- Inserta el PRODUCTO_ID en la tabla temporal si aún no está registrado
        INSERT INTO TEMP_PRODUCTO_IDS (PRODUCTO_ID) VALUES (:NEW.PRODUCTO_ID);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- Si el PRODUCTO_ID ya está en TEMP_PRODUCTO_IDS, lo ignora
            NULL;
    END;
END;

CREATE OR REPLACE TRIGGER CALCULAR_PRECIO_UNITARIO_STATEMENT
AFTER INSERT OR UPDATE ON PRODUCTO_INGREDIENTE
DECLARE
    CURSOR producto_cursor IS
        SELECT DISTINCT PRODUCTO_ID FROM TEMP_PRODUCTO_IDS;
    v_precio_total NUMBER(20,2);
BEGIN
    -- Para cada producto en la lista temporal, calcula y actualiza el PRECIO_UNITARIO
    FOR producto_rec IN producto_cursor LOOP
        SELECT COALESCE(SUM(PRECIO_PRODUCCION), 0) INTO v_precio_total
        FROM PRODUCTO_INGREDIENTE
        WHERE PRODUCTO_ID = producto_rec.PRODUCTO_ID;

        -- Actualizar el precio unitario del producto en la tabla PRODUCTO
        UPDATE PRODUCTO
        SET PRECIO_UNITARIO = v_precio_total * 2
        WHERE ID = producto_rec.PRODUCTO_ID;
    END LOOP;
    
    -- Limpia la tabla temporal al final de la operación
    DELETE FROM TEMP_PRODUCTO_IDS;
END;

--TRANSACCIÓN PARA FACTURA Y DETALLE_FACTURA-- EN SQL NO SE DEBE ESCRIBIR TRANSACTION YA QUE CON BEGIN Y END SE SOBREENTIENDE

-- CREAR DETALLE_FACTURA_INGREDIENTE AL AZAR
DECLARE
    v_factura_id NUMBER;
    v_ingrediente_id NUMBER;
    v_cantidad NUMBER;
BEGIN
    FOR j IN 1..100 LOOP  -- Repetir la transacción 100 veces
        -- Crear una nueva factura con una fecha aleatoria dentro del último año
        INSERT INTO FACTURA (FECHA_CREACION)
        VALUES (TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365)))
        RETURNING ID INTO v_factura_id;

        -- Insertar detalles en DETALLE_FACTURA_INGREDIENTE para la factura creada
        FOR i IN 1..10 LOOP  -- Genera 10 detalles para cada factura
            -- Generar datos aleatorios para el detalle de la factura ingrediente
            v_ingrediente_id := TRUNC(DBMS_RANDOM.VALUE(1, 41));  -- Asume que hay ingredientes con IDs del 1 al 41
            v_cantidad := TRUNC(DBMS_RANDOM.VALUE(1, 5));         -- Cantidad entre 1 y 5

            INSERT INTO DETALLE_FACTURA_INGREDIENTE (FACTURA_ID, INGREDIENTE_ID, CANTIDAD_INGREDIENTE)
            VALUES (v_factura_id, v_ingrediente_id, v_cantidad);
        END LOOP;
    END LOOP;

    -- Confirmar todas las transacciones al final
    COMMIT;
END;

-- CREAR DETALLE_FACTURA_CLIENTE AL AZAR
DECLARE
    v_factura_id NUMBER;
    v_cliente_id NUMBER;
BEGIN
    FOR j IN 1..100 LOOP  -- Repetir la transacción 100 veces
        -- Paso 1: Crear una nueva factura con una fecha aleatoria dentro del último año
        INSERT INTO FACTURA (FECHA_CREACION)
        VALUES (TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365)))
        RETURNING ID INTO v_factura_id;

        -- Paso 2: Seleccionar un CLIENTE_ID aleatorio existente
        SELECT ID INTO v_cliente_id
        FROM (SELECT ID FROM CLIENTE ORDER BY DBMS_RANDOM.RANDOM) 
        WHERE ROWNUM = 1;

        -- Paso 3: Insertar transacciones aleatorias en DETALLE_FACTURA_CLIENTE
        FOR i IN 1..5 LOOP  -- Inserta 5 detalles como ejemplo
            INSERT INTO DETALLE_FACTURA_CLIENTE (FACTURA_ID, CLIENTE_ID, PRODUCTO_ID, CANTIDAD_PRODUCTO)
            VALUES (
                v_factura_id,
                v_cliente_id,
                FLOOR(DBMS_RANDOM.VALUE(1, 35)),  -- Producto ID aleatorio entre 1 y 35
                FLOOR(DBMS_RANDOM.VALUE(1, 4))   -- Cantidad aleatoria entre 1 y 4
            );
        END LOOP;
    END LOOP;

    -- Confirmar la transacción
    COMMIT;
END;

--CREAR CLIENTES AL AZAR
DECLARE
    v_nombre VARCHAR2(100);
    v_documento VARCHAR2(20);
    v_tipo_documento VARCHAR2(3);
    v_email VARCHAR2(100);
BEGIN
    FOR i IN 1..50 LOOP
        -- Generar un nombre aleatorio
        v_nombre := 'Cliente_' || DBMS_RANDOM.STRING('U', 6);
        
        -- Generar un documento único de 9 dígitos
        v_documento := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999)));

        -- Seleccionar un tipo de documento aleatorio
        v_tipo_documento := CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))
                               WHEN 1 THEN 'CC'
                               WHEN 2 THEN 'TI'
                               ELSE 'PAS'
                            END;
        
        -- Generar un email con el nombre aleatorio
        v_email := LOWER(v_nombre) || '@example.com';

        -- Insertar el cliente en la tabla
        INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL)
        VALUES (v_nombre, v_documento, v_tipo_documento, v_email);
    END LOOP;

    COMMIT;
END;
