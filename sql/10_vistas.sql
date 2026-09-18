USE MARFARMA_DB;
GO

CREATE OR ALTER VIEW vw_VentasCompletas AS
SELECT 
    v.id_venta, v.fecha, c.nombre_cliente, p.nombre_producto, 
    dv.cantidad, dv.precio_unitario, dv.subtotal, v.total, ven.nombre_vendedor
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
JOIN DetalleVenta dv ON v.id_venta = dv.id_venta
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Vendedores ven ON v.id_vendedor = ven.id_vendedor;
GO

CREATE OR ALTER VIEW vw_ResumenVentas AS
SELECT fecha, COUNT(id_venta) as cantidad_ventas, SUM(total) as ingresos_totales
FROM Ventas
GROUP BY fecha;
GO

CREATE OR ALTER VIEW vw_VentasPorProducto AS
SELECT p.nombre_producto, SUM(dv.cantidad) as total_vendido, SUM(dv.subtotal) as ingresos
FROM DetalleVenta dv
JOIN Productos p ON dv.id_producto = p.id_producto
GROUP BY p.nombre_producto;
GO

CREATE OR ALTER VIEW vw_VentasPorCliente AS
SELECT c.nombre_cliente, COUNT(v.id_venta) as compras, SUM(v.total) as gasto_total
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.nombre_cliente;
GO
