USE MARFARMA_DB;
GO

-- ==========================================
-- TRIGGER 1: trg_AuditoriaVentas
-- OBJETIVO: Registrar en la tabla Auditoria cuando se inserte o elimine una Venta.
-- ==========================================
CREATE OR ALTER TRIGGER trg_AuditoriaVentas
ON Ventas
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @usuario VARCHAR(100) = SYSTEM_USER;
    DECLARE @fecha DATETIME = GETDATE();
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO Auditoria (tabla, operacion, usuario, fecha, descripcion)
        SELECT 'Ventas', 'INSERT', @usuario, @fecha, 'Se registró la venta ID: ' + id_venta
        FROM inserted;
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO Auditoria (tabla, operacion, usuario, fecha, descripcion)
        SELECT 'Ventas', 'DELETE', @usuario, @fecha, 'Se eliminó la venta ID: ' + id_venta
        FROM deleted;
    END
END;
GO

-- ==========================================
-- TRIGGER 2: trg_IntegridadVentas
-- OBJETIVO: Evitar que se inserten detalles de venta con cantidad negativa o cero.
-- ==========================================
CREATE OR ALTER TRIGGER trg_IntegridadVentas
ON DetalleVenta
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE cantidad <= 0)
    BEGIN
        RAISERROR ('La cantidad del producto debe ser mayor a cero.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv)
    SELECT id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv FROM inserted;
END;
GO
