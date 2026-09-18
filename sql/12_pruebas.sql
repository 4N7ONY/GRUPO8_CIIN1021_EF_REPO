USE MARFARMA_DB;
GO

-- ==========================================
-- PRUEBAS DEL SISTEMA MARFARMA
-- ==========================================

-- Prueba 1: Inserción correcta de una venta (Procedimiento almacenado)
-- Resultado esperado: 'Venta registrada exitosamente.'
EXEC sp_RegistrarVenta 
    @id_venta = 'V99999', 
    @id_cliente = 'CLI165', 
    @id_vendedor = 'VEN005', 
    @metodo_pago = 'Yape', 
    @id_producto = 'PROD055', 
    @cantidad = 2, 
    @precio_unitario = 72.40, 
    @descuento = 0;
GO

-- Prueba 2: Función escalar fn_CalcularTotalVenta
-- Resultado esperado: Devuelve el total correcto con IGV (aprox 170.86)
SELECT dbo.fn_CalcularTotalVenta(2, 72.40, 0) AS TotalVentaCalculado;
GO

-- Prueba 3: Trigger de Auditoría
-- Resultado esperado: Debe mostrar que el INSERT se registró en Auditoria
SELECT * FROM Auditoria ORDER BY fecha DESC;
GO

-- Prueba 4: Restricción de Integridad (Trigger trg_IntegridadVentas)
-- Resultado esperado: Mostrar error "La cantidad del producto debe ser mayor a cero." y anular transacción
BEGIN TRY
    INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv)
    VALUES ('V99999', 'PROD003', -1, 5.00, -5.00, 0, 0);
END TRY
BEGIN CATCH
    PRINT 'Prueba 4 exitosa. El trigger bloqueó la inserción: ' + ERROR_MESSAGE();
END CATCH
GO

-- Prueba 5: Rollback ante error general
-- Resultado esperado: La venta V99998 no debe existir en Ventas, pues el producto no existe y rompe FK
EXEC sp_RegistrarVenta 
    @id_venta = 'V99998', 
    @id_cliente = 'CLI165', 
    @id_vendedor = 'VEN005', 
    @metodo_pago = 'Efectivo', 
    @id_producto = 'PROD_INVALIDO', 
    @cantidad = 1, 
    @precio_unitario = 10, 
    @descuento = 0;

SELECT * FROM Ventas WHERE id_venta = 'V99998'; -- No debe retornar nada
GO

-- Prueba 6: Consulta analítica
-- Resultado esperado: Top 5 de ingresos por producto actualizado
SELECT TOP 5 p.nombre_producto, SUM(dv.subtotal) AS ingresos_generados
FROM DetalleVenta dv
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Ventas v ON dv.id_venta = v.id_venta
WHERE v.estado_venta = 'Completada'
GROUP BY p.nombre_producto
ORDER BY ingresos_generados DESC;
GO
