# Documentacion Tecnica - Cooperativa Electrica "Gobernador Ugarte"

Base de datos PostgreSQL para el sistema de gestion de cooperativa electrica de la PPIV.

## Contenido

- [Estructura de la Base de Datos](#estructura-de-la-base-de-datos)
- [Usuarios de Prueba](#usuarios-de-prueba)
- [Consultas SQL Utiles](#consultas-sql-utiles)
- [Desarrollo](#desarrollo)
- [Comandos Avanzados](#comandos-avanzados)

---

## Estructura de la Base de Datos

### Tablas Principales (22 total)

**Gestion de Socios y Usuarios:**
- `socios` - Informacion de socios de la cooperativa
- `usuarios` - Sistema de autenticacion con bcrypt
- `roles` - 3 roles: CLIENTE, OPERARIO, ADMIN

**Facturacion:**
- `facturas` - Facturas mensuales
- `detalle_factura` - Lineas de detalle de cada factura
- `pagos` - Registro de pagos realizados
- `metodos_pago` - Tipos de pago (efectivo, transferencia, etc.)

**Medidores y Lecturas:**
- `medidores` - Dispositivos de medicion
- `lecturas` - Lecturas periodicas de consumo
- `tipos_medidor` - Clasificacion de medidores

**Reclamos y Ordenes de Trabajo:**
- `reclamos` - Reclamos de socios
- `ordenes_trabajo` - Ordenes generadas desde reclamos
- `estados_reclamo` - Estados del ciclo de vida
- `categorias_reclamo` - Clasificacion de reclamos

**Empleados:**
- `empleados` - Personal de la cooperativa
- `puestos` - Cargos y posiciones
- `areas` - Departamentos

**Configuracion:**
- `tarifas` - Tarifas electricas vigentes
- `periodos_facturacion` - Ciclos de facturacion
- `domicilios` - Direcciones de suministro
- `localidades` - Localidades servidas
- `provincias` - Provincias

---

## Usuarios de Prueba

Todos los usuarios usan la contrasena: **`password123`**

Los hashes fueron generados con bcrypt (10 rounds):
```
$2b$10$WRl0heuhm34IuEWqZWkyF.B6kpWQZ12tiOMZlFQtvbD2DL38lnswG
```

### Clientes (11 usuarios)

```
mariaelena.gonzalez@hotmail.com
robertocarlos.martinez@gmail.com
anapaula.fernandez@yahoo.com
juanmanuel.lopez@outlook.com
silviaraquel.rodriguez@gmail.com
carlosalberto.sanchez@hotmail.com
juancarlos.perez@gmail.com
roberto.martinez@outlook.com
ana.rodriguez@yahoo.com
carlos.fernandez@gmail.com
laura.lopez@gmail.com
```

### Operarios (6 usuarios)

```
pedro.electricista@cooperativa-ugarte.com.ar
juan.operario@cooperativa-ugarte.com.ar
luis.tecnico@cooperativa-ugarte.com.ar
ana.supervisora@cooperativa-ugarte.com.ar
carmen.atencion@cooperativa-ugarte.com.ar
daniel.emergencias@cooperativa-ugarte.com.ar
```

### Administradores (2 usuarios)

```
monica.administradora@cooperativa-ugarte.com.ar
carlos.admin@cooperativa-ugarte.com.ar
```

---

## Consultas SQL Utiles

### Ver todos los usuarios

```sql
SELECT u.email, r.nombre_rol, s.nombre, s.apellido
FROM usuarios u
JOIN roles r ON u.rol_id = r.rol_id
LEFT JOIN socios s ON u.socio_id = s.socio_id
ORDER BY r.nombre_rol, u.email;
```

### Ver facturas de un socio

```sql
SELECT f.numero_factura, f.fecha_emision, f.fecha_vencimiento, 
       f.monto_total, f.pagada
FROM facturas f
WHERE f.socio_id = 1
ORDER BY f.fecha_emision DESC;
```

### Ver reclamos pendientes

```sql
SELECT r.reclamo_id, s.nombre, s.apellido, r.descripcion, 
       e.nombre_estado, r.fecha_reclamo
FROM reclamos r
JOIN socios s ON r.socio_id = s.socio_id
JOIN estados_reclamo e ON r.estado_id = e.estado_id
WHERE e.nombre_estado != 'Resuelto'
ORDER BY r.fecha_reclamo DESC;
```

### Ver consumo mensual

```sql
SELECT s.nombre, s.apellido, l.fecha_lectura, 
       l.lectura_actual, l.lectura_anterior,
       (l.lectura_actual - l.lectura_anterior) as consumo_kwh
FROM lecturas l
JOIN medidores m ON l.medidor_id = m.medidor_id
JOIN socios s ON m.socio_id = s.socio_id
ORDER BY l.fecha_lectura DESC;
```

### Dashboard de cliente (funcion)

```sql
SELECT * FROM dashboard_cliente(1);
```

### Facturas de cliente (funcion)

```sql
SELECT * FROM facturas_cliente(1);
```

---

## Desarrollo

### Estructura de Scripts

Todos los scripts SQL estan en la carpeta `scripts/`:

```
scripts/
  01-schema.sql           # Definicion de tablas, roles, funciones
  02-procedimientos.sql   # Stored procedures
  03-vistas.sql          # Vistas optimizadas (si existen)
  04-datos-prueba.sql    # Datos de ejemplo
  05-usuarios.sql        # Usuarios con autenticacion
```

### Orden de Ejecucion

Los scripts se ejecutan automaticamente en orden numerico cuando se construye la imagen Docker:

1. **01-schema.sql** - Crea estructura completa
2. **02-procedimientos.sql** - Funciones y procedimientos
3. **04-datos-prueba.sql** - Datos de prueba (socios, facturas, reclamos, etc.)
4. **05-usuarios.sql** - Usuarios con hashes bcrypt

### Desarrollo Local con Docker Compose

Si quieres desarrollo local con volumenes:

```bash
docker-compose up -d
```

El archivo `docker-compose.yml` incluye:
- Mapeo de puerto 5432
- Volumenes para persistencia
- Variables de entorno

---

## Comandos Avanzados

### Backup

```bash
# Backup completo
docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

# Backup solo schema
docker exec cooperativa-db pg_dump -U coop_user -s cooperativa_ugarte_db > schema.sql

# Backup solo datos
docker exec cooperativa-db pg_dump -U coop_user -a cooperativa_ugarte_db > datos.sql
```

### Restaurar

```bash
# Restaurar desde backup
docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql
```

### Ver logs

```bash
# Ver logs en tiempo real
docker logs -f cooperativa-db

# Ver ultimas 100 lineas
docker logs --tail 100 cooperativa-db
```

### Reiniciar contenedor

```bash
# Detener y eliminar contenedor
docker stop cooperativa-db
docker rm cooperativa-db

# Crear nuevo contenedor
docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest
```

### Limpiar todo (incluye volumenes)

```bash
docker-compose down -v
```

---

## Notas Tecnicas

### Hashes de Contrasenas

Los hashes bcrypt se generaron con el siguiente script Node.js:

```javascript
const bcrypt = require('bcrypt');
bcrypt.hash('password123', 10, (err, hash) => {
  if (err) throw err;
  console.log(hash);
});
```

Resultado: `$2b$10$WRl0heuhm34IuEWqZWkyF.B6kpWQZ12tiOMZlFQtvbD2DL38lnswG`

**Importante:** Estos son hashes de prueba. En produccion, cada usuario debe tener su propio hash unico.

### Diferencia entre Hash y Contrasena

- **Contrasena (plaintext):** `password123` - Lo que ingresa el usuario
- **Hash (bcrypt):** `$2b$10$WRl...` - Lo que se guarda en la base de datos

Bcrypt es un algoritmo one-way: no se puede revertir el hash para obtener la contrasena original.

---

## Proyecto

**Institucion:** IFTS N° 29  
**Materia:** Practicas Profesionales IV  
**Ano:** 2025  
**Descripcion:** Sistema de gestion para cooperativa electrica de la PPIV

**Docker Hub:** [damian2k/cooperativa-ugarte-db](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)  
**GitHub:** [damianclausi/cooperativa-ugarte-db](https://github.com/damianclausi/cooperativa-ugarte-db)
