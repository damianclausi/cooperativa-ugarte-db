# Documentación Completa - Cooperativa Ugarte DB

Documentación técnica detallada para desarrolladores y usuarios avanzados.

---

## Estructura del Proyecto```

cooperativa-ugarte-db/

```├── Dockerfile                      # Imagen Docker PostgreSQL 15-alpine

cooperativa-ugarte-db/├── docker-compose.yml              # Orquestación de servicios

├── Dockerfile                      # Imagen Docker PostgreSQL 15-alpine├── 01-schema.sql                   # Schema completo (tablas, índices, triggers)

├── docker-compose.yml              # Orquestación de servicios├── scripts/

├── scripts/│   ├── 02-procedimientos.sql       # Funciones y procedimientos almacenados

│   ├── 01-schema.sql               # Schema completo (tablas, índices, triggers)│   ├── 03-consultas.sql            # Funciones de consulta especializadas

│   ├── 02-procedimientos.sql       # Funciones y procedimientos almacenados│   ├── 04-datos-prueba.sql         # Datos de prueba (12 socios, facturas, etc.)

│   ├── 03-consultas.sql            # Funciones de consulta especializadas│   ├── 05-usuarios.sql             # Sistema de autenticación con bcrypt

│   ├── 04-datos-prueba.sql         # Datos de prueba (12 socios, facturas, etc.)│   └── generate_hash.js            # Helper para generar hashes bcrypt

│   ├── 05-usuarios.sql             # Sistema de autenticación con bcrypt├── README.md                       # Documentación principal

│   └── generate_hash.js            # Helper para generar hashes bcrypt└── DEVELOPMENT.md                  # Esta guía

├── README.md                       # Documentación principal```

├── DEVELOPMENT.md                  # Esta guía

├── package.json                    # Dependencias Node.js (bcrypt)## 🔧 Sistema de Autenticación

└── package-lock.json

```### Generación de Hash Bcrypt



---Para generar un nuevo hash de contraseña:



## Sistema de Autenticación```bash

# 1. Instalar dependencias (si no están instaladas)

### Generación de Hash Bcryptnpm install bcrypt



Para generar un nuevo hash de contraseña:# 2. Generar hash

node scripts/generate_hash.js

```bash

# 1. Instalar dependencias (si no están instaladas)# 3. Copiar el hash generado y usarlo en 05-autenticacion.sql

npm install```



# 2. Generar hash### Modificar Usuarios de Prueba

node scripts/generate_hash.js

Para agregar o modificar usuarios, edita `scripts/05-usuarios.sql`:

# Output ejemplo:

# $2b$10$WRl0heuhm34IuEWqZWkyF.B6kpWQZ12tiOMZlFQtvbD2DL38lnswG```sql

-- Ejemplo: Agregar nuevo operario

# 3. Copiar el hash generado y usarlo en los scripts SQLSELECT empleado_id INTO v_empleado_id 

```FROM empleado 

WHERE legajo = 'EMP-004' 

### Modificar Usuarios de PruebaLIMIT 1;



Para agregar o modificar usuarios, edita `scripts/05-usuarios.sql`:IF v_empleado_id IS NULL THEN

    INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)

```sql    VALUES ('Nuevo', 'Operario', 'EMP-004', 'OPERARIO', CURRENT_DATE)

-- Ejemplo: Agregar nuevo operario    RETURNING empleado_id INTO v_empleado_id;

SELECT empleado_id INTO v_empleado_id END IF;

FROM empleado 

WHERE legajo = 'EMP-004' PERFORM crear_usuario_sistema(

LIMIT 1;    'nuevo.operario@cooperativa-ugarte.com.ar',

    v_password_hash,

IF v_empleado_id IS NULL THEN    NULL,

    INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)    v_empleado_id,

    VALUES ('Nuevo', 'Operario', 'EMP-004', 'OPERARIO', CURRENT_DATE)    ARRAY['OPERARIO']

    RETURNING empleado_id INTO v_empleado_id;);

END IF;```



PERFORM crear_usuario_sistema(## 🎭 Roles del Sistema

    'nuevo.operario@cooperativa-ugarte.com.ar',

    v_password_hash,El sistema tiene **EXACTAMENTE 3 ROLES**:

    NULL,

    v_empleado_id,| Rol | ID | Descripción |

    ARRAY['OPERARIO']|-----|-----|-------------|

);| `CLIENTE` | 1 | Socios de la cooperativa |

```| `OPERARIO` | 2 | Empleados operativos |

| `ADMIN` | 3 | Administradores del sistema |

---

⚠️ **NO crear roles adicionales**. El sistema está diseñado para trabajar con estos 3 roles.

## Roles del Sistema

## 🔄 Workflow de Desarrollo

El sistema tiene **EXACTAMENTE 3 ROLES**:

### 1. Desarrollo Local

| Rol | ID | Descripción |

|-----|-----|-------------|```bash

| `CLIENTE` | 1 | Socios de la cooperativa |# Clonar repositorio

| `OPERARIO` | 2 | Empleados operativos |git clone https://github.com/damianclausi/cooperativa-ugarte-db.git

| `ADMIN` | 3 | Administradores del sistema |cd cooperativa-ugarte-db



**IMPORTANTE:** NO crear roles adicionales. El sistema está diseñado para trabajar con estos 3 roles.# Levantar base de datos

docker-compose up -d

---

# Ver logs en tiempo real

## Workflow de Desarrollodocker logs -f cooperativa-db



### 1. Desarrollo Local# Conectar a PostgreSQL

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

```bash```

# Clonar repositorio

git clone https://github.com/damianclausi/cooperativa-ugarte-db.git### 2. Probar Cambios

cd cooperativa-ugarte-db

```bash

# Levantar base de datos# Detener y limpiar volúmenes

docker-compose up -ddocker-compose down -v



# Ver logs en tiempo real# Reconstruir con cambios

docker logs -f cooperativa-dbdocker-compose up -d



# Conectar a PostgreSQL# Esperar inicialización (15-20 segundos)

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_dbsleep 15

```

# Verificar que todo funcione

### 2. Probar Cambiosdocker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db -c "SELECT COUNT(*) FROM usuario;"

```

```bash

# Detener y limpiar volúmenes### 3. Build de Imagen Docker

docker-compose down -v

```bash

# Reconstruir con cambios# Build de nueva versión

docker-compose up -ddocker build -t damian2k/cooperativa-ugarte-db:1.X .



# Esperar inicialización (15-20 segundos)# Etiquetar como latest

sleep 15docker tag damian2k/cooperativa-ugarte-db:1.X damian2k/cooperativa-ugarte-db:latest



# Verificar que todo funcione# Push a Docker Hub

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db \docker push damian2k/cooperativa-ugarte-db:1.X

  -c "SELECT COUNT(*) FROM usuario;"docker push damian2k/cooperativa-ugarte-db:latest

``````



### 3. Build de Imagen Docker### 4. Commit a GitHub



```bash```bash

# Build de nueva versióngit add .

docker build -t damian2k/cooperativa-ugarte-db:1.X .git commit -m "feat: Descripción del cambio"

git push origin main

# Etiquetar como latest```

docker tag damian2k/cooperativa-ugarte-db:1.X damian2k/cooperativa-ugarte-db:latest

## 📊 Verificaciones Post-Deploy

# Push a Docker Hub

docker push damian2k/cooperativa-ugarte-db:1.X### Verificar Roles

docker push damian2k/cooperativa-ugarte-db:latest

``````sql

SELECT * FROM rol ORDER BY rol_id;

### 4. Commit a GitHub-- Debe mostrar exactamente 3 roles: CLIENTE, OPERARIO, ADMIN

```

```bash

git add .### Verificar Usuarios

git commit -m "feat: Descripción del cambio"

git push origin main```sql

```SELECT roles[1] AS rol, COUNT(*) AS cantidad 

FROM v_usuarios_completos 

---GROUP BY roles[1] 

ORDER BY rol;

## Verificaciones Post-Deploy```



### Verificar Roles**Resultado esperado:**

- ADMIN: 2 usuarios

```sql- CLIENTE: 11 usuarios  

SELECT * FROM rol ORDER BY rol_id;- OPERARIO: 6 usuarios

-- Debe mostrar exactamente 3 roles: CLIENTE, OPERARIO, ADMIN

```### Verificar Tablas



### Verificar Usuarios```sql

SELECT table_name 

```sqlFROM information_schema.tables 

SELECT roles[1] AS rol, COUNT(*) AS cantidad WHERE table_schema = 'public' 

FROM v_usuarios_completos ORDER BY table_name;

GROUP BY roles[1] ```

ORDER BY rol;

```### Verificar Funciones



**Resultado esperado:**```sql

- ADMIN: 2 usuariosSELECT proname 

- CLIENTE: 11 usuarios  FROM pg_proc 

- OPERARIO: 6 usuariosWHERE pronamespace = 'public'::regnamespace 

- **TOTAL: 19 usuarios**ORDER BY proname;

```

### Verificar Tablas

## 🐛 Debugging

```sql

SELECT table_name ### Ver logs de inicialización

FROM information_schema.tables 

WHERE table_schema = 'public' ```bash

ORDER BY table_name;docker logs cooperativa-db 2>&1 | grep -i "error\|notice"

```

-- Debe mostrar 22 tablas

```### Verificar orden de ejecución de scripts



### Verificar FuncionesLos scripts se ejecutan en orden numérico:

1. `01-schema.sql` → Schema, tablas, índices y triggers

```sql2. `02-procedimientos.sql` → Funciones almacenadas

SELECT proname 3. `03-consultas.sql` → Funciones de consulta especializadas

FROM pg_proc 4. `04-datos-prueba.sql` → Datos de prueba (socios, facturas, etc.)

WHERE pronamespace = 'public'::regnamespace 5. `05-usuarios.sql` → Sistema de autenticación y usuarios

ORDER BY proname;

```### Resetear completamente la base de datos



### Verificar Hashes```bash

# Eliminar contenedor y volumen

```sqldocker-compose down -v

-- Verificar que NO haya hashes de ejemplo

SELECT email, substring(hash_pass, 1, 30) as hash_inicio # Eliminar imagen local (opcional)

FROM usuario docker rmi damian2k/cooperativa-ugarte-db:latest

LIMIT 5;

# Reconstruir desde cero

-- NO debe mostrar: $2b$10$example_hash_...docker-compose up -d

-- DEBE mostrar: $2b$10$WRl0heuhm34IuEWqZWkyF.B...```

```

## 🔐 Seguridad

---

### Cambiar Credenciales

## Debugging

Para cambiar las credenciales de PostgreSQL:

### Ver logs de inicialización

1. **Editar Dockerfile:**

```bash```dockerfile

docker logs cooperativa-db 2>&1 | grep -i "error\|notice"ENV POSTGRES_PASSWORD=nueva_contraseña

``````



### Verificar orden de ejecución de scripts2. **Editar docker-compose.yml:**

```yaml

Los scripts se ejecutan en orden numérico:environment:

  POSTGRES_PASSWORD: nueva_contraseña

1. `01-schema.sql` → Schema, tablas, índices y triggers```

2. `02-procedimientos.sql` → Funciones almacenadas

3. `03-consultas.sql` → Funciones de consulta especializadas3. **Reconstruir imagen:**

4. `04-datos-prueba.sql` → Datos de prueba (socios, facturas, etc.)```bash

5. `05-usuarios.sql` → Sistema de autenticación y usuariosdocker build -t damian2k/cooperativa-ugarte-db:nueva_version .

```

### Problemas comunes

### Hashes de Contraseña

#### Error: "input parameters after one with a default value must also have defaults"

Todas las contraseñas de usuario se almacenan hasheadas con **bcrypt (10 rounds)**.

**Solución:** Todos los parámetros después de uno con valor por defecto deben tener valores por defecto.

```javascript

```sql// Generar hash (Node.js)

-- MAL:const bcrypt = require('bcrypt');

CREATE FUNCTION foo(a INT DEFAULT 1, b INT) ...const hash = await bcrypt.hash('password123', 10);

```

-- BIEN:

CREATE FUNCTION foo(a INT DEFAULT 1, b INT DEFAULT 2) ...## � Ejemplos de Consultas SQL

```

### Verificar usuarios por rol

#### Error: column "creado_en" does not exist```sql

SELECT roles[1] AS rol, COUNT(*) AS cantidad 

**Solución:** El nombre correcto es `created_at` en la tabla `usuario`.FROM v_usuarios_completos 

GROUP BY roles[1] 

```sqlORDER BY rol;

-- MAL:```

u.creado_en

### Facturas pendientes

-- BIEN:```sql

u.created_atSELECT f.factura_id, s.nombre, s.apellido, f.monto_total, f.fecha_vencimiento

```FROM factura f

JOIN cuenta c ON f.cuenta_id = c.cuenta_id

#### Error: Hashes no funcionan con bcryptJOIN socio s ON c.socio_id = s.socio_id

WHERE f.estado = 'PENDIENTE'

**Solución:** Los hashes de ejemplo (`$2b$10$example_hash_...`) NO son válidos. Genera hashes reales con `generate_hash.js`.ORDER BY f.fecha_vencimiento;

```

### Resetear completamente la base de datos

### Reclamos activos

```bash```sql

# Eliminar contenedor y volumenSELECT * FROM v_reclamos_completos 

docker-compose down -vWHERE estado IN ('NUEVO', 'EN_PROCESO')

ORDER BY fecha_reclamo DESC;

# Eliminar imagen local (opcional)```

docker rmi damian2k/cooperativa-ugarte-db:latest

### Consumo por socio

# Reconstruir desde cero```sql

docker-compose up -dSELECT s.nombre, s.apellido, 

```       SUM(l.lectura_actual - l.lectura_anterior) as total_kwh

FROM socio s

---JOIN cuenta c ON s.socio_id = c.socio_id

JOIN medidor m ON c.cuenta_id = m.cuenta_id

## SeguridadJOIN lectura l ON m.medidor_id = l.medidor_id

GROUP BY s.socio_id, s.nombre, s.apellido

### Cambiar CredencialesORDER BY total_kwh DESC;

```

Para cambiar las credenciales de PostgreSQL:

### Dashboard completo de un cliente

1. **Editar Dockerfile:**```sql

```dockerfileSELECT * FROM dashboard_cliente(1);

ENV POSTGRES_PASSWORD=nueva_contraseña```

```

### Facturas de un cliente

2. **Editar docker-compose.yml:**```sql

```yamlSELECT * FROM facturas_cliente(1);

environment:```

  POSTGRES_PASSWORD: nueva_contraseña

```### Estado de cuenta

```sql

3. **Reconstruir imagen:**SELECT * FROM estado_cuenta_socio(1);

```bash```

docker build -t damian2k/cooperativa-ugarte-db:nueva_version .

```## �📝 Convenciones



### Hashes de Contraseña### Nombrado de Tablas

- Singular: `socio`, `factura`, `reclamo`

Todas las contraseñas de usuario se almacenan hasheadas con **bcrypt (10 rounds)**.- snake_case: `orden_trabajo`, `usuario_rol`



```javascript### Nombrado de Funciones

// Generar hash (Node.js)- snake_case: `dashboard_cliente()`, `crear_usuario_sistema()`

const bcrypt = require('bcrypt');- Verbos descriptivos: `calcular_`, `obtener_`, `crear_`

const hash = await bcrypt.hash('password123', 10);

```### Nombrado de Vistas

- Prefijo `v_`: `v_usuarios_completos`, `v_reclamos_completos`

**Características de bcrypt:**

- Mismo password genera diferentes hashes cada vez (esto es NORMAL)## 🚀 Próximas Mejoras

- Todos los hashes validan correctamente con `bcrypt.compare()`

- NO usar hashes de ejemplo como `$2b$10$example_hash_...`- [ ] Agregar índices para optimización de consultas

- [ ] Implementar soft deletes en tablas principales

---- [ ] Agregar auditoría de cambios

- [ ] Implementar versionado de schema con Flyway/Liquibase

## Ejemplos de Consultas SQL- [ ] Agregar tests automatizados de schema



### Verificar usuarios por rol## 📞 Soporte



```sqlPara problemas o sugerencias:

SELECT roles[1] AS rol, COUNT(*) AS cantidad - GitHub Issues: https://github.com/damianclausi/cooperativa-ugarte-db/issues

FROM v_usuarios_completos 

GROUP BY roles[1] ## 🎓 Contexto Académico

ORDER BY rol;

```Este proyecto es parte de las **Prácticas Profesionales IV (PPIV)** del **IFTS N° 29**.



### Facturas pendientes**Institución:** Instituto de Formación Técnica Superior N° 29  

**Materia:** Prácticas Profesionales IV  

```sql**Sistema:** Gestión integral para Cooperativa Eléctrica "Gobernador Ugarte"  

SELECT f.factura_id, s.nombre, s.apellido, f.monto_total, f.fecha_vencimiento**Estudiante:** Damián Clausi  

FROM factura f**Año:** 2025

JOIN cuenta c ON f.cuenta_id = c.cuenta_id

JOIN socio s ON c.socio_id = s.socio_id---

WHERE f.estado = 'PENDIENTE'

ORDER BY f.fecha_vencimiento;**Última actualización:** Octubre 2025  

```**Versión:** 1.3


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

---

## Convenciones

### Nombrado de Tablas
- Singular: `socio`, `factura`, `reclamo`
- snake_case: `orden_trabajo`, `usuario_rol`

### Nombrado de Funciones
- snake_case: `dashboard_cliente()`, `crear_usuario_sistema()`
- Verbos descriptivos: `calcular_`, `obtener_`, `crear_`

### Nombrado de Vistas
- Prefijo `v_`: `v_usuarios_completos`, `v_reclamos_completos`

### Nombrado de Scripts
- Prefijo numérico para orden de ejecución: `01-`, `02-`, etc.
- Nombres descriptivos: `01-schema.sql`, `05-usuarios.sql`

---

## Próximas Mejoras

- [ ] Agregar índices para optimización de consultas
- [ ] Implementar soft deletes en tablas principales
- [ ] Agregar auditoría de cambios
- [ ] Implementar versionado de schema con Flyway/Liquibase
- [ ] Agregar tests automatizados de schema
- [ ] Documentar API de funciones con ejemplos

---

## Soporte

Para problemas o sugerencias:
- **GitHub Issues:** https://github.com/damianclausi/cooperativa-ugarte-db/issues
- **Docker Hub:** https://hub.docker.com/r/damian2k/cooperativa-ugarte-db

---

## Contexto Académico

Este proyecto es parte de las **Prácticas Profesionales IV (PPIV)** del **IFTS N° 29**.

**Institución:** Instituto de Formación Técnica Superior N° 29  
**Materia:** Prácticas Profesionales IV  
**Objetivo:** Sistema integral de gestión para cooperativa eléctrica  
**Estudiante:** Damián Clausi  
**Año:** 2025

---

**Última actualización:** Octubre 2025
