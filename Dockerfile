# Dockerfile para Cooperativa Eléctrica "Gobernador Ugarte"
FROM postgres:15-alpine

# Información del mantenedor
LABEL maintainer="Cooperativa Eléctrica Gobernador Ugarte"
LABEL description="Base de datos PostgreSQL para sistema de gestión cooperativa eléctrica"
LABEL version="1.6"

# Variables de entorno por defecto
ENV POSTGRES_DB=cooperativa_ugarte_db
ENV POSTGRES_USER=coop_user
ENV POSTGRES_PASSWORD=cooperativa2024
ENV TZ=America/Argentina/Buenos_Aires

# Copiar scripts de inicialización en orden correcto
COPY scripts/01-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY scripts/02-procedimientos.sql /docker-entrypoint-initdb.d/02-procedimientos.sql
COPY scripts/03-consultas.sql /docker-entrypoint-initdb.d/03-consultas.sql
COPY scripts/04-datos-prueba.sql /docker-entrypoint-initdb.d/04-datos-prueba.sql
COPY scripts/05-usuarios.sql /docker-entrypoint-initdb.d/05-usuarios.sql
COPY scripts/06-reclamos-pedro.sql /docker-entrypoint-initdb.d/06-reclamos-pedro.sql

# Configurar timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apk del tzdata

# Exponer puerto
EXPOSE 5432

# Volumen para datos persistentes
VOLUME ["/var/lib/postgresql/data"]

# Comando por defecto (heredado de la imagen base)
CMD ["postgres"]