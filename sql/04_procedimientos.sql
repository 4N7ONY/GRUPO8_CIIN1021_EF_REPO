USE MARFARMA_DB;
GO

-- ==========================================
-- PROCEDIMIENTO: sp_RegistrarVenta
-- OBJETIVO: Registrar una nueva venta y su detalle asociado.
-- UTILIZA: TRY/CATCH, TRANSACCIÓN, COMMIT, ROLLBACK.
-- ==========================================
CREATE OR ALTER PROCEDURE sp_RegistrarVenta (
    @id_venta VARCHAR(20),
    @id_cliente VARCHAR(20),
    @id_vendedor VARCHAR(20),
    @metodo_pago VARCHAR(50),
    @id_producto VARCHAR(20),
    @cantidad INT,
    @precio_unitario DECIMAL(10,2),
    @descuento DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @subtotal DECIMAL(10,2) = @cantidad * @precio_unitario;
    DECLARE @igv DECIMAL(10,2) = (@subtotal - @descuento) * 0.18;
    DECLARE @total DECIMAL(10,2) = (@subtotal - @descuento) + @igv;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insertar la Venta
        INSERT INTO Ventas (id_venta, fecha, hora, id_cliente, id_vendedor, metodo_pago, estado_venta, total)
        VALUES (@id_venta, GETDATE(), CAST(GETDATE() AS TIME), @id_cliente, @id_vendedor, @metodo_pago, 'Completada', @total);
        
        -- Insertar el Detalle
        INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv)
        VALUES (@id_venta, @id_producto, @cantidad, @precio_unitario, @subtotal, @descuento, @igv);
        
        COMMIT TRANSACTION;
        PRINT 'Venta registrada exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error al registrar la venta: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- ==========================================
-- PROCEDIMIENTO: sp_ReporteVentas
-- OBJETIVO: Consultar ventas filtrando por fechas, producto y método de pago.
-- ==========================================
CREATE OR ALTER PROCEDURE sp_ReporteVentas (
    @fecha_inicio DATE = NULL,
    @fecha_fin DATE = NULL,
    @id_producto VARCHAR(20) = NULL,
    @metodo_pago VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        v.id_venta,
        v.fecha,
        c.nombre_cliente,
        p.nombre_producto,
        dv.cantidad,
        v.total,
        v.metodo_pago
    FROM Ventas v
    INNER JOIN Clientes c ON v.id_cliente = c.id_cliente
    INNER JOIN DetalleVenta dv ON v.id_venta = dv.id_venta
    INNER JOIN Productos p ON dv.id_producto = p.id_producto
    WHERE 
        (@fecha_inicio IS NULL OR v.fecha >= @fecha_inicio) AND
        (@fecha_fin IS NULL OR v.fecha <= @fecha_fin) AND
        (@id_producto IS NULL OR p.id_producto = @id_producto) AND
        (@metodo_pago IS NULL OR v.metodo_pago = @metodo_pago)
    ORDER BY v.fecha DESC;
END;
GO
