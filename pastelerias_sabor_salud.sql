-- CREATE DATABASE pastelerias_sabor_salud;
CREATE DATABASE pastelerias_sabor_salud;
USE pastelerias_sabor_salud;

CREATE TABLE Cliente (
    dni_cliente VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    afiliado BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;

-- Inserción de datos Clientes
INSERT INTO Cliente (dni_cliente, nombre, apellido, direccion, afiliado)
VALUES
('12345678A', 'Fiona', 'Flores', 'Madrid, Salamanca', TRUE),
('23456789B', 'Cloe', 'Dugart', 'Madrid, Serrano', FALSE),
('34567890C', 'Luis', 'Martínez', 'Madrid, Chamberí', TRUE),
('45678901D', 'Marta', 'López', 'Madrid, Centro', FALSE),
('56789012E', 'Carlos', 'García', 'Madrid, Retiro', TRUE),
('67890123F', 'Lucía', 'Fernández', 'Madrid, Vallecas', FALSE),
('78901234G', 'Javier', 'Sánchez', 'Madrid, Chamartín', TRUE),
('89012345H', 'Elena', 'Torres', 'Madrid, Moncloa', FALSE),
('90123456I', 'Pablo', 'Ruiz', 'Madrid, Carabanchel', TRUE),
('01234567J', 'Andrea', 'Díaz', 'Madrid, Latina', FALSE);

-- Buscar clientes cuyo nombre comience con "A" 
SELECT * FROM Cliente WHERE nombre LIKE 'A%';

-- Buscar clientes cuyo apellido comience con "G" 
SELECT * FROM Cliente WHERE apellido = 'García';

-- Buscar clientes cuyo nombre empiece con "A" o "C"
SELECT * FROM Cliente WHERE nombre REGEXP '^(A|C)';

CREATE TABLE Telefonos (
    numero DECIMAL(9) PRIMARY KEY,
    dni_cliente VARCHAR(9),
    FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Telefonos (numero, dni_cliente)
VALUES
(612345678, '12345678A'),
(612345679, '23456789B'),
(612345680, '34567890C'),
(612345681, '45678901D'),
(612345682, '56789012E'),
(612345683, '67890123F'),
(612345684, '78901234G'),
(612345685, '89012345H'),
(612345686, '90123456I'),
(612345687, '01234567J');

--Verificar 
SELECT * FROM Telefonos;

CREATE TABLE Pedido (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dni_cliente VARCHAR(9),
    fecha DATE NOT NULL,
    total DECIMAL(9,2) NOT NULL,
    estado ENUM('Pendiente', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Pedido (dni_cliente, fecha, total)
VALUES
('12345678A', '2025-02-01', 50.00),
('23456789B', '2025-02-01', 30.00);

--Verificar la estructura de la tabla 
DESCRIBE Pedido;

CREATE TABLE Producto (
    codigo_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    categoria SET('Dulce', 'Salado', 'Bebida') NOT NULL,
    precio DECIMAL(9,2) NOT NULL,
    duracion TIME NOT NULL
) ENGINE=InnoDB;

-- Insertar productos
INSERT INTO Producto (nombre, categoria, precio, duracion)
VALUES
('Tarta de Zanahoria', 'Dulce', 15.00, '01:30:00'),
('Tarta de Chocolate Vegana', 'Dulce', 20.00, '02:00:00'),
('Galletas sin Gluten', 'Dulce', 5.00, '00:45:00'),
('Brownie sin Azúcar', 'Dulce', 18.00, '01:20:00'),
('Magdalenas de Avena', 'Dulce', 12.00, '00:50:00'),
('Pan Integral', 'Salado', 3.00, '00:40:00'),
('Cupcake Vegano', 'Dulce', 10.00, '00:35:00'),
('Bizcocho Integral', 'Dulce', 8.00, '01:00:00'),
('Batidos Saludables', 'Bebida', 14.00, '00:15:00');

DESCRIBE Producto;

-- Buscar productos cuyo nombre contenga la palabra "tarta"
SELECT * FROM Producto WHERE nombre LIKE '%tarta%';

-- Buscar productos cuyo nombre comience con "ch" o termine con "a"
SELECT * FROM Producto WHERE nombre REGEXP '^ch|a$';

-- Excluir productos cuyo nombre contenga la palabra "azúcar"
SELECT * FROM Producto WHERE nombre NOT LIKE '%azúcar%';

-- Buscar el producto (o productos) con el precio más bajo en la tabla "Producto"
SELECT codigo_producto, nombre, precio
FROM Producto
WHERE precio = (SELECT MIN(precio) FROM Producto);

--Agregar una columna llamada DESCRIPCION para busqueda de TEXTO
ALTER TABLE Producto ADD COLUMN descripcion TEXT;

--Actualizar Producto con DESCRIPCION
UPDATE Producto SET descripcion = 'Deliciosa tarta de chocolate' WHERE codigo_producto = 1;
UPDATE Producto SET descripcion = 'Tarta de fresa con crema' WHERE codigo_producto = 2;

--Ver los datos en la columna descripcion
SELECT descripcion FROM Producto;

--Crear un índice FULLTEXT si deseo búsquedas de texto completo
ALTER TABLE Producto ADD FULLTEXT(descripcion);

--Hacer búsquedas avanzadas en la descripción
SELECT * FROM Producto WHERE MATCH(descripcion) AGAINST ('tarta');

--producto con el precio más bajo, puedes usar una subconsulta en la cláusula WHERE
SELECT nombre, precio
FROM Producto
WHERE precio = (SELECT MIN(precio) FROM Producto);

--Listar los productos cuyo idproducto acabe en 2.
select * from Producto where codigo_producto like "%2";

CREATE TABLE Ingredientes (
    id_ingrediente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo SET('Natural', 'Procesado') NOT NULL
) ENGINE=InnoDB;

INSERT INTO Ingredientes (nombre, tipo)
VALUES
('Manzana', 'Natural'),
('Harina integral', 'Procesado'),
('Avena', 'Natural'),
('Naranja', 'Natural');

CREATE TABLE Contener (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED,
    cantidad DECIMAL(5,2) NOT NULL,
    id_ingrediente INT UNSIGNED,
    FOREIGN KEY (id_producto) REFERENCES Producto(codigo_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Contener (id_producto, cantidad, id_ingrediente)
VALUES
(1, 2.00, 1),
(2, 1.50, 2),
(3, 1.00, 3),
(4, 2.00, 4),
(5, 1.50, 3),  -- Magdalenas de Avena con Avena
(6, 3.00, 2),  -- Pan Integral con Harina Integral
(7, 1.00, 1),  -- Cupcake Vegano con Manzana
(8, 2.00, 2),  -- Bizcocho Integral con Harina Integral
(9, 1.50, 3),  -- Batidos Saludables con Avena
(2, 2.50, 4); -- Tarta de Chocolate Vegana con Naranja

-- Obtener los productos con sus ingredientes
--p.nombre (nombre del producto) → Se muestra como Producto
--i.nombre (nombre del ingrediente) → Se muestra como Ingrediente
--c.cantidad (cantidad del ingrediente usado)

SELECT p.nombre AS Producto, i.nombre AS Ingrediente, c.cantidad
FROM Contener c
JOIN Producto p ON c.id_producto = p.codigo_producto
JOIN Ingredientes i ON c.id_ingrediente = i.id_ingrediente;

CREATE TABLE Trabajadores (
    id_trabajador INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    telefono DECIMAL(9),
    id_supervisor INT UNSIGNED NULL,
    FOREIGN KEY (id_supervisor) REFERENCES Trabajadores(id_trabajador)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Trabajadores (nombre, apellido, direccion, telefono, id_supervisor)
VALUES
('Juan', 'Pérez', 'Madrid, La Castellana', 612345680, NULL),  -- Juan Pérez
('María', 'López', 'Madrid, Chamberí', 612345683, NULL),  -- María López
('Carlos', 'García', 'Madrid, Centro', 612345684, NULL),  -- Carlos García
('Luisa', 'Fernández', 'Madrid, Vallecas', 612345685, NULL),  -- Luisa Fernández
('Pablo', 'Ruiz', 'Madrid, Retiro', 612345686, NULL),  -- Pablo Ruiz
('Andrea', 'Torres', 'Madrid, Moncloa', 612345687, NULL),  -- Andrea Torres
('David', 'Martín', 'Madrid, Chamartín', 612345688, NULL),  -- David Martín
('Roman', 'Pérez', 'Madrid, Carabanchel', 612345689, NULL),  -- Roman Pérez
('Pedro', 'Gómez', 'Madrid, Sol', 612345690, NULL);  -- Pedro Gómez (Administrativo)

CREATE TABLE Elaborar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo_producto INT UNSIGNED NOT NULL,
    id_trabajador INT UNSIGNED NOT NULL,
    FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_trabajador) REFERENCES Trabajadores(id_trabajador)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Elaborar (codigo_producto, id_trabajador)
VALUES
(1, 1),
(2, 2),
(3, 3),  -- Galletas sin Gluten por María López
(4, 4),  -- Brownie sin Azúcar por Carlos García
(5, 5),  -- Magdalenas de Avena por Luisa Fernández
(6, 6),  -- Pan Integral por Pablo Ruiz
(7, 7),  -- Cupcake Vegano por Andrea Torres
(8, 8),  -- Bizcocho Integral por David Martín
(9, 9);  -- Batidos Saludables por Roman Pérez

CREATE TABLE Contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_trabajador INT UNSIGNED,
    fecha DATE NOT NULL,
    cargo SET('Pastelero', 'Repostero', 'Administrativo', 'Repartidor',  'Encargado de Ventas', 'Marketing', 'Logística', 'Dietista', 
               'Desarrollo Web', 'Chef Principal') NOT NULL,
    sueldo DECIMAL(9,2) NOT NULL CHECK (sueldo >= 0), 
    FOREIGN KEY (id_trabajador) REFERENCES Trabajadores(id_trabajador)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Contrato (id_trabajador, fecha, cargo, sueldo)
VALUES
(1, '2025-02-01', 'Pastelero', 1500.00),       -- Juan Pérez, Pastelero
(2, '2025-02-01', 'Encargado de Ventas', 1600.00),  -- María López, Encargada de Ventas
(3, '2025-02-01', 'Pastelero', 1500.00),       -- Carlos García, Pastelero
(4, '2025-02-01', 'Marketing', 1400.00),        -- Luisa Fernández, Marketing
(5, '2025-02-01', 'Logística', 1100.00),        -- Pablo Ruiz, Logística
(6, '2025-02-01', 'Dietista', 1300.00),         -- Andrea Torres, Dietista
(7, '2025-02-01', 'Desarrollo Web', 1800.00),   -- David Martín, Desarrollo Web
(8, '2025-02-01', 'Repartidor', 1100.00),       -- Roman Pérez, Repartidor
(9, '2025-02-01', 'Administrativo', 1000.00);   -- Pedro Gómez, Administrativo

CREATE TABLE Vehiculos (
    codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tipo SET('Camión', 'Coche', 'Moto') NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50)
) ENGINE=InnoDB;

INSERT INTO Vehiculos (tipo, marca, modelo)
VALUES
('Camión', 'Mercedes', 'Actros'),
('Coche', 'Audi', 'A4'),
('Moto', 'Yamaha', 'YZF-R1'),
('Camión', 'Volvo', 'FH16'),
('Coche', 'Ford', 'Focus'),
('Moto', 'Honda', 'CBR1000RR');

CREATE TABLE Repartir (
    codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNSIGNED,
    id_trabajador INT UNSIGNED,
    id_vehiculo INT UNSIGNED,
    hora TIME NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_trabajador) REFERENCES Trabajadores(id_trabajador)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(codigo)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Repartir (id_pedido, id_trabajador, id_vehiculo, hora, fecha)
VALUES
(1, 2, 3, '10:00:00', '2025-03-09 10:00:00'),
(2, 1, 4, '12:00:00', '2025-03-09 12:00:00'),
(1, 3, 5, '14:30:00', '2025-03-09 14:30:00'),
(2, 4, 6, '16:45:00', '2025-03-09 16:45:00'),
(1, 5, 3, '09:00:00', '2025-03-09 09:00:00');

CREATE TABLE Administrativo (
    codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    area_gestion ENUM('Ventas', 'Compras', 'Recursos Humanos', 'Contabilidad') NOT NULL,
    id_trabajador INT UNSIGNED,
    FOREIGN KEY (id_trabajador) REFERENCES Trabajadores(id_trabajador)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Comprar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cantidad DECIMAL(5,2) NOT NULL,
    id_producto INT UNSIGNED,
    id_pedido INT UNSIGNED,
    FOREIGN KEY (id_producto) REFERENCES Producto(codigo_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Comprar (cantidad, id_producto, id_pedido)
VALUES
(3.00, 3, 1),  -- Galletas sin Gluten en el pedido 1
(2.00, 4, 2),  -- Brownie sin Azúcar en el pedido 2
(1.00, 5, 1),  -- Magdalenas de Avena en el pedido 1
(4.00, 6, 2);  -- Pan Integral en el pedido 2

SHOW TABLES;
DESCRIBE Cliente;
DESCRIBE Vehiculos;

