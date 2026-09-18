USE MARFARMA_DB;
GO

-- Crear índice para mejorar consultas por fecha en Ventas
CREATE NONCLUSTERED INDEX IX_Ventas_Fecha 
ON Ventas (fecha)
INCLUDE (id_cliente, total);
GO

-- Mostrar cómo revisar el plan de ejecución
-- En SSMS, activar "Include Actual Execution Plan" y ejecutar:
-- SELECT * FROM Ventas WHERE fecha BETWEEN '2026-01-01' AND '2026-06-30';
