# Changelog - Cooperativa Eléctrica "Gobernador Ugarte" DB

## [1.9] - 2025-10-10

### ✨ Agregado
- **OTs liberadas por defecto**: 6 órdenes de trabajo técnicas vienen sin `empleado_id` (liberadas) desde el inicio
- Las OTs liberadas incluyen campo `observaciones` con texto "Disponible para asignación a itinerario"
- Sistema listo para itinerarios de cuadrillas sin necesidad de ejecutar scripts adicionales

### 🔧 Modificado
- **04-datos-prueba.sql**: 3 de 10 OTs ahora vienen liberadas (OT #4, #5, #7)
- **06-reclamos-pedro.sql**: 3 de 6 OTs PENDIENTES ahora vienen liberadas (en lugar de asignadas a Pedro)

### 📊 Estado de Datos
- **Total OTs**: 30
- **OTs liberadas**: 6 (disponibles para itinerarios)
- **OTs asignadas**: 24 (asignación directa a operarios)
- **Proporción**: 20% liberadas, 80% asignadas

### 🎯 Beneficio
- Base de datos lista para usar con sistema de itinerarios desde el primer despliegue
- No requiere ejecutar scripts de migración o preparación
- Usuarios pueden probar el sistema de itinerarios inmediatamente

---

## [1.8] - 2025-10-09

### 🧹 Limpieza
- Eliminados scripts de migración innecesarios (07-09)
- Dockerfile optimizado con solo scripts esenciales
- Documentación actualizada

### 📝 Modificado
- README.md simplificado
- Eliminado MIGRATION.md

---

## [1.7] - 2025-10-08

### ❌ Eliminado
- Removido estado "CERRADO" de todos los scripts
- Actualizado schema para solo usar: PENDIENTE, EN CURSO, RESUELTO

### 🔧 Modificado
- 01-schema.sql: Comentarios de estado actualizados
- 02-procedimientos.sql: Funciones actualizadas
- 03-consultas.sql: Vistas actualizadas
- 04-datos-prueba.sql: Datos sin estado CERRADO
- 06-reclamos-pedro.sql: OTs sin estado CERRADO

---

## [1.6] - 2025-10-07

### 🔄 Modificado
- Cambiado todos los estados "EN_PROCESO" a "EN CURSO"
- Scripts actualizados: 01-schema.sql, 02-procedimientos.sql, 03-consultas.sql, 04-datos-prueba.sql, 06-reclamos-pedro.sql

---

## [1.5] - 2025-10-06

### ✨ Agregado
- Sistema jerárquico de tipos de reclamo (tipo_reclamo → detalle_tipo_reclamo → reclamo)
- 2 tipos principales: TECNICO, ADMINISTRATIVO
- 8 tipos detallados de reclamos técnicos

### 🔧 Modificado
- Schema actualizado con tablas jerárquicas
- Todos los datos migrados al nuevo sistema

---

## [1.0-1.4] - 2024-2025

### 📝 Historial Previo
- Implementación inicial de la base de datos
- 22 tablas del sistema
- Datos de prueba
- Sistema de usuarios y autenticación
- Procedimientos y consultas

---

## Formato de Versiones

Formato: `[MAYOR.MENOR]`

- **MAYOR**: Cambios significativos en estructura o datos
- **MENOR**: Mejoras, correcciones, optimizaciones

### Tipos de Cambios
- ✨ **Agregado**: Nuevas funcionalidades
- 🔧 **Modificado**: Cambios en funcionalidades existentes
- ❌ **Eliminado**: Funcionalidades removidas
- 🐛 **Corregido**: Corrección de bugs
- 🧹 **Limpieza**: Refactorización sin cambios funcionales
- 📊 **Estado de Datos**: Información sobre los datos incluidos
