CREATE DATABASE TRABAJO_GRUPAL;
GO

USE TRABAJO_GRUPAL;
GO

-- Actividad 1
-- Creacion de tablas y restricciones


-- tabla clientes
CREATE TABLE Clientes
(
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(8) NOT NULL UNIQUE,
    Nombre VARCHAR(60) NOT NULL,
    Correo VARCHAR(100) UNIQUE,
    Telefono VARCHAR(15),
    Estado VARCHAR(10) DEFAULT 'Activo',

    CHECK (Estado IN ('Activo', 'Inactivo'))
);
GO


-- tabla categorias
CREATE TABLE Categorias
(
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL UNIQUE
);
GO


-- tabla productos
CREATE TABLE Productos
(
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    IdCategoria INT NOT NULL,
    NombreProducto VARCHAR(80) NOT NULL UNIQUE,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0,

    CHECK (Precio > 0),
    CHECK (Stock >= 0),

    FOREIGN KEY (IdCategoria)
    REFERENCES Categorias(IdCategoria)
);
GO


-- tabla pedidos
CREATE TABLE Pedidos
(
    IdPedido INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    FechaPedido DATETIME DEFAULT GETDATE(),
    Estado VARCHAR(15) DEFAULT 'Pendiente',

    CHECK (Estado IN ('Pendiente', 'Pagado', 'Anulado')),

    FOREIGN KEY (IdCliente)
    REFERENCES Clientes(IdCliente)
);
GO


-- tabla detalle pedido
CREATE TABLE DetallePedido
(
    IdDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IdPedido INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,

    CHECK (Cantidad > 0),
    CHECK (PrecioUnitario > 0),

    FOREIGN KEY (IdPedido)
    REFERENCES Pedidos(IdPedido),

    FOREIGN KEY (IdProducto)
    REFERENCES Productos(IdProducto)
);
GO


-- insertar clientes
INSERT INTO Clientes (DNI, Nombre, Correo, Telefono)
VALUES ('74125896', 'yamvictor', 'yamvictor@gmail.com', '987654321');

INSERT INTO Clientes (DNI, Nombre, Correo, Telefono)
VALUES ('85214763', 'gasculo', 'gasculo@gmail.com', '986123456');

INSERT INTO Clientes (DNI, Nombre, Correo, Telefono)
VALUES ('96325874', 'panchis', 'panchis@gmail.com', '985741236');

INSERT INTO Clientes (DNI, Nombre, Correo, Telefono)
VALUES ('65412398', 'gustavo67', 'gustavo67@gmail.com', '984521369');
GO


-- insertar categorias
INSERT INTO Categorias (NombreCategoria)
VALUES ('Tecnologia');

INSERT INTO Categorias (NombreCategoria)
VALUES ('Accesorios');

INSERT INTO Categorias (NombreCategoria)
VALUES ('Oficina');
GO


-- insertar productos
INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(1, 'Laptop Lenovo', 2500.00, 10);

INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(1, 'Monitor Samsung', 750.00, 15);

INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(2, 'Mouse Logitech', 85.00, 30);

INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(2, 'Teclado Redragon', 160.00, 20);

INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(3, 'Silla de Oficina', 450.00, 8);
GO


-- insertar pedidos
INSERT INTO Pedidos (IdCliente, Estado)
VALUES (1, 'Pagado');

INSERT INTO Pedidos (IdCliente, Estado)
VALUES (2, 'Pendiente');

INSERT INTO Pedidos (IdCliente, Estado)
VALUES (3, 'Pagado');

INSERT INTO Pedidos (IdCliente, Estado)
VALUES (4, 'Pendiente');
GO


-- insertar detalle de pedidos
INSERT INTO DetallePedido
(IdPedido, IdProducto, Cantidad, PrecioUnitario)
VALUES (1, 1, 1, 2500.00);

INSERT INTO DetallePedido
(IdPedido, IdProducto, Cantidad, PrecioUnitario)
VALUES (1, 3, 2, 85.00);

INSERT INTO DetallePedido
(IdPedido, IdProducto, Cantidad, PrecioUnitario)
VALUES (2, 2, 1, 750.00);

INSERT INTO DetallePedido
(IdPedido, IdProducto, Cantidad, PrecioUnitario)
VALUES (3, 4, 1, 160.00);

INSERT INTO DetallePedido
(IdPedido, IdProducto, Cantidad, PrecioUnitario)
VALUES (4, 5, 2, 450.00);
GO


-- comprobar los datos
SELECT * FROM Clientes;
SELECT * FROM Categorias;
SELECT * FROM Productos;
SELECT * FROM Pedidos;
SELECT * FROM DetallePedido;
GO


-- prueba de restriccion

/*INSERT INTO Productos
(IdCategoria, NombreProducto, Precio, Stock)
VALUES
(1, 'Producto Prueba', -100.00, 5);*/

-- Actividad 2: Consultas de selección, filtros y agrupación
-- Elaborado por: Mauricio Rojas

-- Requerimiento 1: Identificar productos de las categorías 1 (Tecnología) y 2 (Accesorios)
-- cuyo nombre contenga la letra 'o', estandarizando su presentación y calculando su valor bruto.
SELECT 
    UPPER(NombreProducto) AS Producto_Mayuscula, 
    Precio,
    Stock,
    (Precio * Stock) AS ValorTotalInventario, 
    ROUND(Precio * 1.18, 2) AS PrecioConIGV 
FROM 
    Productos
WHERE 
    IdCategoria IN (1, 2) 
    AND NombreProducto LIKE '%o%' 
    AND Precio BETWEEN 50.00 AND 3000.00; 
GO

-- Requerimiento 2: Calcular el monto total facturado por cada pedido,
-- mostrando únicamente aquellos pedidos que superen los 200.00 en su total acumulado.
SELECT 
    IdPedido,
    COUNT(IdProducto) AS CantidadItemsDiferentes, 
    SUM(Cantidad * PrecioUnitario) AS MontoTotalFacturado 
FROM 
    DetallePedido
GROUP BY 
    IdPedido 
HAVING 
    SUM(Cantidad * PrecioUnitario) > 200.00; 
GO

