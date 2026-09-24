CREATE DATABASE TRABAJO_GRUPAL;
GO

USE TRABAJO_GRUPAL;
GO

-- =========================================
-- ACTIVIDAD 3
-- CONSULTAS MULTITABLA
-- =========================================

-- 1. INNER JOIN
SELECT ...
FROM Tabla1
INNER JOIN Tabla2
ON Tabla1.Id = Tabla2.Id;

-- 2. LEFT OUTER JOIN
SELECT ...
FROM Tabla1
LEFT JOIN Tabla2
ON Tabla1.Id = Tabla2.Id;

-- 3. CASE
SELECT ...,
CASE
    WHEN condicion THEN 'Texto 1'
    ELSE 'Texto 2'
END AS Resultado
FROM Tabla1;

-- 4. UNION
SELECT ...
FROM Tabla1

UNION

SELECT ...
FROM Tabla2;