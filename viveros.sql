-- -- Script para eliminar todas las tablas y vistas relacionadas con el sistema de viveros
-- -- Se eliminan las tablas en orden inverso de dependencia (de las que referencian a las referenciadas)
-- -- Usamos DROP TABLE IF EXISTS para evitar errores si las tablas no existen.

-- DROP TABLE IF EXISTS Producto_Pedido;
-- DROP TABLE IF EXISTS Trabaja;
-- DROP TABLE IF EXISTS TelefonoCliente;
-- DROP TABLE IF EXISTS TelefonoEmpleado;
-- DROP TABLE IF EXISTS Pedido;
-- DROP TABLE IF EXISTS Stock;
-- DROP TABLE IF EXISTS Cliente;
-- DROP TABLE IF EXISTS Empleado;
-- DROP TABLE IF EXISTS Producto;
-- DROP TABLE IF EXISTS Tajinaste_plus;
-- DROP TABLE IF EXISTS Zona;


-- -- Creacion de las tablas y vistas necesarias para el sistema de viveros

-- CREATE TABLE Empleado (
--     -- ID_Empleado debe ser INTEGER, ya que SERIAL lo convierte a INTEGER internamente
--     ID_Empleado SERIAL PRIMARY KEY,
--     salario NUMERIC(10, 2) NOT NULL, -- La coma va aquí
--     Nombre VARCHAR(50) NOT NULL      -- No debe ir una coma aquí
-- );

-- ---------------------------------------

-- CREATE TABLE TelefonoEmpleado (
--     -- El teléfono debe ser INTEGER, no VARCHAR, para usar SERIAL. 
--     -- Sin embargo, el teléfono suele ser una clave del negocio (número real).
--     -- Si lo que quieres es un ID autoincremental para CADA registro de teléfono:
--     ID_Telefono SERIAL PRIMARY KEY, -- Renombrada a ID_Telefono para claridad
--     Telefono VARCHAR(20) NOT NULL, -- Columna para el número real de teléfono
    
--     -- El ID_Empleado debe ser del mismo tipo que en la tabla Empleado (INTEGER)
--     ID_Empleado INTEGER NOT NULL
    
--     -- Definición de la Clave Foránea
--     ,FOREIGN KEY (ID_Empleado) 
--         REFERENCES Empleado (ID_Empleado)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- CREATE TABLE Zona (
--     ID_Zona SERIAL PRIMARY KEY, -- PK: Primary Key for the table
--     tipo_zona VARCHAR(50),
--     longitud DECIMAL(9,6), -- Stores a decimal number with 9 digits total, 6 after the decimal point
--     latitud DECIMAL(9,6)   -- Stores a decimal number with 9 digits total, 6 after the decimal point
-- );


-- -- 2. Create the Trabaja table (Relationship table)
-- CREATE TABLE Trabaja (
--     ID_Empleado SERIAL,
--     ID_Zona INTEGER,
--     fecha_inicio DATE,
--     fecha_fin DATE,
--     productividad FLOAT

--     -- PKFK: Define a composite Primary Key using both ID_Empleado and ID_Zona
--     ,PRIMARY KEY (ID_Empleado, ID_Zona),

--     -- FK 1: References the Empleado table (assuming it's already created, as implied by the relationship)
--     FOREIGN KEY (ID_Empleado) REFERENCES Empleado (ID_Empleado)
--         ON DELETE RESTRICT, -- Standard practice: Prevent deleting an employee while they still have work records
        
--     -- FK 2: References the Zona table
--     FOREIGN KEY (ID_Zona) REFERENCES Zona (ID_Zona)
--         ON DELETE RESTRICT -- Prevent deleting a zone while there are work records associated with it
-- );

-- CREATE TABLE Stock (
--     -- PKFK 1: Referencia a Zona.ID_Zona (Es INTEGER porque Zona.ID_Zona es SERIAL)
--     ID_zona INTEGER NOT NULL, 
    
--     -- PKFK 2: Referencia a Producto.ID_Producto (Es INTEGER porque Producto.ID_Producto es SERIAL)
--     ID_producto INTEGER NOT NULL, 
    
--     cantidad INTEGER NOT NULL, -- Cantidad de producto, debe ser obligatoria
    
--     -- Clave Primaria Compuesta: La unicidad se da por la combinación de Zona y Producto
--     PRIMARY KEY (ID_zona, ID_producto),
    
--     -- Definición de Claves Foráneas
    
--     -- FK 1: Referencia a la tabla Zona
--     FOREIGN KEY (ID_zona) 
--         REFERENCES Zona (ID_Zona)
--         ON DELETE CASCADE    -- Si se borra una zona, se borran los registros de stock de esa zona.
--         ON UPDATE CASCADE,
        
--     -- FK 2: Referencia a la tabla Producto
--     FOREIGN KEY (ID_producto) 
--         REFERENCES Producto (ID_Producto)
--         ON DELETE CASCADE    -- Si se borra un producto, se borran los registros de stock de ese producto.
--         ON UPDATE CASCADE
-- );

-- CREATE TABLE Producto (
--     ID_Producto SERIAL PRIMARY KEY,
--     nombre VARCHAR(50) NOT NULL,
--     precio NUMERIC(10, 2) NOT NULL
-- );
-- ---


-- CREATE TABLE Tajinaste_plus (
--     ID_Plus SERIAL PRIMARY KEY,
--     descripcion VARCHAR(255) NOT NULL,
--     fecha_ingreso DATE NOT NULL,
--     fecha_fin DATE NOT NULL,
--     descuento_plus DECIMAL(5, 2) NOT NULL -- se tendría que realizar un trigger para calcular el descuento (0-100)
-- );

-- CREATE TABLE Cliente (
--     ID_Cliente SERIAL PRIMARY KEY,
--     nombre VARCHAR(50) NOT NULL,
--     email VARCHAR(100) UNIQUE NOT NULL,
--     ID_Plus INTEGER,
--     FOREIGN KEY (ID_Plus) 
--         REFERENCES Tajinaste_plus (ID_Plus)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE
-- );

-- CREATE TABLE TelefonoCliente (
--     Telefono SERIAL PRIMARY KEY, -- Columna para el número real de teléfono
--     ID_Cliente INTEGER NOT NULL,       -- El ID_Cliente debe ser del mismo tipo
--     FOREIGN KEY (ID_Cliente) 
--         REFERENCES Cliente (ID_Cliente)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- CREATE TABLE Pedido (
--     ID_Pedido SERIAL PRIMARY KEY,
--     ID_Cliente INTEGER,       -- El ID_Cliente debe ser del mismo tipo
--     FOREIGN KEY (ID_Cliente) 
--         REFERENCES Cliente (ID_Cliente)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     ID_Plus INTEGER,
--     FOREIGN KEY (ID_Plus)
--         REFERENCES Tajinaste_plus (ID_Plus)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE,
--     fecha_pedido DATE NOT NULL,
--     descuento DECIMAL(5, 2) NOT NULL DEFAULT 0.00 CHECK (descuento BETWEEN 0 AND 100), -- Descuento entre 0 y 100
--     -- El descuento se aplica cuando se quiera acceder al dato en el cliente, para no almacenar datos redundantes
--     precio_total NUMERIC(10, 2) NOT NULL,
--     precio_final NUMERIC(10, 2) GENERATED ALWAYS AS (precio_total - (precio_total * (descuento / 100))) STORED, -- Precio final calculado automáticamente

-- );

-- CREATE TABLE Producto_Pedido (
--     ID_Pedido INTEGER NOT NULL, 
--     ID_Producto INTEGER NOT NULL, 
--     cantidad INTEGER NOT NULL,

--     -- Ambas claves foráneas son también la clave primaria compuesta
--     PRIMARY KEY (ID_Pedido, ID_Producto),

--     -- FK 1: Referencia a la tabla Pedido
--     FOREIGN KEY (ID_Pedido) 
--         REFERENCES Pedido (ID_Pedido)
--         ON DELETE RESTRICT -- CUMPLE: Si un pedido se intenta borrar, falla si tiene productos asociados.
--         ON UPDATE CASCADE, -- CUMPLE: Si el ID_Pedido cambia, se actualiza aquí.

--     -- FK 2: Referencia a la tabla Producto
--     FOREIGN KEY (ID_Producto) 
--         REFERENCES Producto (ID_Producto)
--         ON DELETE RESTRICT -- CUMPLE: Si un producto se intenta borrar, falla si está en algún pedido.
--         ON UPDATE CASCADE  -- CUMPLE: Si el ID_Producto cambia, se actualiza aquí.
-- );

-- #######################################################################
-- #                           SECCIÓN 1: LIMPIEZA                         #
-- #######################################################################

-- Eliminación de las tablas en orden inverso de dependencia (IMPRESCINDIBLE)
DROP TABLE IF EXISTS Producto_Pedido;
DROP TABLE IF EXISTS Trabaja;
DROP TABLE IF EXISTS TelefonoCliente;
DROP TABLE IF EXISTS TelefonoEmpleado;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Empleado;
DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS Tajinaste_plus;
DROP TABLE IF EXISTS Zona;


-- #######################################################################
-- #             SECCIÓN 2: CREACIÓN DE TABLAS (ORDEN JERÁRQUICO)        #
-- #######################################################################

-- Nivel 1: Tablas BASE (no dependen de ninguna otra)

CREATE TABLE Empleado (
    ID_Empleado SERIAL PRIMARY KEY,
    salario NUMERIC(10, 2) NOT NULL CHECK (salario >= 800.00), 
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Zona (
    ID_Zona SERIAL PRIMARY KEY,
    tipo_zona VARCHAR(50),
    longitud DECIMAL(9,6), 
    latitud DECIMAL(9,6)   
);

CREATE TABLE Producto (
    ID_Producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio > 0.00)
);

CREATE TABLE Tajinaste_plus (
    ID_Plus SERIAL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_fin DATE NOT NULL CHECK (fecha_fin > fecha_ingreso),
    descuento_plus DECIMAL(5, 2) NOT NULL CHECK (descuento_plus BETWEEN 0 AND 100)
);


-- Nivel 2: Tablas que dependen de Nivel 1 (Entidades de referencia)

CREATE TABLE TelefonoEmpleado (
    ID_Telefono SERIAL PRIMARY KEY, 
    Telefono VARCHAR(20) NOT NULL,
    
    -- ID_Empleado es INTEGER, referenciando a Empleado.ID_Empleado
    ID_Empleado INTEGER NOT NULL,
    
    FOREIGN KEY (ID_Empleado) 
        REFERENCES Empleado (ID_Empleado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Cliente (
    ID_Cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ID_Plus INTEGER,
    
    FOREIGN KEY (ID_Plus) 
        REFERENCES Tajinaste_plus (ID_Plus)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE TelefonoCliente (
    Telefono SERIAL PRIMARY KEY, 
    ID_Cliente INTEGER NOT NULL,       
    
    FOREIGN KEY (ID_Cliente) 
        REFERENCES Cliente (ID_Cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Nivel 3: Tablas N:M sin dependencias de Pedido

CREATE TABLE Trabaja (
    -- CORRECCIÓN: ID_Empleado NO debe ser SERIAL aquí, solo un INTEGER
    ID_Empleado INTEGER NOT NULL,
    ID_Zona INTEGER NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    productividad FLOAT,

    PRIMARY KEY (ID_Empleado, ID_Zona),

    FOREIGN KEY (ID_Empleado) REFERENCES Empleado (ID_Empleado)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE, -- Añadida acción ON UPDATE, que faltaba en tu código
        
    FOREIGN KEY (ID_Zona) REFERENCES Zona (ID_Zona)
        ON DELETE RESTRICT
        ON UPDATE CASCADE -- Añadida acción ON UPDATE
);

CREATE TABLE Stock (
    ID_zona INTEGER NOT NULL, 
    ID_producto INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad >= 0),
    
    PRIMARY KEY (ID_zona, ID_producto),
    
    FOREIGN KEY (ID_zona) 
        REFERENCES Zona (ID_Zona)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    FOREIGN KEY (ID_producto) 
        REFERENCES Producto (ID_Producto)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


-- Nivel 4: Tablas que dependen de Tablas Nivel 1 y 2 (Ej: Pedido)

CREATE TABLE Pedido (
    ID_Pedido SERIAL PRIMARY KEY,
    ID_Cliente INTEGER NOT NULL, -- Debe ser NOT NULL para un pedido válido
    ID_Plus INTEGER,
    fecha_pedido DATE NOT NULL,
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0.00 CHECK (descuento BETWEEN 0 AND 100),
    precio_total NUMERIC(10, 2) NOT NULL CHECK (precio_total >= 0.00),
    
    -- CORRECCIÓN: Se elimina la coma redundante antes del paréntesis final.
    precio_final NUMERIC(10, 2) GENERATED ALWAYS AS (
        precio_total * (1 - descuento / 100.00)
    ) STORED, 
    
    FOREIGN KEY (ID_Cliente) 
        REFERENCES Cliente (ID_Cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    FOREIGN KEY (ID_Plus)
        REFERENCES Tajinaste_plus (ID_Plus)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- Nivel 5: Tablas N:M que dependen de Pedido (Ej: Producto_Pedido)

CREATE TABLE Producto_Pedido (
    ID_Pedido INTEGER NOT NULL, 
    ID_Producto INTEGER NOT NULL, 
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),

    PRIMARY KEY (ID_Pedido, ID_Producto),

    FOREIGN KEY (ID_Pedido) 
        REFERENCES Pedido (ID_Pedido)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,

    FOREIGN KEY (ID_Producto) 
        REFERENCES Producto (ID_Producto)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE  
);



-- EJEMPLOS DE INSERCIÓN DE DATOS

-- TABLAS SIN DEPENDENCIAS (Nivel 1)
INSERT INTO Empleado (salario, nombre) VALUES
(1200.00, 'Laura Pérez'),
(1500.50, 'Carlos Gómez'),
(1800.00, 'Marta Díaz'),
(950.00, 'José Santana'),
(2100.75, 'Ana Morales');


INSERT INTO Zona (tipo_zona, longitud, latitud) VALUES
('Centro', -16.251234, 28.468956),
('Norte', -16.351654, 28.578943),
('Sur', -16.720312, 28.050874),
('Este', -16.422133, 28.490110),
('Oeste', -16.512789, 28.460321);


INSERT INTO Producto (nombre, precio) VALUES
('Café Premium', 4.50),
('Té Verde', 3.20),
('Chocolate Artesanal', 5.80),
('Miel de Palma', 6.00),
('Galletas Integrales', 2.90);


INSERT INTO Tajinaste_plus (descripcion, fecha_ingreso, fecha_fin, descuento_plus) VALUES
('Descuento Primavera', '2025-03-01', '2025-05-31', 10.00),
('Black Friday', '2025-11-01', '2025-11-30', 25.00),
('Navidad', '2025-12-01', '2025-12-31', 15.00),
('Verano Dorado', '2025-06-01', '2025-08-31', 20.00),
('Clientes VIP', '2025-01-01', '2025-12-31', 30.00);


-- TABLAS CON DEPENDENCIAS DE NIVEL 1 (Nivel 2)
INSERT INTO TelefonoEmpleado (Telefono, ID_Empleado) VALUES
('611223344', 1),
('612334455', 2),
('613445566', 3),
('614556677', 4),
('615667788', 5);

INSERT INTO Cliente (nombre, email, ID_Plus) VALUES
('Sofía Morales', 'sofia@example.com', 1),
('Pedro Cabrera', 'pedro@example.com', 2),
('Lucía Herrera', 'lucia@example.com', 3),
('Andrés Alonso', 'andres@example.com', NULL),
('Elena Martín', 'elena@example.com', 5);

INSERT INTO TelefonoCliente (ID_Cliente) VALUES
(1),
(2),
(3),
(4),
(5);


-- TABLAS N:M SIN DEPENDENCIAS DE PEDIDO (Nivel 3)
INSERT INTO Trabaja (ID_Empleado, ID_Zona, fecha_inicio, fecha_fin, productividad) VALUES
(1, 1, '2025-01-01', '2025-12-31', 0.95),
(2, 2, '2025-02-01', '2025-12-31', 0.88),
(3, 3, '2025-03-01', '2025-12-31', 0.92),
(4, 4, '2025-04-01', '2025-12-31', 0.80),
(5, 5, '2025-05-01', '2025-12-31', 0.97);

INSERT INTO Stock (ID_Zona, ID_Producto, cantidad) VALUES
(1, 1, 120),
(2, 2, 80),
(3, 3, 60),
(4, 4, 100),
(5, 5, 90);


-- Nivel 4 – Tablas dependientes (Pedidos)
INSERT INTO Pedido (ID_Cliente, ID_Plus, fecha_pedido, descuento, precio_total) VALUES
(1, 1, '2025-03-15', 10.00, 50.00),
(2, 2, '2025-11-20', 25.00, 120.00),
(3, 3, '2025-12-10', 15.00, 80.00),
(4, NULL, '2025-04-05', 0.00, 45.00),
(5, 5, '2025-07-18', 30.00, 200.00);

-- Nivel 5 – Tablas N:M dependientes de Pedido
INSERT INTO Producto_Pedido (ID_Pedido, ID_Producto, cantidad) VALUES
(1, 1, 3),
(2, 3, 2),
(3, 2, 4),
(4, 5, 1),
(5, 4, 5);


-- #######################################################################
-- #             SECCIÓN 3: VISUALIZACIÓN DE DATOS                       #
-- #######################################################################

-- Visualizar tablas (sobretodo las que tienen claves foráneas)

SELECT * FROM Producto;

SELECT * FROM Producto_Pedido;

SELECT * FROM Pedido;

SELECT * FROM Stock;

-- #######################################################################
-- #             SECCIÓN 4: PRUEBA DE ELIMINACIÓN DE DATOS               #
-- #######################################################################
-- Prueba de eliminación en tablas con dependencias

-- Eliminacion de producto pedido

DELETE FROM Producto_Pedido WHERE ID_Pedido = 1 AND ID_Producto = 1;

-- Mostrar la tabla para verificar
SELECT * FROM Producto_Pedido;

-- Eliminacion de producto (se debe de eliminar la entrada en stock y en producto_pedido)

DELETE FROM Producto WHERE ID_Producto = 1;

-- Mostrar las tablas para verificar
SELECT * FROM Producto;
SELECT * FROM Stock;
SELECT * FROM Producto_Pedido;
