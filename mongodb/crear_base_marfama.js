// Archivo para ejecutar en MongoDB Shell (mongosh)
use MARFARMA_NOSQL;

// Crear colección ventas_marfama
db.createCollection("ventas_marfama");

// Insertar datos de ejemplo derivados del CSV
db.ventas_marfama.insertMany([
  {
    "id_venta": "V00001",
    "fecha": "2026-01-09",
    "hora": "10:49:41",
    "cliente": {
        "id_cliente": "CLI165",
        "nombre": "Juan Díaz Mamani",
        "sexo": "M",
        "edad": 20,
        "distrito": "Namora",
        "tipo_cliente": "Frecuente"
    },
    "vendedor": {
        "id_vendedor": "VEN005",
        "nombre": "Patricia Torres",
        "turno": "Mañana"
    },
    "productos": [
        {
            "id_producto": "PROD055",
            "nombre": "Pañales Huggies XG",
            "categoria": "Bebés",
            "cantidad": 4,
            "precio_unitario": 72.40,
            "subtotal": 289.60
        }
    ],
    "totales": {
        "descuento": 0.00,
        "igv": 52.13,
        "total": 341.73
    },
    "metodo_pago": "Yape",
    "estado_venta": "Completada"
  },
  {
    "id_venta": "V00002",
    "fecha": "2026-08-31",
    "hora": "15:23:25",
    "cliente": {
        "id_cliente": "CLI063",
        "nombre": "Jorge Castillo García",
        "sexo": "M",
        "edad": 29,
        "distrito": "Namora",
        "tipo_cliente": "Frecuente"
    },
    "vendedor": {
        "id_vendedor": "VEN001",
        "nombre": "Ana Díaz",
        "turno": "Tarde"
    },
    "productos": [
        {
            "id_producto": "PROD003",
            "nombre": "Ibuprofeno 400mg",
            "categoria": "Medicamentos",
            "cantidad": 3,
            "precio_unitario": 5.65,
            "subtotal": 16.95
        }
    ],
    "totales": {
        "descuento": 0.85,
        "igv": 3.05,
        "total": 19.15
    },
    "metodo_pago": "Tarjeta",
    "estado_venta": "Completada"
  }
]);

print("Base de datos y colección creadas exitosamente.");
