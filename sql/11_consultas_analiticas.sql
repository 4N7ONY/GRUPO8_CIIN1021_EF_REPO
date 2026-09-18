USE MARFARMA_DB;
GO

-- Pregunta 1: ¿Cuánto dinero se vendió?
SELECT SUM(total) AS IngresosTotales FROM Ventas WHERE estado_venta = 'Completada';

-- Pregunta 2: ¿Cuáles son los productos más vendidos?
SELECT TOP 5 p.nombre_producto, SUM(dv.cantidad) AS cantidad_vendida
FROM DetalleVenta dv
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Ventas v ON dv.id_venta = v.id_venta
WHERE v.estado_venta = 'Completada'
GROUP BY p.nombre_producto
ORDER BY cantidad_vendida DESC;

-- Pregunta 3: ¿Cuáles son los productos que generan mayores ingresos?
SELECT TOP 5 p.nombre_producto, SUM(dv.subtotal) AS ingresos_generados
FROM DetalleVenta dv
JOIN Productos p ON dv.id_producto = p.id_producto
JOIN Ventas v ON dv.id_venta = v.id_venta
WHERE v.estado_venta = 'Completada'
GROUP BY p.nombre_producto
ORDER BY ingresos_generados DESC;

-- Pregunta 4: ¿Cuál es el método de pago más utilizado?
SELECT TOP 1 metodo_pago, COUNT(*) AS usos
FROM Ventas
GROUP BY metodo_pago
ORDER BY usos DESC;

-- Pregunta 5: ¿Cuáles son los días con mayores ventas?
SELECT TOP 5 fecha, SUM(total) AS ingresos_dia
FROM Ventas
GROUP BY fecha
ORDER BY ingresos_dia DESC;

-- Pregunta 6: ¿Cuáles son los clientes frecuentes?
SELECT TOP 5 c.nombre_cliente, COUNT(v.id_venta) AS compras
FROM Ventas v
JOIN Clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.nombre_cliente
ORDER BY compras DESC;

-- Pregunta 7: ¿Cuánto se vende por vendedor?
SELECT ve.nombre_vendedor, SUM(v.total) AS ventas_totales
FROM Ventas v
JOIN Vendedores ve ON v.id_vendedor = ve.id_vendedor
GROUP BY ve.nombre_vendedor
ORDER BY ventas_totales DESC;

-- Pregunta 8: ¿Cuál es el ticket promedio?
SELECT AVG(total) AS ticket_promedio FROM Ventas WHERE estado_venta = 'Completada';

-- Pregunta 9: ¿Cuáles son las categorías más vendidas?
SELECT p.categoria, SUM(dv.cantidad) AS cantidad_vendida
FROM DetalleVenta dv
JOIN Productos p ON dv.id_producto = p.id_producto
GROUP BY p.categoria
ORDER BY cantidad_vendida DESC;

-- Pregunta 10: ¿Cuál es la evolución mensual de las ventas?
SELECT MONTH(fecha) AS mes, SUM(total) AS ventas_mes
FROM Ventas
WHERE YEAR(fecha) = 2026
GROUP BY MONTH(fecha)
ORDER BY mes ASC;
GO
