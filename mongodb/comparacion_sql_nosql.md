# Comparación SQL vs NoSQL aplicada a MARFARMA

En el contexto de nuestro proyecto de botica MARFARMA, ambas tecnologías tienen características útiles:

## 1. Modelo de Datos
- **SQL Server (Relacional):** Utiliza un modelo tabular, normalizado (como las tablas Ventas, Clientes, Productos). Es ideal si queremos que los datos sean estrictos, no redundantes y evitar la duplicación de nombres de productos o clientes.
- **MongoDB (NoSQL Documental):** Utiliza un formato similar a JSON (BSON). Permite agrupar la información de una venta, cliente y sus productos en un único documento, lo que hace que leer una venta completa sea muy natural y rápido, aunque duplica la información del cliente en cada venta de este.

## 2. Escalabilidad
- **SQL Server:** Generalmente escala de forma "Vertical" (Scale-Up), requiriendo servidores con más CPU o RAM cuando la botica crezca masivamente.
- **MongoDB:** Fue diseñado para escalar de forma "Horizontal" (Scale-Out) nativamente a través del particionamiento (Sharding), distribuyendo los documentos de las ventas entre varios servidores baratos. Ideal si tuviésemos miles de sucursales generando millones de transacciones por segundo.

## 3. Consistencia
- **SQL Server:** Ofrece fuerte consistencia ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad). Si una venta falla en registrar el detalle, se anula completamente usando `ROLLBACK` y se asegura que el stock no sea descontado por error.
- **MongoDB:** Por defecto favorece la alta disponibilidad y la partición (BASE), aunque en versiones recientes soporta transacciones ACID. Sin embargo, al guardar la venta y el detalle en un solo documento, la operación sobre ese documento ya es atómica por naturaleza.

## 4. Flexibilidad
- **SQL Server:** Esquema rígido (Schema-on-Write). Si MARFARMA decide empezar a guardar la talla de ropa de sus clientes o un campo nuevo para ciertos productos, habría que alterar las tablas usando `ALTER TABLE`.
- **MongoDB:** Esquema dinámico (Schema-on-Read). Si mañana una venta incluye "puntos de fidelidad", simplemente se le añade el atributo a ese documento de venta sin tener que modificar ninguna estructura previa.
