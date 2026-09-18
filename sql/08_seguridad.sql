USE MARFARMA_DB;
GO

-- Crear roles
CREATE ROLE rol_Administrador;
CREATE ROLE rol_Analista;
CREATE ROLE rol_Auditor;
GO

-- Permisos Administrador (Todo)
GRANT SELECT, INSERT, UPDATE, DELETE ON Clientes TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Productos TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Vendedores TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON Ventas TO rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON DetalleVenta TO rol_Administrador;
GRANT EXECUTE ON sp_RegistrarVenta TO rol_Administrador;
GRANT EXECUTE ON sp_ReporteVentas TO rol_Administrador;

-- Permisos Analista (Lectura y vistas)
GRANT SELECT ON Clientes TO rol_Analista;
GRANT SELECT ON Productos TO rol_Analista;
GRANT SELECT ON Vendedores TO rol_Analista;
GRANT SELECT ON Ventas TO rol_Analista;
GRANT SELECT ON DetalleVenta TO rol_Analista;
GRANT EXECUTE ON sp_ReporteVentas TO rol_Analista;
DENY INSERT, UPDATE, DELETE ON Ventas TO rol_Analista;

-- Permisos Auditor (Solo lectura Auditoria y Ventas)
GRANT SELECT ON Auditoria TO rol_Auditor;
GRANT SELECT ON Ventas TO rol_Auditor;
GRANT SELECT ON DetalleVenta TO rol_Auditor;
DENY INSERT, UPDATE, DELETE ON Ventas TO rol_Auditor;
GO
