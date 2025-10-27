-- ============================================================================
-- SCRIPT: Sistema de Valoración de Reclamos Resueltos
-- Proyecto: Sistema de Gestión Cooperativa Eléctrica
-- Fecha: 27/10/2025
-- Versión: 1.12
-- ============================================================================
-- 
-- DESCRIPCIÓN:
-- Este script crea el sistema de valoraciones que permite a los socios
-- calificar la atención recibida en reclamos resueltos con calificación
-- de 1 a 5 estrellas y comentario opcional.
--
-- CARACTERÍSTICAS:
-- - Valoración solo para reclamos en estado RESUELTO o CERRADO
-- - Una valoración por reclamo por socio (UNIQUE constraint)
-- - Calificación obligatoria (1-5 estrellas)
-- - Comentario opcional (TEXT)
-- - Trazabilidad completa (created_at, fecha_valoracion)
-- - Índices optimizados para consultas frecuentes
-- - Integridad referencial con CASCADE
--
-- ============================================================================

\c cooperativa_ugarte_db;

-- ============================================================================
-- TABLA: valoracion
-- ============================================================================

COMMENT ON DATABASE cooperativa_ugarte_db IS 'Base de datos del sistema de gestión de Cooperativa Eléctrica Gobernador Ugarte - Incluye sistema de valoraciones v1.12';

CREATE TABLE valoracion (
    valoracion_id SERIAL PRIMARY KEY,
    reclamo_id INTEGER NOT NULL REFERENCES reclamo(reclamo_id) ON DELETE CASCADE,
    socio_id INTEGER NOT NULL REFERENCES socio(socio_id) ON DELETE CASCADE,
    calificacion INTEGER NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    fecha_valoracion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricción: Un socio solo puede valorar un reclamo una vez
    CONSTRAINT uq_valoracion_reclamo_socio UNIQUE (reclamo_id, socio_id)
);

-- ============================================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- ============================================================================

COMMENT ON TABLE valoracion IS 
'Tabla de valoraciones de reclamos resueltos. Permite a los socios calificar la atención recibida con calificación de 1-5 estrellas y comentario opcional. Un socio puede valorar cada reclamo una sola vez.';

COMMENT ON COLUMN valoracion.valoracion_id IS 
'Identificador único de la valoración (clave primaria)';

COMMENT ON COLUMN valoracion.reclamo_id IS 
'Referencia al reclamo valorado. Solo reclamos en estado RESUELTO o CERRADO deberían ser valorados.';

COMMENT ON COLUMN valoracion.socio_id IS 
'Referencia al socio que realiza la valoración. Debe corresponder al titular de la cuenta del reclamo.';

COMMENT ON COLUMN valoracion.calificacion IS 
'Calificación numérica de 1 a 5 estrellas (1=Muy malo, 2=Malo, 3=Regular, 4=Bueno, 5=Excelente)';

COMMENT ON COLUMN valoracion.comentario IS 
'Comentario opcional del socio sobre la atención recibida. Puede contener sugerencias, agradecimientos o quejas.';

COMMENT ON COLUMN valoracion.fecha_valoracion IS 
'Fecha y hora en que se realizó la valoración';

COMMENT ON COLUMN valoracion.created_at IS 
'Fecha y hora de creación del registro (auditoría)';

COMMENT ON CONSTRAINT uq_valoracion_reclamo_socio ON valoracion IS 
'Garantiza que un socio solo pueda valorar un mismo reclamo una vez';

-- ============================================================================
-- ÍNDICES PARA OPTIMIZACIÓN DE CONSULTAS
-- ============================================================================

-- Índice para consultas de valoraciones por reclamo
CREATE INDEX idx_valoracion_reclamo ON valoracion(reclamo_id);

-- Índice para consultas de valoraciones por socio
CREATE INDEX idx_valoracion_socio ON valoracion(socio_id);

-- Índice para consultas de valoraciones por calificación (reportes estadísticos)
CREATE INDEX idx_valoracion_calificacion ON valoracion(calificacion);

-- Índice para consultas ordenadas por fecha de valoración
CREATE INDEX idx_valoracion_fecha ON valoracion(fecha_valoracion DESC);

-- Índice compuesto para consultas de reclamos con valoraciones
CREATE INDEX idx_valoracion_reclamo_fecha ON valoracion(reclamo_id, fecha_valoracion DESC);

COMMENT ON INDEX idx_valoracion_reclamo IS 
'Optimiza consultas de valoraciones por reclamo específico';

COMMENT ON INDEX idx_valoracion_socio IS 
'Optimiza consultas de valoraciones realizadas por un socio';

COMMENT ON INDEX idx_valoracion_calificacion IS 
'Optimiza consultas estadísticas por calificación (reportes de satisfacción)';

COMMENT ON INDEX idx_valoracion_fecha IS 
'Optimiza consultas de valoraciones recientes ordenadas por fecha';

COMMENT ON INDEX idx_valoracion_reclamo_fecha IS 
'Optimiza consultas de valoraciones de un reclamo ordenadas cronológicamente';

-- ============================================================================
-- FUNCIÓN: Validar estado del reclamo antes de valorar
-- ============================================================================

CREATE OR REPLACE FUNCTION validar_reclamo_para_valoracion()
RETURNS TRIGGER AS $$
DECLARE
    v_estado VARCHAR(50);
    v_cuenta_id INTEGER;
    v_socio_id_reclamo INTEGER;
BEGIN
    -- Obtener el estado del reclamo y el socio titular de la cuenta
    SELECT r.estado, c.socio_id INTO v_estado, v_socio_id_reclamo
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.reclamo_id = NEW.reclamo_id;
    
    -- Verificar que el reclamo existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El reclamo % no existe', NEW.reclamo_id;
    END IF;
    
    -- Verificar que el reclamo está resuelto o cerrado
    IF v_estado NOT IN ('RESUELTO', 'CERRADO') THEN
        RAISE EXCEPTION 'Solo se pueden valorar reclamos en estado RESUELTO o CERRADO. Estado actual: %', v_estado;
    END IF;
    
    -- Verificar que el socio que valora es el titular de la cuenta del reclamo
    IF NEW.socio_id != v_socio_id_reclamo THEN
        RAISE EXCEPTION 'Solo el socio titular de la cuenta puede valorar el reclamo';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION validar_reclamo_para_valoracion() IS 
'Trigger function que valida que: 1) El reclamo esté en estado RESUELTO o CERRADO, 2) El socio que valora sea el titular de la cuenta del reclamo';

-- ============================================================================
-- TRIGGER: Validar antes de insertar valoración
-- ============================================================================

CREATE TRIGGER trg_validar_valoracion
    BEFORE INSERT ON valoracion
    FOR EACH ROW
    EXECUTE FUNCTION validar_reclamo_para_valoracion();

COMMENT ON TRIGGER trg_validar_valoracion ON valoracion IS 
'Valida que el reclamo esté resuelto/cerrado y que el socio sea el titular antes de permitir la valoración';

-- ============================================================================
-- VISTA: Estadísticas de valoraciones
-- ============================================================================

CREATE OR REPLACE VIEW v_estadisticas_valoraciones AS
SELECT 
    COUNT(*) as total_valoraciones,
    AVG(calificacion)::NUMERIC(3,2) as promedio_general,
    COUNT(CASE WHEN calificacion = 5 THEN 1 END) as cinco_estrellas,
    COUNT(CASE WHEN calificacion = 4 THEN 1 END) as cuatro_estrellas,
    COUNT(CASE WHEN calificacion = 3 THEN 1 END) as tres_estrellas,
    COUNT(CASE WHEN calificacion = 2 THEN 1 END) as dos_estrellas,
    COUNT(CASE WHEN calificacion = 1 THEN 1 END) as una_estrella,
    COUNT(CASE WHEN comentario IS NOT NULL AND comentario != '' THEN 1 END) as con_comentario,
    COUNT(CASE WHEN comentario IS NULL OR comentario = '' THEN 1 END) as sin_comentario,
    MIN(fecha_valoracion) as primera_valoracion,
    MAX(fecha_valoracion) as ultima_valoracion
FROM valoracion;

COMMENT ON VIEW v_estadisticas_valoraciones IS 
'Vista con estadísticas generales del sistema de valoraciones';

-- ============================================================================
-- VISTA: Valoraciones completas con datos del reclamo y socio
-- ============================================================================

CREATE OR REPLACE VIEW v_valoraciones_detalle AS
SELECT 
    v.valoracion_id,
    v.reclamo_id,
    r.descripcion as reclamo_descripcion,
    r.estado as reclamo_estado,
    r.fecha_alta as reclamo_fecha_alta,
    r.fecha_cierre as reclamo_fecha_cierre,
    dtr.nombre as tipo_reclamo,
    v.socio_id,
    s.nombre || ' ' || s.apellido as socio_nombre_completo,
    s.email as socio_email,
    c.numero_cuenta,
    c.direccion,
    v.calificacion,
    v.comentario,
    v.fecha_valoracion,
    EXTRACT(DAY FROM (v.fecha_valoracion - r.fecha_cierre)) as dias_hasta_valoracion
FROM valoracion v
JOIN reclamo r ON v.reclamo_id = r.reclamo_id
JOIN socio s ON v.socio_id = s.socio_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
ORDER BY v.fecha_valoracion DESC;

COMMENT ON VIEW v_valoraciones_detalle IS 
'Vista completa de valoraciones con información contextual del reclamo, socio y cuenta';

-- ============================================================================
-- VISTA: Promedio de valoraciones por tipo de reclamo
-- ============================================================================

CREATE OR REPLACE VIEW v_valoraciones_por_tipo_reclamo AS
SELECT 
    dtr.detalle_id,
    dtr.nombre as tipo_reclamo,
    tr.nombre as categoria,
    COUNT(v.valoracion_id) as total_valoraciones,
    AVG(v.calificacion)::NUMERIC(3,2) as promedio_calificacion,
    COUNT(CASE WHEN v.calificacion >= 4 THEN 1 END) as satisfactorias,
    COUNT(CASE WHEN v.calificacion <= 2 THEN 1 END) as insatisfactorias
FROM detalle_tipo_reclamo dtr
LEFT JOIN reclamo r ON dtr.detalle_id = r.detalle_id
LEFT JOIN valoracion v ON r.reclamo_id = v.reclamo_id
LEFT JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
GROUP BY dtr.detalle_id, dtr.nombre, tr.nombre
HAVING COUNT(v.valoracion_id) > 0
ORDER BY promedio_calificacion DESC, total_valoraciones DESC;

COMMENT ON VIEW v_valoraciones_por_tipo_reclamo IS 
'Vista de estadísticas de valoraciones agrupadas por tipo de reclamo';

-- ============================================================================
-- VISTA: Empleados mejor valorados (basado en OTs resueltas)
-- ============================================================================

CREATE OR REPLACE VIEW v_valoraciones_por_empleado AS
SELECT 
    e.empleado_id,
    e.nombre || ' ' || e.apellido as empleado_nombre_completo,
    e.rol_interno,
    COUNT(DISTINCT v.valoracion_id) as total_valoraciones,
    AVG(v.calificacion)::NUMERIC(3,2) as promedio_calificacion,
    COUNT(CASE WHEN v.calificacion = 5 THEN 1 END) as cinco_estrellas,
    COUNT(CASE WHEN v.calificacion >= 4 THEN 1 END) as satisfactorias,
    COUNT(CASE WHEN v.calificacion <= 2 THEN 1 END) as insatisfactorias,
    COUNT(DISTINCT ot.reclamo_id) as total_reclamos_atendidos,
    COUNT(DISTINCT v.reclamo_id) as reclamos_valorados
FROM empleado e
JOIN orden_trabajo ot ON e.empleado_id = ot.empleado_id
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
LEFT JOIN valoracion v ON r.reclamo_id = v.reclamo_id
WHERE ot.estado = 'COMPLETADA'
GROUP BY e.empleado_id, e.nombre, e.apellido, e.rol_interno
HAVING COUNT(v.valoracion_id) > 0
ORDER BY promedio_calificacion DESC, total_valoraciones DESC;

COMMENT ON VIEW v_valoraciones_por_empleado IS 
'Vista de empleados con estadísticas de valoraciones basadas en los reclamos que atendieron';

-- ============================================================================
-- DATOS DE PRUEBA
-- ============================================================================

DO $$
DECLARE
    v_reclamo_id INTEGER;
    v_socio_id INTEGER;
    v_cuenta_id INTEGER;
    v_contador INTEGER := 0;
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'INSERTANDO VALORACIONES DE PRUEBA';
    RAISE NOTICE '============================================';
    
    -- Valoración 1: Reclamo resuelto - 5 estrellas con comentario positivo
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    LIMIT 1;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            5,
            'Excelente atención. El técnico llegó a tiempo y resolvió el problema rápidamente. Muy profesional.',
            CURRENT_TIMESTAMP - INTERVAL '2 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 1: 5 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 2: Reclamo resuelto - 4 estrellas con comentario
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 1;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            4,
            'Buen servicio, aunque tuvieron que venir dos veces para resolver completamente el problema.',
            CURRENT_TIMESTAMP - INTERVAL '5 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 2: 4 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 3: Reclamo resuelto - 5 estrellas sin comentario
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 2;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            5,
            CURRENT_TIMESTAMP - INTERVAL '1 day'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 3: 5 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 4: Reclamo resuelto - 3 estrellas con comentario neutral
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 3;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            3,
            'El problema se resolvió pero tardaron más de lo esperado en responder.',
            CURRENT_TIMESTAMP - INTERVAL '10 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 4: 3 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 5: Reclamo resuelto - 4 estrellas con comentario
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 4;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            4,
            'Muy conformes con la solución. Personal amable y eficiente.',
            CURRENT_TIMESTAMP - INTERVAL '3 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 5: 4 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 6: Reclamo resuelto - 5 estrellas con comentario muy positivo
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 5;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            5,
            'Impecable el servicio. Solucionaron una emergencia en menos de 2 horas. Felicitaciones a todo el equipo.',
            CURRENT_TIMESTAMP - INTERVAL '7 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 6: 5 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 7: Reclamo resuelto - 2 estrellas con queja
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 6;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, comentario, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            2,
            'Tardaron demasiado en responder. Tuve que estar sin luz por 48 horas.',
            CURRENT_TIMESTAMP - INTERVAL '15 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 7: 2 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    -- Valoración 8: Reclamo resuelto - 4 estrellas sin comentario
    SELECT r.reclamo_id, c.socio_id INTO v_reclamo_id, v_socio_id
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    WHERE r.estado IN ('RESUELTO', 'CERRADO')
    AND NOT EXISTS (SELECT 1 FROM valoracion v WHERE v.reclamo_id = r.reclamo_id)
    LIMIT 1 OFFSET 7;
    
    IF v_reclamo_id IS NOT NULL THEN
        INSERT INTO valoracion (reclamo_id, socio_id, calificacion, fecha_valoracion)
        VALUES (
            v_reclamo_id,
            v_socio_id,
            4,
            CURRENT_TIMESTAMP - INTERVAL '4 days'
        );
        v_contador := v_contador + 1;
        RAISE NOTICE '✓ Valoración 8: 4 estrellas - Reclamo % valorado por socio %', v_reclamo_id, v_socio_id;
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
    RAISE NOTICE '✅ VALORACIONES INSERTADAS: %', v_contador;
    RAISE NOTICE '============================================';
    
    IF v_contador = 0 THEN
        RAISE WARNING 'No se pudieron insertar valoraciones. Verifique que existan reclamos en estado RESUELTO o CERRADO.';
    END IF;
END $$;

-- ============================================================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================================================

\echo ''
\echo '============================================'
\echo 'ESTADÍSTICAS GENERALES DE VALORACIONES'
\echo '============================================'
SELECT * FROM v_estadisticas_valoraciones;

\echo ''
\echo '============================================'
\echo 'ÚLTIMAS 5 VALORACIONES'
\echo '============================================'
SELECT 
    valoracion_id,
    reclamo_id,
    socio_nombre_completo,
    calificacion || ' estrellas' as valoracion,
    CASE 
        WHEN comentario IS NOT NULL THEN LEFT(comentario, 50) || '...'
        ELSE '(sin comentario)'
    END as comentario_preview,
    fecha_valoracion
FROM v_valoraciones_detalle
LIMIT 5;

\echo ''
\echo '============================================'
\echo 'PROMEDIO POR TIPO DE RECLAMO'
\echo '============================================'
SELECT 
    tipo_reclamo,
    total_valoraciones,
    promedio_calificacion,
    satisfactorias || ' (' || ROUND(satisfactorias::NUMERIC / total_valoraciones * 100, 1) || '%)' as porcentaje_satisfaccion
FROM v_valoraciones_por_tipo_reclamo
ORDER BY promedio_calificacion DESC
LIMIT 5;

\echo ''
\echo '✅ Script de valoraciones completado exitosamente'
\echo ''
