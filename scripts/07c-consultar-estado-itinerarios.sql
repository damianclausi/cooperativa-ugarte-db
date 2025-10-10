-- ============================================
-- CONSULTA: ESTADO ACTUAL DEL SISTEMA DE ITINERARIOS
-- Solo consulta, no modifica datos
-- ============================================

\echo ''
\echo '================================================'
\echo '  ESTADO ACTUAL DEL SISTEMA DE ITINERARIOS'
\echo '================================================'
\echo ''

-- 1. Resumen General de OTs Técnicas
\echo '--- RESUMEN GENERAL DE OTs TÉCNICAS ---'
SELECT 
    ot.estado,
    COUNT(*) as total,
    SUM(CASE WHEN ot.empleado_id IS NULL THEN 1 ELSE 0 END) as sin_asignar,
    SUM(CASE WHEN ot.empleado_id IS NOT NULL THEN 1 ELSE 0 END) as asignadas,
    SUM(CASE WHEN ot.observaciones LIKE '%[ITINERARIO:%' THEN 1 ELSE 0 END) as en_itinerario
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
GROUP BY ot.estado
ORDER BY ot.estado;

\echo ''

-- 2. OTs Disponibles para Asignar a Itinerarios
\echo '--- OTs DISPONIBLES PARA ITINERARIOS ---'
\echo '(PENDIENTE + empleado_id NULL + sin [ITINERARIO:])'
SELECT COUNT(*) as disponibles
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.estado = 'PENDIENTE'
    AND ot.empleado_id IS NULL
    AND (ot.observaciones IS NULL OR ot.observaciones NOT LIKE '%[ITINERARIO:%');

\echo ''

-- 3. Detalle de OTs Disponibles
\echo '--- DETALLE DE OTs DISPONIBLES ---'
SELECT 
    ot.ot_id,
    s.nombre || ' ' || s.apellido as socio,
    c.direccion,
    c.localidad,
    dtr.nombre as tipo_problema,
    r.prioridad,
    LEFT(r.descripcion, 50) || '...' as descripcion
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.estado = 'PENDIENTE'
    AND ot.empleado_id IS NULL
    AND (ot.observaciones IS NULL OR ot.observaciones NOT LIKE '%[ITINERARIO:%')
ORDER BY r.prioridad DESC, ot.ot_id;

\echo ''

-- 4. OTs en Itinerarios Activos
\echo '--- OTs EN ITINERARIOS ACTIVOS ---'
SELECT 
    ot.ot_id,
    s.nombre || ' ' || s.apellido as socio,
    CASE 
        WHEN ot.empleado_id IS NULL THEN '⏳ Sin tomar'
        ELSE '✅ Tomada por ' || e.nombre || ' ' || e.apellido
    END as estado_itinerario,
    SUBSTRING(ot.observaciones FROM '\[ITINERARIO:[^\]]+\]') as itinerario,
    r.prioridad
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
LEFT JOIN empleado e ON ot.empleado_id = e.empleado_id
WHERE ot.observaciones LIKE '%[ITINERARIO:%'
ORDER BY ot.ot_id;

\echo ''

-- 5. Cuadrillas del Sistema
\echo '--- CUADRILLAS DISPONIBLES ---'
SELECT 
    c.cuadrilla_id,
    c.nombre as cuadrilla,
    c.especialidad,
    c.activo,
    COUNT(ec.empleado_id) as cantidad_operarios,
    STRING_AGG(e.nombre || ' ' || e.apellido, ', ' ORDER BY e.apellido) as operarios
FROM cuadrilla c
LEFT JOIN empleado_cuadrilla ec ON c.cuadrilla_id = ec.cuadrilla_id
LEFT JOIN empleado e ON ec.empleado_id = e.empleado_id
GROUP BY c.cuadrilla_id, c.nombre, c.especialidad, c.activo
ORDER BY c.cuadrilla_id;

\echo ''

-- 6. OTs Candidatas para Liberar
\echo '--- OTs CANDIDATAS PARA LIBERAR ---'
\echo '(Si necesitas más OTs disponibles para itinerarios)'
SELECT COUNT(*) as candidatas
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
