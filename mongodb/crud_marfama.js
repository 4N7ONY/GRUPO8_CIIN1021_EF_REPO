// Operaciones CRUD en MongoDB para MARFARMA

use MARFARMA_NOSQL;

// 1. CREATE (Insert) - Registrar una nueva venta
db.ventas_marfama.insertOne({
    "id_venta": "V00851",
    "fecha": "2026-09-01",
    "hora": "10:00:00",
    "cliente": {
        "id_cliente": "CLI999",
        "nombre": "Estudiante de Prueba",
        "sexo": "M",
        "edad": 22,
        "distrito": "Cajamarca",
        "tipo_cliente": "Nuevo"
    },
    "vendedor": {
        "id_vendedor": "VEN001",
        "nombre": "Ana Díaz",
        "turno": "Mañana"
    },
    "productos": [
        {
            "id_producto": "PROD001",
            "nombre": "Paracetamol 500mg",
            "categoria": "Medicamentos",
            "cantidad": 2,
            "precio_unitario": 5.84,
            "subtotal": 11.68
        }
    ],
    "totales": {
        "descuento": 0.00,
        "igv": 2.10,
        "total": 13.78
    },
    "metodo_pago": "Efectivo",
    "estado_venta": "Completada"
});

// 2. READ (Find) - Consultar la venta recién insertada
var ventaEncontrada = db.ventas_marfama.find({ "id_venta": "V00851" }).toArray();
print("Venta encontrada:");
printjson(ventaEncontrada);

// 3. UPDATE (UpdateOne) - Modificar el método de pago a Yape
db.ventas_marfama.updateOne(
    { "id_venta": "V00851" },
    { $set: { "metodo_pago": "Yape" } }
);
print("Venta V00851 actualizada (método de pago a Yape).");

// 4. DELETE (DeleteOne) - Eliminar la venta de prueba
db.ventas_marfama.deleteOne({ "id_venta": "V00851" });
print("Venta V00851 eliminada de la colección.");
