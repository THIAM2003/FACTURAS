CREATE TABLE PROVEEDOR(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL
);

ALTER TABLE PROVEEDOR
ADD CONSTRAINT NOMBRE_UK UNIQUE (NOMBRE);

CREATE TABLE INGREDIENTE(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL,
    PROVEEDOR_ID NUMBER(20) NOT NULL,
    PRECIO_LIBRA NUMBER(20) NOT NULL
);

ALTER TABLE INGREDIENTE
ADD CONSTRAINT PROVEEDOR_ID_FK FOREIGN KEY (PROVEEDOR_ID) REFERENCES PROVEEDOR(ID);

CREATE TABLE FACTURA(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FECHA_CREACION DATE NOT NULL,
    VALOR_TOTAL NUMBER(20)
);

CREATE TABLE DETALLE_FACTURA_INGREDIENTE(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FACTURA_ID NUMBER(20) NOT NULL,
    INGREDIENTE_ID NUMBER(20) NOT NULL,
    CANTIDAD_INGREDIENTE NUMBER(20) NOT NULL,
    SUBTOTAL NUMBER(20)
);

ALTER TABLE DETALLE_FACTURA_INGREDIENTE
ADD CONSTRAINT FACTURA_ID_FK FOREIGN KEY (FACTURA_ID) REFERENCES FACTURA(ID);

ALTER TABLE DETALLE_FACTURA_INGREDIENTE
ADD CONSTRAINT INGREDIENTE_ID_FK FOREIGN KEY (INGREDIENTE_ID) REFERENCES INGREDIENTE(ID);

CREATE TABLE CLIENTE(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL,
    DOCUMENTO VARCHAR(20) NOT NULL,
    TIPO_DOCUMENTO VARCHAR2(3) NOT NULL,
    EMAIL VARCHAR2(100) NOT NULL
);

ALTER TABLE CLIENTE
ADD CONSTRAINT TIPO_DOCUMENTO_CK CHECK (TIPO_DOCUMENTO IN ('CC', 'TI', 'PAS'));

ALTER TABLE CLIENTE
ADD CONSTRAINT DOCUMENTO_UK UNIQUE (DOCUMENTO);

CREATE TABLE PRODUCTO(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL,
    PRECIO_UNITARIO NUMBER(20)
);

CREATE TABLE PRODUCTO_INGREDIENTE(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    PRODUCTO_ID NUMBER(20) NOT NULL,
    INGREDIENTE_ID NUMBER(20) NOT NULL,
    FRACCION_LIBRA NUMBER(20, 2) NOT NULL,
    PRECIO_PRODUCCION NUMBER(20, 2)
);

ALTER TABLE PRODUCTO_INGREDIENTE
ADD CONSTRAINT PRODUCTO_FK FOREIGN KEY (PRODUCTO_ID) REFERENCES PRODUCTO(ID);

ALTER TABLE PRODUCTO_INGREDIENTE
ADD CONSTRAINT INGREDIENTE_FK FOREIGN KEY (INGREDIENTE_ID) REFERENCES INGREDIENTE(ID);

ALTER TABLE PRODUCTO_INGREDIENTE
ADD CONSTRAINT INGREDIENTE_UK UNIQUE (PRODUCTO_ID, INGREDIENTE_ID);

CREATE TABLE DETALLE_FACTURA_CLIENTE(
    ID NUMBER(20) GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FACTURA_ID NUMBER(20) NOT NULL,
    PRODUCTO_ID NUMBER(20) NOT NULL,
    CLIENTE_ID NUMBER(20) NOT NULL,
    CANTIDAD_PRODUCTO NUMBER(20) NOT NULL,
    SUBTOTAL NUMBER(20)
);

ALTER TABLE DETALLE_FACTURA_CLIENTE
ADD CONSTRAINT FACTURA_ID_CLI_FK FOREIGN KEY (FACTURA_ID) REFERENCES FACTURA(ID);

ALTER TABLE DETALLE_FACTURA_CLIENTE
ADD CONSTRAINT PRODUCTO_ID_CLI_FK FOREIGN KEY (PRODUCTO_ID) REFERENCES PRODUCTO(ID);

ALTER TABLE DETALLE_FACTURA_CLIENTE
ADD CONSTRAINT CLIENTE_ID_FK FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE(ID);

-- Proveedores de carnes
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Carnes Premium Ltda');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Distribuidora de Carnes el Sol');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Carne y Corte S.A.');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Carnes Frescas del Norte');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('MacPollo');

-- Proveedores de verduras
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Exito');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('La Huerta');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Vegetales Orgánicos SAS');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Alkosto');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Distribuciones Hortícolas');

-- Proveedores de especias
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Especias del Mundo');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Sabor Gourmet');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Condimentos y Sabores Ltda');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Esencias de la India');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('La Casa de las Especias');

-- Proveedores de bebidas
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Bebidas del Valle');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Coca Cola');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Manantial');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Postobon');
INSERT INTO PROVEEDOR (NOMBRE) VALUES ('Distribuidora de Lácteos y Bebidas');

-- Insertar ingredientes en la tabla INGREDIENTE
-- Carnes
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Churrasco', 1, 20000); -- Carnes Premium Ltda
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Punta de Anca', 2, 18000); -- Distribuidora de Carnes el Sol
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Baby Beef', 3, 22000); -- Carne y Corte S.A.
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Alitas de Pollo', 5, 8000); -- MacPollo
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Carne de Hamburguesa', 1, 15000); -- Carnes Premium Ltda
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Salmón', 4, 35000); -- Carnes Frescas del Norte
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Chorizo', 4, 7800);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Tocino', 4, 6800);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Pechuga de pollo', 5, 8500);

-- Especias
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Sal Gruesa', 11, 5000); -- Especias del Mundo
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Azúcar', 12, 3000); -- Sabor Gourmet
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Orégano', 11, 12000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Pimienta negra', 12, 14000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Comino', 13, 11000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Curry', 14, 15000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Páprika', 15, 13000);

-- Verduras y Frutas
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Papa Francesa', 7, 2000); -- La Huerta
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Piña en Cuadritos', 10, 4000); -- Distribuciones Hortícolas
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Champiñones', 8, 6000); -- Vegetales Orgánicos SAS
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Tomate', 6, 3200);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Cebolla', 7, 1800);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Lechuga', 8, 1500);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Zanahoria', 9, 1400);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Pimentón', 10, 2500);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Jalapeño', 7, 3000);

-- Granos y Pasta
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Pasta Larga', 6, 1500); -- Exito
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Lasagna', 6, 2000); -- Exito
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Harina', 9, 2500); -- Alkosto
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Queso', 9, 7000); -- Alkosto
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Pan de Hamburguesa', 9, 1500); -- Alkosto

-- Salsas
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Salsa de Tomate', 6, 4500); 
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Salsa de Piña', 9, 5000); 
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Salsa Rosada', 7, 5500); -- Manantial
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Mayonesa', 8, 4000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Mostaza', 10, 4200); -- Distribuidora de Lácteos y Bebidas

-- Ingredientes de Bebidas
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Coca cola', 17, 1200);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Agua mineral', 18, 1000);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Jugo de naranja', 16, 1400);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Gaseosa de uva', 19, 1400);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Gaseosa manzana', 16, 1200);
INSERT INTO INGREDIENTE (NOMBRE, PROVEEDOR_ID, PRECIO_LIBRA) VALUES ('Leche', 20, 1500);

-- Insertar productos en la tabla PRODUCTO sin el precio unitario

-- Insertar productos de proteínas con especificación de peso

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Churrasco 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Churrasco 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Churrasco 750g');

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Punta de Anca 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Punta de Anca 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Punta de Anca 750g');

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Baby Beef 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Baby Beef 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Baby Beef 750g');

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Alitas de Pollo 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Alitas de Pollo 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Alitas de Pollo 750g');

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Salmon 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Salmon 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Salmon 750g');

INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pechuga 500g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pechuga 250g');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pechuga 750g');

-- Pastas y lasañas
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pasta Alfredo');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Lasagna de Pollo');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Lasagna de Carne');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Lasagna Mixta');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pasta Carbonara');

-- Hamburguesas y pizzas
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Hamburguesa Sencilla');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Hamburguesa Doble Carne');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pizza Hawaiana');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pizza de Pollo y Champiñones');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pizza Mexicana');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Pizza Napolitana');

-- Ensaladas
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Ensalada Especial');

-- Bebidas
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Coca Cola');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Agua Mineral');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Jugo de Naranja');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Gaseosa de Uva');
INSERT INTO PRODUCTO (NOMBRE) VALUES ('Gaseosa de Manzana');

-- Insertar Clientes
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Juan Pérez', '123456789', 'CC', 'juan.perez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('María Gómez', '987654321', 'CC', 'maria.gomez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Carlos Rodríguez', '456789123', 'TI', 'carlos.rodriguez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Luisa Fernández', '789456123', 'CC', 'luisa.fernandez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('José Martínez', '234567891', 'PAS', 'jose.martinez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Ana Ramírez', '567891234', 'CC', 'ana.ramirez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('David López', '123789456', 'TI', 'david.lopez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Andrea Torres', '987123654', 'PAS', 'andrea.torres@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Sofía Moreno', '345678912', 'CC', 'sofia.moreno@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Ricardo Castillo', '678912345', 'TI', 'ricardo.castillo@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Laura Vargas', '876543210', 'CC', 'laura.vargas@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Miguel Álvarez', '234567890', 'TI', 'miguel.alvarez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Mónica Ortiz', '789012345', 'PAS', 'monica.ortiz@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Diana Ruiz', '345678901', 'CC', 'diana.ruiz@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Luis Mejía', '567890123', 'TI', 'luis.mejia@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Gabriela Herrera', '123456780', 'CC', 'gabriela.herrera@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Jorge Ríos', '678901234', 'PAS', 'jorge.rios@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Natalia Salazar', '345678900', 'TI', 'natalia.salazar@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Felipe Suárez', '789012334', 'CC', 'felipe.suarez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Carolina Pardo', '234567899', 'PAS', 'carolina.pardo@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Roberto Mendoza', '987654329', 'TI', 'roberto.mendoza@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Patricia Bonilla', '456789098', 'CC', 'patricia.bonilla@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Álvaro Gil', '678901233', 'TI', 'alvaro.gil@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Estefanía Rangel', '234567898', 'CC', 'estefania.rangel@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Cristina León', '876543219', 'PAS', 'cristina.leon@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Pablo Castaño', '345678909', 'CC', 'pablo.castano@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Camila Caicedo', '567890124', 'TI', 'camila.caicedo@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Daniela Márquez', '123456799', 'PAS', 'daniela.marquez@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Alejandro Nieto', '678912344', 'CC', 'alejandro.nieto@gmail.com');
INSERT INTO CLIENTE (NOMBRE, DOCUMENTO, TIPO_DOCUMENTO, EMAIL) VALUES ('Isabel Sanabria', '876543208', 'TI', 'isabel.sanabria@gmail.com');

-- Insertar Producto_Ingrediente para cada variante de proteínas con fracción de libra basada en el peso

-- Churrasco
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (1, 1, 1.1); -- 500g ≈ 1.1 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (2, 1, 0.55); -- 250g ≈ 0.55 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (3, 1, 1.65); -- 750g ≈ 1.65 libras

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (1, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (2, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (3, 13, 0.02); -- Pimienta

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (1, 10, 0.02); -- sal
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (2, 10, 0.02); --sal
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (3, 10, 0.02); -- sal

-- Punta de Anca
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (4, 2, 1.1); -- 500g ≈ 1.1 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (5, 2, 0.55); -- 250g ≈ 0.55 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (6, 2, 1.65); -- 750g ≈ 1.65 libras

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (4, 10, 0.02); -- 500g ≈ 1.1 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (5, 10, 0.02); -- 250g ≈ 0.55 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (6, 10, 0.02); -- 750g ≈ 1.65 libras
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (4, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (5, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (6, 13, 0.02); -- Pimienta

-- Baby Beef
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (7, 3, 1.1);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (8, 3, 0.55);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (9, 3, 1.65);

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (7, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (8, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (9, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (7, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (8, 13, 0.02); -- Pimienta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (9, 13, 0.02); -- Pimienta

-- Alitas de Pollo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (10, 4, 1.1);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (11, 4, 0.55);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (12, 4, 1.65);

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (10, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (11, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (12, 10, 0.02);

-- Salmon
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (13, 6, 1.1);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (14, 6, 0.55);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (15, 6, 1.65);

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (13, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (14, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (15, 10, 0.02);

-- Pechuga
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (16, 9, 1.1);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (17, 9, 0.55);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (18, 9, 1.65);

INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (16, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (17, 10, 0.02);
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (18, 10, 0.02);

-- Pasta Alfredo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (19, 25, 0.5); -- Pasta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (19, 28, 0.15); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (19, 40, 0.1); -- Crema

-- Lasagna de Pollo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (20, 9, 0.75); -- Pollo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (20, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (20, 26, 0.5); -- Pasta

-- Lasagna de Carne
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (21, 3, 0.75); -- Carne
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (21, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (21, 26, 0.5); -- Pasta

-- Lasagna Mixta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (22, 3, 0.5); -- Carne
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (22, 9, 0.5); -- Pollo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (22, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (22, 26, 0.5); -- Pasta

-- Pasta Carbonara
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (23, 25, 0.5); -- Pasta
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (23, 28, 0.15); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (23, 40, 0.1); -- Crema

-- Hamburguesa Sencilla
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 5, 0.6); --Carne hamburguesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 28, 0.02); --Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 21, 0.1); --Cebolla
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 20, 0.1); --Tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 22, 0.1); --Lechuga
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 17, 0.25); -- Papa francesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 29, 0.1); -- Pan
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 30, 0.1); -- salsa tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 31, 0.1); -- salsa de piña
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 32, 0.1); -- salsa rosada
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 33, 0.1); -- salsa mayonesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (24, 34, 0.1); -- salsa mostaza

-- Hamburguesa DOBLE
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 5, 1.2); --Carne hamburguesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 28, 0.02); --Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 21, 0.1); --Cebolla
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 20, 0.1); --Tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 22, 0.1); --Lechuga
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 17, 0.25); -- Papa francesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 30, 0.1); -- Pan
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 31, 0.1); -- salsa tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 32, 0.1); -- salsa de piña
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 33, 0.1); -- salsa rosada
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 34, 0.1); -- salsa mayonesa
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (25, 35, 0.1); -- salsa mostaza

-- Pizza Hawaiana
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (26, 27, 0.5); -- Masa de pizza
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (26, 8, 0.25); -- Tocino
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (26, 18, 0.15); -- Piña
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (26, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (26, 12, 0.02); -- Oregano

-- Pizza de Pollo y Champiñón
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (27, 27, 0.5); -- Masa de pizza
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (27, 9, 0.25); -- Pollo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (27, 19, 0.15); -- Champiñón
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (27, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (27, 12, 0.02); -- Oregano

-- Pizza Mexicana
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 27, 0.5); -- Masa de pizza
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 3, 0.25); -- Carne
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 41, 0.15); -- Jalapeño
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 7, 0.25); -- Chorizo
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 12, 0.02); -- Oregano
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 24, 0.1); -- Pimenton
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (28, 16, 0.01); -- Paprika

-- Pizza Napolitana
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 27, 0.5); -- Masa de pizza
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 20, 0.25); -- Tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 28, 0.25); -- Queso
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 12, 0.02); -- Oregano
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 14, 0.02); -- Comino
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (29, 15, 0.02); -- Curry

-- Ensalada Especial
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (30, 22, 0.25); -- Lechuga
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (30, 20, 0.15); -- Tomate
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (30, 21, 0.1); -- Cebolla
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (30, 23, 0.1); -- Zanahoria
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (30, 28, 0.15); -- Queso fresco

-- Bebidas
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (31, 36, 1); -- Bebida (Coca Cola)
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (32, 37, 1); -- Bebida (Agua)
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (33, 38, 1); -- Bebida (Jugo de naranja)
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (34, 39, 1); -- Bebida (Gaseosa de uva)
INSERT INTO PRODUCTO_INGREDIENTE (PRODUCTO_ID, INGREDIENTE_ID, FRACCION_LIBRA) VALUES (35, 40, 1); -- Bebida (Gaseosa de manzana)
