-- ============================================================================
-- MIGRACIÓN: Reestructurar tipos de reclamo con jerarquía
-- ============================================================================
-- Estructura: tipo_reclamo (TECNICO/ADMINISTRATIVO) → detalle_tipo_reclamo → reclamo
-- ============================================================================

-- PASO 0: Guardar vistas que dependen de tipo_reclamo y eliminarlas temporalmente
DROP VIEW IF EXISTS v_reclamos_completos CASCADE;
DROP VIEW IF EXISTS v_ordenes_trabajo_completas CASCADE;

-- PASO 1: Renombrar la tabla actual tipo_reclamo a temporal
ALTER TABLE tipo_reclamo RENAME TO detalle_tipo_reclamo_temp;

-- PASO 2: Renombrar la columna tipo_id a detalle_id en la tabla temporal
ALTER TABLE detalle_tipo_reclamo_temp RENAME COLUMN tipo_id TO detalle_id;

-- PASO 3: Crear nueva tabla tipo_reclamo (TECNICO / ADMINISTRATIVO)
CREATE TABLE IF NOT EXISTS tipo_reclamo (
    tipo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PASO 4: Insertar los dos tipos principales
INSERT INTO tipo_reclamo (tipo_id, nombre, descripcion) VALUES
    (1, 'TECNICO', 'Reclamos que requieren intervención de operario en terreno'),
    (2, 'ADMINISTRATIVO', 'Reclamos que se resuelven desde oficina')
ON CONFLICT (nombre) DO NOTHING;

-- PASO 5: Crear tabla detalle_tipo_reclamo con la nueva estructura
CREATE TABLE IF NOT EXISTS detalle_tipo_reclamo (
    detalle_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo_id INTEGER NOT NULL REFERENCES tipo_reclamo(tipo_id),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PASO 6: Migrar datos de la tabla temporal a detalle_tipo_reclamo con sus tipos
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

-- PASO 7: Actualizar referencias en tabla reclamo
ALTER TABLE reclamo RENAME COLUMN tipo_id TO detalle_id;

-- PASO 8: Actualizar constraint de foreign key
ALTER TABLE reclamo DROP CONSTRAINT IF EXISTS reclamo_tipo_id_fkey;
ALTER TABLE reclamo ADD CONSTRAINT reclamo_detalle_id_fkey 
    FOREIGN KEY (detalle_id) REFERENCES detalle_tipo_reclamo(detalle_id);

-- PASO 9: Eliminar tabla temporal
DROP TABLE IF EXISTS detalle_tipo_reclamo_temp CASCADE;

-- PASO 10: Recrear vistas actualizadas con nueva estructura
CREATE OR REPLACE VIEW v_reclamos_completos AS
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

CREATE OR REPLACE VIEW v_ordenes_trabajo_completas AS
SELECT 
    ot.ot_id,
    ot.fecha_programada,
    ot.estado AS estado_ot,
    e.nombre || ' ' || e.apellido AS operario,
    r.reclamo_id,
    r.descripcion AS descripcion_reclamo,
    d.nombre AS detalle_reclamo,
    t.nombre AS tipo_reclamo,
    r.estado AS estado_reclamo,
    c.numero_cuenta,
    s.nombre || ' ' || s.apellido AS solicitante,
    ot.direccion_intervencion
FROM orden_trabajo ot
JOIN empleado e ON ot.empleado_id = e.empleado_id
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id;

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE '=== VERIFICACIÓN DE MIGRACIÓN ===';
    RAISE NOTICE 'Tipos de reclamo: %', (SELECT COUNT(*) FROM tipo_reclamo);
    RAISE NOTICE 'Detalles de reclamo: %', (SELECT COUNT(*) FROM detalle_tipo_reclamo);
    RAISE NOTICE 'Reclamos totales: %', (SELECT COUNT(*) FROM reclamo);
END $$;

-- Ver estructura final
SELECT 
    d.detalle_id,
    d.nombre AS detalle,
    t.nombre AS tipo
FROM detalle_tipo_reclamo d
LEFT JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
ORDER BY t.nombre DESC, d.detalle_id;
