-- Script para eliminar todas las tablas y vistas relacionadas con el sistema de viveros
-- para por si se han hecho pruebas y se quiere empezar de nuevo
DROP VIEW IF EXISTS vista_viveros;

DROP TABLE IF EXISTS viveros CASCADE;
DROP TABLE IF EXISTS telefono_empleado CASCADE;
DROP TABLE IF EXISTS trabaja CASCADE;
DROP TABLE IF EXISTS zona CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS pedido_producto CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS telefono_cliente CASCADE;
DROP TABLE IF EXISTS tajinaste_plus CASCADE;

-- Creacion de las tablas y vistas necesarias para el sistema de viveros


