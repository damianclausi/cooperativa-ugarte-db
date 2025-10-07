-- ============================================================================
-- MIGRACIÓN: Reestructurar tipos de reclamo con jerarquía
-- ============================================================================
-- Estructura: tipo_reclamo (TECNICO/ADMINISTRATIVO) → detalle_tipo_reclamo → reclamo
-- ============================================================================

DO $$
DECLARE
    migracion_aplicada BOOLEAN := FALSE;
BEGIN
    -- Verificar si existe la columna detalle_id en reclamo (indica migración aplicada)
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'reclamo' AND column_name = 'detalle_id'
    ) THEN
        migracion_aplicada := TRUE;
    END IF;

    IF migracion_aplicada THEN
        RAISE NOTICE 'La migración de tipos de reclamo ya se aplicó. Saltando...';
        RETURN;
    END IF;

    RAISE NOTICE 'Aplicando migración de tipos de reclamo...';

    -- PASO 0: Guardar vistas que dependen de tipo_reclamo y eliminarlas temporalmente
    DROP VIEW IF EXISTS v_reclamos_completos CASCADE;
    DROP VIEW IF EXISTS v_ordenes_trabajo_completas CASCADE;

    -- PASO 1: Renombrar la tabla actual tipo_reclamo a temporal
    ALTER TABLE tipo_reclamo RENAME TO detalle_tipo_reclamo_temp;

    -- PASO 2: Renombrar la columna tipo_id a detalle_id en la tabla temporal
    ALTER TABLE detalle_tipo_reclamo_temp RENAME COLUMN tipo_id TO detalle_id;

    -- PASO 3: Crear nueva tabla tipo_reclamo (TECNICO / ADMINISTRATIVO)
    CREATE TABLE tipo_reclamo (
        tipo_id SERIAL PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        descripcion TEXT,
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- PASO 4: Insertar los dos tipos principales
    INSERT INTO tipo_reclamo (tipo_id, nombre, descripcion) VALUES
    (1, 'TECNICO', 'Reclamos que requieren intervención de operario en terreno'),
    (2, 'ADMINISTRATIVO', 'Reclamos que se resuelven desde oficina');

    -- PASO 5: Crear nueva tabla detalle_tipo_reclamo
    CREATE TABLE detalle_tipo_reclamo (
        detalle_id SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        tipo_id INTEGER NOT NULL REFERENCES tipo_reclamo(tipo_id),
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- PASO 6: Migrar datos de la tabla temporal a la nueva estructura
    INSERT INTO detalle_tipo_reclamo (detalle_id, nombre, tipo_id, activo, created_at)
    SELECT
        detalle_id,
        nombre,
        CASE
            WHEN detalle_id IN (1, 2, 3, 4, 7, 8) THEN 1  -- TÉCNICOS
            WHEN detalle_id IN (5, 6) THEN 2               -- ADMINISTRATIVOS
        END as tipo_id,
        activo,
        created_at
    FROM detalle_tipo_reclamo_temp;

    -- PASO 7: Actualizar tabla reclamo para usar detalle_id en lugar de tipo_id
    ALTER TABLE reclamo ADD COLUMN detalle_id_temp INTEGER;
    UPDATE reclamo SET detalle_id_temp = tipo_id;
    ALTER TABLE reclamo DROP COLUMN tipo_id CASCADE;
    ALTER TABLE reclamo RENAME COLUMN detalle_id_temp TO detalle_id;
    ALTER TABLE reclamo ADD CONSTRAINT fk_reclamo_detalle FOREIGN KEY (detalle_id) REFERENCES detalle_tipo_reclamo(detalle_id);

    -- PASO 8: Recrear vistas
    CREATE VIEW v_reclamos_completos AS
    SELECT
        r.reclamo_id,
        r.fecha_alta,
        c.numero_cuenta,
        s.nombre || ' ' || s.apellido AS solicitante,
        d.nombre AS detalle_reclamo,
        t.nombre AS tipo_reclamo,
        p.nombre AS prioridad,
        r.estado,
        r.descripcion,
        r.canal
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    JOIN socio s ON c.socio_id = s.socio_id
    JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
    JOIN prioridad p ON r.prioridad_id = p.prioridad_id;

    CREATE VIEW v_ordenes_trabajo_completas AS
    SELECT
        ot.ot_id,
        ot.fecha_programada,
        ot.estado,
        e.nombre || ' ' || e.apellido AS tecnico_asignado,
        r.reclamo_id,
        d.nombre AS detalle_reclamo,
        t.nombre AS tipo_reclamo,
        c.numero_cuenta,
        s.nombre || ' ' || s.apellido AS solicitante,
        ot.direccion_intervencion
    FROM orden_trabajo ot
    JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    JOIN socio s ON c.socio_id = s.socio_id
    JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
    LEFT JOIN empleado e ON ot.empleado_id = e.empleado_id;

    -- PASO 9: Limpiar tabla temporal
    DROP TABLE detalle_tipo_reclamo_temp;

    RAISE NOTICE 'Migración de tipos de reclamo completada exitosamente';
END $$;
