# Cooperativa Electrica "Gobernador Ugarte" - Base de Datos PostgreSQL

Base de datos PostgreSQL para sistema de gestion de cooperativa electrica de la PPIV.

**Version 1.12:** Sistema completo de valoraciones con estrellas (1-5) para reclamos resueltos + itinerarios diciembre 2025.

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
├── 01-schema.sql                           # Crea las 22 tablas, roles y funciones
├── 02-procedimientos.sql                   # Stored procedures adicionales
├── 03-consultas.sql                        # Vistas optimizadas (opcional)
├── 04-datos-prueba.sql                     # Inserta datos de ejemplo
├── 05-usuarios.sql                         # Crea 19 usuarios con autenticacion bcrypt
├── 06-reclamos-pedro.sql                   # 20 reclamos tecnicos para operario Pedro
├── 10-itinerarios-diciembre-2025.sql       # Itinerarios de prueba diciembre 2025 (45 OTs)
├── 11-valoraciones.sql                     # Sistema de valoraciones con estrellas (1-5)
├── 11-valoraciones-rollback.sql            # Script de rollback para valoraciones
│
├── SISTEMA DE ITINERARIOS DE CUADRILLAS:
├── 07-preparar-itinerarios.sql             # Libera OTs para itinerarios (con reportes)
├── 07b-liberar-ots-rapido.sql              # Version rapida (sin reportes)
├── 07c-consultar-estado-itinerarios.sql    # Solo consulta (no modifica)
├── 08-asignar-ots-a-itinerarios.sql        # Asigna OTs a cuadrillas automaticamente
├── 09-demo-completa-itinerarios.sql        # Demo interactiva del flujo completo
├── EJEMPLOS-CONSULTAS-ITINERARIOS.sql      # Consultas SQL utiles de referencia
├── GUIA-RAPIDA-ITINERARIOS.md              # Guia rapida con comandos
└── ITINERARIOS-README.md                   # Documentacion completa
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
- **Datos de ejemplo:** 12 socios, 15 facturas, 30 reclamos, 30 ordenes de trabajo
- **🆕 OTs para itinerarios:** 6 OTs técnicas liberadas (sin empleado asignado) listas para sistema de itinerarios
- **OTs asignadas:** 24 OTs asignadas directamente a operarios

---

## 🆕 Sistema de Itinerarios de Cuadrillas

Este proyecto incluye scripts especiales para preparar datos de prueba del **sistema de itinerarios de cuadrillas**.

### ¿Qué es el Sistema de Itinerarios?

Permite asignar OTs técnicas a **cuadrillas completas** en lugar de operarios individuales:
- Una OT sin `empleado_id` está disponible para cuadrillas
- Se marca con `[ITINERARIO: fecha cuadrilla_id]` en observaciones
- Cualquier operario de la cuadrilla puede "tomarla"
- Al tomarla, se asigna automáticamente al operario

### Scripts Disponibles

| Script | Propósito | Tiempo | Uso |
|--------|-----------|--------|-----|
| `07c-consultar-estado-itinerarios.sql` | 📊 Solo consulta | 5s | Ver estado actual |
| `07-preparar-itinerarios.sql` | ⭐ Liberar OTs (con reportes) | 15s | Producción |
| `07b-liberar-ots-rapido.sql` | ⚡ Liberar OTs (rápido) | 10s | Producción rápida |
| `08-asignar-ots-a-itinerarios.sql` | 🎯 Asignar a cuadrillas | 20s | Crear itinerarios |
| `09-demo-completa-itinerarios.sql` | 🎬 Demo interactiva | 30s | Aprender |
| `EJEMPLOS-CONSULTAS-ITINERARIOS.sql` | 📚 Consultas útiles | 1m | Referencia |

### Inicio Rápido

**✨ Novedad v1.9:** La base de datos ya incluye **6 OTs liberadas** por defecto, listas para asignar a itinerarios.

```bash
# 1. Ver estado actual (ya hay OTs disponibles)
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/07c-consultar-estado-itinerarios.sql

# 2. Ver demo completa del flujo
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/09-demo-completa-itinerarios.sql

# 3. Asignar OTs disponibles a cuadrillas
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/08-asignar-ots-a-itinerarios.sql

# 4. Si necesitas más OTs liberadas
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/07-preparar-itinerarios.sql

# 4. Asignar OTs a cuadrillas automáticamente
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db < scripts/08-asignar-ots-a-itinerarios.sql
```

### Flujo del Sistema

```
OT Asignada → Liberar → Asignar a Cuadrilla → Operario Toma → Ejecuta
(empleado_id) (NULL)   [ITINERARIO:...] (empleado_id)   (completa)
```

📖 **Documentación completa:** [scripts/ITINERARIOS-README.md](scripts/ITINERARIOS-README.md)  
⚡ **Guía rápida:** [scripts/GUIA-RAPIDA-ITINERARIOS.md](scripts/GUIA-RAPIDA-ITINERARIOS.md)

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
