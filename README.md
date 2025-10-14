# P04 - Base de Datos para la Gestión de Viveros

Este repositorio contiene el script SQL para la creación y gestión de la base de datos `viveros` de acuerdo con el modelo Entidad-Relación (E-R) proporcionado.

## 📄 Archivos del Proyecto

| Archivo | Descripción |
| :--- | :--- |
| `viveros.sql` | **Script principal de PostgreSQL.** Contiene la creación de la base de datos, la estructura de las tablas, las restricciones de integridad y las inserciones de datos. |
| `P4_modelosRelacionales.drawio.jpg` | Imagen del modelo Entidad-Relación (E-R) en el que se basa la construcción de la base de datos. |
| `README.md` | Este archivo. Documentación del proyecto. |

## ⚙️ Características de la Base de Datos

El script `viveros.sql` está diseñado para PostgreSQL y cumple con los siguientes requisitos:

1.  **Creación de la BD:** Incluye el comando para la creación de la base de datos `viveros`.
2.  **Modelado E-R:** Construcción de las tablas basada en el modelo relacional del esquema de Viveros.
3.  **Tipos de Datos:** Uso de tipos optimizados (ej: `SERIAL` para IDs, `NUMERIC` para valores monetarios, `TIMESTAMP WITH TIME ZONE` para marcas de tiempo).
4.  **Restricciones de Integridad:**
    * **Claves Primarias (`PRIMARY KEY`)** y **Claves Foráneas (`FOREIGN KEY`)** definidas correctamente.
    * **Valores Nulos:** Uso estricto de `NOT NULL` en atributos obligatorios.
    * **Restricciones `CHECK`:** Implementadas en columnas como `temperatura_promedio`, `salario`, y `cantidad` para validar rangos y valores permitidos.
5.  **Integridad Referencial:** Uso de acciones de referencia para manejar las dependencias:
    * **`ON DELETE CASCADE`:** En relaciones fuertes (ej: Si se borra un Vivero, se borran sus Plazas y Zonas asociadas).
    * **`ON DELETE RESTRICT`:** En relaciones críticas (ej: No se puede eliminar un Producto si hay stock o pedidos asociados).
    * **`ON DELETE SET NULL`:** En relaciones opcionales (ej: Si se borra un Vendedor, el `id_vendedor` en el Pedido se pone a `NULL`).
6.  **Atributos Derivados:** Definidos mediante **VISTAS** (`VIEW`) para calcular información en tiempo real (ej: `Vista_Valor_Stock_Zona`, `Vista_Detalle_Pedido`).
7.  **Población de Datos:** Incluye al menos 5 filas de ejemplo por tabla, cubriendo diferentes escenarios de restricciones.
8.  **Operaciones `DELETE`:** Incluye ejemplos comentados y ejecutables para demostrar las acciones `CASCADE`, `RESTRICT` y `SET NULL`.

## 🛠️ Instrucciones de Uso

Para ejecutar este script y montar la base de datos en tu entorno PostgreSQL:

1.  **Conexión:** Abre tu cliente PostgreSQL (pgAdmin, DBeaver, psql, o la extensión de VS Code).
2.  **Creación de la BD:** Ejecuta el comando `CREATE DATABASE viveros;` para crear la base de datos vacía.
3.  **Conectar:** Conéctate a la nueva base de datos `viveros`.
4.  **Ejecución:** Ejecuta el contenido completo del archivo `viveros.sql`. El script está diseñado para ser autocontenido, incluyendo la limpieza inicial (`DROP TABLE IF EXISTS`) para facilitar su re-ejecución.

### 🔍 Comprobaciones Post-Ejecución

Una vez ejecutado el script, puedes verificar la correcta creación de la base de datos con estas consultas:

```sql
-- Verificar los datos insertados en las tablas
SELECT * FROM Vivero;
SELECT * FROM Producto;
SELECT * FROM Pedido;

-- Comprobar el atributo derivado del stock
SELECT * FROM Vista_Valor_Stock_Zona;

-- Comprobar el subtotal de cada línea de pedido
SELECT * FROM Vista_Detalle_Pedido;