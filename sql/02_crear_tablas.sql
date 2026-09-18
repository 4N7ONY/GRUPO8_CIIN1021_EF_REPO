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
