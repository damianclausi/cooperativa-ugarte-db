# Scripts de Migración - Cooperativa Eléctrica DB

## 📋 Información General

Los scripts de migración (07-09) son **opcionales** y están diseñados para actualizar bases de datos existentes que fueron creadas con versiones anteriores del esquema.

**Para nuevas instalaciones**, estos scripts **NO son necesarios** ya que la estructura actual del esquema ya incluye todos los cambios.

## 🔄 Scripts Disponibles

### 07-migracion-tipos-reclamo.sql
- **Propósito**: Restructura la jerarquía de tipos de reclamo
- **Cambios**:
  - Convierte tabla plana `tipo_reclamo` en jerarquía: `tipo_reclamo` → `detalle_tipo_reclamo`
  - Actualiza referencias de `tipo_id` a `detalle_id` en tabla `reclamo`
  - Recrea vistas con nueva estructura
- **Idempotente**: Sí - detecta si ya se aplicó

### 08-migracion-estados.sql
- **Propósito**: Actualiza estados de reclamos y órdenes de trabajo
- **Cambios**:
  - Cambia todos los estados `EN_PROCESO` → `EN CURSO`
- **Idempotente**: Sí - detecta si ya se aplicó

### 09-eliminar-estado-cerrado.sql
- **Propósito**: Elimina el estado CERRADO del sistema
- **Cambios**:
  - Elimina cualquier registro con estado `CERRADO`
  - Actualiza consultas para excluir solo `RESUELTO`
- **Idempotente**: Sí - detecta si ya se aplicó

## 🚀 Cómo Usar Scripts de Migración

### Opción 1: Para bases de datos existentes (Docker)

Si tienes una base de datos corriendo en Docker y necesitas migrarla:

```bash
# Ejecutar scripts de migración uno por uno
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/07-migracion-tipos-reclamo.sql
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/08-migracion-estados.sql
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/09-eliminar-estado-cerrado.sql
```

### Opción 2: Crear imagen con migración incluida

Si necesitas una imagen que incluya los scripts de migración (para actualizar bases existentes):

```dockerfile
# Dockerfile con migración
FROM postgres:15-alpine

# ... configuración básica ...

# Copiar TODOS los scripts incluyendo migración
COPY scripts/01-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY scripts/02-procedimientos.sql /docker-entrypoint-initdb.d/02-procedimientos.sql
COPY scripts/03-consultas.sql /docker-entrypoint-initdb.d/03-consultas.sql
COPY scripts/04-datos-prueba.sql /docker-entrypoint-initdb.d/04-datos-prueba.sql
COPY scripts/05-usuarios.sql /docker-entrypoint-initdb.d/05-usuarios.sql
COPY scripts/06-reclamos-pedro.sql /docker-entrypoint-initdb.d/06-reclamos-pedro.sql
# Scripts de migración
COPY scripts/07-migracion-tipos-reclamo.sql /docker-entrypoint-initdb.d/07-migracion-tipos-reclamo.sql
COPY scripts/08-migracion-estados.sql /docker-entrypoint-initdb.d/08-migracion-estados.sql
COPY scripts/09-eliminar-estado-cerrado.sql /docker-entrypoint-initdb.d/09-eliminar-estado-cerrado.sql
```

### Opción 3: Migración manual (sin Docker)

Para bases de datos PostgreSQL que no están en Docker:

```bash
# Conectar a tu base de datos
psql -U tu_usuario -d tu_base_datos

# Ejecutar scripts
\i scripts/07-migracion-tipos-reclamo.sql
\i scripts/08-migracion-estados.sql
\i scripts/09-eliminar-estado-cerrado.sql
```

## ✅ Verificación

Después de ejecutar las migraciones, verifica que todo esté correcto:

```sql
-- Verificar estados
SELECT estado, COUNT(*) FROM reclamo GROUP BY estado ORDER BY estado;

-- Verificar estructura jerárquica
SELECT
    t.nombre AS tipo,
    d.nombre AS detalle,
    COUNT(r.reclamo_id) AS cantidad_reclamos
FROM tipo_reclamo t
JOIN detalle_tipo_reclamo d ON t.tipo_id = d.tipo_id
LEFT JOIN reclamo r ON d.detalle_id = r.detalle_id
GROUP BY t.nombre, d.nombre
ORDER BY t.nombre, d.nombre;
```

## 📝 Notas Importantes

- **Seguridad**: Haz backup de tu base de datos antes de ejecutar migraciones
- **Orden**: Ejecuta los scripts en orden numérico (07 → 08 → 09)
- **Idempotencia**: Los scripts pueden ejecutarse múltiples veces sin problemas
- **Tiempo**: Las migraciones pueden tomar tiempo en bases de datos grandes
- **Rollback**: No hay scripts de rollback - asegúrate de tener backups

## 🆘 Solución de Problemas

### Error: "duplicate key value violates unique constraint"
- **Causa**: El script detectó que ya se aplicó pero hay código fuera del bloque DO
- **Solución**: Los scripts están diseñados para ser idempotentes. Si ves este error, significa que la migración ya se aplicó correctamente.

### Error: "relation already exists"
- **Causa**: Intentando crear tablas que ya existen
- **Solución**: Verificar que la base de datos no tenga la estructura nueva ya aplicada

### Migración no se aplica
- **Causa**: El script detectó que ya se aplicó
- **Solución**: Verificar con las consultas de verificación que los cambios están presentes</content>
<parameter name="filePath">/home/damian/projects/cooperativa-ugarte-db/MIGRATION.md