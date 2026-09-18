USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'MARFARMA_DB')
BEGIN
    ALTER DATABASE MARFARMA_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MARFARMA_DB;
END
GO

CREATE DATABASE MARFARMA_DB;
GO

USE MARFARMA_DB;
GO
USE MARFARMA_DB;
GO

-- Tabla Clientes
CREATE TABLE Clientes (
    id_cliente VARCHAR(20) PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    edad INT CHECK (edad >= 0),
    distrito VARCHAR(50),
    tipo_cliente VARCHAR(50)
);

-- Tabla Productos
CREATE TABLE Productos (
    id_producto VARCHAR(20) PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    laboratorio VARCHAR(50),
    requiere_receta VARCHAR(2) CHECK (requiere_receta IN ('SI', 'NO'))
);

-- Tabla Vendedores
CREATE TABLE Vendedores (
    id_vendedor VARCHAR(20) PRIMARY KEY,
    nombre_vendedor VARCHAR(100) NOT NULL,
    turno VARCHAR(20)
);

-- Tabla Ventas
CREATE TABLE Ventas (
    id_venta VARCHAR(20) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_cliente VARCHAR(20) FOREIGN KEY REFERENCES Clientes(id_cliente),
    id_vendedor VARCHAR(20) FOREIGN KEY REFERENCES Vendedores(id_vendedor),
    metodo_pago VARCHAR(50),
    estado_venta VARCHAR(20),
    total DECIMAL(10,2) CHECK (total >= 0)
);

-- Tabla DetalleVenta
CREATE TABLE DetalleVenta (
    id_venta VARCHAR(20) FOREIGN KEY REFERENCES Ventas(id_venta),
    id_producto VARCHAR(20) FOREIGN KEY REFERENCES Productos(id_producto),
    cantidad INT CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) CHECK (precio_unitario >= 0),
    subtotal DECIMAL(10,2) CHECK (subtotal >= 0),
    descuento DECIMAL(10,2) CHECK (descuento >= 0),
    igv DECIMAL(10,2) CHECK (igv >= 0),
    PRIMARY KEY (id_venta, id_producto)
);

-- Tabla Staging (Para el proceso ETL/Carga)
CREATE TABLE Stg_Ventas (
    id_venta VARCHAR(20),
    fecha VARCHAR(20),
    hora VARCHAR(20),
    id_cliente VARCHAR(20),
    nombre_cliente VARCHAR(100),
    sexo VARCHAR(5),
    edad VARCHAR(10),
    distrito VARCHAR(50),
    id_producto VARCHAR(20),
    nombre_producto VARCHAR(100),
    categoria VARCHAR(50),
    laboratorio VARCHAR(50),
    requiere_receta VARCHAR(5),
    cantidad VARCHAR(10),
    precio_unitario VARCHAR(20),
    subtotal VARCHAR(20),
    descuento VARCHAR(20),
    igv VARCHAR(20),
    total VARCHAR(20),
    metodo_pago VARCHAR(50),
    id_vendedor VARCHAR(20),
    nombre_vendedor VARCHAR(100),
    turno VARCHAR(50),
    tipo_cliente VARCHAR(50),
    estado_venta VARCHAR(50)
);
GO
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
USE MARFARMA_DB;
GO

INSERT INTO Stg_Ventas (id_venta,fecha,hora,id_cliente,nombre_cliente,sexo,edad,distrito,id_producto,nombre_producto,categoria,laboratorio,requiere_receta,cantidad,precio_unitario,subtotal,descuento,igv,total,metodo_pago,id_vendedor,nombre_vendedor,turno,tipo_cliente,estado_venta) VALUES
('V00001','09/01/2026','10:49:41','CLI165','Juan Díaz Mamani','M','20','Namora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','4','72.4','289.6','0.0','52.13','341.73','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00002','31/08/2026','15:23:25','CLI063','Jorge Castillo García','M','29','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','0.85','3.05','19.15','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00003','22/08/2026','11:49:16','CLI160','Jorge García Ruiz','M','25','Jesús','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.15','2.07','12.44','Efectivo','VEN004','Luis Sánchez','Mañana','Convenio','Completada'),
('V00004','21/02/2026','20:04:28','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','6','50.31','301.86','45.28','54.33','310.91','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00005','20/06/2026','08:35:34','CLI023','Juana Sánchez Vargas','F','77','Cajamarca','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','1.04','3.74','23.48','Tarjeta','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00006','23/07/2026','10:07:12','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.97','2.36','13.51','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00007','05/04/2026','18:30:33','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD039','Calcibon D','Vitaminas','Medifarma','NO','4','75.16','300.64','0.0','54.12','354.76','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00008','26/04/2026','19:35:40','CLI060','Manuel Quispe García','M','64','Cajamarca','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','2','56.45','112.9','16.93','20.32','116.29','Efectivo','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00009','01/08/2026','09:19:10','CLI184','Carmen Flores Gómez','F','24','Namora','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','6','9.33','55.98','2.8','10.08','63.26','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00010','18/08/2026','09:37:37','CLI142','Julio Sánchez López','M','79','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','1.97','3.54','21.25','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00011','08/01/2026','17:49:36','CLI064','Rosa Ruiz García','F','63','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','24.23','29.08','166.39','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00012','13/06/2026','21:40:34','CLI159','Carmen Rojas Díaz','F','69','Llacanora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','3','62.78','188.34','28.25','33.9','193.99','Yape','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00013','26/07/2026','13:19:29','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','1','28.53','28.53','1.43','5.14','32.24','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00014','22/02/2026','09:20:55','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','6','38.8','232.8','23.28','41.9','251.42','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00015','23/03/2026','08:17:28','CLI237','Víctor Gutiérrez Díaz','M','42','Jesús','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','1','93.42','93.42','0.0','16.82','110.24','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00016','31/08/2026','21:10:52','CLI230','Diego Vargas López','M','19','Cajamarca','PROD027','Fluconazol 150mg','Medicamentos','Genfar','NO','5','8.93','44.65','4.46','8.04','48.23','Plin','VEN002','Carlos Rojas','Noche','Frecuente','Anulada'),
('V00017','15/07/2026','15:29:15','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','3','72.29','216.87','0.0','39.04','255.91','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00018','14/03/2026','11:34:00','CLI084','Jorge Quispe López','M','85','Namora','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','2','4.21','8.42','0.42','1.52','9.52','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00019','06/07/2026','13:23:02','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD040','Omega 3','Vitaminas','Teva','NO','5','47.32','236.6','11.83','42.59','267.36','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00020','22/05/2026','11:52:39','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','1','5.3','5.3','0.27','0.95','5.98','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00021','11/04/2026','10:38:32','CLI183','Miguel Gutiérrez García','M','71','Namora','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','1','24.06','24.06','0.0','4.33','28.39','Yape','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00022','25/07/2026','09:20:59','CLI079','Juana Huamán Sánchez','F','80','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','2','72.4','144.8','21.72','26.06','149.14','Tarjeta','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00023','01/06/2026','20:32:34','CLI226','Andrea Rojas Castillo','F','21','Llacanora','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','5','74.88','374.4','37.44','67.39','404.35','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00024','28/07/2026','20:44:40','CLI163','Carmen Gonzales Ruiz','F','80','Jesús','PROD039','Calcibon D','Vitaminas','Medifarma','NO','4','75.16','300.64','30.06','54.12','324.7','Tarjeta','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00025','28/05/2026','07:37:30','CLI089','José Vargas García','M','78','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','5.64','6.77','38.75','Efectivo','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00026','29/06/2026','07:28:20','CLI010','Fernando Gutiérrez Pérez','M','23','Jesús','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','4','72.29','289.16','14.46','52.05','326.75','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00027','13/05/2026','18:16:39','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','2','3.15','6.3','0.63','1.13','6.8','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00028','18/03/2026','11:49:18','CLI096','Marta Vargas Flores','F','38','Cajamarca','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','6','37.3','223.8','33.57','40.28','230.51','Yape','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00029','03/05/2026','11:07:36','CLI058','Lucía Cruz Gutiérrez','F','85','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','4','38.8','155.2','23.28','27.94','159.86','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00030','16/03/2026','18:05:22','CLI132','Juana Castillo Díaz','F','46','Magdalena','PROD038','Complejo B','Vitaminas','Medifarma','NO','6','27.37','164.22','16.42','29.56','177.36','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00031','24/02/2026','11:08:06','CLI243','Rosa Huamán Torres','F','58','Cajamarca','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','5','74.88','374.4','18.72','67.39','423.07','Efectivo','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00032','16/05/2026','10:03:06','CLI071','Mario Mendoza Gómez','M','60','Namora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','2.59','3.11','17.8','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00033','26/08/2026','17:59:56','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','4','72.4','289.6','14.48','52.13','327.25','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00034','24/03/2026','07:58:49','CLI046','Juana Flores Fernández','F','63','Llacanora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','3','10.39','31.17','1.56','5.61','35.22','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00035','28/08/2026','09:59:58','CLI177','Mario Vargas García','M','57','Llacanora','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','4','22.73','90.92','13.64','16.37','93.65','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00036','13/08/2026','11:36:38','CLI182','Raúl López Quispe','M','49','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','3','38.8','116.4','11.64','20.95','125.71','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00037','14/06/2026','12:10:46','CLI065','Roberto Cruz Ruiz','M','55','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','4.07','14.66','92.01','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00038','08/07/2026','11:36:43','CLI031','Luis Castillo Gómez','M','41','Jesús','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','2','5.84','11.68','1.75','2.1','12.03','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00039','12/05/2026','13:42:06','CLI174','Luis Rojas Flores','M','49','Namora','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','2','69.19','138.38','20.76','24.91','142.53','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00040','28/08/2026','11:24:15','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','1.97','3.54','21.25','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00041','03/01/2026','12:44:15','CLI153','Andrea Cruz Flores','F','68','Llacanora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','5.82','6.98','39.96','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00042','10/02/2026','19:19:44','CLI158','Luis Huamán Vargas','M','69','Magdalena','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','3.41','6.15','36.88','Tarjeta','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00043','26/02/2026','09:30:09','CLI044','Ricardo Ruiz Castillo','M','83','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','1.7','3.05','18.3','Yape','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00044','29/06/2026','20:13:48','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','5','80.77','403.85','0.0','72.69','476.54','Yape','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00045','25/04/2026','10:36:34','CLI162','Silvia Díaz Gonzales','F','25','Baños del Inca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','3','38.8','116.4','17.46','20.95','119.89','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00046','24/06/2026','14:51:03','CLI101','Diego Rodríguez Pérez','M','46','Llacanora','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','5','81.28','406.4','60.96','73.15','418.59','Tarjeta','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00047','25/05/2026','14:43:51','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','1','6.56','6.56','0.98','1.18','6.76','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00048','29/07/2026','10:37:04','CLI170','Luis Gutiérrez Vargas','M','76','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00049','01/05/2026','13:11:49','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','65.16','78.19','447.43','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00050','17/08/2026','20:58:58','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','1','22.73','22.73','1.14','4.09','25.68','Tarjeta','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00051','31/01/2026','15:25:33','CLI199','Ana Castillo Rodríguez','F','27','Llacanora','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','2','72.29','144.58','0.0','26.02','170.6','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00052','04/07/2026','15:24:52','CLI200','Víctor Quispe Mamani','M','30','Baños del Inca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','32.31','58.15','348.92','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00053','12/03/2026','21:46:48','CLI192','Andrea Quispe Díaz','F','27','Cajamarca','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','6','56.45','338.7','50.8','60.97','348.87','Tarjeta','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00054','16/08/2026','10:04:06','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','4','44.34','177.36','0.0','31.92','209.28','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00055','09/07/2026','14:14:34','CLI225','Andrés Rodríguez Quispe','M','20','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','1.32','4.74','29.75','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00056','16/03/2026','21:46:36','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','13.17','23.7','142.18','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00057','19/06/2026','13:19:17','CLI024','Juan Sánchez García','M','25','Llacanora','PROD015','Losartán 100mg','Medicamentos','Teva','SI','5','22.4','112.0','5.6','20.16','126.56','Plin','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00058','23/05/2026','12:41:42','CLI143','Diego Gómez Rojas','M','28','Jesús','PROD045','Pasta Dental Colgate','Cuidado personal','Genfar','NO','5','6.72','33.6','3.36','6.05','36.29','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00059','15/04/2026','10:54:14','CLI087','Patricia Castillo Fernández','F','51','Jesús','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','6','44.34','266.04','13.3','47.89','300.63','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00060','23/08/2026','13:15:16','CLI194','Teresa Rodríguez Pérez','F','44','Baños del Inca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','6','6.56','39.36','0.0','7.08','46.44','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00061','05/08/2026','15:46:53','CLI135','Mario Huamán Rojas','M','30','Jesús','PROD028','Albendazol 400mg','Medicamentos','Medifarma','NO','3','5.68','17.04','2.56','3.07','17.55','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00062','04/06/2026','18:42:35','CLI031','Luis Castillo Gómez','M','41','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.31','2.36','14.17','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00063','21/08/2026','21:12:47','CLI027','Raúl Torres Díaz','M','48','Cajamarca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','0.63','2.27','14.24','Yape','VEN005','Patricia Torres','Noche','Nuevo','Completada'),
('V00064','30/06/2026','21:15:35','CLI203','Luis Fernández Huamán','M','55','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','3','30.24','90.72','13.61','16.33','93.44','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00065','17/05/2026','11:16:23','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','4','26.33','105.32','15.8','18.96','108.48','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00066','25/07/2026','14:48:53','CLI236','Andrés Gonzales Sánchez','M','77','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','16.15','29.08','174.47','Tarjeta','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00067','16/04/2026','20:14:47','CLI023','Juana Sánchez Vargas','F','77','Cajamarca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','3','44.34','133.02','19.95','23.94','137.01','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00068','09/02/2026','10:24:36','CLI225','Andrés Rodríguez Quispe','M','20','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','2.26','4.07','24.41','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00069','05/07/2026','17:03:33','CLI119','Fernando Castillo Gutiérrez','M','43','Namora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.0','0.57','3.72','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00070','16/04/2026','17:14:04','CLI163','Carmen Gonzales Ruiz','F','80','Jesús','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','1','11.21','11.21','0.56','2.02','12.67','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Anulada'),
('V00071','27/04/2026','21:30:42','CLI099','Carmen Torres Quispe','F','20','Jesús','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','1','72.29','72.29','10.84','13.01','74.46','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00072','15/03/2026','20:44:43','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','2','5.84','11.68','0.0','2.1','13.78','Plin','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00073','15/05/2026','10:39:33','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','3.41','6.15','36.88','Plin','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00074','21/01/2026','13:29:36','CLI136','Rocío Huamán Sánchez','F','81','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','6','80.77','484.62','24.23','87.23','547.62','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00075','08/08/2026','07:05:25','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','29.1','34.92','199.82','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00076','13/06/2026','09:05:31','CLI224','Miguel Flores Díaz','M','58','Jesús','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','6','5.84','35.04','3.5','6.31','37.85','Efectivo','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00077','11/01/2026','17:59:17','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','0.0','3.11','20.39','Yape','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00078','31/05/2026','20:45:52','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','3.88','6.98','41.9','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00079','25/05/2026','09:50:44','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','5','80.77','403.85','40.39','72.69','436.15','Plin','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00080','26/01/2026','12:01:40','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','4','69.19','276.76','41.51','49.82','285.07','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00081','07/04/2026','17:37:42','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','5','81.28','406.4','40.64','73.15','438.91','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00082','02/07/2026','11:09:24','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD045','Pasta Dental Colgate','Cuidado personal','Genfar','NO','6','6.72','40.32','2.02','7.26','45.56','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00083','23/03/2026','08:00:19','CLI217','María Gonzales Quispe','F','21','Jesús','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','3','3.15','9.45','0.0','1.7','11.15','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00084','23/01/2026','08:01:05','CLI200','Víctor Quispe Mamani','M','30','Baños del Inca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','8.08','14.54','87.23','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00085','04/01/2026','09:43:24','CLI100','Miguel Flores Díaz','M','77','Jesús','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','3','50.31','150.93','15.09','27.17','163.01','Tarjeta','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00086','07/05/2026','09:27:17','CLI119','Fernando Castillo Gutiérrez','M','43','Namora','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','4','27.32','109.28','0.0','19.67','128.95','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00087','04/07/2026','16:39:12','CLI217','María Gonzales Quispe','F','21','Jesús','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','2','97.38','194.76','19.48','35.06','210.34','Plin','VEN001','Ana Díaz','Tarde','Frecuente','Devuelta'),
('V00088','31/08/2026','12:28:21','CLI136','Rocío Huamán Sánchez','F','81','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','9.07','32.66','205.03','Tarjeta','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00089','27/06/2026','11:47:44','CLI064','Rosa Ruiz García','F','63','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','4.07','14.66','92.01','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00090','07/04/2026','19:25:23','CLI151','Raúl Vargas Díaz','M','54','Baños del Inca','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','5','17.48','87.4','4.37','15.73','98.76','Yape','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00091','20/05/2026','19:35:01','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','1.13','4.07','25.54','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00092','24/07/2026','18:04:52','CLI191','Lucía Cruz Rodríguez','F','34','Jesús','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','4','74.88','299.52','44.93','53.91','308.5','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00093','12/06/2026','11:42:09','CLI138','Manuel Huamán Quispe','M','83','Cajamarca','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','0.0','45.2','296.32','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00094','03/06/2026','19:23:44','CLI008','Andrea Fernández Cruz','F','80','Jesús','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','5','11.65','58.25','0.0','10.48','68.73','Yape','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00095','16/07/2026','17:22:10','CLI057','Mario Gómez López','M','45','Llacanora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.85','1.02','5.82','Efectivo','VEN003','Rosa Fernández','Tarde','Nuevo','Completada'),
('V00096','23/07/2026','07:06:16','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','7.9','28.44','178.52','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00097','06/04/2026','19:43:37','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','5.27','9.48','56.87','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00098','04/05/2026','13:58:05','CLI155','Marta Sánchez Mendoza','F','26','Cajamarca','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','6','84.92','509.52','25.48','91.71','575.75','Tarjeta','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00099','21/03/2026','19:13:33','CLI230','Diego Vargas López','M','19','Cajamarca','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','4','44.33','177.32','0.0','31.92','209.24','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00100','04/07/2026','12:04:19','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','6','38.8','232.8','0.0','41.9','274.7','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00101','06/08/2026','08:43:51','CLI063','Jorge Castillo García','M','29','Namora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','6','3.15','18.9','0.94','3.4','21.36','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00102','14/02/2026','10:51:25','CLI039','Silvia Díaz Sánchez','F','57','Jesús','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','2','17.48','34.96','5.24','6.29','36.01','Yape','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00103','15/08/2026','16:27:24','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','2','29.84','59.68','2.98','10.74','67.44','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00104','12/07/2026','19:04:36','CLI045','Julio Fernández Castillo','M','29','Jesús','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','5','21.05','105.25','5.26','18.95','118.94','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00105','25/03/2026','16:25:37','CLI072','Laura Pérez Gonzales','F','43','Llacanora','PROD012','Loratadina 10mg','Medicamentos','Genfar','NO','3','6.54','19.62','2.94','3.53','20.21','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00106','22/03/2026','11:07:11','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','2','37.3','74.6','11.19','13.43','76.84','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00107','02/06/2026','13:27:11','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','0.79','2.83','17.79','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00108','05/02/2026','20:28:39','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','3','9.96','29.88','0.0','5.38','35.26','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00109','04/02/2026','13:43:31','CLI072','Laura Pérez Gonzales','F','43','Llacanora','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','4','97.38','389.52','58.43','70.11','401.2','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00110','16/03/2026','10:34:18','CLI056','Raúl Mendoza Ruiz','M','69','Jesús','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','2','12.54','25.08','3.76','4.51','25.83','Yape','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00111','11/05/2026','19:46:28','CLI098','Pedro Gutiérrez Flores','M','55','Namora','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','4','24.06','96.24','0.0','17.32','113.56','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00112','23/01/2026','08:49:51','CLI065','Roberto Cruz Ruiz','M','55','Llacanora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','18.14','32.66','195.96','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00113','11/06/2026','16:08:50','CLI132','Juana Castillo Díaz','F','46','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','0.0','2.36','15.48','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00114','02/06/2026','12:45:18','CLI063','Jorge Castillo García','M','29','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','0.0','2.86','18.76','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00115','12/07/2026','09:44:55','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','2','37.3','74.6','7.46','13.43','80.57','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00116','11/04/2026','21:49:05','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','8.14','14.66','87.94','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00117','07/07/2026','10:27:52','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.31','2.36','14.17','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00118','28/03/2026','09:36:54','CLI184','Carmen Flores Gómez','F','24','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','3','26.33','78.99','0.0','14.22','93.21','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00119','10/02/2026','09:55:59','CLI097','Fernando Rodríguez Ruiz','M','82','Baños del Inca','PROD021','Clonazepam 2mg','Medicamentos','Roche','SI','1','53.2','53.2','5.32','9.58','57.46','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00120','22/01/2026','21:41:10','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD044','Jabón Protex','Cuidado personal','Teva','NO','6','5.74','34.44','3.44','6.2','37.2','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00121','30/06/2026','10:30:04','CLI040','Juan Mamani Rojas','M','39','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','1.59','1.91','10.92','Efectivo','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00122','29/07/2026','20:27:44','CLI074','Rocío Fernández Vargas','F','79','Namora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','1','10.39','10.39','0.52','1.87','11.74','Tarjeta','VEN004','Luis Sánchez','Noche','Adulto Mayor','Completada'),
('V00123','27/01/2026','12:56:19','CLI131','Diana Mamani Torres','F','67','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','1.36','4.89','30.67','Plin','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00124','16/05/2026','16:41:10','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','6','50.31','301.86','15.09','54.33','341.1','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00125','24/08/2026','17:28:55','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD011','Pantoprazol 40mg','Medicamentos','Teva','SI','1','21.72','21.72','1.09','3.91','24.54','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00126','05/03/2026','18:38:18','CLI137','Teresa Huamán Gutiérrez','F','61','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','0.0','28.44','186.42','Efectivo','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00127','22/02/2026','15:12:47','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','6','56.45','338.7','0.0','60.97','399.67','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00128','07/05/2026','10:31:40','CLI063','Jorge Castillo García','M','29','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','0.0','5.08','33.33','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00129','28/08/2026','12:34:43','CLI145','Luis Vargas Gonzales','M','69','Magdalena','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','0.0','1.91','12.51','Yape','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00130','31/05/2026','11:13:02','CLI013','José Cruz López','M','37','Namora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','4','5.76','23.04','2.3','4.15','24.89','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00131','16/07/2026','18:25:05','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','5','56.45','282.25','14.11','50.8','318.94','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00132','22/01/2026','09:34:20','CLI170','Luis Gutiérrez Vargas','M','76','Namora','PROD038','Complejo B','Vitaminas','Medifarma','NO','6','27.37','164.22','0.0','29.56','193.78','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00133','28/06/2026','20:15:03','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','4','17.07','68.28','0.0','12.29','80.57','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00134','06/06/2026','11:42:47','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00135','01/07/2026','11:10:23','CLI048','Juana García Pérez','F','43','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','0.0','3.05','20.0','Yape','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00136','03/04/2026','20:36:10','CLI211','Andrea Cruz López','F','23','Jesús','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','0.0','2.86','18.76','Tarjeta','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00137','01/01/2026','20:00:15','CLI044','Ricardo Ruiz Castillo','M','83','Baños del Inca','PROD012','Loratadina 10mg','Medicamentos','Genfar','NO','2','6.54','13.08','1.96','2.35','13.47','Tarjeta','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00138','08/08/2026','19:58:45','CLI131','Diana Mamani Torres','F','67','Namora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','1.71','6.15','38.58','Tarjeta','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00139','05/03/2026','18:20:17','CLI203','Luis Fernández Huamán','M','55','Namora','PROD028','Albendazol 400mg','Medicamentos','Medifarma','NO','5','5.68','28.4','2.84','5.11','30.67','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00140','14/01/2026','19:33:02','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','1','44.34','44.34','6.65','7.98','45.67','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00141','18/07/2026','12:05:35','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','3','26.33','78.99','3.95','14.22','89.26','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00142','09/07/2026','19:49:12','CLI157','Manuel Gutiérrez Pérez','M','48','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','1.41','5.08','31.92','Tarjeta','VEN002','Carlos Rojas','Noche','Nuevo','Completada'),
('V00143','07/01/2026','09:45:17','CLI088','Diana Castillo Gómez','F','58','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','1.59','1.91','10.92','Tarjeta','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00144','10/05/2026','10:18:16','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','4','81.28','325.12','32.51','58.52','351.13','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00145','26/04/2026','16:06:09','CLI083','Rocío Torres Sánchez','F','57','Magdalena','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','4','27.32','109.28','16.39','19.67','112.56','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00146','15/04/2026','12:49:13','CLI142','Julio Sánchez López','M','79','Magdalena','PROD039','Calcibon D','Vitaminas','Medifarma','NO','4','75.16','300.64','30.06','54.12','324.7','Tarjeta','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00147','24/01/2026','17:19:52','CLI203','Luis Fernández Huamán','M','55','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','0.0','5.08','33.33','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00148','07/02/2026','10:22:25','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD046','Pasta Dental Sensodyne','Cuidado personal','Teva','NO','6','15.03','90.18','9.02','16.23','97.39','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00149','11/07/2026','09:07:00','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','2','72.4','144.8','7.24','26.06','163.62','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00150','30/07/2026','17:40:41','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','5','28.41','142.05','14.21','25.57','153.41','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00151','01/02/2026','13:52:46','CLI226','Andrea Rojas Castillo','F','21','Llacanora','PROD040','Omega 3','Vitaminas','Teva','NO','1','47.32','47.32','7.1','8.52','48.74','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00152','14/02/2026','21:11:17','CLI236','Andrés Gonzales Sánchez','M','77','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','1','5.3','5.3','0.0','0.95','6.25','Yape','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00153','08/06/2026','17:18:31','CLI151','Raúl Vargas Díaz','M','54','Baños del Inca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','5','5.84','29.2','4.38','5.26','30.08','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00154','23/01/2026','09:26:12','CLI140','Carlos Mamani Díaz','M','42','Llacanora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','7.56','27.22','170.86','Tarjeta','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00155','23/07/2026','13:50:45','CLI039','Silvia Díaz Sánchez','F','57','Jesús','PROD040','Omega 3','Vitaminas','Teva','NO','5','47.32','236.6','35.49','42.59','243.7','Yape','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00156','22/08/2026','12:24:17','CLI182','Raúl López Quispe','M','49','Namora','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','3','55.29','165.87','8.29','29.86','187.44','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00157','13/03/2026','10:10:06','CLI031','Luis Castillo Gómez','M','41','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','16.15','29.08','174.47','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00158','08/07/2026','10:36:54','CLI229','Patricia Rojas Díaz','F','57','Llacanora','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','4','50.31','201.24','20.12','36.22','217.34','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00159','15/02/2026','12:36:36','CLI105','Mario López López','M','67','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.85','1.02','5.82','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00160','21/03/2026','07:05:03','CLI001','Fernando Torres Huamán','M','59','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','0.0','2.07','13.59','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00161','03/05/2026','20:55:20','CLI229','Patricia Rojas Díaz','F','57','Llacanora','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','2','44.33','88.66','4.43','15.96','100.19','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00162','19/06/2026','08:21:19','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD021','Clonazepam 2mg','Medicamentos','Roche','SI','2','53.2','106.4','15.96','19.15','109.59','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00163','16/06/2026','18:35:44','CLI046','Juana Flores Fernández','F','63','Llacanora','PROD028','Albendazol 400mg','Medicamentos','Medifarma','NO','3','5.68','17.04','1.7','3.07','18.41','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00164','20/06/2026','09:24:19','CLI097','Fernando Rodríguez Ruiz','M','82','Baños del Inca','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','2.71','9.77','61.34','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00165','06/07/2026','18:36:25','CLI166','Luis Ruiz Torres','M','57','Baños del Inca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','5','6.56','32.8','0.0','5.9','38.7','Plin','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00166','04/06/2026','19:39:14','CLI109','Laura Quispe Díaz','F','29','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','1','6.56','6.56','0.98','1.18','6.76','Plin','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00167','02/03/2026','18:56:21','CLI147','Manuel Mendoza Gómez','M','40','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','3','3.15','9.45','0.47','1.7','10.68','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00168','27/06/2026','11:50:06','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','1','5.76','5.76','0.86','1.04','5.94','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00169','07/07/2026','09:56:26','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD038','Complejo B','Vitaminas','Medifarma','NO','4','27.37','109.48','10.95','19.71','118.24','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00170','07/04/2026','19:43:14','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD038','Complejo B','Vitaminas','Medifarma','NO','1','27.37','27.37','0.0','4.93','32.3','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00171','06/01/2026','08:04:21','CLI138','Manuel Huamán Quispe','M','83','Cajamarca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','0.53','1.91','11.98','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00172','24/01/2026','13:10:03','CLI236','Andrés Gonzales Sánchez','M','77','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','1','12.54','12.54','0.63','2.26','14.17','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00173','28/06/2026','21:46:34','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','3','5.84','17.52','1.75','3.15','18.92','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00174','25/01/2026','16:35:53','CLI165','Juan Díaz Mamani','M','20','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.58','1.05','6.31','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00175','20/04/2026','10:06:01','CLI168','Elizabeth Rodríguez Pérez','F','23','Baños del Inca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','6','5.84','35.04','3.5','6.31','37.85','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00176','19/06/2026','17:34:24','CLI047','Diego García Torres','M','74','Jesús','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','2','29.87','59.74','5.97','10.75','64.52','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00177','25/04/2026','14:29:16','CLI063','Jorge Castillo García','M','29','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','3','30.24','90.72','0.0','16.33','107.05','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00178','12/07/2026','08:05:42','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','3','27.32','81.96','12.29','14.75','84.42','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00179','28/02/2026','16:56:15','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.88','1.05','6.01','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00180','09/05/2026','19:12:08','CLI008','Andrea Fernández Cruz','F','80','Jesús','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','1','10.39','10.39','1.56','1.87','10.7','Yape','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00181','30/07/2026','20:38:16','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','6','12.72','76.32','0.0','13.74','90.06','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00182','22/05/2026','11:33:29','CLI100','Miguel Flores Díaz','M','77','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','4.07','4.89','27.96','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00183','17/04/2026','21:22:56','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','4','38.8','155.2','23.28','27.94','159.86','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00184','05/06/2026','09:17:25','CLI236','Andrés Gonzales Sánchez','M','77','Namora','PROD039','Calcibon D','Vitaminas','Medifarma','NO','5','75.16','375.8','56.37','67.64','387.07','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00185','24/08/2026','11:19:17','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','6','84.92','509.52','0.0','91.71','601.23','Tarjeta','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00186','04/02/2026','18:28:49','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','2','12.54','25.08','3.76','4.51','25.83','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00187','15/06/2026','18:31:48','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','0.0','2.86','18.76','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Devuelta'),
('V00188','22/07/2026','11:45:32','CLI131','Diana Mamani Torres','F','67','Namora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','3','10.39','31.17','0.0','5.61','36.78','Efectivo','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00189','05/03/2026','11:23:52','CLI227','María Castillo Díaz','F','42','Baños del Inca','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','4','28.53','114.12','0.0','20.54','134.66','Yape','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00190','03/03/2026','14:37:35','CLI136','Rocío Huamán Sánchez','F','81','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','7.76','13.97','83.81','Tarjeta','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00191','14/03/2026','10:54:14','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','6','17.48','104.88','5.24','18.88','118.52','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00192','16/06/2026','17:00:30','CLI148','María Mendoza Flores','F','28','Magdalena','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','6','6.6','39.6','1.98','7.13','44.75','Yape','VEN005','Patricia Torres','Tarde','Convenio','Completada'),
('V00193','25/07/2026','11:38:51','CLI227','María Castillo Díaz','F','42','Baños del Inca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','15.8','28.44','170.62','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00194','18/08/2026','12:29:16','CLI012','Ana Ruiz Rojas','F','25','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','2.38','2.86','16.38','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00195','27/01/2026','17:53:53','CLI150','José Rojas Huamán','M','28','Magdalena','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','3.18','5.72','34.34','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00196','25/06/2026','21:41:19','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','7.56','27.22','170.86','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00197','26/07/2026','19:38:25','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','6','22.73','136.38','6.82','24.55','154.11','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00198','17/06/2026','11:16:58','CLI058','Lucía Cruz Gutiérrez','F','85','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','2','3.15','6.3','0.0','1.13','7.43','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00199','28/07/2026','18:45:14','CLI013','José Cruz López','M','37','Namora','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','6','44.33','265.98','39.9','47.88','273.96','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00200','10/05/2026','09:53:42','CLI191','Lucía Cruz Rodríguez','F','34','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.31','2.36','14.17','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00201','01/05/2026','11:46:51','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','1','8.93','8.93','0.89','1.61','9.65','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00202','26/02/2026','18:55:19','CLI203','Luis Fernández Huamán','M','55','Namora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','3','62.78','188.34','18.83','33.9','203.41','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00203','30/05/2026','20:07:30','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','6','44.33','265.98','0.0','47.88','313.86','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00204','16/08/2026','08:55:43','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','3','50.31','150.93','22.64','27.17','155.46','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00205','29/03/2026','09:20:55','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','1','50.31','50.31','7.55','9.06','51.82','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00206','22/03/2026','07:28:17','CLI165','Juan Díaz Mamani','M','20','Namora','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','2','9.33','18.66','0.93','3.36','21.09','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00207','23/01/2026','13:40:27','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD008','Diclofenaco 50mg','Medicamentos','Genfar','NO','4','3.43','13.72','2.06','2.47','14.13','Plin','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00208','10/01/2026','18:23:00','CLI011','Carlos García Gómez','M','62','Magdalena','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','5','69.19','345.95','17.3','62.27','390.92','Tarjeta','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00209','23/06/2026','18:15:14','CLI142','Julio Sánchez López','M','79','Magdalena','PROD056','Leche Enfamil 1','Bebés','Abbott','NO','3','77.41','232.23','23.22','41.8','250.81','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00210','27/01/2026','16:19:10','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','1','97.38','97.38','9.74','17.53','105.17','Plin','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00211','02/06/2026','12:57:31','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD058','Leche NAN 3','Bebés','Roche','NO','2','72.81','145.62','7.28','26.21','164.55','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00212','05/01/2026','18:08:13','CLI205','Elena Flores Gómez','F','26','Cajamarca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','0.79','2.83','17.79','Yape','VEN001','Ana Díaz','Tarde','Nuevo','Completada'),
('V00213','22/07/2026','17:06:41','CLI032','Fernando García Flores','M','52','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.0','0.57','3.72','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00214','24/04/2026','10:44:43','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','2.54','3.05','17.46','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00215','19/06/2026','16:38:44','CLI195','Víctor Ruiz García','M','57','Magdalena','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','0.0','4.03','26.43','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00216','08/05/2026','10:49:16','CLI153','Andrea Cruz Flores','F','68','Llacanora','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','2.24','4.03','24.19','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00217','17/03/2026','15:31:58','CLI005','Ana Mendoza Mendoza','F','45','Namora','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','4','50.31','201.24','20.12','36.22','217.34','Yape','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00218','01/01/2026','17:31:09','CLI197','Sonia Gómez Mendoza','F','44','Jesús','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','5','84.37','421.85','0.0','75.93','497.78','Efectivo','VEN001','Ana Díaz','Tarde','Convenio','Completada'),
('V00219','20/08/2026','10:29:18','CLI105','Mario López López','M','67','Namora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','1','5.76','5.76','0.0','1.04','6.8','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00220','12/08/2026','11:23:51','CLI246','Ana Castillo Sánchez','F','57','Baños del Inca','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','4','29.84','119.36','0.0','21.48','140.84','Efectivo','VEN001','Ana Díaz','Mañana','Convenio','Completada'),
('V00221','12/01/2026','09:42:41','CLI182','Raúl López Quispe','M','49','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','2.38','2.86','16.38','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00222','24/01/2026','12:11:07','CLI076','Patricia Vargas Fernández','F','24','Jesús','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','4','72.29','289.16','28.92','52.05','312.29','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00223','24/07/2026','21:51:10','CLI004','Ana Díaz Rodríguez','F','20','Magdalena','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','6','84.37','506.22','0.0','91.12','597.34','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00224','27/01/2026','14:11:39','CLI169','María Fernández Flores','F','29','Llacanora','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','3','8.08','24.24','0.0','4.36','28.6','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00225','23/04/2026','11:41:20','CLI024','Juan Sánchez García','M','25','Llacanora','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','6','28.41','170.46','8.52','30.68','192.62','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00226','29/06/2026','13:42:46','CLI119','Fernando Castillo Gutiérrez','M','43','Namora','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','3','6.6','19.8','2.97','3.56','20.39','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Devuelta'),
('V00227','14/01/2026','20:31:55','CLI062','Lucía Mendoza Gutiérrez','F','35','Magdalena','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','32.31','58.15','348.92','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00228','25/07/2026','08:54:31','CLI129','María Quispe Quispe','F','78','Magdalena','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','3.36','4.03','23.07','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00229','27/01/2026','07:35:35','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','1','93.42','93.42','9.34','16.82','100.9','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00230','24/05/2026','17:29:21','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD060','Crema Cero','Bebés','Genfar','NO','1','18.07','18.07','0.9','3.25','20.42','Tarjeta','VEN004','Luis Sánchez','Tarde','Frecuente','Devuelta'),
('V00231','08/06/2026','18:42:23','CLI046','Juana Flores Fernández','F','63','Llacanora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','1','17.07','17.07','0.0','3.07','20.14','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00232','01/01/2026','20:40:51','CLI040','Juan Mamani Rojas','M','39','Baños del Inca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','36.2','65.16','390.96','Efectivo','VEN001','Ana Díaz','Noche','Nuevo','Completada'),
('V00233','07/05/2026','18:47:46','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD041','Shampoo Head&Shoulders','Cuidado personal','Abbott','NO','3','24.16','72.48','3.62','13.05','81.91','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00234','11/04/2026','08:48:26','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','0.0','5.72','37.52','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00235','10/05/2026','18:52:08','CLI237','Víctor Gutiérrez Díaz','M','42','Jesús','PROD058','Leche NAN 3','Bebés','Roche','NO','6','72.81','436.86','43.69','78.63','471.8','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00236','14/08/2026','11:25:21','CLI135','Mario Huamán Rojas','M','30','Jesús','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','0.63','2.27','14.24','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00237','21/02/2026','18:18:43','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','21.72','78.19','490.87','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00238','09/05/2026','17:20:45','CLI059','Luis Quispe Cruz','M','50','Jesús','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','3','11.65','34.95','5.24','6.29','36.0','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00239','01/07/2026','18:57:53','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','0.0','2.07','13.59','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00240','28/01/2026','09:03:42','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','3','11.65','34.95','1.75','6.29','39.49','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00241','24/06/2026','10:48:34','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','0.0','45.2','296.32','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00242','10/07/2026','19:44:18','CLI217','María Gonzales Quispe','F','21','Jesús','PROD054','Pañales Babysec G','Bebés','Genfar','NO','1','62.78','62.78','9.42','11.3','64.66','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00243','25/06/2026','10:39:55','CLI169','María Fernández Flores','F','29','Llacanora','PROD046','Pasta Dental Sensodyne','Cuidado personal','Teva','NO','4','15.03','60.12','3.01','10.82','67.93','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00244','13/07/2026','18:38:12','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','2','9.96','19.92','1.99','3.59','21.52','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00245','20/01/2026','09:47:32','CLI033','Diana Mamani Sánchez','F','27','Namora','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','1','56.45','56.45','8.47','10.16','58.14','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00246','23/05/2026','09:37:54','CLI203','Luis Fernández Huamán','M','55','Namora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','3','72.4','217.2','32.58','39.1','223.72','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00247','11/01/2026','17:39:53','CLI076','Patricia Vargas Fernández','F','24','Jesús','PROD046','Pasta Dental Sensodyne','Cuidado personal','Teva','NO','4','15.03','60.12','6.01','10.82','64.93','Plin','VEN001','Ana Díaz','Tarde','Nuevo','Completada'),
('V00248','15/05/2026','09:33:04','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','2','12.72','25.44','3.82','4.58','26.2','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00249','18/05/2026','12:14:56','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD039','Calcibon D','Vitaminas','Medifarma','NO','3','75.16','225.48','22.55','40.59','243.52','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Anulada'),
('V00250','17/03/2026','19:39:33','CLI090','Teresa Pérez Gutiérrez','F','65','Llacanora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','0.0','34.92','228.92','Tarjeta','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00251','21/06/2026','10:57:41','CLI233','Diana Sánchez Rodríguez','F','75','Namora','PROD038','Complejo B','Vitaminas','Medifarma','NO','5','27.37','136.85','6.84','24.63','154.64','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00252','30/08/2026','11:34:46','CLI175','Rocío López Cruz','F','47','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','2.83','5.08','30.5','Yape','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00253','25/07/2026','10:20:32','CLI154','Teresa Rodríguez Vargas','F','64','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.28','1.02','6.39','Tarjeta','VEN005','Patricia Torres','Mañana','Adulto Mayor','Anulada'),
('V00254','17/05/2026','10:55:43','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','1','44.34','44.34','2.22','7.98','50.1','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00255','09/02/2026','18:21:02','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.16','0.57','3.56','Efectivo','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00256','23/05/2026','20:14:58','CLI191','Lucía Cruz Rodríguez','F','34','Jesús','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','4','44.34','177.36','26.6','31.92','182.68','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00257','21/04/2026','17:46:39','CLI250','Marta Cruz Fernández','F','64','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','0.0','14.66','96.08','Yape','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00258','28/01/2026','17:19:38','CLI195','Víctor Ruiz García','M','57','Magdalena','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','4','9.33','37.32','5.6','6.72','38.44','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00259','30/07/2026','14:10:34','CLI169','María Fernández Flores','F','29','Llacanora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','27.22','32.66','186.88','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00260','06/02/2026','17:23:00','CLI038','Lucía Mamani Torres','F','58','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','6.58','23.7','148.77','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00261','11/01/2026','21:46:22','CLI161','Patricia Castillo Huamán','F','25','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','7.9','28.44','178.52','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Devuelta'),
('V00262','17/02/2026','20:16:12','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','6','29.84','179.04','0.0','32.23','211.27','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00263','19/01/2026','08:16:06','CLI009','Miguel Gonzales Fernández','M','55','Namora','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','5','11.21','56.05','8.41','10.09','57.73','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00264','02/04/2026','17:15:06','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','4.04','14.54','91.27','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00265','07/06/2026','18:37:09','CLI192','Andrea Quispe Díaz','F','27','Cajamarca','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','3','29.84','89.52','8.95','16.11','96.68','Tarjeta','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00266','13/02/2026','10:50:14','CLI158','Luis Huamán Vargas','M','69','Magdalena','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','2.38','2.86','16.38','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00267','04/08/2026','17:46:21','CLI153','Andrea Cruz Flores','F','68','Llacanora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','37.67','45.2','258.65','Yape','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00268','18/07/2026','09:57:34','CLI033','Diana Mamani Sánchez','F','27','Namora','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','6','44.34','266.04','0.0','47.89','313.93','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00269','17/08/2026','21:02:35','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','2.36','2.83','16.22','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00270','04/04/2026','11:08:29','CLI196','Ana Mendoza Díaz','F','45','Cajamarca','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','1','69.19','69.19','10.38','12.45','71.26','Yape','VEN003','Rosa Fernández','Mañana','Convenio','Completada'),
('V00271','09/05/2026','10:54:51','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','7.9','28.44','178.52','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00272','15/02/2026','18:46:30','CLI077','Roberto Mamani Mamani','M','72','Jesús','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','1','24.06','24.06','1.2','4.33','27.19','Tarjeta','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00273','01/03/2026','15:58:50','CLI011','Carlos García Gómez','M','62','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.73','2.07','11.86','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00274','24/03/2026','15:40:53','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','3.18','5.72','34.34','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00275','04/04/2026','12:52:55','CLI174','Luis Rojas Flores','M','49','Namora','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','4','74.88','299.52','0.0','53.91','353.43','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00276','14/08/2026','09:14:04','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','0.98','3.54','22.24','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00277','17/02/2026','16:45:52','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','2','33.51','67.02','10.05','12.06','69.03','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00278','04/07/2026','17:30:30','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','2','97.38','194.76','29.21','35.06','200.61','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00279','04/03/2026','16:37:10','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','0.0','14.66','96.08','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00280','07/02/2026','11:59:11','CLI233','Diana Sánchez Rodríguez','F','75','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00281','31/08/2026','09:14:53','CLI218','Lucía García Rojas','F','22','Cajamarca','PROD054','Pañales Babysec G','Bebés','Genfar','NO','2','62.78','125.56','6.28','22.6','141.88','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00282','18/06/2026','09:46:43','CLI202','Patricia García Rodríguez','F','21','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','0.0','4.07','26.67','Tarjeta','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00283','07/04/2026','21:32:43','CLI203','Luis Fernández Huamán','M','55','Namora','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','2','8.93','17.86','0.0','3.21','21.07','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00284','03/06/2026','19:34:32','CLI181','Carmen Castillo Gonzales','F','84','Llacanora','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','1','28.53','28.53','4.28','5.14','29.39','Efectivo','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00285','31/07/2026','19:43:41','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','4','50.31','201.24','20.12','36.22','217.34','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Anulada'),
('V00286','28/06/2026','10:51:30','CLI089','José Vargas García','M','78','Namora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','2.08','3.74','22.44','Tarjeta','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00287','25/07/2026','19:53:44','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','1.71','6.15','38.58','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00288','14/03/2026','15:26:16','CLI250','Marta Cruz Fernández','F','64','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','6','80.77','484.62','0.0','87.23','571.85','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00289','14/05/2026','07:24:41','CLI169','María Fernández Flores','F','29','Llacanora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','2.54','3.05','17.46','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00290','28/01/2026','17:37:16','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD058','Leche NAN 3','Bebés','Roche','NO','5','72.81','364.05','54.61','65.53','374.97','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00291','04/04/2026','17:25:48','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','5','17.07','85.35','12.8','15.36','87.91','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Devuelta'),
('V00292','05/04/2026','19:45:25','CLI011','Carlos García Gómez','M','62','Magdalena','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','6','44.34','266.04','0.0','47.89','313.93','Yape','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00293','11/02/2026','15:25:50','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','0.0','34.92','228.92','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00294','30/07/2026','21:38:27','CLI110','Ana García Flores','F','80','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','2','12.54','25.08','1.25','4.51','28.34','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00295','05/07/2026','18:38:03','CLI056','Raúl Mendoza Ruiz','M','69','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','4.07','4.89','27.96','Yape','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00296','03/01/2026','17:59:51','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','2','30.24','60.48','0.0','10.89','71.37','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00297','01/03/2026','17:02:23','CLI063','Jorge Castillo García','M','29','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','4.04','14.54','91.27','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00298','13/05/2026','18:04:58','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','1.59','2.86','17.17','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00299','28/07/2026','16:00:16','CLI129','María Quispe Quispe','F','78','Magdalena','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','0.0','9.22','60.43','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00300','25/07/2026','11:56:34','CLI102','Teresa Fernández Díaz','F','58','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','5','80.77','403.85','40.39','72.69','436.15','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00301','17/07/2026','21:37:55','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','1','62.78','62.78','6.28','11.3','67.8','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Anulada'),
('V00302','05/03/2026','08:35:59','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','3','33.51','100.53','10.05','18.1','108.58','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00303','21/02/2026','10:55:16','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','2','56.45','112.9','5.65','20.32','127.57','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00304','02/04/2026','08:07:58','CLI065','Roberto Cruz Ruiz','M','55','Llacanora','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','6','6.6','39.6','5.94','7.13','40.79','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00305','08/06/2026','11:31:11','CLI045','Julio Fernández Castillo','M','29','Jesús','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','5','5.84','29.2','2.92','5.26','31.54','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00306','02/02/2026','19:27:30','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD056','Leche Enfamil 1','Bebés','Abbott','NO','1','77.41','77.41','7.74','13.93','83.6','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00307','14/02/2026','08:44:33','CLI218','Lucía García Rojas','F','22','Cajamarca','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','6','17.07','102.42','0.0','18.44','120.86','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00308','22/06/2026','16:06:20','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','3','38.8','116.4','5.82','20.95','131.53','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00309','09/03/2026','14:39:21','CLI032','Fernando García Flores','M','52','Magdalena','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','4','8.93','35.72','5.36','6.43','36.79','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00310','06/04/2026','13:17:28','CLI128','Luis Flores Castillo','M','56','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','2','5.84','11.68','0.58','2.1','13.2','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Devuelta'),
('V00311','04/07/2026','10:35:27','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','2','5.84','11.68','0.58','2.1','13.2','Plin','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00312','15/02/2026','09:57:54','CLI218','Lucía García Rojas','F','22','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','19.4','34.92','209.52','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00313','18/03/2026','20:36:03','CLI167','Patricia López Pérez','F','35','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','1.59','5.72','35.93','Efectivo','VEN001','Ana Díaz','Noche','Nuevo','Completada'),
('V00314','25/01/2026','12:16:23','CLI174','Luis Rojas Flores','M','49','Namora','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','5','28.53','142.65','14.27','25.68','154.06','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Anulada'),
('V00315','06/01/2026','10:36:36','CLI025','Víctor Díaz Fernández','M','43','Jesús','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','5','12.72','63.6','3.18','11.45','71.87','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00316','01/04/2026','17:51:59','CLI047','Diego García Torres','M','74','Jesús','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','3','8.93','26.79','4.02','4.82','27.59','Tarjeta','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00317','21/01/2026','10:20:20','CLI170','Luis Gutiérrez Vargas','M','76','Namora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','5.12','9.22','55.31','Yape','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00318','15/06/2026','14:26:10','CLI142','Julio Sánchez López','M','79','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.16','0.57','3.56','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00319','19/06/2026','18:44:47','CLI169','María Fernández Flores','F','29','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','8.14','9.77','55.91','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00320','25/01/2026','21:30:35','CLI164','Víctor Flores Torres','M','74','Cajamarca','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','2','21.05','42.1','0.0','7.58','49.68','Yape','VEN001','Ana Díaz','Noche','Adulto Mayor','Devuelta'),
('V00321','15/08/2026','10:15:47','CLI013','José Cruz López','M','37','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','6','80.77','484.62','24.23','87.23','547.62','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00322','08/01/2026','12:55:58','CLI193','Pedro Quispe Torres','M','84','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','8.14','9.77','55.91','Yape','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00323','28/08/2026','17:56:36','CLI106','Diana Vargas Quispe','F','73','Jesús','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','1.73','3.11','18.66','Yape','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00324','26/07/2026','11:23:26','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','3','93.42','280.26','0.0','50.45','330.71','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00325','06/08/2026','11:30:34','CLI032','Fernando García Flores','M','52','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','4','38.8','155.2','23.28','27.94','159.86','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00326','24/07/2026','10:50:00','CLI098','Pedro Gutiérrez Flores','M','55','Namora','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','2','33.51','67.02','10.05','12.06','69.03','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00327','22/04/2026','09:45:47','CLI116','José Gómez Díaz','M','65','Llacanora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','1.04','3.74','23.48','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00328','21/01/2026','10:33:48','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','5','6.6','33.0','3.3','5.94','35.64','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00329','27/07/2026','10:54:04','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','3','29.87','89.61','0.0','16.13','105.74','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00330','08/06/2026','18:39:31','CLI121','Roberto Castillo Díaz','M','23','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.29','1.05','6.6','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00331','17/05/2026','08:18:17','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','0.0','9.77','64.05','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00332','24/01/2026','14:13:21','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','4','97.38','389.52','38.95','70.11','420.68','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00333','28/06/2026','09:03:17','CLI004','Ana Díaz Rodríguez','F','20','Magdalena','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','1','12.54','12.54','1.88','2.26','12.92','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00334','01/08/2026','19:45:15','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD024','Simvastatina 40mg','Medicamentos','Genfar','SI','4','18.11','72.44','3.62','13.04','81.86','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00335','17/07/2026','17:13:30','CLI233','Diana Sánchez Rodríguez','F','75','Namora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.15','2.07','12.44','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00336','14/05/2026','14:40:19','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','1','72.29','72.29','3.61','13.01','81.69','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00337','25/03/2026','19:17:37','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','2','69.19','138.38','0.0','24.91','163.29','Yape','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00338','09/02/2026','08:15:10','CLI071','Mario Mendoza Gómez','M','60','Namora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','1.73','3.11','18.66','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00339','16/01/2026','09:44:34','CLI170','Luis Gutiérrez Vargas','M','76','Namora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','1','10.39','10.39','1.56','1.87','10.7','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00340','21/07/2026','12:51:57','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','0.0','4.89','32.03','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Anulada'),
('V00341','24/05/2026','18:31:12','CLI121','Roberto Castillo Díaz','M','23','Namora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','36.2','65.16','390.96','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00342','07/07/2026','14:18:52','CLI160','Jorge García Ruiz','M','25','Jesús','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','3','50.31','150.93','22.64','27.17','155.46','Yape','VEN001','Ana Díaz','Tarde','Convenio','Completada'),
('V00343','18/07/2026','10:20:46','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','5','17.48','87.4','13.11','15.73','90.02','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00344','16/07/2026','16:18:20','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','3','72.4','217.2','0.0','39.1','256.3','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00345','03/02/2026','07:12:06','CLI062','Lucía Mendoza Gutiérrez','F','35','Magdalena','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','1','93.42','93.42','0.0','16.82','110.24','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00346','14/06/2026','17:31:33','CLI110','Ana García Flores','F','80','Namora','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','5','74.88','374.4','37.44','67.39','404.35','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00347','04/04/2026','18:04:00','CLI116','José Gómez Díaz','M','65','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','4.07','4.89','27.96','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00348','16/01/2026','18:56:26','CLI217','María Gonzales Quispe','F','21','Jesús','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','6','8.08','48.48','0.0','8.73','57.21','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00349','07/07/2026','11:04:13','CLI162','Silvia Díaz Gonzales','F','25','Baños del Inca','PROD044','Jabón Protex','Cuidado personal','Teva','NO','1','5.74','5.74','0.0','1.03','6.77','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00350','17/05/2026','10:33:42','CLI102','Teresa Fernández Díaz','F','58','Llacanora','PROD042','Shampoo Pantene','Cuidado personal','Genfar','NO','6','12.6','75.6','3.78','13.61','85.43','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Devuelta'),
('V00351','11/07/2026','18:06:49','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','3','30.24','90.72','13.61','16.33','93.44','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00352','15/08/2026','19:11:35','CLI178','Sonia Rodríguez Mamani','F','52','Jesús','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','3','44.34','133.02','6.65','23.94','150.31','Plin','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00353','03/06/2026','12:54:23','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','23.7','28.44','162.72','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00354','05/06/2026','21:47:16','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','1.89','2.27','12.98','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00355','14/03/2026','15:08:56','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','3','17.48','52.44','2.62','9.44','59.26','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00356','08/08/2026','19:52:44','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','1.41','5.08','31.92','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00357','10/01/2026','09:08:16','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','5','50.31','251.55','12.58','45.28','284.25','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00358','24/01/2026','18:20:50','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','4','12.54','50.16','0.0','9.03','59.19','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Devuelta'),
('V00359','14/06/2026','18:51:36','CLI166','Luis Ruiz Torres','M','57','Baños del Inca','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','1','74.88','74.88','7.49','13.48','80.87','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00360','03/01/2026','17:24:03','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','1','74.88','74.88','7.49','13.48','80.87','Plin','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00361','25/05/2026','15:44:14','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','6','5.76','34.56','5.18','6.22','35.6','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00362','12/07/2026','15:05:14','CLI116','José Gómez Díaz','M','65','Llacanora','PROD038','Complejo B','Vitaminas','Medifarma','NO','4','27.37','109.48','5.47','19.71','123.72','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00363','28/03/2026','11:05:25','CLI195','Víctor Ruiz García','M','57','Magdalena','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','6','55.29','331.74','16.59','59.71','374.86','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00364','05/05/2026','18:33:15','CLI039','Silvia Díaz Sánchez','F','57','Jesús','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','3','84.37','253.11','37.97','45.56','260.7','Tarjeta','VEN003','Rosa Fernández','Tarde','Nuevo','Completada'),
('V00365','23/01/2026','13:27:23','CLI211','Andrea Cruz López','F','23','Jesús','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','3','74.88','224.64','22.46','40.44','242.62','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00366','17/06/2026','11:10:22','CLI187','Ana Rojas Huamán','F','62','Magdalena','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','1.04','3.74','23.48','Tarjeta','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00367','01/03/2026','08:07:47','CLI176','Carmen Rodríguez Huamán','F','55','Namora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','0.79','2.83','17.79','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00368','04/01/2026','19:07:19','CLI096','Marta Vargas Flores','F','38','Cajamarca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','1','6.56','6.56','0.66','1.18','7.08','Tarjeta','VEN002','Carlos Rojas','Noche','Nuevo','Completada'),
('V00369','09/07/2026','10:34:33','CLI081','Carmen Gómez Torres','F','39','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','19.75','23.7','135.6','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00370','27/06/2026','15:02:16','CLI129','María Quispe Quispe','F','78','Magdalena','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','3','50.31','150.93','7.55','27.17','170.55','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Devuelta'),
('V00371','11/03/2026','17:00:04','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','5.12','9.22','55.31','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00372','05/01/2026','21:41:24','CLI203','Luis Fernández Huamán','M','55','Namora','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','4','29.87','119.48','0.0','21.51','140.99','Tarjeta','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00373','17/05/2026','10:32:29','CLI199','Ana Castillo Rodríguez','F','27','Llacanora','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','6','93.42','560.52','0.0','100.89','661.41','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00374','20/03/2026','13:47:10','CLI106','Diana Vargas Quispe','F','73','Jesús','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','3','10.39','31.17','3.12','5.61','33.66','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00375','10/06/2026','15:17:51','CLI243','Rosa Huamán Torres','F','58','Cajamarca','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','3','11.65','34.95','5.24','6.29','36.0','Tarjeta','VEN001','Ana Díaz','Tarde','Nuevo','Completada'),
('V00376','30/08/2026','11:14:09','CLI217','María Gonzales Quispe','F','21','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','16.15','58.15','365.08','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00377','06/07/2026','17:39:55','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD012','Loratadina 10mg','Medicamentos','Genfar','NO','2','6.54','13.08','1.96','2.35','13.47','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00378','27/05/2026','11:58:38','CLI038','Lucía Mamani Torres','F','58','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','6.58','23.7','148.77','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00379','17/06/2026','15:43:51','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','16.15','29.08','174.47','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Anulada'),
('V00380','21/08/2026','16:58:10','CLI112','Luis Díaz Fernández','M','79','Magdalena','PROD015','Losartán 100mg','Medicamentos','Teva','SI','3','22.4','67.2','0.0','12.1','79.3','Yape','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00381','15/07/2026','13:26:19','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','3','8.08','24.24','2.42','4.36','26.18','Efectivo','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00382','19/07/2026','09:11:01','CLI163','Carmen Gonzales Ruiz','F','80','Jesús','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','3','10.39','31.17','3.12','5.61','33.66','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00383','02/06/2026','17:01:22','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','0.63','2.27','14.24','Plin','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00384','02/07/2026','09:54:24','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','2','84.37','168.74','8.44','30.37','190.67','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00385','27/02/2026','19:00:59','CLI032','Fernando García Flores','M','52','Magdalena','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','4','4.21','16.84','0.84','3.03','19.03','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00386','13/07/2026','09:59:28','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','4','26.33','105.32','10.53','18.96','113.75','Plin','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00387','16/08/2026','20:24:46','CLI153','Andrea Cruz Flores','F','68','Llacanora','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','0.0','3.11','20.39','Yape','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00388','08/07/2026','07:12:18','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','1.7','3.05','18.3','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00389','12/02/2026','09:49:37','CLI051','Mario Gonzales Mamani','M','47','Cajamarca','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','6','8.08','48.48','2.42','8.73','54.79','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00390','16/04/2026','18:57:12','CLI182','Raúl López Quispe','M','49','Namora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','1','62.78','62.78','6.28','11.3','67.8','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00391','27/06/2026','18:50:10','CLI121','Roberto Castillo Díaz','M','23','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.0','1.05','6.89','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00392','30/06/2026','18:50:32','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','11.64','13.97','79.93','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00393','08/04/2026','09:58:21','CLI063','Jorge Castillo García','M','29','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','6','80.77','484.62','24.23','87.23','547.62','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00394','11/08/2026','19:45:03','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','1.59','1.91','10.92','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00395','10/06/2026','21:08:12','CLI211','Andrea Cruz López','F','23','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','0.0','3.54','23.22','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00396','02/03/2026','17:30:29','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','1','44.34','44.34','0.0','7.98','52.32','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00397','08/06/2026','20:52:13','CLI103','Luis Mendoza Gutiérrez','M','28','Magdalena','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','2','24.06','48.12','0.0','8.66','56.78','Tarjeta','VEN003','Rosa Fernández','Noche','Nuevo','Completada'),
('V00398','10/01/2026','11:21:58','CLI237','Víctor Gutiérrez Díaz','M','42','Jesús','PROD054','Pañales Babysec G','Bebés','Genfar','NO','1','62.78','62.78','9.42','11.3','64.66','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00399','06/06/2026','18:38:36','CLI113','Diana Rodríguez Vargas','F','53','Llacanora','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','2','28.41','56.82','8.52','10.23','58.53','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00400','24/03/2026','20:35:04','CLI225','Andrés Rodríguez Quispe','M','20','Jesús','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','2','24.06','48.12','0.0','8.66','56.78','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00401','15/05/2026','10:39:03','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','6','12.72','76.32','0.0','13.74','90.06','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00402','05/07/2026','21:50:45','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','5','5.3','26.5','2.65','4.77','28.62','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00403','09/06/2026','09:39:36','CLI169','María Fernández Flores','F','29','Llacanora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','6','3.15','18.9','2.83','3.4','19.47','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00404','26/07/2026','16:14:45','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00405','23/07/2026','13:26:02','CLI182','Raúl López Quispe','M','49','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','5','27.14','135.7','6.79','24.43','153.34','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00406','13/06/2026','11:16:50','CLI192','Andrea Quispe Díaz','F','27','Cajamarca','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','3','30.24','90.72','9.07','16.33','97.98','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00407','29/03/2026','10:21:53','CLI026','Elena Castillo Ruiz','F','46','Baños del Inca','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','27.22','32.66','186.88','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00408','24/07/2026','09:30:09','CLI005','Ana Mendoza Mendoza','F','45','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','2.83','5.08','30.5','Plin','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00409','02/08/2026','16:46:43','CLI191','Lucía Cruz Rodríguez','F','34','Jesús','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','5','11.21','56.05','0.0','10.09','66.14','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00410','23/07/2026','09:17:53','CLI032','Fernando García Flores','M','52','Magdalena','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','4','6.6','26.4','1.32','4.75','29.83','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00411','05/06/2026','11:45:54','CLI132','Juana Castillo Díaz','F','46','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.32','0.57','3.4','Plin','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00412','02/03/2026','09:07:23','CLI078','Silvia Sánchez Gutiérrez','F','26','Cajamarca','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','2','84.37','168.74','0.0','30.37','199.11','Yape','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00413','10/05/2026','14:57:32','CLI184','Carmen Flores Gómez','F','24','Namora','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','3','97.38','292.14','43.82','52.59','300.91','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00414','29/08/2026','09:13:46','CLI089','José Vargas García','M','78','Namora','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','4','9.96','39.84','0.0','7.17','47.01','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00415','12/08/2026','14:56:02','CLI112','Luis Díaz Fernández','M','79','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','1.73','3.11','18.66','Yape','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00416','13/06/2026','12:12:12','CLI063','Jorge Castillo García','M','29','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','2.83','5.08','30.5','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00417','21/06/2026','09:10:17','CLI162','Silvia Díaz Gonzales','F','25','Baños del Inca','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','5','72.29','361.45','0.0','65.06','426.51','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00418','19/05/2026','19:18:36','CLI213','Ana Mamani Rodríguez','F','43','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','8.08','14.54','87.23','Efectivo','VEN005','Patricia Torres','Noche','Nuevo','Completada'),
('V00419','17/08/2026','14:03:08','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','0.0','78.19','512.59','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00420','09/04/2026','18:28:39','CLI165','Juan Díaz Mamani','M','20','Namora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','0.98','3.54','22.24','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Devuelta'),
('V00421','26/05/2026','18:49:29','CLI233','Diana Sánchez Rodríguez','F','75','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.28','1.02','6.39','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00422','11/04/2026','21:20:29','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','1','97.38','97.38','14.61','17.53','100.3','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00423','05/08/2026','19:22:38','CLI211','Andrea Cruz López','F','23','Jesús','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','0.0','65.16','427.16','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00424','28/01/2026','17:04:50','CLI128','Luis Flores Castillo','M','56','Namora','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','4','4.21','16.84','2.53','3.03','17.34','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00425','16/04/2026','10:35:10','CLI218','Lucía García Rojas','F','22','Cajamarca','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','4','12.72','50.88','0.0','9.16','60.04','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00426','01/06/2026','13:36:50','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','6','5.84','35.04','1.75','6.31','39.6','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00427','29/04/2026','08:52:28','CLI248','Sonia Fernández Vargas','F','32','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','4','6.56','26.24','0.0','4.72','30.96','Efectivo','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00428','08/04/2026','17:42:03','CLI053','Ricardo Castillo Sánchez','M','70','Namora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','1','17.07','17.07','0.0','3.07','20.14','Yape','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00429','19/06/2026','17:19:58','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','4','44.33','177.32','17.73','31.92','191.51','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00430','30/05/2026','15:25:54','CLI001','Fernando Torres Huamán','M','59','Magdalena','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','3','44.34','133.02','0.0','23.94','156.96','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00431','14/01/2026','15:52:22','CLI053','Ricardo Castillo Sánchez','M','70','Namora','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','3','97.38','292.14','0.0','52.59','344.73','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00432','11/04/2026','18:24:25','CLI038','Lucía Mamani Torres','F','58','Jesús','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','5','69.19','345.95','17.3','62.27','390.92','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Devuelta'),
('V00433','02/05/2026','20:26:09','CLI098','Pedro Gutiérrez Flores','M','55','Namora','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','6','8.93','53.58','2.68','9.64','60.54','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00434','03/01/2026','17:27:08','CLI147','Manuel Mendoza Gómez','M','40','Magdalena','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','6','33.51','201.06','30.16','36.19','207.09','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00435','09/06/2026','13:22:14','CLI001','Fernando Torres Huamán','M','59','Magdalena','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','5','6.6','33.0','0.0','5.94','38.94','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00436','10/03/2026','15:36:23','CLI024','Juan Sánchez García','M','25','Llacanora','PROD040','Omega 3','Vitaminas','Teva','NO','1','47.32','47.32','7.1','8.52','48.74','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00437','26/06/2026','18:46:33','CLI018','Lucía Ruiz Rojas','F','59','Namora','PROD040','Omega 3','Vitaminas','Teva','NO','3','47.32','141.96','21.29','25.55','146.22','Yape','VEN005','Patricia Torres','Tarde','Nuevo','Completada'),
('V00438','06/06/2026','17:04:43','CLI150','José Rojas Huamán','M','28','Magdalena','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','5','11.65','58.25','5.83','10.48','62.9','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00439','07/07/2026','12:51:18','CLI204','Teresa Huamán Mamani','F','19','Llacanora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','3.88','6.98','41.9','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00440','08/03/2026','17:18:51','CLI087','Patricia Castillo Fernández','F','51','Jesús','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','1','93.42','93.42','9.34','16.82','100.9','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00441','22/01/2026','08:54:50','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','7.76','13.97','83.81','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00442','08/08/2026','18:07:38','CLI112','Luis Díaz Fernández','M','79','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','0.98','3.54','22.24','Efectivo','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00443','24/07/2026','16:59:52','CLI182','Raúl López Quispe','M','49','Namora','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','4','84.37','337.48','50.62','60.75','347.61','Tarjeta','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00444','05/07/2026','10:36:46','CLI110','Ana García Flores','F','80','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','3.88','6.98','41.9','Tarjeta','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00445','14/01/2026','13:30:19','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','18.1','65.16','409.06','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00446','02/05/2026','15:55:27','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','4','10.39','41.56','6.23','7.48','42.81','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00447','11/01/2026','11:21:17','CLI007','Carmen Quispe Castillo','F','18','Magdalena','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.58','1.05','6.31','Tarjeta','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00448','11/04/2026','17:47:15','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','5','72.29','361.45','18.07','65.06','408.44','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00449','16/02/2026','17:28:22','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','3','9.96','29.88','2.99','5.38','32.27','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00450','09/01/2026','18:07:05','CLI199','Ana Castillo Rodríguez','F','27','Llacanora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','11.64','13.97','79.93','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00451','25/07/2026','21:07:44','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','3','30.24','90.72','13.61','16.33','93.44','Yape','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00452','13/06/2026','11:49:27','CLI180','Carmen Gonzales Rojas','F','49','Namora','PROD060','Crema Cero','Bebés','Genfar','NO','6','18.07','108.42','10.84','19.52','117.1','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00453','08/04/2026','07:16:52','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','4','44.34','177.36','0.0','31.92','209.28','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00454','26/08/2026','13:11:41','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','1.7','2.03','11.63','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00455','07/06/2026','21:28:45','CLI064','Rosa Ruiz García','F','63','Llacanora','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','1','84.92','84.92','0.0','15.29','100.21','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00456','18/07/2026','11:09:44','CLI188','Víctor Castillo Vargas','M','42','Jesús','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','4','8.93','35.72','0.0','6.43','42.15','Tarjeta','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00457','19/07/2026','08:34:14','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','3','3.15','9.45','1.42','1.7','9.73','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00458','02/04/2026','11:25:03','CLI036','Andrea Pérez Ruiz','F','52','Cajamarca','PROD038','Complejo B','Vitaminas','Medifarma','NO','6','27.37','164.22','0.0','29.56','193.78','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00459','29/03/2026','14:48:49','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','2','5.84','11.68','0.58','2.1','13.2','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Anulada'),
('V00460','19/06/2026','18:24:57','CLI138','Manuel Huamán Quispe','M','83','Cajamarca','PROD060','Crema Cero','Bebés','Genfar','NO','6','18.07','108.42','10.84','19.52','117.1','Efectivo','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00461','05/02/2026','07:46:37','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','4','72.4','289.6','0.0','52.13','341.73','Plin','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00462','14/06/2026','15:53:51','CLI165','Juan Díaz Mamani','M','20','Namora','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','1','28.53','28.53','0.0','5.14','33.67','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00463','15/01/2026','18:02:25','CLI242','Elena Cruz Mendoza','F','77','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','23.7','28.44','162.72','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00464','08/06/2026','18:41:08','CLI038','Lucía Mamani Torres','F','58','Jesús','PROD021','Clonazepam 2mg','Medicamentos','Roche','SI','6','53.2','319.2','0.0','57.46','376.66','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00465','02/08/2026','20:52:06','CLI138','Manuel Huamán Quispe','M','83','Cajamarca','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','2.56','9.22','57.87','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00466','25/07/2026','17:25:20','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','6','5.65','33.9','1.7','6.1','38.3','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00467','01/06/2026','08:07:17','CLI022','Pedro Ruiz Vargas','M','20','Jesús','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','4','24.06','96.24','4.81','17.32','108.75','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00468','22/05/2026','10:59:37','CLI235','Ricardo García Gómez','M','52','Magdalena','PROD056','Leche Enfamil 1','Bebés','Abbott','NO','1','77.41','77.41','11.61','13.93','79.73','Yape','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00469','21/01/2026','09:59:05','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','5','11.21','56.05','5.61','10.09','60.53','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00470','27/06/2026','19:30:44','CLI128','Luis Flores Castillo','M','56','Namora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','2','72.4','144.8','14.48','26.06','156.38','Yape','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00471','26/04/2026','09:39:44','CLI194','Teresa Rodríguez Pérez','F','44','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.73','2.07','11.86','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00472','20/07/2026','13:00:35','CLI087','Patricia Castillo Fernández','F','51','Jesús','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','1','9.96','9.96','0.0','1.79','11.75','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00473','18/06/2026','17:54:58','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','2','9.96','19.92','1.0','3.59','22.51','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00474','14/03/2026','11:21:39','CLI116','José Gómez Díaz','M','65','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','0.0','58.15','381.23','Tarjeta','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00475','09/07/2026','14:32:07','CLI018','Lucía Ruiz Rojas','F','59','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','11.64','13.97','79.93','Tarjeta','VEN005','Patricia Torres','Tarde','Nuevo','Completada'),
('V00476','29/05/2026','10:47:43','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','1','21.05','21.05','0.0','3.79','24.84','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00477','28/02/2026','18:26:55','CLI100','Miguel Flores Díaz','M','77','Jesús','PROD041','Shampoo Head&Shoulders','Cuidado personal','Abbott','NO','2','24.16','48.32','0.0','8.7','57.02','Plin','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00478','30/05/2026','21:27:09','CLI131','Diana Mamani Torres','F','67','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','5.64','6.77','38.75','Tarjeta','VEN002','Carlos Rojas','Noche','Adulto Mayor','Completada'),
('V00479','10/04/2026','11:12:21','CLI161','Patricia Castillo Huamán','F','25','Namora','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','6','93.42','560.52','0.0','100.89','661.41','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00480','04/02/2026','14:29:26','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','0.8','2.86','17.96','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00481','04/06/2026','19:40:39','CLI083','Rocío Torres Sánchez','F','57','Magdalena','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','5','84.92','424.6','21.23','76.43','479.8','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00482','05/03/2026','09:58:36','CLI245','Rocío Mamani Fernández','F','46','Jesús','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','4','5.3','21.2','0.0','3.82','25.02','Efectivo','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00483','10/05/2026','18:52:06','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','2','30.24','60.48','0.0','10.89','71.37','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00484','12/07/2026','18:26:13','CLI153','Andrea Cruz Flores','F','68','Llacanora','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','2','37.3','74.6','3.73','13.43','84.3','Tarjeta','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00485','20/03/2026','20:45:25','CLI127','Patricia Mendoza Torres','F','76','Magdalena','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','3','80.77','242.31','36.35','43.62','249.58','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Devuelta'),
('V00486','09/08/2026','13:57:44','CLI167','Patricia López Pérez','F','35','Baños del Inca','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','1','12.72','12.72','1.27','2.29','13.74','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00487','12/07/2026','19:43:05','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','3','6.56','19.68','0.0','3.54','23.22','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00488','29/01/2026','14:39:02','CLI132','Juana Castillo Díaz','F','46','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','2','72.4','144.8','0.0','26.06','170.86','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00489','16/06/2026','19:37:55','CLI181','Carmen Castillo Gonzales','F','84','Llacanora','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','1.12','4.03','25.31','Tarjeta','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00490','12/03/2026','12:22:28','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD054','Pañales Babysec G','Bebés','Genfar','NO','5','62.78','313.9','0.0','56.5','370.4','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00491','01/07/2026','20:34:57','CLI203','Luis Fernández Huamán','M','55','Namora','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','5','24.06','120.3','12.03','21.65','129.92','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00492','28/04/2026','13:57:11','CLI204','Teresa Huamán Mamani','F','19','Llacanora','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','1','56.45','56.45','0.0','10.16','66.61','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00493','12/03/2026','09:31:09','CLI204','Teresa Huamán Mamani','F','19','Llacanora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','5','6.56','32.8','0.0','5.9','38.7','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00494','02/05/2026','14:47:41','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','2','8.93','17.86','0.0','3.21','21.07','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00495','15/06/2026','15:53:35','CLI154','Teresa Rodríguez Vargas','F','64','Baños del Inca','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','1.71','6.15','38.58','Tarjeta','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00496','28/02/2026','11:49:54','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','3','12.72','38.16','3.82','6.87','41.21','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00497','15/03/2026','09:53:45','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','6','9.33','55.98','2.8','10.08','63.26','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00498','02/03/2026','12:36:08','CLI215','Rocío Rojas López','F','33','Jesús','PROD021','Clonazepam 2mg','Medicamentos','Roche','SI','3','53.2','159.6','7.98','28.73','180.35','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00499','20/06/2026','12:09:23','CLI162','Silvia Díaz Gonzales','F','25','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','2','44.34','88.68','8.87','15.96','95.77','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00500','24/08/2026','21:31:49','CLI057','Mario Gómez López','M','45','Llacanora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','4','5.84','23.36','2.34','4.2','25.22','Efectivo','VEN002','Carlos Rojas','Noche','Nuevo','Completada'),
('V00501','24/07/2026','21:59:28','CLI234','Andrés Gómez García','M','40','Llacanora','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','1','9.96','9.96','1.49','1.79','10.26','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00502','30/01/2026','13:39:53','CLI166','Luis Ruiz Torres','M','57','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','0.0','2.86','18.76','Tarjeta','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00503','16/07/2026','17:42:05','CLI138','Manuel Huamán Quispe','M','83','Cajamarca','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','2','28.53','57.06','2.85','10.27','64.48','Efectivo','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00504','12/04/2026','20:27:23','CLI217','María Gonzales Quispe','F','21','Jesús','PROD039','Calcibon D','Vitaminas','Medifarma','NO','1','75.16','75.16','7.52','13.53','81.17','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Anulada'),
('V00505','31/03/2026','14:55:35','CLI030','Manuel Mendoza Rodríguez','M','78','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','2.59','3.11','17.8','Efectivo','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00506','25/07/2026','09:51:46','CLI229','Patricia Rojas Díaz','F','57','Llacanora','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','4','72.29','289.16','43.37','52.05','297.84','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00507','02/08/2026','08:09:13','CLI226','Andrea Rojas Castillo','F','21','Llacanora','PROD058','Leche NAN 3','Bebés','Roche','NO','5','72.81','364.05','36.41','65.53','393.17','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00508','13/07/2026','13:11:35','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','7.56','27.22','170.86','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00509','09/07/2026','07:50:00','CLI073','Diego García Flores','M','31','Llacanora','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','3','9.96','29.88','4.48','5.38','30.78','Efectivo','VEN001','Ana Díaz','Mañana','Convenio','Completada'),
('V00510','17/06/2026','11:26:11','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','6','6.56','39.36','1.97','7.08','44.47','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00511','18/01/2026','18:52:07','CLI119','Fernando Castillo Gutiérrez','M','43','Namora','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','6','4.21','25.26','0.0','4.55','29.81','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00512','07/02/2026','21:44:08','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','1','44.34','44.34','4.43','7.98','47.89','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00513','18/04/2026','12:03:18','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','0.0','32.66','214.1','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00514','20/05/2026','11:17:43','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','0.0','3.05','20.0','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00515','29/05/2026','09:00:08','CLI010','Fernando Gutiérrez Pérez','M','23','Jesús','PROD039','Calcibon D','Vitaminas','Medifarma','NO','3','75.16','225.48','33.82','40.59','232.25','Plin','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00516','11/02/2026','09:32:14','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','0.0','5.08','33.33','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00517','25/08/2026','12:19:44','CLI031','Luis Castillo Gómez','M','41','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','2.26','4.07','24.41','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00518','01/07/2026','18:52:07','CLI205','Elena Flores Gómez','F','26','Cajamarca','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','6','50.31','301.86','15.09','54.33','341.1','Yape','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00519','20/03/2026','09:05:27','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','0.0','4.03','26.43','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00520','18/07/2026','13:02:12','CLI150','José Rojas Huamán','M','28','Magdalena','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','6','29.84','179.04','0.0','32.23','211.27','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00521','12/01/2026','17:00:48','CLI159','Carmen Rojas Díaz','F','69','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','1.32','4.74','29.75','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00522','19/08/2026','17:22:01','CLI128','Luis Flores Castillo','M','56','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','6','5.65','33.9','3.39','6.1','36.61','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00523','31/03/2026','10:32:36','CLI164','Víctor Flores Torres','M','74','Cajamarca','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','5','93.42','467.1','0.0','84.08','551.18','Yape','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00524','14/03/2026','19:34:00','CLI127','Patricia Mendoza Torres','F','76','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','1.94','6.98','43.84','Efectivo','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00525','17/02/2026','08:11:53','CLI097','Fernando Rodríguez Ruiz','M','82','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.73','2.07','11.86','Efectivo','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00526','12/05/2026','08:48:20','CLI072','Laura Pérez Gonzales','F','43','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','4.04','14.54','91.27','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00527','15/07/2026','11:35:46','CLI052','Lucía Flores Díaz','F','31','Namora','PROD044','Jabón Protex','Cuidado personal','Teva','NO','3','5.74','17.22','2.58','3.1','17.74','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00528','09/04/2026','11:54:27','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.88','1.05','6.01','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00529','15/02/2026','17:31:43','CLI010','Fernando Gutiérrez Pérez','M','23','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','0.0','4.07','26.67','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00530','06/02/2026','18:37:06','CLI143','Diego Gómez Rojas','M','28','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','0.0','9.48','62.14','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00531','20/02/2026','16:54:25','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.97','2.36','13.51','Yape','VEN003','Rosa Fernández','Tarde','Adulto Mayor','Completada'),
('V00532','14/06/2026','13:31:32','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','4','26.33','105.32','0.0','18.96','124.28','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00533','01/03/2026','09:01:06','CLI174','Luis Rojas Flores','M','49','Namora','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','1','84.37','84.37','12.66','15.19','86.9','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00534','15/02/2026','17:20:09','CLI103','Luis Mendoza Gutiérrez','M','28','Magdalena','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','5','28.41','142.05','0.0','25.57','167.62','Efectivo','VEN001','Ana Díaz','Tarde','Nuevo','Completada'),
('V00535','16/07/2026','19:55:34','CLI177','Mario Vargas García','M','57','Llacanora','PROD042','Shampoo Pantene','Cuidado personal','Genfar','NO','1','12.6','12.6','1.89','2.27','12.98','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00536','07/08/2026','14:02:02','CLI237','Víctor Gutiérrez Díaz','M','42','Jesús','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','43.44','78.19','469.15','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00537','06/05/2026','11:45:24','CLI013','José Cruz López','M','37','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','1','5.3','5.3','0.79','0.95','5.46','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00538','25/06/2026','15:03:25','CLI171','Roberto Cruz García','M','61','Magdalena','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','3','28.53','85.59','12.84','15.41','88.16','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00539','23/06/2026','11:20:03','CLI098','Pedro Gutiérrez Flores','M','55','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.28','1.02','6.39','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00540','30/05/2026','21:40:21','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','2.26','4.07','24.41','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00541','16/04/2026','17:15:15','CLI168','Elizabeth Rodríguez Pérez','F','23','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','3','44.34','133.02','0.0','23.94','156.96','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00542','11/08/2026','16:32:57','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','1','12.72','12.72','1.91','2.29','13.1','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00543','26/07/2026','18:43:13','CLI218','Lucía García Rojas','F','22','Cajamarca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','36.2','65.16','390.96','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00544','07/06/2026','19:04:53','CLI019','Juana Gutiérrez Castillo','F','19','Magdalena','PROD038','Complejo B','Vitaminas','Medifarma','NO','2','27.37','54.74','5.47','9.85','59.12','Efectivo','VEN003','Rosa Fernández','Noche','Nuevo','Completada'),
('V00545','13/01/2026','16:25:51','CLI110','Ana García Flores','F','80','Namora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','0.0','6.77','44.39','Yape','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00546','25/01/2026','11:04:36','CLI012','Ana Ruiz Rojas','F','25','Namora','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','4','37.3','149.2','22.38','26.86','153.68','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00547','22/03/2026','17:48:35','CLI180','Carmen Gonzales Rojas','F','49','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','1','30.24','30.24','1.51','5.44','34.17','Tarjeta','VEN005','Patricia Torres','Tarde','Nuevo','Completada'),
('V00548','08/05/2026','20:47:29','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','6','12.72','76.32','11.45','13.74','78.61','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00549','06/07/2026','15:12:23','CLI194','Teresa Rodríguez Pérez','F','44','Baños del Inca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','3.88','13.97','87.69','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00550','05/08/2026','17:13:54','CLI215','Rocío Rojas López','F','33','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','3','80.77','242.31','12.12','43.62','273.81','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00551','25/06/2026','13:15:07','CLI145','Luis Vargas Gonzales','M','69','Magdalena','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','1','12.54','12.54','0.63','2.26','14.17','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00552','22/04/2026','21:02:12','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','0.0','9.48','62.14','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00553','18/06/2026','17:54:02','CLI036','Andrea Pérez Ruiz','F','52','Cajamarca','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','4','81.28','325.12','0.0','58.52','383.64','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00554','22/03/2026','09:15:07','CLI007','Carmen Quispe Castillo','F','18','Magdalena','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','5','9.33','46.65','0.0','8.4','55.05','Yape','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00555','20/06/2026','19:59:33','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','1.32','4.74','29.75','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00556','22/03/2026','18:15:59','CLI150','José Rojas Huamán','M','28','Magdalena','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','2','8.08','16.16','0.0','2.91','19.07','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Devuelta'),
('V00557','23/04/2026','20:37:03','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','3','44.34','133.02','0.0','23.94','156.96','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00558','20/05/2026','17:15:17','CLI008','Andrea Fernández Cruz','F','80','Jesús','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','1','24.06','24.06','2.41','4.33','25.98','Plin','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00559','03/07/2026','11:01:41','CLI011','Carlos García Gómez','M','62','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','3','3.15','9.45','0.0','1.7','11.15','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00560','21/06/2026','18:23:57','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD050','Toallas Higiénicas Nosotras','Cuidado personal','AC Farma','NO','1','11.65','11.65','0.58','2.1','13.17','Yape','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00561','10/04/2026','13:59:58','CLI223','Diana Quispe Mendoza','F','44','Baños del Inca','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','1','21.05','21.05','1.05','3.79','23.79','Plin','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00562','11/06/2026','19:49:41','CLI221','Roberto López Quispe','M','85','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','1','27.14','27.14','2.71','4.89','29.32','Tarjeta','VEN001','Ana Díaz','Noche','Adulto Mayor','Devuelta'),
('V00563','28/06/2026','20:35:47','CLI077','Roberto Mamani Mamani','M','72','Jesús','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','6','55.29','331.74','0.0','59.71','391.45','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Completada'),
('V00564','14/06/2026','17:28:50','CLI090','Teresa Pérez Gutiérrez','F','65','Llacanora','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','1','56.45','56.45','8.47','10.16','58.14','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00565','10/06/2026','16:05:07','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD060','Crema Cero','Bebés','Genfar','NO','5','18.07','90.35','4.52','16.26','102.09','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00566','25/06/2026','09:16:11','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','3','5.3','15.9','1.59','2.86','17.17','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00567','22/01/2026','09:25:56','CLI090','Teresa Pérez Gutiérrez','F','65','Llacanora','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','1.88','6.77','42.51','Plin','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00568','31/08/2026','21:05:29','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD039','Calcibon D','Vitaminas','Medifarma','NO','6','75.16','450.96','22.55','81.17','509.58','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00569','03/06/2026','19:58:59','CLI158','Luis Huamán Vargas','M','69','Magdalena','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','7.68','9.22','52.75','Efectivo','VEN001','Ana Díaz','Noche','Adulto Mayor','Devuelta'),
('V00570','08/04/2026','20:13:38','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD044','Jabón Protex','Cuidado personal','Teva','NO','3','5.74','17.22','0.86','3.1','19.46','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00571','16/02/2026','09:01:18','CLI052','Lucía Flores Díaz','F','31','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','7.9','9.48','54.24','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00572','05/04/2026','17:29:05','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD021','Clonazepam 2mg','Medicamentos','Roche','SI','2','53.2','106.4','10.64','19.15','114.91','Plin','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00573','25/06/2026','11:04:06','CLI178','Sonia Rodríguez Mamani','F','52','Jesús','PROD038','Complejo B','Vitaminas','Medifarma','NO','1','27.37','27.37','2.74','4.93','29.56','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00574','25/07/2026','18:51:02','CLI195','Víctor Ruiz García','M','57','Magdalena','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','4.24','5.08','29.09','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00575','24/05/2026','09:16:10','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','3','84.92','254.76','38.21','45.86','262.41','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00576','23/01/2026','15:27:09','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','3','38.8','116.4','0.0','20.95','137.35','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00577','02/08/2026','12:59:27','CLI099','Carmen Torres Quispe','F','20','Jesús','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','3','72.29','216.87','21.69','39.04','234.22','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00578','22/03/2026','09:20:47','CLI101','Diego Rodríguez Pérez','M','46','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','7.9','9.48','54.24','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00579','18/02/2026','10:11:02','CLI217','María Gonzales Quispe','F','21','Jesús','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','2','84.37','168.74','25.31','30.37','173.8','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00580','24/04/2026','18:35:31','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD040','Omega 3','Vitaminas','Teva','NO','1','47.32','47.32','2.37','8.52','53.47','Plin','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00581','31/03/2026','18:32:52','CLI030','Manuel Mendoza Rodríguez','M','78','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','6','44.34','266.04','13.3','47.89','300.63','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00582','27/05/2026','17:06:56','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Tarjeta','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00583','09/02/2026','21:51:36','CLI128','Luis Flores Castillo','M','56','Namora','PROD044','Jabón Protex','Cuidado personal','Teva','NO','1','5.74','5.74','0.57','1.03','6.2','Tarjeta','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00584','24/07/2026','08:35:38','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','4','9.33','37.32','3.73','6.72','40.31','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00585','10/08/2026','07:54:13','CLI035','Manuel Gonzales Quispe','M','26','Magdalena','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','4','4.21','16.84','1.68','3.03','18.19','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00586','31/01/2026','19:27:47','CLI072','Laura Pérez Gonzales','F','43','Llacanora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','3','17.07','51.21','2.56','9.22','57.87','Plin','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00587','20/06/2026','12:32:12','CLI250','Marta Cruz Fernández','F','64','Namora','PROD038','Complejo B','Vitaminas','Medifarma','NO','4','27.37','109.48','16.42','19.71','112.77','Tarjeta','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00588','27/07/2026','09:27:40','CLI004','Ana Díaz Rodríguez','F','20','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','1','72.4','72.4','7.24','13.03','78.19','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00589','23/06/2026','17:45:09','CLI036','Andrea Pérez Ruiz','F','52','Cajamarca','PROD058','Leche NAN 3','Bebés','Roche','NO','5','72.81','364.05','0.0','65.53','429.58','Tarjeta','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00590','30/04/2026','21:51:30','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','2','84.92','169.84','16.98','30.57','183.43','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00591','14/05/2026','16:03:35','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','1','21.05','21.05','0.0','3.79','24.84','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00592','19/04/2026','11:22:16','CLI019','Juana Gutiérrez Castillo','F','19','Magdalena','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','5','44.33','221.65','0.0','39.9','261.55','Efectivo','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00593','09/07/2026','09:50:11','CLI236','Andrés Gonzales Sánchez','M','77','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.0','1.02','6.67','Plin','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00594','22/03/2026','14:48:42','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','3','3.15','9.45','0.94','1.7','10.21','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00595','24/02/2026','18:38:16','CLI175','Rocío López Cruz','F','47','Namora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.47','0.57','3.25','Efectivo','VEN005','Patricia Torres','Tarde','Nuevo','Completada'),
('V00596','05/01/2026','18:38:46','CLI079','Juana Huamán Sánchez','F','80','Cajamarca','PROD015','Losartán 100mg','Medicamentos','Teva','SI','3','22.4','67.2','6.72','12.1','72.58','Efectivo','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00597','25/07/2026','09:08:00','CLI230','Diego Vargas López','M','19','Cajamarca','PROD024','Simvastatina 40mg','Medicamentos','Genfar','SI','1','18.11','18.11','0.91','3.26','20.46','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00598','07/02/2026','15:12:05','CLI120','Roberto Sánchez Mamani','M','34','Llacanora','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','4','17.48','69.92','3.5','12.59','79.01','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Anulada'),
('V00599','19/04/2026','09:57:09','CLI150','José Rojas Huamán','M','28','Magdalena','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','4','27.14','108.56','16.28','19.54','111.82','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00600','30/05/2026','11:36:53','CLI221','Roberto López Quispe','M','85','Llacanora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','1','17.07','17.07','1.71','3.07','18.43','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00601','02/07/2026','07:31:25','CLI157','Manuel Gutiérrez Pérez','M','48','Jesús','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','2.36','2.83','16.22','Yape','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00602','02/07/2026','07:27:36','CLI177','Mario Vargas García','M','57','Llacanora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','1','72.4','72.4','7.24','13.03','78.19','Tarjeta','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00603','16/08/2026','14:39:41','CLI130','Patricia Vargas Ruiz','F','41','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','4.77','5.72','32.75','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00604','11/02/2026','10:30:22','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD015','Losartán 100mg','Medicamentos','Teva','SI','3','22.4','67.2','3.36','12.1','75.94','Efectivo','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00605','30/04/2026','11:46:45','CLI014','Raúl Mendoza Huamán','M','59','Namora','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','4','44.34','177.36','17.74','31.92','191.54','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00606','03/02/2026','09:38:31','CLI128','Luis Flores Castillo','M','56','Namora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','1.89','2.27','12.98','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00607','02/03/2026','12:43:10','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','0.0','65.16','427.16','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00608','28/03/2026','19:02:49','CLI183','Miguel Gutiérrez García','M','71','Namora','PROD015','Losartán 100mg','Medicamentos','Teva','SI','2','22.4','44.8','2.24','8.06','50.62','Efectivo','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00609','30/06/2026','19:07:06','CLI071','Mario Mendoza Gómez','M','60','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','0.0','27.22','178.42','Efectivo','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00610','11/01/2026','09:40:07','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','0.58','2.07','13.01','Tarjeta','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00611','01/07/2026','09:41:23','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','2','3.15','6.3','0.0','1.13','7.43','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00612','02/05/2026','15:10:05','CLI102','Teresa Fernández Díaz','F','58','Llacanora','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','6','22.73','136.38','20.46','24.55','140.47','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00613','11/06/2026','09:48:48','CLI045','Julio Fernández Castillo','M','29','Jesús','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','2','30.24','60.48','3.02','10.89','68.35','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Anulada'),
('V00614','24/06/2026','18:51:33','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','8.08','14.54','87.23','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00615','12/02/2026','17:09:57','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','6','6.6','39.6','3.96','7.13','42.77','Yape','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00616','29/06/2026','11:46:47','CLI096','Marta Vargas Flores','F','38','Cajamarca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','3','80.77','242.31','0.0','43.62','285.93','Yape','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00617','24/08/2026','13:28:41','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','5','17.07','85.35','12.8','15.36','87.91','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00618','16/06/2026','10:56:19','CLI013','José Cruz López','M','37','Namora','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','5','44.34','221.7','22.17','39.91','239.44','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00619','05/07/2026','11:13:05','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','8.14','14.66','87.94','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00620','06/01/2026','19:34:37','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD008','Diclofenaco 50mg','Medicamentos','Genfar','NO','3','3.43','10.29','1.54','1.85','10.6','Yape','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00621','04/08/2026','17:32:22','CLI079','Juana Huamán Sánchez','F','80','Cajamarca','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','3','10.39','31.17','0.0','5.61','36.78','Yape','VEN004','Luis Sánchez','Tarde','Adulto Mayor','Completada'),
('V00622','20/06/2026','16:14:22','CLI083','Rocío Torres Sánchez','F','57','Magdalena','PROD051','Protectores Diarios','Cuidado personal','Genfar','NO','6','9.33','55.98','2.8','10.08','63.26','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00623','27/01/2026','20:26:05','CLI052','Lucía Flores Díaz','F','31','Namora','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','4','81.28','325.12','16.26','58.52','367.38','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00624','12/08/2026','18:59:31','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','4','5.65','22.6','1.13','4.07','25.54','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00625','10/05/2026','18:29:08','CLI209','Carlos Vargas Rodríguez','M','70','Magdalena','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','3','5.84','17.52','0.0','3.15','20.67','Efectivo','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00626','11/07/2026','16:54:26','CLI004','Ana Díaz Rodríguez','F','20','Magdalena','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','3','37.3','111.9','11.19','20.14','120.85','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00627','14/05/2026','12:19:23','CLI106','Diana Vargas Quispe','F','73','Jesús','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','4','69.19','276.76','0.0','49.82','326.58','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00628','18/04/2026','21:19:56','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','24.23','29.08','166.39','Yape','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00629','01/02/2026','08:55:02','CLI083','Rocío Torres Sánchez','F','57','Magdalena','PROD062','Talco para Bebé','Bebés','AC Farma','NO','5','19.6','98.0','9.8','17.64','105.84','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00630','20/07/2026','19:08:32','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','4','37.3','149.2','22.38','26.86','153.68','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00631','20/06/2026','13:14:57','CLI200','Víctor Quispe Mamani','M','30','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','5','5.65','28.25','0.0','5.08','33.33','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00632','08/07/2026','11:35:41','CLI079','Juana Huamán Sánchez','F','80','Cajamarca','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','0.0','27.22','178.42','Yape','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00633','08/06/2026','19:03:36','CLI099','Carmen Torres Quispe','F','20','Jesús','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','4','5.84','23.36','0.0','4.2','27.56','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00634','24/04/2026','15:38:20','CLI242','Elena Cruz Mendoza','F','77','Llacanora','PROD062','Talco para Bebé','Bebés','AC Farma','NO','1','19.6','19.6','2.94','3.53','20.19','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00635','29/03/2026','13:16:05','CLI193','Pedro Quispe Torres','M','84','Jesús','PROD042','Shampoo Pantene','Cuidado personal','Genfar','NO','1','12.6','12.6','0.63','2.27','14.24','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00636','06/02/2026','19:05:09','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','0.63','2.27','14.24','Efectivo','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00637','07/06/2026','09:01:45','CLI122','Diana Díaz Torres','F','35','Jesús','PROD057','Leche Similac 2','Bebés','Abbott','NO','4','52.7','210.8','0.0','37.94','248.74','Yape','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00638','06/02/2026','21:07:03','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','5','84.92','424.6','21.23','76.43','479.8','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Devuelta'),
('V00639','10/03/2026','14:35:26','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','12.12','14.54','83.19','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00640','25/04/2026','17:32:13','CLI060','Manuel Quispe García','M','64','Cajamarca','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','1','10.39','10.39','1.04','1.87','11.22','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00641','22/08/2026','07:00:52','CLI193','Pedro Quispe Torres','M','84','Jesús','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','8.14','14.66','87.94','Efectivo','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00642','01/01/2026','15:18:02','CLI161','Patricia Castillo Huamán','F','25','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','0.0','23.7','155.35','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00643','23/01/2026','11:56:27','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','5','97.38','486.9','48.69','87.64','525.85','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00644','12/06/2026','19:45:28','CLI221','Roberto López Quispe','M','85','Llacanora','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','6','69.19','415.14','41.51','74.73','448.36','Efectivo','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00645','03/06/2026','07:38:30','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','1','22.73','22.73','1.14','4.09','25.68','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00646','30/06/2026','17:41:04','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','6','38.8','232.8','34.92','41.9','239.78','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00647','02/04/2026','07:07:29','CLI169','María Fernández Flores','F','29','Llacanora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','1.7','2.03','11.63','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00648','14/07/2026','21:45:22','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','19.4','34.92','209.52','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00649','03/04/2026','10:00:12','CLI044','Ricardo Ruiz Castillo','M','83','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','2.59','3.11','17.8','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00650','11/08/2026','17:47:36','CLI211','Andrea Cruz López','F','23','Jesús','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','5','84.37','421.85','21.09','75.93','476.69','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00651','31/05/2026','19:17:12','CLI063','Jorge Castillo García','M','29','Namora','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','1','81.28','81.28','8.13','14.63','87.78','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00652','15/08/2026','07:54:20','CLI249','Sonia Flores Huamán','F','61','Cajamarca','PROD040','Omega 3','Vitaminas','Teva','NO','4','47.32','189.28','18.93','34.07','204.42','Plin','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00653','24/06/2026','21:46:14','CLI068','Juana Flores Mamani','F','48','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','4','38.8','155.2','23.28','27.94','159.86','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00654','02/01/2026','13:04:58','CLI155','Marta Sánchez Mendoza','F','26','Cajamarca','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','2','84.37','168.74','16.87','30.37','182.24','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00655','17/01/2026','08:01:30','CLI226','Andrea Rojas Castillo','F','21','Llacanora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','1','80.77','80.77','8.08','14.54','87.23','Plin','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00656','05/03/2026','10:21:53','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','3','9.96','29.88','1.49','5.38','33.77','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00657','18/07/2026','21:02:24','CLI178','Sonia Rodríguez Mamani','F','52','Jesús','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','6','27.32','163.92','0.0','29.51','193.43','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00658','24/04/2026','16:40:27','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD039','Calcibon D','Vitaminas','Medifarma','NO','6','75.16','450.96','0.0','81.17','532.13','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00659','14/01/2026','17:39:00','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','4','5.84','23.36','3.5','4.2','24.06','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00660','08/06/2026','17:43:50','CLI061','Manuel Gutiérrez López','M','62','Llacanora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','8.14','14.66','87.94','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00661','19/02/2026','07:38:45','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','2','72.4','144.8','7.24','26.06','163.62','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00662','07/03/2026','14:46:39','CLI008','Andrea Fernández Cruz','F','80','Jesús','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','1','33.51','33.51','1.68','6.03','37.86','Yape','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00663','16/01/2026','19:22:19','CLI077','Roberto Mamani Mamani','M','72','Jesús','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','1.88','6.77','42.51','Tarjeta','VEN002','Carlos Rojas','Noche','Adulto Mayor','Devuelta'),
('V00664','01/05/2026','15:54:03','CLI012','Ana Ruiz Rojas','F','25','Namora','PROD059','Toallitas Húmedas','Bebés','Medifarma','NO','2','9.96','19.92','1.0','3.59','22.51','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00665','21/07/2026','10:42:30','CLI186','Marta Pérez Fernández','F','78','Magdalena','PROD067','Agua Micelar Bioderma','Dermocosmética','Bagó','NO','4','50.31','201.24','20.12','36.22','217.34','Plin','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00666','07/06/2026','12:10:06','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD054','Pañales Babysec G','Bebés','Genfar','NO','1','62.78','62.78','9.42','11.3','64.66','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00667','24/08/2026','10:44:14','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','2','11.21','22.42','1.12','4.04','25.34','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00668','28/07/2026','18:24:13','CLI229','Patricia Rojas Díaz','F','57','Llacanora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','1','6.56','6.56','0.66','1.18','7.08','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00669','19/01/2026','15:07:09','CLI011','Carlos García Gómez','M','62','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.32','0.57','3.4','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00670','08/01/2026','11:11:14','CLI074','Rocío Fernández Vargas','F','79','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','6','80.77','484.62','24.23','87.23','547.62','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00671','15/02/2026','09:53:16','CLI144','Silvia Pérez Vargas','F','81','Namora','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','1','72.29','72.29','3.61','13.01','81.69','Tarjeta','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00672','29/01/2026','10:19:29','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','3','29.84','89.52','4.48','16.11','101.15','Tarjeta','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00673','14/08/2026','18:04:07','CLI109','Laura Quispe Díaz','F','29','Jesús','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','2','93.42','186.84','9.34','33.63','211.13','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00674','17/05/2026','12:20:38','CLI053','Ricardo Castillo Sánchez','M','70','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','3','27.14','81.42','4.07','14.66','92.01','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00675','15/07/2026','10:54:34','CLI215','Rocío Rojas López','F','33','Jesús','PROD018','Metformina 850mg','Medicamentos','Medifarma','SI','2','17.07','34.14','3.41','6.15','36.88','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00676','20/07/2026','17:39:04','CLI234','Andrés Gómez García','M','40','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','4','26.33','105.32','10.53','18.96','113.75','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00677','02/05/2026','17:02:13','CLI209','Carlos Vargas Rodríguez','M','70','Magdalena','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','1','12.54','12.54','1.88','2.26','12.92','Yape','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00678','12/04/2026','21:53:23','CLI165','Juan Díaz Mamani','M','20','Namora','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','1','6.56','6.56','0.33','1.18','7.41','Tarjeta','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00679','01/04/2026','13:28:29','CLI074','Rocío Fernández Vargas','F','79','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','8.14','9.77','55.91','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00680','11/03/2026','09:28:14','CLI189','Ana Díaz Rojas','F','27','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.58','1.05','6.31','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00681','26/08/2026','08:04:23','CLI014','Raúl Mendoza Huamán','M','59','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','16.15','29.08','174.47','Efectivo','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00682','22/06/2026','11:47:52','CLI081','Carmen Gómez Torres','F','39','Jesús','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','3','29.87','89.61','4.48','16.13','101.26','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00683','12/07/2026','15:58:16','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD009','Diclofenaco Gel','Medicamentos','Medifarma','NO','3','17.48','52.44','5.24','9.44','56.64','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00684','31/08/2026','16:48:41','CLI214','Patricia Mamani Sánchez','F','35','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','6','26.33','157.98','7.9','28.44','178.52','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00685','28/02/2026','18:13:30','CLI177','Mario Vargas García','M','57','Llacanora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','5','72.4','362.0','54.3','65.16','372.86','Efectivo','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00686','28/06/2026','11:47:00','CLI225','Andrés Rodríguez Quispe','M','20','Jesús','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','43.44','78.19','469.15','Plin','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00687','27/02/2026','17:48:25','CLI102','Teresa Fernández Díaz','F','58','Llacanora','PROD041','Shampoo Head&Shoulders','Cuidado personal','Abbott','NO','6','24.16','144.96','14.5','26.09','156.55','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00688','31/05/2026','19:02:59','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD054','Pañales Babysec G','Bebés','Genfar','NO','3','62.78','188.34','28.25','33.9','193.99','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00689','17/01/2026','10:30:06','CLI145','Luis Vargas Gonzales','M','69','Magdalena','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','4','93.42','373.68','37.37','67.26','403.57','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00690','13/02/2026','16:31:01','CLI150','José Rojas Huamán','M','28','Magdalena','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','1','4.21','4.21','0.63','0.76','4.34','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00691','22/02/2026','17:33:04','CLI028','Rosa Díaz Gómez','F','58','Namora','PROD037','Colágeno Hidrolizado','Vitaminas','Bagó','NO','3','74.88','224.64','0.0','40.44','265.08','Yape','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00692','16/04/2026','08:08:34','CLI231','Lucía Rojas Ruiz','F','79','Namora','PROD057','Leche Similac 2','Bebés','Abbott','NO','6','52.7','316.2','0.0','56.92','373.12','Yape','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00693','21/03/2026','18:42:30','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','5','97.38','486.9','48.69','87.64','525.85','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00694','21/02/2026','17:29:17','CLI217','María Gonzales Quispe','F','21','Jesús','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','2','24.06','48.12','7.22','8.66','49.56','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00695','31/07/2026','19:15:33','CLI091','Ricardo Flores Mamani','M','50','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','5','5.76','28.8','4.32','5.18','29.66','Plin','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00696','08/07/2026','17:56:58','CLI174','Luis Rojas Flores','M','49','Namora','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','18.14','32.66','195.96','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00697','06/06/2026','20:11:26','CLI125','Roberto Rodríguez Huamán','M','75','Magdalena','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','5.64','6.77','38.75','Efectivo','VEN004','Luis Sánchez','Noche','Adulto Mayor','Completada'),
('V00698','25/01/2026','11:56:40','CLI182','Raúl López Quispe','M','49','Namora','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','6','29.87','179.22','0.0','32.26','211.48','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00699','15/07/2026','12:04:48','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','3','62.78','188.34','28.25','33.9','193.99','Plin','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00700','12/02/2026','15:02:29','CLI062','Lucía Mendoza Gutiérrez','F','35','Magdalena','PROD054','Pañales Babysec G','Bebés','Genfar','NO','6','62.78','376.68','56.5','67.8','387.98','Tarjeta','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00701','08/08/2026','07:00:16','CLI240','Roberto Gutiérrez Huamán','M','20','Cajamarca','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','2','3.15','6.3','0.63','1.13','6.8','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00702','23/04/2026','20:17:53','CLI217','María Gonzales Quispe','F','21','Jesús','PROD013','Cetirizina 10mg','Medicamentos','Medifarma','NO','1','4.21','4.21','0.0','0.76','4.97','Tarjeta','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00703','17/03/2026','18:25:10','CLI104','Miguel Rojas Gómez','M','62','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','1','5.3','5.3','0.53','0.95','5.72','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00704','23/04/2026','10:45:02','CLI082','Jorge Fernández Quispe','M','18','Jesús','PROD012','Loratadina 10mg','Medicamentos','Genfar','NO','5','6.54','32.7','1.64','5.89','36.95','Tarjeta','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00705','28/06/2026','17:51:33','CLI195','Víctor Ruiz García','M','57','Magdalena','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','6','5.3','31.8','0.0','5.72','37.52','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00706','26/06/2026','07:38:00','CLI208','Roberto Gómez Huamán','M','27','Llacanora','PROD062','Talco para Bebé','Bebés','AC Farma','NO','4','19.6','78.4','3.92','14.11','88.59','Efectivo','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00707','21/02/2026','13:01:00','CLI013','José Cruz López','M','37','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','0.0','13.97','91.57','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00708','14/08/2026','20:53:42','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD044','Jabón Protex','Cuidado personal','Teva','NO','2','5.74','11.48','0.0','2.07','13.55','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00709','12/05/2026','13:07:14','CLI106','Diana Vargas Quispe','F','73','Jesús','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','1.31','2.36','14.17','Tarjeta','VEN002','Carlos Rojas','Mañana','Adulto Mayor','Completada'),
('V00710','04/01/2026','12:00:24','CLI112','Luis Díaz Fernández','M','79','Magdalena','PROD028','Albendazol 400mg','Medicamentos','Medifarma','NO','1','5.68','5.68','0.0','1.02','6.7','Efectivo','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00711','16/06/2026','07:04:56','CLI099','Carmen Torres Quispe','F','20','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','3','80.77','242.31','36.35','43.62','249.58','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00712','02/07/2026','21:54:36','CLI159','Carmen Rojas Díaz','F','69','Llacanora','PROD015','Losartán 100mg','Medicamentos','Teva','SI','1','22.4','22.4','2.24','4.03','24.19','Efectivo','VEN004','Luis Sánchez','Noche','Adulto Mayor','Completada'),
('V00713','27/03/2026','19:56:44','CLI027','Raúl Torres Díaz','M','48','Cajamarca','PROD011','Pantoprazol 40mg','Medicamentos','Teva','SI','6','21.72','130.32','19.55','23.46','134.23','Efectivo','VEN001','Ana Díaz','Noche','Nuevo','Completada'),
('V00714','27/03/2026','21:37:28','CLI244','Silvia Rodríguez Gonzales','F','43','Magdalena','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','6','5.65','33.9','1.7','6.1','38.3','Yape','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00715','04/01/2026','16:48:57','CLI241','Rosa Quispe Torres','F','21','Cajamarca','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','2','21.05','42.1','6.32','7.58','43.36','Efectivo','VEN002','Carlos Rojas','Tarde','Convenio','Completada'),
('V00716','08/06/2026','09:23:31','CLI174','Luis Rojas Flores','M','49','Namora','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','2','28.41','56.82','8.52','10.23','58.53','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00717','14/06/2026','14:47:56','CLI070','Mario Castillo Mamani','M','44','Cajamarca','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','3','37.3','111.9','11.19','20.14','120.85','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00718','26/03/2026','10:34:03','CLI076','Patricia Vargas Fernández','F','24','Jesús','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','6','30.24','181.44','9.07','32.66','205.03','Plin','VEN002','Carlos Rojas','Mañana','Nuevo','Completada'),
('V00719','14/05/2026','14:40:00','CLI021','Carlos Mendoza Mamani','M','63','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','2','5.65','11.3','0.0','2.03','13.33','Plin','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00720','02/02/2026','10:15:32','CLI024','Juan Sánchez García','M','25','Llacanora','PROD041','Shampoo Head&Shoulders','Cuidado personal','Abbott','NO','6','24.16','144.96','21.74','26.09','149.31','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00721','04/03/2026','16:15:19','CLI070','Mario Castillo Mamani','M','44','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','4','5.84','23.36','1.17','4.2','26.39','Plin','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00722','03/04/2026','09:30:28','CLI169','María Fernández Flores','F','29','Llacanora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','5','62.78','313.9','47.08','56.5','323.32','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00723','04/05/2026','13:27:54','CLI071','Mario Mendoza Gómez','M','60','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','2.71','9.77','61.34','Tarjeta','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00724','06/07/2026','13:29:19','CLI029','Carlos Cruz Sánchez','M','62','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','1.59','1.91','10.92','Tarjeta','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00725','27/03/2026','18:23:31','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','4','28.53','114.12','17.12','20.54','117.54','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00726','14/06/2026','08:26:56','CLI169','María Fernández Flores','F','29','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','3.95','4.74','27.12','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00727','11/02/2026','18:22:32','CLI065','Roberto Cruz Ruiz','M','55','Llacanora','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','6','8.93','53.58','5.36','9.64','57.86','Plin','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00728','16/06/2026','13:47:15','CLI211','Andrea Cruz López','F','23','Jesús','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','1','10.39','10.39','1.04','1.87','11.22','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Anulada'),
('V00729','28/06/2026','09:16:38','CLI027','Raúl Torres Díaz','M','48','Cajamarca','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','6','5.84','35.04','1.75','6.31','39.6','Efectivo','VEN003','Rosa Fernández','Mañana','Nuevo','Completada'),
('V00730','04/01/2026','08:33:58','CLI184','Carmen Flores Gómez','F','24','Namora','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','16.15','58.15','365.08','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00731','31/05/2026','19:51:22','CLI113','Diana Rodríguez Vargas','F','53','Llacanora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','3','72.4','217.2','10.86','39.1','245.44','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00732','28/06/2026','09:52:31','CLI152','Raúl Mamani Castillo','M','20','Namora','PROD045','Pasta Dental Colgate','Cuidado personal','Genfar','NO','1','6.72','6.72','1.01','1.21','6.92','Efectivo','VEN005','Patricia Torres','Mañana','Nuevo','Completada'),
('V00733','07/07/2026','09:23:11','CLI024','Juan Sánchez García','M','25','Llacanora','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','2','28.53','57.06','8.56','10.27','58.77','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00734','26/04/2026','10:11:12','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','2','27.32','54.64','2.73','9.84','61.75','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00735','09/06/2026','17:10:05','CLI065','Roberto Cruz Ruiz','M','55','Llacanora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','4','3.15','12.6','0.0','2.27','14.87','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00736','17/01/2026','16:15:30','CLI151','Raúl Vargas Díaz','M','54','Baños del Inca','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','1','12.72','12.72','0.0','2.29','15.01','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00737','25/01/2026','19:00:24','CLI211','Andrea Cruz López','F','23','Jesús','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','3','97.38','292.14','43.82','52.59','300.91','Tarjeta','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00738','13/07/2026','12:20:52','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','2.59','3.11','17.8','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00739','06/06/2026','18:53:56','CLI182','Raúl López Quispe','M','49','Namora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','0.0','4.74','31.07','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00740','12/07/2026','20:30:32','CLI229','Patricia Rojas Díaz','F','57','Llacanora','PROD040','Omega 3','Vitaminas','Teva','NO','2','47.32','94.64','0.0','17.04','111.68','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00741','12/08/2026','19:47:20','CLI098','Pedro Gutiérrez Flores','M','55','Namora','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','2','29.84','59.68','8.95','10.74','61.47','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00742','09/07/2026','21:06:46','CLI117','Silvia Fernández Gómez','F','57','Llacanora','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','5','22.73','113.65','5.68','20.46','128.43','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00743','03/07/2026','09:31:50','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD028','Albendazol 400mg','Medicamentos','Medifarma','NO','6','5.68','34.08','5.11','6.13','35.1','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00744','19/05/2026','10:10:48','CLI017','Carlos Mamani Sánchez','M','39','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','6','72.4','434.4','0.0','78.19','512.59','Efectivo','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00745','08/01/2026','21:20:57','CLI006','María Rodríguez Ruiz','F','84','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','0.58','2.07','13.01','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00746','20/06/2026','08:50:44','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','2','55.29','110.58','0.0','19.9','130.48','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00747','20/07/2026','20:27:51','CLI107','Jorge Torres Huamán','M','28','Cajamarca','PROD047','Desodorante Rexona','Cuidado personal','Roche','NO','3','11.21','33.63','0.0','6.05','39.68','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00748','23/01/2026','18:07:36','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','2.54','3.05','17.46','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00749','08/07/2026','07:37:34','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','4','72.4','289.6','43.44','52.13','298.29','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00750','17/07/2026','17:59:50','CLI077','Roberto Mamani Mamani','M','72','Jesús','PROD015','Losartán 100mg','Medicamentos','Teva','SI','3','22.4','67.2','3.36','12.1','75.94','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00751','12/04/2026','20:29:20','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','3','44.33','132.99','6.65','23.94','150.28','Efectivo','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00752','24/06/2026','18:07:17','CLI194','Teresa Rodríguez Pérez','F','44','Baños del Inca','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','6','69.19','415.14','62.27','74.73','427.6','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00753','07/05/2026','13:03:51','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','6','27.14','162.84','8.14','29.31','184.01','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00754','06/07/2026','07:35:25','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','6','5.65','33.9','5.08','6.1','34.92','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00755','13/07/2026','08:33:46','CLI127','Patricia Mendoza Torres','F','76','Magdalena','PROD015','Losartán 100mg','Medicamentos','Teva','SI','3','22.4','67.2','3.36','12.1','75.94','Tarjeta','VEN005','Patricia Torres','Mañana','Adulto Mayor','Completada'),
('V00756','11/04/2026','19:03:54','CLI210','Andrés Huamán Fernández','M','29','Llacanora','PROD057','Leche Similac 2','Bebés','Abbott','NO','3','52.7','158.1','23.71','28.46','162.85','Yape','VEN002','Carlos Rojas','Noche','Nuevo','Completada'),
('V00757','28/05/2026','18:30:18','CLI151','Raúl Vargas Díaz','M','54','Baños del Inca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','0.66','2.36','14.82','Yape','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00758','08/07/2026','17:50:54','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD022','Salbutamol Inhalador','Medicamentos','AC Farma','SI','4','29.87','119.48','5.97','21.51','135.02','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00759','25/01/2026','14:11:03','CLI001','Fernando Torres Huamán','M','59','Magdalena','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','5','30.24','151.2','15.12','27.22','163.3','Yape','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00760','04/03/2026','10:25:31','CLI043','Marta Díaz Gonzales','F','21','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','5','6.56','32.8','1.64','5.9','37.06','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00761','18/07/2026','19:42:42','CLI222','Manuel Quispe Gutiérrez','M','66','Jesús','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','3.12','3.74','21.4','Efectivo','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00762','11/06/2026','12:00:07','CLI059','Luis Quispe Cruz','M','50','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','3.95','4.74','27.12','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00763','27/02/2026','16:36:30','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD023','Atorvastatina 20mg','Medicamentos','Pfizer','SI','6','33.51','201.06','0.0','36.19','237.25','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00764','16/02/2026','17:44:27','CLI239','Fernando Rojas Díaz','M','41','Magdalena','PROD043','Jabón Neko','Cuidado personal','Medifarma','NO','2','6.6','13.2','0.0','2.38','15.58','Yape','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00765','17/02/2026','18:01:25','CLI111','Mario Rodríguez Ruiz','M','20','Jesús','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','5','38.8','194.0','29.1','34.92','199.82','Yape','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00766','22/07/2026','19:48:13','CLI045','Julio Fernández Castillo','M','29','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','1','26.33','26.33','1.32','4.74','29.75','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00767','27/06/2026','15:28:51','CLI159','Carmen Rojas Díaz','F','69','Llacanora','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','1','69.19','69.19','3.46','12.45','78.18','Efectivo','VEN005','Patricia Torres','Tarde','Adulto Mayor','Completada'),
('V00768','22/02/2026','12:34:10','CLI031','Luis Castillo Gómez','M','41','Jesús','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','6','5.76','34.56','0.0','6.22','40.78','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00769','18/03/2026','15:57:50','CLI054','Carmen Quispe Cruz','F','44','Jesús','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','5','26.33','131.65','19.75','23.7','135.6','Tarjeta','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00770','22/03/2026','18:06:42','CLI128','Luis Flores Castillo','M','56','Namora','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','2','28.41','56.82','0.0','10.23','67.05','Efectivo','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00771','06/02/2026','10:37:22','CLI020','Marta Castillo Castillo','F','54','Cajamarca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','6','38.8','232.8','34.92','41.9','239.78','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00772','21/05/2026','13:41:57','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD026','Levofloxacino 500mg','Medicamentos','Teva','SI','4','28.41','113.64','0.0','20.46','134.1','Efectivo','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00773','23/06/2026','18:09:34','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','6','55.29','331.74','33.17','59.71','358.28','Tarjeta','VEN002','Carlos Rojas','Tarde','Frecuente','Completada'),
('V00774','02/07/2026','17:41:52','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','1','5.76','5.76','0.86','1.04','5.94','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00775','22/04/2026','16:15:04','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','5','84.92','424.6','0.0','76.43','501.03','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00776','15/04/2026','17:05:23','CLI021','Carlos Mendoza Mamani','M','63','Baños del Inca','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','2','12.54','25.08','1.25','4.51','28.34','Tarjeta','VEN002','Carlos Rojas','Tarde','Adulto Mayor','Completada'),
('V00777','12/03/2026','19:59:07','CLI053','Ricardo Castillo Sánchez','M','70','Namora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','3','5.65','16.95','1.7','3.05','18.3','Tarjeta','VEN005','Patricia Torres','Noche','Adulto Mayor','Completada'),
('V00778','25/01/2026','18:36:55','CLI134','Carmen Vargas Rodríguez','F','45','Cajamarca','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','3','80.77','242.31','0.0','43.62','285.93','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00779','13/02/2026','19:24:11','CLI021','Carlos Mendoza Mamani','M','63','Baños del Inca','PROD016','Enalapril 20mg','Medicamentos','Genfar','SI','3','12.54','37.62','5.64','6.77','38.75','Tarjeta','VEN004','Luis Sánchez','Noche','Adulto Mayor','Completada'),
('V00780','01/06/2026','17:08:09','CLI250','Marta Cruz Fernández','F','64','Namora','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','6','44.33','265.98','26.6','47.88','287.26','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00781','16/02/2026','11:27:33','CLI092','María Cruz Torres','F','29','Llacanora','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','2','26.33','52.66','5.27','9.48','56.87','Efectivo','VEN001','Ana Díaz','Mañana','Nuevo','Completada'),
('V00782','31/08/2026','19:20:54','CLI118','Diego Gonzales Castillo','M','52','Cajamarca','PROD052','Pañales Huggies RN','Bebés','AC Farma','NO','1','30.24','30.24','0.0','5.44','35.68','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00783','30/08/2026','18:08:30','CLI003','Sonia Gómez Mendoza','F','35','Namora','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','6','8.08','48.48','0.0','8.73','57.21','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00784','04/01/2026','21:53:47','CLI001','Fernando Torres Huamán','M','59','Magdalena','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','25.11','45.2','271.21','Tarjeta','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00785','09/07/2026','17:38:02','CLI019','Juana Gutiérrez Castillo','F','19','Magdalena','PROD060','Crema Cero','Bebés','Genfar','NO','2','18.07','36.14','1.81','6.51','40.84','Yape','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00786','20/01/2026','09:32:22','CLI186','Marta Pérez Fernández','F','78','Magdalena','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','37.67','45.2','258.65','Yape','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00787','13/02/2026','08:18:19','CLI168','Elizabeth Rodríguez Pérez','F','23','Baños del Inca','PROD046','Pasta Dental Sensodyne','Cuidado personal','Teva','NO','3','15.03','45.09','2.25','8.12','50.96','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00788','08/07/2026','13:13:59','CLI051','Mario Gonzales Mamani','M','47','Cajamarca','PROD061','Shampoo Johnson''s','Bebés','Teva','NO','6','29.84','179.04','0.0','32.23','211.27','Yape','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00789','05/05/2026','07:39:29','CLI187','Ana Rojas Huamán','F','62','Magdalena','PROD035','Vitamina E 400 UI','Vitaminas','Medifarma','NO','3','26.33','78.99','0.0','14.22','93.21','Yape','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00790','17/02/2026','07:06:27','CLI144','Silvia Pérez Vargas','F','81','Namora','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','1','38.8','38.8','1.94','6.98','43.84','Efectivo','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00791','02/01/2026','17:16:14','CLI178','Sonia Rodríguez Mamani','F','52','Jesús','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','3','8.93','26.79','2.68','4.82','28.93','Efectivo','VEN003','Rosa Fernández','Tarde','Frecuente','Completada'),
('V00792','11/02/2026','18:27:00','CLI063','Jorge Castillo García','M','29','Namora','PROD008','Diclofenaco 50mg','Medicamentos','Genfar','NO','6','3.43','20.58','1.03','3.7','23.25','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00793','18/02/2026','09:25:26','CLI128','Luis Flores Castillo','M','56','Namora','PROD005','Amoxicilina 500mg','Medicamentos','Bayer','SI','1','21.05','21.05','1.05','3.79','23.79','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00794','20/06/2026','19:43:45','CLI101','Diego Rodríguez Pérez','M','46','Llacanora','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','4','72.4','289.6','43.44','52.13','298.29','Yape','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00795','22/07/2026','09:22:32','CLI071','Mario Mendoza Gómez','M','60','Namora','PROD029','Loperamida 2mg','Medicamentos','AC Farma','NO','3','8.93','26.79','1.34','4.82','30.27','Efectivo','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00796','08/07/2026','14:18:18','CLI161','Patricia Castillo Huamán','F','25','Namora','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','4','56.45','225.8','11.29','40.64','255.15','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00797','17/02/2026','19:07:55','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','6','8.08','48.48','2.42','8.73','54.79','Yape','VEN004','Luis Sánchez','Noche','Frecuente','Completada'),
('V00798','06/06/2026','10:07:08','CLI166','Luis Ruiz Torres','M','57','Baños del Inca','PROD055','Pañales Huggies XG','Bebés','AC Farma','NO','3','72.4','217.2','10.86','39.1','245.44','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00799','20/04/2026','10:05:55','CLI049','Ana Flores Gonzales','F','43','Magdalena','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','4','6.56','26.24','2.62','4.72','28.34','Yape','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00800','26/02/2026','14:03:32','CLI112','Luis Díaz Fernández','M','79','Magdalena','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','1','3.15','3.15','0.32','0.57','3.4','Efectivo','VEN001','Ana Díaz','Tarde','Adulto Mayor','Completada'),
('V00801','10/03/2026','12:45:26','CLI219','Fernando López Rojas','M','35','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','1','5.3','5.3','0.27','0.95','5.98','Yape','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00802','01/01/2026','18:20:13','CLI167','Patricia López Pérez','F','35','Baños del Inca','PROD033','Supradyn Forte','Vitaminas','Bayer','NO','3','56.45','169.35','0.0','30.48','199.83','Tarjeta','VEN004','Luis Sánchez','Tarde','Nuevo','Completada'),
('V00803','17/02/2026','14:23:21','CLI085','Ricardo Ruiz Castillo','M','33','Namora','PROD062','Talco para Bebé','Bebés','AC Farma','NO','1','19.6','19.6','0.0','3.53','23.13','Plin','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00804','26/03/2026','19:23:47','CLI212','Sonia Mamani López','F','28','Magdalena','PROD025','Ciprofloxacino 500mg','Medicamentos','Bayer','SI','5','27.32','136.6','13.66','24.59','147.53','Yape','VEN002','Carlos Rojas','Noche','Convenio','Completada'),
('V00805','16/06/2026','09:40:47','CLI026','Elena Castillo Ruiz','F','46','Baños del Inca','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','1','84.37','84.37','4.22','15.19','95.34','Efectivo','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00806','30/06/2026','11:46:30','CLI199','Ana Castillo Rodríguez','F','27','Llacanora','PROD066','Crema Hidratante Cerave','Dermocosmética','Roche','NO','2','84.92','169.84','8.49','30.57','191.92','Plin','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00807','02/02/2026','19:54:54','CLI011','Carlos García Gómez','M','62','Magdalena','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','2','5.76','11.52','1.15','2.07','12.44','Efectivo','VEN004','Luis Sánchez','Noche','Adulto Mayor','Completada'),
('V00808','22/08/2026','15:50:01','CLI096','Marta Vargas Flores','F','38','Cajamarca','PROD063','Bloqueador Solar ISDIN','Dermocosmética','Bagó','NO','3','93.42','280.26','14.01','50.45','316.7','Yape','VEN003','Rosa Fernández','Tarde','Nuevo','Completada'),
('V00809','27/06/2026','20:32:04','CLI165','Juan Díaz Mamani','M','20','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','5','5.3','26.5','3.97','4.77','27.3','Efectivo','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00810','19/07/2026','16:17:13','CLI157','Manuel Gutiérrez Pérez','M','48','Jesús','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','2','44.34','88.68','4.43','15.96','100.21','Efectivo','VEN005','Patricia Torres','Tarde','Nuevo','Completada'),
('V00811','28/06/2026','21:50:32','CLI154','Teresa Rodríguez Vargas','F','64','Baños del Inca','PROD034','Redoxon 1g','Vitaminas','Bayer','NO','6','44.33','265.98','26.6','47.88','287.26','Yape','VEN003','Rosa Fernández','Noche','Adulto Mayor','Completada'),
('V00812','07/08/2026','18:17:35','CLI146','Silvia Vargas Quispe','F','24','Llacanora','PROD040','Omega 3','Vitaminas','Teva','NO','2','47.32','94.64','0.0','17.04','111.68','Plin','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00813','02/03/2026','17:09:56','CLI115','Teresa López Flores','F','21','Magdalena','PROD054','Pañales Babysec G','Bebés','Genfar','NO','2','62.78','125.56','12.56','22.6','135.6','Efectivo','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00814','14/06/2026','20:13:34','CLI147','Manuel Mendoza Gómez','M','40','Magdalena','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','6','55.29','331.74','33.17','59.71','358.28','Tarjeta','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00815','05/04/2026','18:56:35','CLI132','Juana Castillo Díaz','F','46','Magdalena','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','8.14','9.77','55.91','Plin','VEN005','Patricia Torres','Tarde','Frecuente','Devuelta'),
('V00816','17/03/2026','07:40:52','CLI163','Carmen Gonzales Ruiz','F','80','Jesús','PROD054','Pañales Babysec G','Bebés','Genfar','NO','3','62.78','188.34','9.42','33.9','212.82','Yape','VEN003','Rosa Fernández','Mañana','Adulto Mayor','Completada'),
('V00817','15/02/2026','19:49:37','CLI013','José Cruz López','M','37','Namora','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','6','24.06','144.36','21.65','25.98','148.69','Yape','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00818','04/06/2026','20:28:14','CLI099','Carmen Torres Quispe','F','20','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','2','80.77','161.54','24.23','29.08','166.39','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00819','25/04/2026','18:27:23','CLI172','Diana Huamán Pérez','F','25','Llacanora','PROD054','Pañales Babysec G','Bebés','Genfar','NO','4','62.78','251.12','0.0','45.2','296.32','Yape','VEN004','Luis Sánchez','Tarde','Frecuente','Completada'),
('V00820','15/06/2026','11:10:56','CLI042','Ricardo Gómez Ruiz','M','20','Cajamarca','PROD045','Pasta Dental Colgate','Cuidado personal','Genfar','NO','4','6.72','26.88','1.34','4.84','30.38','Yape','VEN001','Ana Díaz','Mañana','Convenio','Completada'),
('V00821','06/02/2026','10:29:58','CLI174','Luis Rojas Flores','M','49','Namora','PROD030','Bismutol Suspensión','Medicamentos','Medifarma','NO','4','24.06','96.24','0.0','17.32','113.56','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00822','26/07/2026','08:24:24','CLI045','Julio Fernández Castillo','M','29','Jesús','PROD001','Paracetamol 500mg','Medicamentos','Genfar','NO','1','5.84','5.84','0.0','1.05','6.89','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Completada'),
('V00823','10/03/2026','17:38:00','CLI173','Carmen Gutiérrez Vargas','F','19','Jesús','PROD065','Bloqueador Nivea','Dermocosmética','Medifarma','NO','1','55.29','55.29','0.0','9.95','65.24','Tarjeta','VEN005','Patricia Torres','Tarde','Frecuente','Anulada'),
('V00824','21/02/2026','19:36:57','CLI133','Rocío Huamán Rojas','F','32','Baños del Inca','PROD036','Vitamina C + Zinc','Vitaminas','Genfar','NO','2','38.8','77.6','7.76','13.97','83.81','Efectivo','VEN003','Rosa Fernández','Noche','Frecuente','Completada'),
('V00825','03/05/2026','07:34:44','CLI143','Diego Gómez Rojas','M','28','Jesús','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','5','5.3','26.5','0.0','4.77','31.27','Tarjeta','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00826','31/07/2026','20:26:09','CLI147','Manuel Mendoza Gómez','M','40','Magdalena','PROD019','Metformina 1000mg','Medicamentos','Teva','SI','2','27.14','54.28','0.0','9.77','64.05','Efectivo','VEN002','Carlos Rojas','Noche','Frecuente','Completada'),
('V00827','20/04/2026','12:41:18','CLI110','Ana García Flores','F','80','Namora','PROD007','Azitromicina 500mg','Medicamentos','Pfizer','SI','3','37.3','111.9','16.79','20.14','115.25','Yape','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00828','06/05/2026','11:22:04','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD048','Enjuague Bucal Listerine','Cuidado personal','Pfizer','NO','1','22.73','22.73','2.27','4.09','24.55','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00829','18/08/2026','09:11:27','CLI220','Julio Vargas Díaz','M','52','Magdalena','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','5','28.53','142.65','7.13','25.68','161.2','Yape','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00830','25/06/2026','11:58:31','CLI199','Ana Castillo Rodríguez','F','27','Llacanora','PROD070','Gel Limpiador La Roche','Dermocosmética','Roche','NO','3','84.37','253.11','0.0','45.56','298.67','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00831','07/02/2026','14:52:04','CLI156','Marta Flores Gómez','F','51','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','4','80.77','323.08','32.31','58.15','348.92','Yape','VEN002','Carlos Rojas','Tarde','Nuevo','Completada'),
('V00832','24/01/2026','09:11:49','CLI016','Manuel Pérez Sánchez','M','32','Baños del Inca','PROD017','Enalapril 10mg','Medicamentos','AC Farma','SI','3','5.76','17.28','2.59','3.11','17.8','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Anulada'),
('V00833','12/06/2026','19:41:58','CLI203','Luis Fernández Huamán','M','55','Namora','PROD057','Leche Similac 2','Bebés','Abbott','NO','4','52.7','210.8','31.62','37.94','217.12','Tarjeta','VEN005','Patricia Torres','Noche','Frecuente','Completada'),
('V00834','17/05/2026','15:52:14','CLI101','Diego Rodríguez Pérez','M','46','Llacanora','PROD002','Paracetamol 1g','Medicamentos','Teva','NO','5','3.15','15.75','2.36','2.83','16.22','Efectivo','VEN005','Patricia Torres','Tarde','Frecuente','Completada'),
('V00835','29/06/2026','07:23:35','CLI119','Fernando Castillo Gutiérrez','M','43','Namora','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','0.0','1.91','12.51','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00836','22/08/2026','09:18:29','CLI038','Lucía Mamani Torres','F','58','Jesús','PROD069','Sérum Vitamina C','Dermocosmética','IQ Farma','NO','5','80.77','403.85','60.58','72.69','415.96','Tarjeta','VEN002','Carlos Rojas','Mañana','Frecuente','Anulada'),
('V00837','30/06/2026','18:01:44','CLI113','Diana Rodríguez Vargas','F','53','Llacanora','PROD031','Centrum Hombre','Vitaminas','Pfizer','NO','3','72.29','216.87','0.0','39.04','255.91','Tarjeta','VEN001','Ana Díaz','Tarde','Frecuente','Completada'),
('V00838','19/06/2026','07:09:23','CLI080','Manuel Torres Pérez','M','38','Baños del Inca','PROD010','Omeprazol 20mg','Medicamentos','AC Farma','NO','2','5.3','10.6','0.0','1.91','12.51','Efectivo','VEN001','Ana Díaz','Mañana','Frecuente','Completada'),
('V00839','17/04/2026','09:30:47','CLI094','Raúl García Mendoza','M','40','Magdalena','PROD049','Crema Dental Oral-B','Cuidado personal','Medifarma','NO','5','12.72','63.6','6.36','11.45','68.69','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00840','27/06/2026','07:38:48','CLI200','Víctor Quispe Mamani','M','30','Baños del Inca','PROD004','Ibuprofeno 600mg','Medicamentos','Genfar','NO','2','6.56','13.12','0.0','2.36','15.48','Efectivo','VEN004','Luis Sánchez','Mañana','Frecuente','Completada'),
('V00841','02/08/2026','11:58:36','CLI041','Sonia Ruiz Pérez','F','29','Baños del Inca','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','6','5.65','33.9','1.7','6.1','38.3','Yape','VEN004','Luis Sánchez','Mañana','Convenio','Completada'),
('V00842','27/08/2026','09:47:13','CLI139','Carmen Huamán Rodríguez','F','53','Jesús','PROD064','Bloqueador Eucerin','Dermocosmética','Bayer','NO','1','97.38','97.38','4.87','17.53','110.04','Efectivo','VEN004','Luis Sánchez','Mañana','Nuevo','Completada'),
('V00843','24/05/2026','08:52:44','CLI127','Patricia Mendoza Torres','F','76','Magdalena','PROD014','Losartán 50mg','Medicamentos','IQ Farma','SI','2','10.39','20.78','3.12','3.74','21.4','Yape','VEN004','Luis Sánchez','Mañana','Adulto Mayor','Completada'),
('V00844','12/02/2026','12:41:27','CLI123','Laura Rodríguez Pérez','F','79','Baños del Inca','PROD006','Amoxicilina 875mg','Medicamentos','Roche','SI','1','28.53','28.53','0.0','5.14','33.67','Yape','VEN001','Ana Díaz','Mañana','Adulto Mayor','Completada'),
('V00845','05/08/2026','10:18:10','CLI204','Teresa Huamán Mamani','F','19','Llacanora','PROD003','Ibuprofeno 400mg','Medicamentos','Medifarma','NO','1','5.65','5.65','0.28','1.02','6.39','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00846','21/03/2026','10:40:59','CLI179','Patricia Gutiérrez Sánchez','F','19','Cajamarca','PROD040','Omega 3','Vitaminas','Teva','NO','3','47.32','141.96','0.0','25.55','167.51','Yape','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00847','25/05/2026','19:30:02','CLI217','María Gonzales Quispe','F','21','Jesús','PROD032','Centrum Mujer','Vitaminas','Pfizer','NO','1','69.19','69.19','6.92','12.45','74.72','Yape','VEN001','Ana Díaz','Noche','Frecuente','Completada'),
('V00848','12/04/2026','09:44:43','CLI247','Teresa Rodríguez Sánchez','F','40','Jesús','PROD068','Crema Anti-edad Eucerin','Dermocosmética','Bayer','NO','4','81.28','325.12','0.0','58.52','383.64','Efectivo','VEN005','Patricia Torres','Mañana','Frecuente','Completada'),
('V00849','26/07/2026','07:37:50','CLI124','Raúl Ruiz Pérez','M','33','Baños del Inca','PROD053','Pañales Pampers M','Bebés','Medifarma','NO','5','44.34','221.7','0.0','39.91','261.61','Yape','VEN003','Rosa Fernández','Mañana','Frecuente','Completada'),
('V00850','11/02/2026','18:14:56','CLI210','Andrés Huamán Fernández','M','29','Llacanora','PROD020','Naproxeno 550mg','Medicamentos','Bayer','NO','6','8.08','48.48','2.42','8.73','54.79','Tarjeta','VEN002','Carlos Rojas','Tarde','Nuevo','Completada');
GO

-- Normalizar Clientes
INSERT INTO Clientes (id_cliente, nombre_cliente, sexo, edad, distrito, tipo_cliente)
SELECT DISTINCT id_cliente, nombre_cliente, sexo, CAST(edad AS INT), distrito, tipo_cliente 
FROM Stg_Ventas 
WHERE id_cliente NOT IN (SELECT id_cliente FROM Clientes);
GO

-- Normalizar Productos
INSERT INTO Productos (id_producto, nombre_producto, categoria, laboratorio, requiere_receta)
SELECT DISTINCT id_producto, nombre_producto, categoria, laboratorio, requiere_receta 
FROM Stg_Ventas 
WHERE id_producto NOT IN (SELECT id_producto FROM Productos);
GO

-- Normalizar Vendedores
INSERT INTO Vendedores (id_vendedor, nombre_vendedor, turno)
SELECT 
    id_vendedor, 
    MAX(nombre_vendedor), 
    MAX(turno)
FROM Stg_Ventas
WHERE id_vendedor NOT IN (SELECT id_vendedor FROM Vendedores)
GROUP BY id_vendedor;
GO
SELECT * FROM Vendedores
GO

-- Normalizar Ventas
INSERT INTO Ventas (id_venta, fecha, hora, id_cliente, id_vendedor, metodo_pago, estado_venta, total)
SELECT DISTINCT id_venta, CONVERT(DATE, fecha, 103), CAST(hora AS TIME), id_cliente, id_vendedor, metodo_pago, estado_venta, CAST(total AS DECIMAL(10,2)) 
FROM Stg_Ventas 
WHERE id_venta NOT IN (SELECT id_venta FROM Ventas);
GO
SELECT * FROM Ventas
GO

-- Normalizar DetalleVenta
INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, precio_unitario, subtotal, descuento, igv)
SELECT id_venta, id_producto, CAST(cantidad AS INT), CAST(precio_unitario AS DECIMAL(10,2)), CAST(subtotal AS DECIMAL(10,2)), CAST(descuento AS DECIMAL(10,2)), CAST(igv AS DECIMAL(10,2)) 
FROM Stg_Ventas;
GO
SELECT * FROM DetalleVenta
GO

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
SELECT 
    *, 
    dbo.fn_CalcularTotalVenta(cantidad, precio_unitario, descuento) AS total_calculado
FROM Stg_Ventas;
GO

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

-- 1. Ejecutar el procedimiento con datos de prueba
EXEC dbo.sp_RegistrarVenta 
    @id_venta = 'V-TEST-01',
    @id_cliente = 'CLI001',     -- Este ID debe existir en tu tabla Clientes
    @id_vendedor = 'VEN001',    -- Este ID debe existir en tu tabla Vendedores
    @metodo_pago = 'Tarjeta',
    @id_producto = 'PROD001',   -- Este ID debe existir en tu tabla de Productos
    @cantidad = 3,
    @precio_unitario = 150.00,
    @descuento = 20.00;
GO

-- 2. Consultar las tablas para verificar que la transacción se guardó
SELECT * FROM Ventas WHERE id_venta = 'V-TEST-01';
SELECT * FROM DetalleVenta WHERE id_venta = 'V-TEST-01';
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
--PRUEBAS
--todo el historial de venta
EXEC dbo.sp_ReporteVentas;
--Filtrando por un rango de fechas
EXEC dbo.sp_ReporteVentas 
    @fecha_inicio = '2026-09-01', 
    @fecha_fin = '2026-09-30';
--Filtrando solo por un método de pago y un producto
EXEC dbo.sp_ReporteVentas 
    @id_producto = 'PROD001', 
    @metodo_pago = 'Tarjeta';
-- todos los filtros al mismo tiempo
EXEC dbo.sp_ReporteVentas 
    @fecha_inicio = '2026-01-01', 
    @fecha_fin = '2026-09-01',
    @id_producto = 'PROD055',
    @metodo_pago = 'Yape';
GO

-- ==========================================
-- TRIGGER 1: trg_AuditoriaVentas
-- OBJETIVO: Registrar en la tabla Auditoria cuando se inserte o elimine una Venta.
-- ==========================================
USE MARFARMA_DB;
GO
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
--TETS
-- 1. Disparar el evento INSERT (Creando una venta temporal)
INSERT INTO Ventas (id_venta, fecha, hora, id_cliente, id_vendedor, metodo_pago, estado_venta, total)
VALUES ('V-TRIG-01', GETDATE(), CAST(GETDATE() AS TIME), 'CLI001', 'VEN001', 'Efectivo', 'Completada', 100.00);
GO

-- 2. Confirmar que el trigger capturó el INSERT
SELECT * FROM Auditoria WHERE descripcion LIKE '%V-TRIG-01%';
GO

-- 3. Disparar el evento DELETE (Borrando la venta temporal)
DELETE FROM Ventas WHERE id_venta = 'V-TRIG-01';
GO

-- 4. Confirmar que el trigger capturó el DELETE
SELECT * FROM Auditoria WHERE descripcion LIKE '%V-TRIG-01%';
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
-- Prueba
SELECT * FROM DetalleVenta WHERE id_venta = 'V-TEST-01';
GO

----------------------
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



-- Crear índice para mejorar consultas por fecha en Ventas
USE MARFARMA_DB;
GO

CREATE NONCLUSTERED INDEX IX_Ventas_Fecha 
ON Ventas (fecha)
INCLUDE (id_cliente, total);
GO
--
EXEC sp_helpindex 'Ventas';
GO
-- Encendemos las estadísticas para medir el rendimiento
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Esta consulta aprovechará al máximo tu nuevo índice
SELECT fecha, id_cliente, total 
FROM Ventas 
WHERE fecha >= '2026-09-01' AND fecha <= '2026-09-30';

-- Apagamos las estadísticas
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


-- Mostrar cómo revisar el plan de ejecución
-- En SSMS, activar "Include Actual Execution Plan" y ejecutar:
-- SELECT * FROM Ventas WHERE fecha BETWEEN '2026-01-01' AND '2026-06-30';
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
USE MARFARMA_DB;
GO

-- Pregunta 1: ¿Cuánto fue su ingreso total?
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
