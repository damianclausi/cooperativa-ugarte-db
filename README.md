# Cooperativa Eléctrica "Gobernador Ugarte" - Base de Datos# 🏢 Cooperativa Eléctrica "Gobernador Ugarte" - Base de Datos# Cooperativa Eléctrica "Gobernador Ugarte"



Base de datos PostgreSQL completa y lista para usar, diseñada específicamente para sistemas de gestión de cooperativas eléctricas.



**Proyecto académico:** Prácticas Profesionales IV - IFTS N° 29Base de datos PostgreSQL completa y lista para usar, diseñada específicamente para sistemas de gestión de cooperativas eléctricas.Base de datos PostgreSQL completa para gestión de cooperativa eléctrica con Docker.



[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)

> 🎓 **Proyecto académico:** Prácticas Profesionales IV - IFTS N° 29[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

## Características



- Schema completo con 22 tablas interrelacionadas

- Sistema de autenticación con bcrypt y 3 roles (Cliente, Operario, Admin)[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)## Inicio Rápido

- 19 usuarios de prueba listos para testing

- Funciones especializadas para cooperativas eléctricas[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)

- Vistas optimizadas para consultas complejas

- Datos de ejemplo realistas (socios, facturas, reclamos, órdenes de trabajo)### Usando Docker Hub (Recomendado)

- Docker ready - ejecutar en segundos

## ✨ Características

## Inicio Rápido

```bash

### Opción 1: Docker Run

- ✅ **Schema completo** con 22 tablas interrelacionadas# Solo base de datos

```bash

docker run -d \- ✅ **Sistema de autenticación** con bcrypt y 3 roles (Cliente, Operario, Admin)docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest

  --name cooperativa-db \

  -p 5432:5432 \- ✅ **19 usuarios de prueba** listos para testing

  damian2k/cooperativa-ugarte-db:latest

```- ✅ **Funciones especializadas** para cooperativas eléctricas# Con pgAdmin



### Opción 2: Docker Compose- ✅ **Vistas optimizadas** para consultas complejasdocker run -d --name cooperativa-pgadmin -p 8080:80 \



```bash- ✅ **Datos de ejemplo** realistas (socios, facturas, reclamos, órdenes de trabajo)  -e PGADMIN_DEFAULT_EMAIL=admin@cooperativa.com.ar \

git clone https://github.com/damianclausi/cooperativa-ugarte-db.git

cd cooperativa-ugarte-db- ✅ **Docker ready** - ejecutar en segundos  -e PGADMIN_DEFAULT_PASSWORD=admin123 \

docker-compose up -d

```  dpage/pgadmin4:latest



## Credenciales## 🚀 Inicio Rápido```



### PostgreSQL

```

Host:     localhost### Opción 1: Docker Run (Más simple)### Usando Docker Compose

Puerto:   5432

Usuario:  coop_user

Password: cooperativa2024

Database: cooperativa_ugarte_db```bash```bash

```

docker run -d \git clone https://github.com/damianclausi/cooperativa-ugarte-db.git

### Conexión Rápida

```bash  --name cooperativa-db \cd cooperativa-ugarte-db

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

```  -p 5432:5432 \docker-compose up -d



### String de Conexión  damian2k/cooperativa-ugarte-db:latest```

```

postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_db```

```

## Credenciales

## Usuarios de Prueba

### Opción 2: Docker Compose (Recomendado)

Todos los usuarios tienen la contraseña: **`password123`**

### Base de Datos PostgreSQL

### Clientes (11 usuarios)

``````bash- **Host:** `localhost:5432`

mariaelena.gonzalez@hotmail.com

robertocarlos.martinez@gmail.comgit clone https://github.com/damianclausi/cooperativa-ugarte-db.git- **Database:** `cooperativa_ugarte_db`

anapaula.fernandez@yahoo.com

juanmanuel.lopez@outlook.comcd cooperativa-ugarte-db- **Usuario:** `coop_user`

silviaraquel.rodriguez@gmail.com

carlosalberto.sanchez@hotmail.comdocker-compose up -d- **Contraseña:** `cooperativa2024`

juancarlos.perez@gmail.com

roberto.martinez@outlook.com```

ana.rodriguez@yahoo.com

carlos.fernandez@gmail.com### pgAdmin (http://localhost:8080)

laura.lopez@gmail.com

```## 🔐 Credenciales- **Email:** `admin@cooperativa-ugarte.com.ar`



### Operarios (6 usuarios)- **Contraseña:** `admin123`

```

pedro.electricista@cooperativa-ugarte.com.ar### PostgreSQL

juan.operario@cooperativa-ugarte.com.ar

luis.tecnico@cooperativa-ugarte.com.ar```## Datos Incluidos

ana.supervisora@cooperativa-ugarte.com.ar

carmen.atencion@cooperativa-ugarte.com.arHost:     localhost

daniel.emergencias@cooperativa-ugarte.com.ar

```Puerto:   5432- **12 Socios** con datos realistas



### Administradores (2 usuarios)Usuario:  coop_user- **15 Facturas** de diferentes períodos

```

monica.administradora@cooperativa-ugarte.com.arPassword: cooperativa2024- **10 Reclamos** en varios estados

carlos.admin@cooperativa-ugarte.com.ar

```Database: cooperativa_ugarte_db- **Servicios** típicos de cooperativa eléctrica



## Datos Incluidos```- **Funciones personalizadas** como `dashboard_cliente()`



| Entidad | Cantidad | Descripción |

|---------|----------|-------------|

| Socios | 12 | Clientes con datos realistas |### Conexión Rápida## Consultas de Ejemplo

| Cuentas | 12 | Una por socio |

| Medidores | 10 | Medidores eléctricos instalados |```bash

| Lecturas | 30 | Historial de lecturas |

| Facturas | 15 | Facturas en diferentes estados |docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db```sql

| Reclamos | 10 | Reclamos de diferentes tipos |

| Órdenes de Trabajo | 10 | OTs asignadas a empleados |```-- Verificar datos

| Empleados | 10 | Personal de la cooperativa |

| Usuarios | 19 | Sistema de autenticación completo |SELECT COUNT(*) FROM socio;



## Estructura de la Base de Datos### String de Conexión



### Módulos Principales```-- Dashboard de cliente



**Gestión de Socios**postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_dbSELECT dashboard_cliente(1);

- Socios, cuentas, medidores, lecturas

```

**Facturación**

- Facturas, pagos, conceptos, servicios-- Facturas pendientes



**Gestión Operativa**## 👥 Usuarios de PruebaSELECT * FROM factura WHERE estado = 'PENDIENTE';

- Reclamos, órdenes de trabajo, empleados, cuadrillas



**Autenticación**

- Usuarios, roles (CLIENTE, OPERARIO, ADMIN), permisosTodos los usuarios usan la contraseña: **`password123`**-- Reclamos activos



### Funciones y VistasSELECT * FROM v_reclamos_completos 



La base de datos incluye funciones especializadas y vistas optimizadas. Para detalles completos y ejemplos de uso, consulta la [Guía de Desarrollo](DEVELOPMENT.md).### 🔵 Clientes (11 usuarios)WHERE estado IN ('NUEVO', 'EN_PROCESO');



## Comandos Útiles``````



### Backupmariaelena.gonzalez@hotmail.com

```bash

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sqlrobertocarlos.martinez@gmail.com## Estructura

```

anapaula.fernandez@yahoo.com

### Restaurar

```bashjuanmanuel.lopez@outlook.com### Tablas Principales

docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

```silviaraquel.rodriguez@gmail.com- `socio`, `cuenta`, `factura`, `reclamo`



### Ver logscarlosalberto.sanchez@hotmail.com- `medidor`, `lectura`, `orden_trabajo`

```bash

docker logs cooperativa-dbjuancarlos.perez@gmail.com- `empleado`, `servicio`, `material`

```

roberto.martinez@outlook.com

### Reiniciar limpio

```bashana.rodriguez@yahoo.com### Funciones Personalizadas

docker-compose down -v

docker-compose up -dcarlos.fernandez@gmail.com- `dashboard_cliente(socio_id)` → Dashboard JSON

```

laura.lopez@gmail.com- `facturas_cliente(socio_id)` → Historial

## Docker Hub

```- `crear_nueva_cuenta()` → Gestión de cuentas

**Imagen:** [damian2k/cooperativa-ugarte-db](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)



**Tags disponibles:**

- `latest` - Última versión estable (v1.3)### 🔧 Operarios (6 usuarios)### Vistas Especializadas

- `1.3` - Sistema de autenticación con 3 roles y nombres de archivos descriptivos

- `1.2` - Funciones optimizadas```- `v_cuentas_completas`

- `1.1` - Datos de prueba mejorados

- `1.0` - Primera versión establepedro.electricista@cooperativa-ugarte.com.ar- `v_reclamos_completos`



**Tamaño:** ~399 MB  juan.operario@cooperativa-ugarte.com.ar- `v_ordenes_trabajo_completas`

**Base:** PostgreSQL 15-alpine

luis.tecnico@cooperativa-ugarte.com.ar

## Para Desarrolladores

ana.supervisora@cooperativa-ugarte.com.ar## Configuración pgAdmin

¿Necesitas modificar o extender la base de datos? Consulta la [Guía de Desarrollo](DEVELOPMENT.md) para:

- Ejemplos de consultas SQLcarmen.atencion@cooperativa-ugarte.com.ar

- Workflow de desarrollo

- Generación de hashes bcryptdaniel.emergencias@cooperativa-ugarte.com.ar1. Ir a http://localhost:8080

- Debugging y troubleshooting

- Convenciones de código```2. Login con las credenciales de pgAdmin



## Estructura del Proyecto3. Agregar servidor:



```### 👑 Administradores (2 usuarios)   - **Host:** `postgres` (en Docker) o `localhost`

cooperativa-ugarte-db/

├── Dockerfile```   - **Port:** `5432`

├── docker-compose.yml

├── 01-schema.sql                   # Schema completo (tablas, índices, triggers)monica.administradora@cooperativa-ugarte.com.ar   - **Database:** `cooperativa_ugarte_db`

├── scripts/

│   ├── 02-procedimientos.sql       # Funciones almacenadascarlos.admin@cooperativa-ugarte.com.ar   - **User:** `coop_user`

│   ├── 03-consultas.sql            # Consultas especializadas

│   ├── 04-datos-prueba.sql         # Datos de ejemplo```   - **Password:** `cooperativa2024`

│   ├── 05-usuarios.sql             # Sistema de autenticación

│   └── generate_hash.js            # Helper bcrypt

├── README.md

└── DEVELOPMENT.md## 📊 Datos Incluidos## Docker Hub

```



## Solución de Problemas

| Entidad | Cantidad | Descripción |**Imagen:** `damian2k/cooperativa-ugarte-db`  

### Puerto 5432 ocupado

```bash|---------|----------|-------------|**Tags:** `latest`, `1.2`, `1.1`, `1.0`  

docker run -d -p 5433:5432 damian2k/cooperativa-ugarte-db:latest

```| **Socios** | 12 | Clientes con datos realistas |**Tamaño:** ~399MB  



### Base de datos no inicia| **Cuentas** | 12 | Una por socio |**Base:** PostgreSQL 15-alpine

```bash

docker logs cooperativa-db| **Medidores** | 10 | Medidores eléctricos instalados |

docker-compose down -v

docker-compose up -d| **Lecturas** | 30 | Historial de lecturas |## Comandos Útiles

```

| **Facturas** | 15 | Facturas en diferentes estados |

## Contexto

| **Reclamos** | 10 | Reclamos de diferentes tipos |```bash

### Cooperativa

- **Ubicación:** Gobernador Ugarte, Buenos Aires, Argentina| **Órdenes de Trabajo** | 10 | OTs asignadas a empleados |# Ver logs

- **Código de área:** 2226

- **Timezone:** America/Argentina/Buenos_Aires| **Empleados** | 10 | Personal de la cooperativa |docker logs cooperativa-db

- **Moneda:** Pesos argentinos (ARS)

| **Usuarios** | 19 | Sistema de autenticación completo |

### Proyecto Académico

- **Institución:** IFTS N° 29 (Instituto de Formación Técnica Superior N° 29)# Conectar por terminal

- **Materia:** Prácticas Profesionales IV (PPIV)

- **Objetivo:** Sistema integral de gestión para cooperativa eléctrica## 🗂️ Estructura de la Base de Datosdocker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

- **Estudiante:** Damián Clausi

- **Año:** 2025



## Contribuir### Módulos Principales# Backup



1. Fork el proyectodocker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

2. Crea una rama (`git checkout -b feature/NuevaCaracteristica`)

3. Commit tus cambios (`git commit -m 'Agrega nueva característica'`)**🔹 Gestión de Socios**

4. Push a la rama (`git push origin feature/NuevaCaracteristica`)

5. Abre un Pull Request- Socios, cuentas, medidores, lecturas# Restaurar



## Licenciadocker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql



Este proyecto está bajo la Licencia MIT.**🔹 Facturación**```



---- Facturas, pagos, conceptos, servicios



**Si este proyecto te resulta útil, considera darle una estrella en GitHub**## Solución de Problemas


**🔹 Gestión Operativa**

- Reclamos, órdenes de trabajo, empleados, cuadrillas### Puerto ocupado

```bash

**🔹 Autenticación**# Usar puerto alternativo

- Usuarios, roles (CLIENTE, OPERARIO, ADMIN), permisosdocker run -d -p 5433:5432 damian2k/cooperativa-ugarte-db:latest

```

### Funciones y Vistas

### Reiniciar limpio

La base de datos incluye funciones especializadas y vistas optimizadas. Para detalles completos y ejemplos de uso, consulta la [Guía de Desarrollo](DEVELOPMENT.md).```bash

docker-compose down -v

## 🛠️ Comandos Útilesdocker-compose up -d

```

### Backup

```bash## Contexto

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

```**Ubicación:** Gobernador Ugarte, Buenos Aires, Argentina  

**Código de área:** 2226  

### Restaurar**Timezone:** America/Argentina/Buenos_Aires  

```bash**Moneda:** Pesos argentinos (ARS)

docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

```---



### Ver logs**Desarrollado para sistemas de gestión de cooperativa eléctrica - PPIV.**

```bash
docker logs cooperativa-db
```

### Reiniciar limpio
```bash
docker-compose down -v
docker-compose up -d
```

## 🐳 Docker Hub

**Imagen:** [`damian2k/cooperativa-ugarte-db`](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

**Tags disponibles:**
- `latest` - Última versión estable (v1.3)
- `1.3` - Sistema de autenticación con 3 roles
- `1.2` - Funciones optimizadas
- `1.1` - Datos de prueba mejorados
- `1.0` - Primera versión estable

**Tamaño:** ~399 MB  
**Base:** PostgreSQL 15-alpine

## 🔧 Para Desarrolladores

¿Necesitas modificar o extender la base de datos? Consulta la [Guía de Desarrollo](DEVELOPMENT.md) para:
- Ejemplos de consultas SQL
- Workflow de desarrollo
- Generación de hashes bcrypt
- Debugging y troubleshooting
- Convenciones de código

## 📁 Estructura del Proyecto

```
cooperativa-ugarte-db/
├── Dockerfile                      # Imagen Docker
├── docker-compose.yml              # Orquestación
├── 01-schema.sql                   # Schema completo (tablas, índices, triggers)
├── scripts/
│   ├── 02-procedimientos.sql       # Funciones almacenadas
│   ├── 03-consultas.sql            # Consultas especializadas
│   ├── 04-datos-prueba.sql         # Datos de ejemplo
│   ├── 05-usuarios.sql             # Sistema de autenticación
│   └── generate_hash.js            # Helper bcrypt
├── README.md                       # Este archivo
└── DEVELOPMENT.md                  # Guía para desarrolladores
```

## ⚠️ Solución de Problemas

### Puerto 5432 ocupado
```bash
docker run -d -p 5433:5432 damian2k/cooperativa-ugarte-db:latest
```

### Base de datos no inicia
```bash
docker logs cooperativa-db
docker-compose down -v
docker-compose up -d
```

## 📍 Contexto

### Cooperativa
**Ubicación:** Gobernador Ugarte, Buenos Aires, Argentina  
**Código de área:** 2226  
**Timezone:** America/Argentina/Buenos_Aires  
**Moneda:** Pesos argentinos (ARS)

### Proyecto Académico
**Institución:** IFTS N° 29 (Instituto de Formación Técnica Superior N° 29)  
**Materia:** Prácticas Profesionales IV (PPIV)  
**Objetivo:** Sistema integral de gestión para cooperativa eléctrica  
**Estudiante:** Damián Clausi  
**Año:** 2025

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/MejoraMavillosa`)
3. Commit tus cambios (`git commit -m 'Agrega característica X'`)
4. Push a la rama (`git push origin feature/MejoraMavillosa`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

---

⭐ **Si este proyecto te resulta útil, considera darle una estrella en GitHub**
