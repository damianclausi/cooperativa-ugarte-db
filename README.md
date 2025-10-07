# Cooperativa Electrica "Gobernador Ugarte" - Base de Datos PostgreSQL

Base de datos PostgreSQL para sistema de gestion de cooperativa electrica de la PPIV.

---

## Como Usar Este Proyecto

### Opcion A: Descargar y usar imagen lista desde Docker Hub

Si solo quieres usar la base de datos:

```bash
# Descargar y ejecutar
docker pull damian2k/cooperativa-ugarte-db:latest
docker run -d --name cooperativa-db -p 5432:5432 damian2k/cooperativa-ugarte-db:latest

# Conectar
docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db
```

**Credenciales:**
- Host: `localhost:5432`
- Database: `cooperativa_ugarte_db`
- Usuario: `coop_user`
- Password: `cooperativa2024`

---

### Opcion B: Construir y subir tu propia version a Docker Hub

Si quieres modificar los scripts y crear tu propia imagen:

#### 1. Clonar el repositorio

```bash
git clone https://github.com/damianclausi/cooperativa-ugarte-db.git
cd cooperativa-ugarte-db
```

#### 2. Entender la estructura de scripts

Los scripts SQL se encuentran en la carpeta `scripts/` y se ejecutan automaticamente en orden:

```
scripts/
├── 01-schema.sql         # Crea las 22 tablas, roles y funciones
├── 02-procedimientos.sql # Stored procedures adicionales
├── 03-consultas.sql      # Vistas optimizadas (opcional)
├── 04-datos-prueba.sql   # Inserta datos de ejemplo (12 socios, 15 facturas, etc.)
├── 05-usuarios.sql       # Crea 19 usuarios con autenticacion bcrypt
└── 06-reclamos-pedro.sql # 20 reclamos tecnicos para operario Pedro (PENDIENTE/EN CURSO/RESUELTO)
```

**Modificar scripts (si necesitas):**
- Edita cualquier archivo `.sql` en la carpeta `scripts/`
- Los cambios se aplicaran al construir la imagen Docker

#### 3. Probar scripts localmente (opcional)

Con Docker Compose:

```bash
docker-compose up -d
docker exec -it cooperativa-db psql -U coop_user -d cooperativa_ugarte_db
```

Verificar que todo funciona:
```sql
-- Ver cuantos usuarios hay
SELECT COUNT(*) FROM usuarios;

-- Ver socios
SELECT * FROM socios LIMIT 5;
```

Detener:
```bash
docker-compose down -v
```

#### 4. Construir la imagen Docker

```bash
docker build -t tu-usuario/cooperativa-ugarte-db:1.0 .
```

**Que hace este comando:**
- Lee el `Dockerfile`
- Copia los scripts SQL al contenedor
- Crea una imagen PostgreSQL 15-alpine con tus datos

#### 5. Probar la imagen localmente

```bash
docker run -d --name test-db -p 5432:5432 tu-usuario/cooperativa-ugarte-db:1.0
docker logs test-db  # Ver que los scripts se ejecutaron correctamente
docker exec -it test-db psql -U coop_user -d cooperativa_ugarte_db

# Verificar
# SELECT COUNT(*) FROM usuarios;

# Limpiar
docker stop test-db && docker rm test-db
```

#### 6. Login a Docker Hub

```bash
docker login
```

Ingresa tu usuario y password de Docker Hub (crea cuenta en https://hub.docker.com si no tienes).

#### 7. Subir imagen a Docker Hub

```bash
# Tag como latest
docker tag tu-usuario/cooperativa-ugarte-db:1.0 tu-usuario/cooperativa-ugarte-db:latest

# Push ambas versiones
docker push tu-usuario/cooperativa-ugarte-db:1.0
docker push tu-usuario/cooperativa-ugarte-db:latest
```

#### 8. Usar tu imagen desde Docker Hub

Ahora cualquiera (incluso tu desde otra computadora) puede usar tu imagen:

```bash
docker pull tu-usuario/cooperativa-ugarte-db:latest
docker run -d --name cooperativa-db -p 5432:5432 tu-usuario/cooperativa-ugarte-db:latest
```

---

## Comandos Utiles

```bash
# Ver logs del contenedor
docker logs cooperativa-db

# Ver logs en tiempo real
docker logs -f cooperativa-db

# Hacer backup de la base de datos
docker exec cooperativa-db pg_dump -U coop_user cooperativa_ugarte_db > backup.sql

# Restaurar desde backup
docker exec -i cooperativa-db psql -U coop_user cooperativa_ugarte_db < backup.sql

# Detener contenedor
docker stop cooperativa-db

# Eliminar contenedor
docker rm cooperativa-db

# Eliminar imagen local
docker rmi tu-usuario/cooperativa-ugarte-db:1.0
```

---

## Contenido de la Base de Datos

- **22 tablas:** socios, usuarios, facturas, pagos, reclamos, ordenes_trabajo, medidores, lecturas, empleados, tarifas, etc.
- **3 roles:** CLIENTE, OPERARIO, ADMIN
- **19 usuarios de prueba:** password `password123`
- **Datos de ejemplo:** 12 socios, 15 facturas, 30 reclamos (10 iniciales + 20 de Pedro), 33 ordenes de trabajo
- **Operario Pedro:** 23 ordenes de trabajo asignadas (6 PENDIENTES, 8 EN CURSO, 6 RESUELTOS)

---

## Documentacion Tecnica Completa

Para detalles sobre:
- Estructura completa de las 22 tablas
- Lista de todos los usuarios de prueba
- Ejemplos de consultas SQL
- Funciones especializadas

Ver: **[Documentacion.md](Documentacion.md)**

---

**Proyecto Academico**  
IFTS N° 29 - Practicas Profesionales IV - 2025
