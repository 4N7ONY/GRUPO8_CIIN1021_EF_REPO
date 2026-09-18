USE MARFARMA_DB;
GO

CREATE TABLE Auditoria (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(20) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha DATETIME NOT NULL,
    descripcion VARCHAR(255)
);
GO
