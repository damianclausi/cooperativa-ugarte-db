# Cooperativa Eléctrica "Gobernador Ugarte"# Cooperativa Eléctrica "Gobernador Ugarte"# Cooperativa Eléctrica "Gobernador Ugarte"# Cooperativa Eléctrica "Gobernador Ugarte" - Base de Datos# 🏢 Cooperativa Eléctrica "Gobernador Ugarte" - Base de Datos# Cooperativa Eléctrica "Gobernador Ugarte"



Base de datos PostgreSQL para el sistema de gestión de cooperativa eléctrica de la PPIV.



[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)Base de datos PostgreSQL lista para usar para sistemas de gestión de cooperativas eléctricas.

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)



> Proyecto académico - Prácticas Profesionales IV - IFTS N° 29

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)Base de datos PostgreSQL completa y lista para usar, diseñada específicamente para sistemas de gestión de cooperativas eléctricas.

---

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)

## Inicio Rápido



```bash

docker run -d \> Proyecto académico - Prácticas Profesionales IV - IFTS N° 29

  --name cooperativa-db \

  -p 5432:5432 \[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)Base de datos PostgreSQL completa y lista para usar, diseñada específicamente para sistemas de gestión de cooperativas eléctricas.

  damian2k/cooperativa-ugarte-db:latest

```---



La base de datos está lista con datos de prueba.[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)



---## Inicio Rápido



## Credenciales



``````bash

Host:     localhost:5432

Database: cooperativa_ugarte_dbdocker run -d \> **Proyecto académico:** Prácticas Profesionales IV - IFTS N° 29

Usuario:  coop_user

Password: cooperativa2024  --name cooperativa-db \

```

  -p 5432:5432 \**Proyecto académico:** Prácticas Profesionales IV - IFTS N° 29Base de datos PostgreSQL completa y lista para usar, diseñada específicamente para sistemas de gestión de cooperativas eléctricas.Base de datos PostgreSQL completa para gestión de cooperativa eléctrica con Docker.

### Conectar

  damian2k/cooperativa-ugarte-db:latest

```bash

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db```---

```



### String de conexión

**Listo!** La base de datos está corriendo con datos de prueba.

```

postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_db

```

---## Características

---



## Usuarios de Prueba

## Credenciales[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

Todos usan la contraseña: **`password123`**



### Clientes (11 usuarios)

``````- **Schema completo** con 22 tablas interrelacionadas

mariaelena.gonzalez@hotmail.com

robertocarlos.martinez@gmail.comHost:     localhost:5432

anapaula.fernandez@yahoo.com

juanmanuel.lopez@outlook.comDatabase: cooperativa_ugarte_db- **Sistema de autenticación** con bcrypt y 3 roles (Cliente, Operario, Admin)[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)

silviaraquel.rodriguez@gmail.com

carlosalberto.sanchez@hotmail.comUsuario:  coop_user

juancarlos.perez@gmail.com

roberto.martinez@outlook.comPassword: cooperativa2024- **19 usuarios de prueba** listos para testing

ana.rodriguez@yahoo.com

carlos.fernandez@gmail.com```

laura.lopez@gmail.com

```- **Funciones especializadas** para cooperativas eléctricas> 🎓 **Proyecto académico:** Prácticas Profesionales IV - IFTS N° 29[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)



### Operarios (6 usuarios)### Conectar

```

pedro.electricista@cooperativa-ugarte.com.ar- **Vistas optimizadas** para consultas complejas

juan.operario@cooperativa-ugarte.com.ar

luis.tecnico@cooperativa-ugarte.com.ar```bash

ana.supervisora@cooperativa-ugarte.com.ar

carmen.atencion@cooperativa-ugarte.com.ardocker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db- **Datos de ejemplo** realistas (socios, facturas, reclamos, órdenes de trabajo)## Características

daniel.emergencias@cooperativa-ugarte.com.ar

``````



### Administradores (2 usuarios)- **Docker ready** - ejecutar en segundos

```

monica.administradora@cooperativa-ugarte.com.ar### String de conexión

carlos.admin@cooperativa-ugarte.com.ar

```



---```



## Que Incluyepostgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_db---



- 22 tablas (socios, facturas, reclamos, medidores, etc.)```

- 3 roles: CLIENTE, OPERARIO, ADMIN

- 19 usuarios de prueba- Schema completo con 22 tablas interrelacionadas

- Datos de ejemplo: 12 socios, 15 facturas, 10 reclamos, 10 órdenes de trabajo

- Funciones especializadas: `dashboard_cliente()`, `facturas_cliente()`, etc.---



---## Inicio Rápido



## Comandos Útiles## Usuarios de Prueba



### Backup- Sistema de autenticación con bcrypt y 3 roles (Cliente, Operario, Admin)[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-damian2k%2Fcooperativa--ugarte--db-blue)](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)## Inicio Rápido

```bash

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sqlTodos usan la contraseña: **`password123`**

```

### Opción 1: Docker Run (Más simple)

### Restaurar

```bash### Clientes (11 usuarios)

docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

``````- 19 usuarios de prueba listos para testing



### Ver logsmariaelena.gonzalez@hotmail.com

```bash

docker logs cooperativa-dbrobertocarlos.martinez@gmail.com```bash

```

anapaula.fernandez@yahoo.com

### Reiniciar

```bashjuanmanuel.lopez@outlook.comdocker run -d \- Funciones especializadas para cooperativas eléctricas[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-336791?logo=postgresql)](https://www.postgresql.org/)

docker stop cooperativa-db && docker rm cooperativa-db

docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latestsilviaraquel.rodriguez@gmail.com

```

carlosalberto.sanchez@hotmail.com  --name cooperativa-db \

---

juancarlos.perez@gmail.com

## Documentación Completa

roberto.martinez@outlook.com  -p 5432:5432 \- Vistas optimizadas para consultas complejas

Para detalles técnicos, consultas SQL, desarrollo y más información:

ana.rodriguez@yahoo.com

**[Ver DOCUMENTATION.md](DOCUMENTATION.md)**

carlos.fernandez@gmail.com  damian2k/cooperativa-ugarte-db:latest

---

laura.lopez@gmail.com

## Proyecto Académico

``````- Datos de ejemplo realistas (socios, facturas, reclamos, órdenes de trabajo)### Usando Docker Hub (Recomendado)

**IFTS N° 29** - Prácticas Profesionales IV  

**Estudiante:** Damián Clausi  

**Año:** 2025

### Operarios (6 usuarios)

---

```

## Licencia

pedro.electricista@cooperativa-ugarte.com.ar### Opción 2: Docker Compose (Recomendado)- Docker ready - ejecutar en segundos

MIT License

juan.operario@cooperativa-ugarte.com.ar

luis.tecnico@cooperativa-ugarte.com.ar

ana.supervisora@cooperativa-ugarte.com.ar

carmen.atencion@cooperativa-ugarte.com.ar```bash## ✨ Características

daniel.emergencias@cooperativa-ugarte.com.ar

```git clone https://github.com/damianclausi/cooperativa-ugarte-db.git



### Administradores (2 usuarios)cd cooperativa-ugarte-db## Inicio Rápido

```

monica.administradora@cooperativa-ugarte.com.ardocker-compose up -d

carlos.admin@cooperativa-ugarte.com.ar

`````````bash



---



## Que Incluye---### Opción 1: Docker Run



- 22 tablas (socios, facturas, reclamos, medidores, etc.)

- 3 roles: CLIENTE, OPERARIO, ADMIN

- 19 usuarios de prueba## Credenciales- ✅ **Schema completo** con 22 tablas interrelacionadas# Solo base de datos

- Datos de ejemplo: 12 socios, 15 facturas, 10 reclamos, 10 órdenes de trabajo

- Funciones especializadas: `dashboard_cliente()`, `facturas_cliente()`, etc.



---### Base de Datos PostgreSQL```bash



## Comandos Útiles



### Backup```docker run -d \- ✅ **Sistema de autenticación** con bcrypt y 3 roles (Cliente, Operario, Admin)docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest

```bash

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sqlHost:     localhost

```

Puerto:   5432  --name cooperativa-db \

### Restaurar

```bashUsuario:  coop_user

docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

```Password: cooperativa2024  -p 5432:5432 \- ✅ **19 usuarios de prueba** listos para testing



### Ver logsDatabase: cooperativa_ugarte_db

```bash

docker logs cooperativa-db```  damian2k/cooperativa-ugarte-db:latest

```



### Reiniciar

```bash### Conexión Rápida```- ✅ **Funciones especializadas** para cooperativas eléctricas# Con pgAdmin

docker stop cooperativa-db && docker rm cooperativa-db

docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest

```

```bash

---

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

## Documentación Completa

```### Opción 2: Docker Compose- ✅ **Vistas optimizadas** para consultas complejasdocker run -d --name cooperativa-pgadmin -p 8080:80 \

Para detalles técnicos, consultas SQL, desarrollo y más información:



**[Ver DOCUMENTATION.md](DOCUMENTATION.md)**

### String de Conexión

---



## Docker Hub

``````bash- ✅ **Datos de ejemplo** realistas (socios, facturas, reclamos, órdenes de trabajo)  -e PGADMIN_DEFAULT_EMAIL=admin@cooperativa.com.ar \

**Imagen:** `damian2k/cooperativa-ugarte-db`  

**Tags:** `latest`, `1.4`, `1.3`, `1.2`, `1.1`, `1.0`postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_db



---```git clone https://github.com/damianclausi/cooperativa-ugarte-db.git



## Proyecto Académico



**IFTS N° 29** - Prácticas Profesionales IV  ---cd cooperativa-ugarte-db- ✅ **Docker ready** - ejecutar en segundos  -e PGADMIN_DEFAULT_PASSWORD=admin123 \

**Estudiante:** Damián Clausi  

**Año:** 2025



---## Usuarios de Pruebadocker-compose up -d



## Licencia



MIT LicenseTodos los usuarios usan la contraseña: **`password123`**```  dpage/pgadmin4:latest




### Clientes (11 usuarios)



```## Credenciales## 🚀 Inicio Rápido```

mariaelena.gonzalez@hotmail.com

robertocarlos.martinez@gmail.com

anapaula.fernandez@yahoo.com

juanmanuel.lopez@outlook.com### PostgreSQL

silviaraquel.rodriguez@gmail.com

carlosalberto.sanchez@hotmail.com```

juancarlos.perez@gmail.com

roberto.martinez@outlook.comHost:     localhost### Opción 1: Docker Run (Más simple)### Usando Docker Compose

ana.rodriguez@yahoo.com

carlos.fernandez@gmail.comPuerto:   5432

laura.lopez@gmail.com

```Usuario:  coop_user



### Operarios (6 usuarios)Password: cooperativa2024



```Database: cooperativa_ugarte_db```bash```bash

pedro.electricista@cooperativa-ugarte.com.ar

juan.operario@cooperativa-ugarte.com.ar```

luis.tecnico@cooperativa-ugarte.com.ar

ana.supervisora@cooperativa-ugarte.com.ardocker run -d \git clone https://github.com/damianclausi/cooperativa-ugarte-db.git

carmen.atencion@cooperativa-ugarte.com.ar

daniel.emergencias@cooperativa-ugarte.com.ar### Conexión Rápida

```

```bash  --name cooperativa-db \cd cooperativa-ugarte-db

### Administradores (2 usuarios)

docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db

```

monica.administradora@cooperativa-ugarte.com.ar```  -p 5432:5432 \docker-compose up -d

carlos.admin@cooperativa-ugarte.com.ar

```



---### String de Conexión  damian2k/cooperativa-ugarte-db:latest```



## Entendiendo Password vs Hash```



### ¿Qué es un hash bcrypt?postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_db```



**Contraseña en texto plano** (lo que escribe el usuario):```

```

password123## Credenciales

```

## Usuarios de Prueba

**Hash bcrypt** (lo que se guarda en la base de datos):

```### Opción 2: Docker Compose (Recomendado)

$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi

```Todos los usuarios tienen la contraseña: **`password123`**



### ¿Por qué son diferentes?### Base de Datos PostgreSQL



- **Seguridad**: NUNCA guardamos contraseñas en texto plano en la base de datos### Clientes (11 usuarios)

- **Bcrypt**: Es un algoritmo de encriptación unidireccional (no se puede revertir)

- **Validación**: Al hacer login, bcrypt compara la contraseña ingresada con el hash``````bash- **Host:** `localhost:5432`



### Ejemplo de flujo:mariaelena.gonzalez@hotmail.com



```robertocarlos.martinez@gmail.comgit clone https://github.com/damianclausi/cooperativa-ugarte-db.git- **Database:** `cooperativa_ugarte_db`

1. Usuario se registra:

   - Escribe: "password123"anapaula.fernandez@yahoo.com

   - Backend genera hash: "$2b$10$92IXU..."

   - DB guarda: "$2b$10$92IXU..."juanmanuel.lopez@outlook.comcd cooperativa-ugarte-db- **Usuario:** `coop_user`



2. Usuario hace login:silviaraquel.rodriguez@gmail.com

   - Escribe: "password123"

   - Backend ejecuta: bcrypt.compare("password123", "$2b$10$92IXU...")carlosalberto.sanchez@hotmail.comdocker-compose up -d- **Contraseña:** `cooperativa2024`

   - Si coincide: Login exitoso

   - Si no coincide: Credenciales inválidasjuancarlos.perez@gmail.com

```

roberto.martinez@outlook.com```

### Importante:

ana.rodriguez@yahoo.com

- **Mismo password = Diferentes hashes**: Cada vez que encriptas `password123` obtienes un hash diferente (esto es normal y correcto en bcrypt)

- **Todos validan igual**: Aunque los hashes sean diferentes, todos validan correctamente contra `password123`carlos.fernandez@gmail.com### pgAdmin (http://localhost:8080)

- **NO uses hashes de ejemplo**: `$2b$10$example_hash_...` NO es un hash válido, NO funcionará con bcrypt

laura.lopez@gmail.com

---

```## 🔐 Credenciales- **Email:** `admin@cooperativa-ugarte.com.ar`

## Datos Incluidos



| Entidad | Cantidad | Descripción |

|---------|----------|-------------|### Operarios (6 usuarios)- **Contraseña:** `admin123`

| **Socios** | 12 | Clientes con datos realistas |

| **Cuentas** | 12 | Una por socio |```

| **Medidores** | 10 | Medidores eléctricos instalados |

| **Lecturas** | 30 | Historial de lecturas |pedro.electricista@cooperativa-ugarte.com.ar### PostgreSQL

| **Facturas** | 15 | Facturas en diferentes estados |

| **Pagos** | 10 | Pagos registrados |juan.operario@cooperativa-ugarte.com.ar

| **Reclamos** | 10 | Reclamos de diferentes tipos |

| **Órdenes de Trabajo** | 10 | OTs asignadas a empleados |luis.tecnico@cooperativa-ugarte.com.ar```## Datos Incluidos

| **Empleados** | 10 | Personal de la cooperativa |

| **Usuarios** | 19 | Sistema de autenticación completo |ana.supervisora@cooperativa-ugarte.com.ar



---carmen.atencion@cooperativa-ugarte.com.arHost:     localhost



## Estructuradaniel.emergencias@cooperativa-ugarte.com.ar



### Tablas Principales```Puerto:   5432- **12 Socios** con datos realistas



- `socio`, `cuenta`, `factura`, `reclamo`

- `medidor`, `lectura`, `orden_trabajo`

- `empleado`, `servicio`, `material`### Administradores (2 usuarios)Usuario:  coop_user- **15 Facturas** de diferentes períodos

- `usuario`, `rol`, `usuario_rol`

```

### Funciones Personalizadas

monica.administradora@cooperativa-ugarte.com.arPassword: cooperativa2024- **10 Reclamos** en varios estados

- `dashboard_cliente(socio_id)` → Dashboard JSON

- `facturas_cliente(socio_id)` → Historialcarlos.admin@cooperativa-ugarte.com.ar

- `crear_nueva_cuenta()` → Gestión de cuentas

- `crear_usuario_sistema()` → Autenticación```Database: cooperativa_ugarte_db- **Servicios** típicos de cooperativa eléctrica



### Vistas Especializadas



- `v_cuentas_completas`## Datos Incluidos```- **Funciones personalizadas** como `dashboard_cliente()`

- `v_reclamos_completos`

- `v_ordenes_trabajo_completas`

- `v_usuarios_completos`

| Entidad | Cantidad | Descripción |

---

|---------|----------|-------------|

## Consultas de Ejemplo

| Socios | 12 | Clientes con datos realistas |### Conexión Rápida## Consultas de Ejemplo

```sql

-- Verificar datos| Cuentas | 12 | Una por socio |

SELECT COUNT(*) FROM socio;

| Medidores | 10 | Medidores eléctricos instalados |```bash

-- Dashboard de cliente

SELECT dashboard_cliente(1);| Lecturas | 30 | Historial de lecturas |



-- Facturas pendientes| Facturas | 15 | Facturas en diferentes estados |docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db```sql

SELECT * FROM factura WHERE estado = 'PENDIENTE';

| Reclamos | 10 | Reclamos de diferentes tipos |

-- Reclamos activos

SELECT * FROM v_reclamos_completos | Órdenes de Trabajo | 10 | OTs asignadas a empleados |```-- Verificar datos

WHERE estado IN ('NUEVO', 'EN_PROCESO');

| Empleados | 10 | Personal de la cooperativa |

-- Ver todos los usuarios por rol

SELECT | Usuarios | 19 | Sistema de autenticación completo |SELECT COUNT(*) FROM socio;

    roles[1] AS rol,

    COUNT(*) AS cantidad

FROM v_usuarios_completos

GROUP BY roles[1]## Estructura de la Base de Datos### String de Conexión

ORDER BY rol;

```



---### Módulos Principales```-- Dashboard de cliente



## Comandos Útiles



### Backup**Gestión de Socios**postgresql://coop_user:cooperativa2024@localhost:5432/cooperativa_ugarte_dbSELECT dashboard_cliente(1);



```bash- Socios, cuentas, medidores, lecturas

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

``````



### Restaurar**Facturación**



```bash- Facturas, pagos, conceptos, servicios-- Facturas pendientes

docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

```



### Ver logs**Gestión Operativa**## 👥 Usuarios de PruebaSELECT * FROM factura WHERE estado = 'PENDIENTE';



```bash- Reclamos, órdenes de trabajo, empleados, cuadrillas

docker logs cooperativa-db

```



### Reiniciar limpio**Autenticación**



```bash- Usuarios, roles (CLIENTE, OPERARIO, ADMIN), permisosTodos los usuarios usan la contraseña: **`password123`**-- Reclamos activos

docker-compose down -v

docker-compose up -d

```

### Funciones y VistasSELECT * FROM v_reclamos_completos 

---



## Configuración pgAdmin

La base de datos incluye funciones especializadas y vistas optimizadas. Para detalles completos y ejemplos de uso, consulta la [Guía de Desarrollo](DEVELOPMENT.md).### 🔵 Clientes (11 usuarios)WHERE estado IN ('NUEVO', 'EN_PROCESO');

1. Ir a http://localhost:8080

2. Login con:

   - **Email:** `admin@cooperativa-ugarte.com.ar`

   - **Contraseña:** `admin123`## Comandos Útiles``````



3. Agregar servidor:

   - **Host:** `postgres` (en Docker) o `localhost`

   - **Port:** `5432`### Backupmariaelena.gonzalez@hotmail.com

   - **Database:** `cooperativa_ugarte_db`

   - **User:** `coop_user````bash

   - **Password:** `cooperativa2024`

docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sqlrobertocarlos.martinez@gmail.com## Estructura

---

```

## Docker Hub

anapaula.fernandez@yahoo.com

**Imagen:** `damian2k/cooperativa-ugarte-db`  

**Tags:** `latest`, `1.4`, `1.3`, `1.2`, `1.1`, `1.0`  ### Restaurar

**Tamaño:** ~399MB  

**Base:** PostgreSQL 15-alpine```bashjuanmanuel.lopez@outlook.com### Tablas Principales



---docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql



## Estructura del Proyecto```silviaraquel.rodriguez@gmail.com- `socio`, `cuenta`, `factura`, `reclamo`



```

cooperativa-ugarte-db/

├── Dockerfile### Ver logscarlosalberto.sanchez@hotmail.com- `medidor`, `lectura`, `orden_trabajo`

├── docker-compose.yml

├── scripts/```bash

│   ├── 01-schema.sql              # Schema completo (tablas, índices, triggers)

│   ├── 02-procedimientos.sql      # Funciones almacenadasdocker logs cooperativa-dbjuancarlos.perez@gmail.com- `empleado`, `servicio`, `material`

│   ├── 03-consultas.sql           # Consultas especializadas

│   ├── 04-datos-prueba.sql        # Datos de ejemplo```

│   ├── 05-usuarios.sql            # Sistema de autenticación

│   └── generate_hash.js           # Helper bcryptroberto.martinez@outlook.com

├── README.md

├── DEVELOPMENT.md### Reiniciar limpio

├── package.json

└── package-lock.json```bashana.rodriguez@yahoo.com### Funciones Personalizadas

```

docker-compose down -v

---

docker-compose up -dcarlos.fernandez@gmail.com- `dashboard_cliente(socio_id)` → Dashboard JSON

## Solución de Problemas

```

### Puerto 5432 ocupado

laura.lopez@gmail.com- `facturas_cliente(socio_id)` → Historial

```bash

docker run -d -p 5433:5432 damian2k/cooperativa-ugarte-db:latest## Docker Hub

```

```- `crear_nueva_cuenta()` → Gestión de cuentas

### Base de datos no inicia

**Imagen:** [damian2k/cooperativa-ugarte-db](https://hub.docker.com/r/damian2k/cooperativa-ugarte-db)

```bash

docker logs cooperativa-db

# Verificar errores en los scripts SQL

```**Tags disponibles:**



### Limpiar todo y empezar de cero- `latest` - Última versión estable (v1.3)### 🔧 Operarios (6 usuarios)### Vistas Especializadas



```bash- `1.3` - Sistema de autenticación con 3 roles y nombres de archivos descriptivos

docker-compose down -v

docker system prune -a --volumes- `1.2` - Funciones optimizadas```- `v_cuentas_completas`

docker-compose up -d

```- `1.1` - Datos de prueba mejorados



---- `1.0` - Primera versión establepedro.electricista@cooperativa-ugarte.com.ar- `v_reclamos_completos`



## Para Desarrolladores



¿Necesitas modificar o extender la base de datos? Consulta la [Guía de Desarrollo](DEVELOPMENT.md) para:**Tamaño:** ~399 MB  juan.operario@cooperativa-ugarte.com.ar- `v_ordenes_trabajo_completas`



- Ejemplos de consultas SQL**Base:** PostgreSQL 15-alpine

- Workflow de desarrollo

- Generación de hashes bcryptluis.tecnico@cooperativa-ugarte.com.ar

- Debugging y troubleshooting

- Convenciones de código## Para Desarrolladores



---ana.supervisora@cooperativa-ugarte.com.ar## Configuración pgAdmin



### Proyecto Académico¿Necesitas modificar o extender la base de datos? Consulta la [Guía de Desarrollo](DEVELOPMENT.md) para:



**Institución:** IFTS N° 29 (Instituto de Formación Técnica Superior N° 29)  - Ejemplos de consultas SQLcarmen.atencion@cooperativa-ugarte.com.ar

**Materia:** Prácticas Profesionales IV (PPIV)  

**Objetivo:** Sistema integral de gestión para cooperativa eléctrica  - Workflow de desarrollo

**Estudiante:** Damián Clausi  

**Año:** 2025- Generación de hashes bcryptdaniel.emergencias@cooperativa-ugarte.com.ar1. Ir a http://localhost:8080



---- Debugging y troubleshooting



## Contribuir- Convenciones de código```2. Login con las credenciales de pgAdmin



1. Fork el proyecto

2. Crea una rama (`git checkout -b feature/MejoraMavillosa`)

3. Commit tus cambios (`git commit -m 'Agrega característica X'`)## Estructura del Proyecto3. Agregar servidor:

4. Push a la rama (`git push origin feature/MejoraMavillosa`)

5. Abre un Pull Request



---```### 👑 Administradores (2 usuarios)   - **Host:** `postgres` (en Docker) o `localhost`



## Licenciacooperativa-ugarte-db/



Este proyecto está bajo la Licencia MIT.├── Dockerfile```   - **Port:** `5432`



---├── docker-compose.yml



**Si este proyecto te resulta útil, considera darle una estrella en GitHub**├── 01-schema.sql                   # Schema completo (tablas, índices, triggers)monica.administradora@cooperativa-ugarte.com.ar   - **Database:** `cooperativa_ugarte_db`


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

---

## 🔐 Entendiendo Password vs Hash

### ¿Qué es un hash bcrypt?

**Contraseña en texto plano** (lo que escribe el usuario):
```
password123
```

**Hash bcrypt** (lo que se guarda en la base de datos):
```
$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
```

### ¿Por qué son diferentes?

- **Seguridad**: NUNCA guardamos contraseñas en texto plano en la base de datos
- **Bcrypt**: Es un algoritmo de encriptación unidireccional (no se puede revertir)
- **Validación**: Al hacer login, bcrypt compara la contraseña ingresada con el hash

### Ejemplo de flujo:

```
1. Usuario se registra:
   - Escribe: "password123"
   - Backend genera hash: "$2b$10$92IXU..."
   - DB guarda: "$2b$10$92IXU..."

2. Usuario hace login:
   - Escribe: "password123"
   - Backend ejecuta: bcrypt.compare("password123", "$2b$10$92IXU...")
   - Si coincide: ✅ Login exitoso
   - Si no coincide: ❌ Credenciales inválidas
```

### ⚠️ Importante:

- **Mismo password = Diferentes hashes**: Cada vez que encriptas `password123` obtienes un hash diferente (esto es normal y correcto en bcrypt)
- **Todos validan igual**: Aunque los hashes sean diferentes, todos validan correctamente contra `password123`
- **NO uses hashes de ejemplo**: `$2b$10$example_hash_...` NO es un hash válido, NO funcionará con bcrypt

---

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
