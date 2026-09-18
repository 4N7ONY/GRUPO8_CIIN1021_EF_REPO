USE MARFARMA_DB;
GO

-- ==========================================
-- FUNCIÓN: fn_CalcularTotalVenta
-- OBJETIVO: Calcular el total de una venta sumando su subtotal, menos descuentos, más IGV.
-- ==========================================
CREATE OR ALTER FUNCTION fn_CalcularTotalVenta (
    @cantidad INT,
    @precio_unitario DECIMAL(10,2),
    @descuento DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @subtotal DECIMAL(10,2) = @cantidad * @precio_unitario;
    DECLARE @igv DECIMAL(10,2) = (@subtotal - @descuento) * 0.18;
    RETURN (@subtotal - @descuento) + @igv;
END;
GO
