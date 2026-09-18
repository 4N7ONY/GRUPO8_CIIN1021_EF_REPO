# GRUPO8_CIIN1021_EF_REPO
Proyecto Final de Base de Datos: MARFARMA 

Curso: CIIN1021
Grupo: 8

Tipo de Evaluación: Evaluación Final (EF)

Descripción del Proyecto

Este repositorio contiene el diseño, implementación y pruebas de la base de datos para el sistema de gestión farmacéutica MARFARMA. El proyecto aborda la solución desde dos paradigmas de bases de datos: un enfoque relacional tradicional (SQL) y una aproximación NoSQL (MongoDB), permitiendo evaluar y comparar el rendimiento y estructura de ambas tecnologías.

Estructura del Repositorio

El repositorio está organizado en las siguientes carpetas y archivos principales:

Archivo Principal

MARFARMA_COMPLETO.sql: Script unificado que contiene toda la estructura relacional, datos, lógicas y configuraciones de seguridad en un solo paso. Ideal para despliegues rápidos.

Carpeta /sql (Implementación Relacional)

Contiene la implementación modular de la base de datos SQL, diseñada para ejecutarse en el siguiente orden secuencial:

01_crear_base_datos.sql: Creación del esquema/base de datos principal.

02_crear_tablas.sql: Definición del modelo de datos (DDL).

03_insertar_datos.sql: Poblado inicial de datos (DML) para catálogos y pruebas.

04_procedimientos.sql: Procedimientos almacenados para la lógica de negocio.

05_funciones.sql: Funciones escalares y tabulares personalizadas.

06_triggers.sql: Disparadores para automatización e integridad de datos.

07_auditoria.sql: Tablas y mecanismos para el rastreo de cambios e historial.

08_seguridad.sql: Roles, usuarios y asignación de permisos.

09_indices.sql: Optimización de consultas a través de índices.

10_vistas.sql: Vistas predefinidas para reportes comunes.

11_consultas_analiticas.sql: Consultas complejas para inteligencia de negocios y reportes.

12_pruebas.sql: Casos de prueba para verificar el correcto funcionamiento de la lógica.

Carpeta /mongodb (Implementación NoSQL)

Contiene la adaptación del modelo a un entorno documental y su análisis:

crear_base_marfama.js: Script para la creación de colecciones e inserción de documentos iniciales en MongoDB.

crud_marfama.js: Ejemplos de operaciones CRUD (Create, Read, Update, Delete) y agregaciones adaptadas al modelo documental.

comparacion_sql_nosql.md: Documento de análisis que compara las ventajas, desventajas y casos de uso de ambas implementaciones para este negocio específico.

Instrucciones de Ejecución

Para Entorno SQL (Relacional)

Opción A (Despliegue Rápido):

Abre tu gestor de base de datos preferido.

Carga y ejecuta el archivo MARFARMA_COMPLETO.sql.

Opción B (Despliegue Modular - Recomendado para desarrollo):

Ingresa a la carpeta /sql.

Ejecuta los scripts en estricto orden numérico (del 01 al 12) para evitar errores de dependencias.

Para Entorno MongoDB (NoSQL)

Inicia tu servidor local de MongoDB o conéctate a tu clúster en MongoDB Atlas.

Abre la terminal (mongosh) o un entorno como MongoDB Compass.

Ejecuta el archivo de creación: load('ruta/al/proyecto/mongodb/crear_base_marfama.js').

Explora las operaciones disponibles en crud_marfama.js.

Integrantes del Grupo 8

[Aguilar Cruz, Alex Gustavo]

[Fernandez Vigo Sergio Esteban]

[Ishpilco Quispe, Esau]

[Malca Chilon, Antony]

[Vasquez Valdez Jaime Farid]

Repositorio generado para fines académicos - Universidad / CIIN1021
