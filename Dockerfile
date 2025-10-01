# Dockerfile para Cooperativa Eléctrica "Gobernador Ugarte"
FROM postgres:15-alpine

# Información del mantenedor
LABEL maintainer="Cooperativa Eléctrica Gobernador Ugarte"
LABEL description="Base de datos PostgreSQL para sistema de gestión cooperativa eléctrica"
LABEL version="1.0"

# Variables de entorno por defecto
ENV POSTGRES_DB=cooperativa_ugarte_db
ENV POSTGRES_USER=coop_user
ENV POSTGRES_PASSWORD=coop_password
ENV TZ=America/Argentina/Buenos_Aires

# Copiar scripts de inicialización en orden correcto
COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
COPY scripts/procedimientos.sql /docker-entrypoint-initdb.d/02-procedimientos.sql
COPY scripts/consultas_cooperativa.sql /docker-entrypoint-initdb.d/03-consultas.sql
COPY scripts/datos_prueba.sql /docker-entrypoint-initdb.d/04-datos.sql

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