-- ============================================
-- SCRIPT DE PREPARACIÓN DE DATOS PARA SISTEMA DE ITINERARIOS
-- Fecha: 2025-10-10
-- Propósito: Liberar OTs técnicas para asignación a cuadrillas
-- ============================================

\echo ''
\echo '================================================'
\echo '  PREPARACIÓN DE DATOS PARA ITINERARIOS'
\echo '================================================'
\echo ''

-- ============================================
-- 1. ANÁLISIS DEL ESTADO ACTUAL
-- ============================================

\echo '--- ESTADO ACTUAL DE OTs TÉCNICAS ---'
\echo ''

-- Total de OTs técnicas por estado
SELECT 
    'Total OTs Técnicas por Estado:' as analisis,
    ot.estado,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
GROUP BY ot.estado
ORDER BY ot.estado;

\echo ''

-- Análisis de asignación de empleados
SELECT 
    'Análisis de Asignación:' as analisis,
    CASE 
        WHEN ot.empleado_id IS NULL THEN 'Sin asignar (NULL)'
        ELSE 'Asignado directamente'
    END as tipo_asignacion,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
GROUP BY CASE 
    WHEN ot.empleado_id IS NULL THEN 'Sin asignar (NULL)'
    ELSE 'Asignado directamente'
END;

\echo ''

-- OTs que ya están en itinerarios
SELECT 
    'OTs ya en Itinerarios:' as analisis,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.observaciones LIKE '%[ITINERARIO%';

\echo ''

-- OTs candidatas para liberar (PENDIENTE, con empleado_id, sin itinerario)
SELECT 
    'OTs Candidatas para Liberar (PENDIENTE + empleado_id asignado + sin itinerario):' as analisis,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.estado = 'PENDIENTE'
    AND ot.empleado_id IS NOT NULL
    AND (ot.observaciones IS NULL OR ot.observaciones NOT LIKE '%[ITINERARIO%');

\echo ''
\echo '================================================'
\echo ''

-- ============================================
-- 2. LIBERACIÓN DE OTs PARA ITINERARIOS
-- ============================================

\echo '--- LIBERANDO OTs PARA ITINERARIOS ---'
\echo ''

-- Crear una tabla temporal con las OTs a liberar
CREATE TEMPORARY TABLE ots_a_liberar AS
SELECT 
    ot.ot_id,
    ot.reclamo_id,
    ot.empleado_id as empleado_anterior,
    s.nombre || ' ' || s.apellido as socio,
    c.direccion,
    r.prioridad,
    dtr.nombre as tipo_detalle,
    ot.observaciones as observaciones_actuales
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.estado = 'PENDIENTE'
    AND ot.empleado_id IS NOT NULL
    AND (ot.observaciones IS NULL OR ot.observaciones NOT LIKE '%[ITINERARIO%')
ORDER BY r.prioridad DESC, ot.ot_id
LIMIT 8;  -- Liberamos 8 OTs (un número intermedio entre 5 y 10)

\echo 'OTs seleccionadas para liberar:'
\echo ''

-- Mostrar las OTs que se van a liberar
SELECT 
    ot_id,
    socio,
    direccion,
    tipo_detalle,
    CASE prioridad
        WHEN 'ALTA' THEN 'ALTA ⚠️'
        WHEN 'MEDIA' THEN 'MEDIA'
        ELSE 'BAJA'
    END as prioridad
FROM ots_a_liberar
ORDER BY ot_id;

\echo ''
\echo 'Actualizando OTs...'
\echo ''

-- Realizar la actualización
UPDATE orden_trabajo
SET 
    empleado_id = NULL,
    observaciones = COALESCE(observaciones || ' ', '') || '[Liberada para itinerario de cuadrilla]',
    updated_at = CURRENT_TIMESTAMP
WHERE ot_id IN (SELECT ot_id FROM ots_a_liberar);

-- Mostrar resultado de la actualización
SELECT 
    'Resultado:' as info,
    COUNT(*) || ' OTs liberadas exitosamente' as mensaje
FROM ots_a_liberar;

\echo ''
\echo '================================================'
\echo ''

-- ============================================
-- 3. VERIFICACIÓN POST-ACTUALIZACIÓN
-- ============================================

\echo '--- VERIFICACIÓN POST-ACTUALIZACIÓN ---'
\echo ''

-- Contar OTs disponibles para itinerario
SELECT 
    'OTs Disponibles para Itinerarios:' as verificacion,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.estado = 'PENDIENTE'
    AND ot.empleado_id IS NULL
    AND (ot.observaciones IS NULL OR ot.observaciones NOT LIKE '%[ITINERARIO:%');

\echo ''

-- Estado actualizado de asignación
SELECT 
    'Estado Actualizado de Asignación:' as verificacion,
    CASE 
        WHEN ot.empleado_id IS NULL THEN 'Sin asignar (Disponible para itinerario)'
        ELSE 'Asignado directamente'
    END as tipo_asignacion,
    COUNT(*) as cantidad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
GROUP BY CASE 
    WHEN ot.empleado_id IS NULL THEN 'Sin asignar (Disponible para itinerario)'
    ELSE 'Asignado directamente'
END;

\echo ''
\echo '================================================'
\echo ''

-- ============================================
-- 4. INFORMACIÓN DE CUADRILLAS DISPONIBLES
-- ============================================

\echo '--- CUADRILLAS DISPONIBLES EN EL SISTEMA ---'
\echo ''

SELECT 
    c.cuadrilla_id,
    c.nombre as cuadrilla,
    c.especialidad,
    COUNT(ec.empleado_id) as cantidad_operarios,
    STRING_AGG(e.nombre || ' ' || e.apellido, ', ' ORDER BY e.apellido) as operarios
FROM cuadrilla c
LEFT JOIN empleado_cuadrilla ec ON c.cuadrilla_id = ec.cuadrilla_id
LEFT JOIN empleado e ON ec.empleado_id = e.empleado_id
WHERE c.activo = true
GROUP BY c.cuadrilla_id, c.nombre, c.especialidad
ORDER BY c.cuadrilla_id;

\echo ''
\echo '================================================'
\echo ''

-- ============================================
-- 5. DETALLE DE OTs LIBERADAS
-- ============================================

\echo '--- DETALLE DE OTs LIBERADAS ---'
\echo ''

SELECT 
    ot.ot_id,
    r.reclamo_id,
    s.nombre || ' ' || s.apellido as socio,
    c.direccion,
    c.localidad,
    dtr.nombre as tipo_reclamo,
    r.prioridad,
    r.descripcion as descripcion_problema,
    ot.observaciones
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE ot.ot_id IN (SELECT ot_id FROM ots_a_liberar)
ORDER BY r.prioridad DESC, ot.ot_id;

\echo ''
\echo '================================================'
\echo '  PREPARACIÓN COMPLETADA EXITOSAMENTE'
\echo '================================================'
\echo ''
\echo 'Próximos pasos:'
\echo '1. Recarga la aplicación web en http://localhost:3002/dashboard/admin/itinerario'
\echo '2. Deberías ver el botón "Solo Disponibles (X)" con las OTs liberadas'
\echo '3. Puedes asignar estas OTs a las cuadrillas disponibles'
\echo ''
\echo 'Para asignar una OT a una cuadrilla, el campo observaciones debe contener:'
\echo '[ITINERARIO: YYYY-MM-DD CUADRILLA_ID]'
\echo 'Ejemplo: [ITINERARIO: 2025-10-10 1]'
\echo ''

-- Limpiar tabla temporal
DROP TABLE IF EXISTS ots_a_liberar;
