# Cooperativa Eléctrica "Gobernador Ugarte"

Base de datos PostgreSQL completa para gestión de cooperativa eléctrica con Docker.

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

## Inicio Rápido

### Usando Docker Hub (Recomendado)

```bash
# Solo base de datos
docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest

# Con pgAdmin
docker run -d --name cooperativa-pgadmin -p 8080:80 \
  -e PGADMIN_DEFAULT_EMAIL=admin@cooperativa.com.ar \
  -e PGADMIN_DEFAULT_PASSWORD=admin123 \
  dpage/pgadmin4:latest
```

### Usando Docker Compose

```bash
git clone https://github.com/damianclausi/cooperativa-ugarte-db.git
cd cooperativa-ugarte-db
docker-compose up -d
```

## Credenciales

### Base de Datos PostgreSQL
- **Host:** `localhost:5432`
- **Database:** `cooperativa_ugarte_db`
- **Usuario:** `coop_user`
- **Contraseña:** `cooperativa2024`

### pgAdmin (http://localhost:8080)
- **Email:** `admin@cooperativa-ugarte.com.ar`
- **Contraseña:** `admin123`

## Datos Incluidos

- **12 Socios** con datos realistas
- **15 Facturas** de diferentes períodos
- **10 Reclamos** en varios estados
- **Servicios** típicos de cooperativa eléctrica
- **Funciones personalizadas** como `dashboard_cliente()`

## Consultas de Ejemplo

```sql
-- Verificar datos
SELECT COUNT(*) FROM socio;

-- Dashboard de cliente
SELECT dashboard_cliente(1);

-- Facturas pendientes
SELECT * FROM factura WHERE estado = 'PENDIENTE';

-- Reclamos activos
SELECT * FROM v_reclamos_completos 
WHERE estado IN ('NUEVO', 'EN_PROCESO');
```

## Estructura

### Tablas Principales
- `socio`, `cuenta`, `factura`, `reclamo`
- `medidor`, `lectura`, `orden_trabajo`
- `empleado`, `servicio`, `material`

### Funciones Personalizadas
- `dashboard_cliente(socio_id)` → Dashboard JSON
- `facturas_cliente(socio_id)` → Historial
- `crear_nueva_cuenta()` → Gestión de cuentas

### Vistas Especializadas
- `v_cuentas_completas`
- `v_reclamos_completos`
- `v_ordenes_trabajo_completas`

## Configuración pgAdmin

1. Ir a http://localhost:8080
2. Login con las credenciales de pgAdmin
3. Agregar servidor:
   - **Host:** `postgres` (en Docker) o `localhost`
   - **Port:** `5432`
   - **Database:** `cooperativa_ugarte_db`
   - **User:** `coop_user`
   - **Password:** `cooperativa2024`

## Docker Hub

**Imagen:** `damian2k/cooperativa-ugarte-db`  
**Tags:** `latest`, `1.2`, `1.1`, `1.0`  
**Tamaño:** ~399MB  
**Base:** PostgreSQL 15-alpine

## Comandos Útiles

```bash
# Ver logs
docker logs cooperativa-db

# Conectar por terminal
docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

# Backup
docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

# Restaurar
docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql
```

## Solución de Problemas

### Puerto ocupado
```bash
# Usar puerto alternativo
docker run -d -p 5433:5432 damian2k/cooperativa-ugarte-db:latest
```

### Reiniciar limpio
```bash
docker-compose down -v
docker-compose up -d
```

## Contexto

**Ubicación:** Gobernador Ugarte, Buenos Aires, Argentina  
**Código de área:** 2226  
**Timezone:** America/Argentina/Buenos_Aires  
**Moneda:** Pesos argentinos (ARS)

---

**Desarrollado para sistemas de gestión de cooperativa eléctrica - PPIV.**
