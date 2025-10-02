# Guía de Desarrollo - Cooperativa Ugarte DB

Documentación técnica para desarrolladores que necesiten modificar o extender la base de datos.

## 📁 Estructura del Proyecto

```
cooperativa-ugarte-db/
├── Dockerfile                      # Imagen Docker PostgreSQL 15-alpine
├── docker-compose.yml              # Orquestación de servicios
├── 01-schema.sql                   # Schema completo (tablas, índices, triggers)
├── scripts/
│   ├── 02-procedimientos.sql       # Funciones y procedimientos almacenados
│   ├── 03-consultas.sql            # Funciones de consulta especializadas
│   ├── 04-datos-prueba.sql         # Datos de prueba (12 socios, facturas, etc.)
│   ├── 05-usuarios.sql             # Sistema de autenticación con bcrypt
│   └── generate_hash.js            # Helper para generar hashes bcrypt
├── README.md                       # Documentación principal
└── DEVELOPMENT.md                  # Esta guía
```

## 🔧 Sistema de Autenticación

### Generación de Hash Bcrypt

Para generar un nuevo hash de contraseña:

```bash
# 1. Instalar dependencias (si no están instaladas)
npm install bcrypt

# 2. Generar hash
node scripts/generate_hash.js

# 3. Copiar el hash generado y usarlo en 05-autenticacion.sql
```

### Modificar Usuarios de Prueba

Para agregar o modificar usuarios, edita `scripts/05-usuarios.sql`:

```sql
-- Ejemplo: Agregar nuevo operario
SELECT empleado_id INTO v_empleado_id 
FROM empleado 
WHERE legajo = 'EMP-004' 
LIMIT 1;

IF v_empleado_id IS NULL THEN
    INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
    VALUES ('Nuevo', 'Operario', 'EMP-004', 'OPERARIO', CURRENT_DATE)
    RETURNING empleado_id INTO v_empleado_id;
END IF;

PERFORM crear_usuario_sistema(
    'nuevo.operario@cooperativa-ugarte.com.ar',
    v_password_hash,
    NULL,
    v_empleado_id,
    ARRAY['OPERARIO']
);
```

## 🎭 Roles del Sistema

El sistema tiene **EXACTAMENTE 3 ROLES**:

| Rol | ID | Descripción |
|-----|-----|-------------|
| `CLIENTE` | 1 | Socios de la cooperativa |
| `OPERARIO` | 2 | Empleados operativos |
| `ADMIN` | 3 | Administradores del sistema |

⚠️ **NO crear roles adicionales**. El sistema está diseñado para trabajar con estos 3 roles.

## 🔄 Workflow de Desarrollo

### 1. Desarrollo Local

```bash
# Clonar repositorio
git clone https://github.com/damianclausi/cooperativa-ugarte-db.git
cd cooperativa-ugarte-db

# Levantar base de datos
docker-compose up -d

# Ver logs en tiempo real
docker logs -f cooperativa-db

# Conectar a PostgreSQL
docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db
```

### 2. Probar Cambios

```bash
# Detener y limpiar volúmenes
docker-compose down -v

# Reconstruir con cambios
docker-compose up -d

# Esperar inicialización (15-20 segundos)
sleep 15

# Verificar que todo funcione
docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db -c "SELECT COUNT(*) FROM usuario;"
```

### 3. Build de Imagen Docker

```bash
# Build de nueva versión
docker build -t damian2k/cooperativa-ugarte-db:1.X .

# Etiquetar como latest
docker tag damian2k/cooperativa-ugarte-db:1.X damian2k/cooperativa-ugarte-db:latest

# Push a Docker Hub
docker push damian2k/cooperativa-ugarte-db:1.X
docker push damian2k/cooperativa-ugarte-db:latest
```

### 4. Commit a GitHub

```bash
git add .
git commit -m "feat: Descripción del cambio"
git push origin main
```

## 📊 Verificaciones Post-Deploy

### Verificar Roles

```sql
SELECT * FROM rol ORDER BY rol_id;
-- Debe mostrar exactamente 3 roles: CLIENTE, OPERARIO, ADMIN
```

### Verificar Usuarios

```sql
SELECT roles[1] AS rol, COUNT(*) AS cantidad 
FROM v_usuarios_completos 
GROUP BY roles[1] 
ORDER BY rol;
```

**Resultado esperado:**
- ADMIN: 2 usuarios
- CLIENTE: 11 usuarios  
- OPERARIO: 6 usuarios

### Verificar Tablas

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### Verificar Funciones

```sql
SELECT proname 
FROM pg_proc 
WHERE pronamespace = 'public'::regnamespace 
ORDER BY proname;
```

## 🐛 Debugging

### Ver logs de inicialización

```bash
docker logs cooperativa-db 2>&1 | grep -i "error\|notice"
```

### Verificar orden de ejecución de scripts

Los scripts se ejecutan en orden numérico:
1. `01-schema.sql` → Schema, tablas, índices y triggers
2. `02-procedimientos.sql` → Funciones almacenadas
3. `03-consultas.sql` → Funciones de consulta especializadas
4. `04-datos-prueba.sql` → Datos de prueba (socios, facturas, etc.)
5. `05-usuarios.sql` → Sistema de autenticación y usuarios

### Resetear completamente la base de datos

```bash
# Eliminar contenedor y volumen
docker-compose down -v

# Eliminar imagen local (opcional)
docker rmi damian2k/cooperativa-ugarte-db:latest

# Reconstruir desde cero
docker-compose up -d
```

## 🔐 Seguridad

### Cambiar Credenciales

Para cambiar las credenciales de PostgreSQL:

1. **Editar Dockerfile:**
```dockerfile
ENV POSTGRES_PASSWORD=nueva_contraseña
```

2. **Editar docker-compose.yml:**
```yaml
environment:
  POSTGRES_PASSWORD: nueva_contraseña
```

3. **Reconstruir imagen:**
```bash
docker build -t damian2k/cooperativa-ugarte-db:nueva_version .
```

### Hashes de Contraseña

Todas las contraseñas de usuario se almacenan hasheadas con **bcrypt (10 rounds)**.

```javascript
// Generar hash (Node.js)
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash('password123', 10);
```

## � Ejemplos de Consultas SQL

### Verificar usuarios por rol
```sql
SELECT roles[1] AS rol, COUNT(*) AS cantidad 
FROM v_usuarios_completos 
GROUP BY roles[1] 
ORDER BY rol;
```

### Facturas pendientes
```sql
SELECT f.factura_id, s.nombre, s.apellido, f.monto_total, f.fecha_vencimiento
FROM factura f
JOIN cuenta c ON f.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
WHERE f.estado = 'PENDIENTE'
ORDER BY f.fecha_vencimiento;
```

### Reclamos activos
```sql
SELECT * FROM v_reclamos_completos 
WHERE estado IN ('NUEVO', 'EN_PROCESO')
ORDER BY fecha_reclamo DESC;
```

### Consumo por socio
```sql
SELECT s.nombre, s.apellido, 
       SUM(l.lectura_actual - l.lectura_anterior) as total_kwh
FROM socio s
JOIN cuenta c ON s.socio_id = c.socio_id
JOIN medidor m ON c.cuenta_id = m.cuenta_id
JOIN lectura l ON m.medidor_id = l.medidor_id
GROUP BY s.socio_id, s.nombre, s.apellido
ORDER BY total_kwh DESC;
```

### Dashboard completo de un cliente
```sql
SELECT * FROM dashboard_cliente(1);
```

### Facturas de un cliente
```sql
SELECT * FROM facturas_cliente(1);
```

### Estado de cuenta
```sql
SELECT * FROM estado_cuenta_socio(1);
```

## �📝 Convenciones

### Nombrado de Tablas
- Singular: `socio`, `factura`, `reclamo`
- snake_case: `orden_trabajo`, `usuario_rol`

### Nombrado de Funciones
- snake_case: `dashboard_cliente()`, `crear_usuario_sistema()`
- Verbos descriptivos: `calcular_`, `obtener_`, `crear_`

### Nombrado de Vistas
- Prefijo `v_`: `v_usuarios_completos`, `v_reclamos_completos`

## 🚀 Próximas Mejoras

- [ ] Agregar índices para optimización de consultas
- [ ] Implementar soft deletes en tablas principales
- [ ] Agregar auditoría de cambios
- [ ] Implementar versionado de schema con Flyway/Liquibase
- [ ] Agregar tests automatizados de schema

## 📞 Soporte

Para problemas o sugerencias:
- GitHub Issues: https://github.com/damianclausi/cooperativa-ugarte-db/issues

## 🎓 Contexto Académico

Este proyecto es parte de las **Prácticas Profesionales IV (PPIV)** del **IFTS N° 29**.

**Institución:** Instituto de Formación Técnica Superior N° 29  
**Materia:** Prácticas Profesionales IV  
**Sistema:** Gestión integral para Cooperativa Eléctrica "Gobernador Ugarte"  
**Estudiante:** Damián Clausi  
**Año:** 2025

---

**Última actualización:** Octubre 2025  
**Versión:** 1.3
