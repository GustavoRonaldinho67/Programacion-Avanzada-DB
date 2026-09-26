CREATE DATABASE TRABAJO_GRUPAL;
GO

USE TRABAJO_GRUPAL;
GO

-- =========================================================================
-- Actividad 1: Creacion de tablas y restricciones
-- =========================================================================
-- Elaborado por: Gustavo Muñoz

-- =========================================================================
-- INICIO DEL BLOQUE DE LIMPIEZA PREVENTIVA
-- =========================================================================
-- Esto elimina las tablas si ya existen, evitando errores al ejecutar el script múltiples veces.
-- El orden de eliminación es inverso al de creación (por las dependencias de llaves foráneas).
IF OBJECT_ID('DetallePedido', 'U') IS NOT NULL DROP TABLE DetallePedido;
IF OBJECT_ID('Pedidos', 'U') IS NOT NULL DROP TABLE Pedidos;
IF OBJECT_ID('Productos', 'U') IS NOT NULL DROP TABLE Productos;
IF OBJECT_ID('Categorias', 'U') IS NOT NULL DROP TABLE Categorias;
IF OBJECT_ID('Clientes', 'U') IS NOT NULL DROP TABLE Clientes;
GO
-- =========================================================================
-- FIN DEL BLOQUE DE LIMPIEZA PREVENTIVA
-- =========================================================================

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

-- =========================================================================
-- Actividad 2: Consultas de selección, filtros y agrupación
-- =========================================================================
-- Elaborado por: Leandro Henostroza (Optimizado por Mauricio Rojas)

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

-- =========================================================================
-- Actividad 3: Consultas multitabla y consolidación de resultados
-- =========================================================================
-- Elaborado por: Mauricio Rojas

-- Requerimiento 3.1: Clasificar el valor comercial de todos los clientes, 
-- incluyendo aquellos que aún no tienen transacciones registradas.
-- Implementación técnica: LEFT OUTER JOIN, INNER JOIN y CASE.
SELECT 
    C.DNI,
    C.Nombre,
    ISNULL(SUM(DP.Cantidad * DP.PrecioUnitario), 0) AS TotalFacturado,
    CASE 
        WHEN SUM(DP.Cantidad * DP.PrecioUnitario) >= 2000 THEN 'Cliente VIP'
        WHEN SUM(DP.Cantidad * DP.PrecioUnitario) > 0 AND SUM(DP.Cantidad * DP.PrecioUnitario) < 2000 THEN 'Cliente Regular'
        ELSE 'Prospecto (Sin Compras)'
    END AS CategoriaComercial
FROM 
    Clientes C
LEFT OUTER JOIN Pedidos P ON C.IdCliente = P.IdCliente
LEFT OUTER JOIN DetallePedido DP ON P.IdPedido = DP.IdPedido
GROUP BY 
    C.DNI, C.Nombre;
GO

-- Requerimiento 3.2: Consolidar un reporte operativo del estado del inventario.
-- Implementación técnica: UNION para unificar dos conjuntos de datos independientes.
SELECT 
    NombreProducto, 
    Stock, 
    'Inventario Crítico (Requiere Reposición)' AS EstadoStock
FROM 
    Productos 
WHERE 
    Stock < 15
UNION
SELECT 
    NombreProducto, 
    Stock, 
    'Inventario Óptimo' AS EstadoStock
FROM 
    Productos 
WHERE 
    Stock >= 15;
GO

-- =========================================================================
-- Actividad 4: Subconsultas y contraste de alternativas
-- =========================================================================
-- Elaborado por: Mauricio Rojas

-- Requerimiento 4.1: Identificar productos cuyo precio está por encima de la media del mercado.
-- Implementación técnica: Subconsulta en la cláusula WHERE.
SELECT 
    NombreProducto, 
    Precio,
    (SELECT AVG(Precio) FROM Productos) AS PrecioPromedioGlobal
FROM 
    Productos 
WHERE 
    Precio > (SELECT AVG(Precio) FROM Productos);
GO

-- Requerimiento 4.2: Aislar clientes que representan un riesgo financiero (pedidos pendientes).
-- Implementación técnica: Cláusula EXISTS (optimización de rendimiento frente a IN o JOIN).
SELECT 
    C.Nombre, 
    C.Correo,
    C.Telefono
FROM 
    Clientes C
WHERE EXISTS (
    SELECT 1 
    FROM Pedidos P 
    WHERE P.IdCliente = C.IdCliente 
    AND P.Estado = 'Pendiente'
);
GO