-- ===========================================
-- MIGRACIÓN: Eliminar estado CERRADO
-- ===========================================
-- Fecha: Octubre 2025
-- Descripción: Elimina cualquier registro con estado 'CERRADO'
--              de las tablas reclamo y orden_trabajo
-- ===========================================

-- Verificar si la migración ya se aplicó
DO $$
DECLARE
    migracion_aplicada BOOLEAN := FALSE;
BEGIN
    -- Verificar si ya no existen estados CERRADO (indica migración aplicada)
    IF NOT EXISTS (
        SELECT 1 FROM reclamo WHERE estado = 'CERRADO'
        UNION
        SELECT 1 FROM orden_trabajo WHERE estado = 'CERRADO'
    ) THEN
        migracion_aplicada := TRUE;
    END IF;

    IF migracion_aplicada THEN
        RAISE NOTICE 'La eliminación de estado CERRADO ya se aplicó. Saltando...';
        RETURN;
    END IF;

    RAISE NOTICE 'Aplicando eliminación de estado CERRADO...';
END $$;

-- Eliminar registros con estado CERRADO en tabla reclamo
DELETE FROM reclamo WHERE estado = 'CERRADO';

-- Eliminar registros con estado CERRADO en tabla orden_trabajo
DELETE FROM orden_trabajo WHERE estado = 'CERRADO';

-- Verificar que no quedan registros con estado CERRADO
DO $$
DECLARE
    reclamos_cerrados INT;
    ordenes_cerradas INT;
BEGIN
    SELECT COUNT(*) INTO reclamos_cerrados FROM reclamo WHERE estado = 'CERRADO';
    SELECT COUNT(*) INTO ordenes_cerradas FROM orden_trabajo WHERE estado = 'CERRADO';

    RAISE NOTICE '=== LIMPIEZA COMPLETADA ===';
    RAISE NOTICE 'Reclamos con estado CERRADO eliminados: %', reclamos_cerrados;
    RAISE NOTICE 'Órdenes de trabajo con estado CERRADO eliminadas: %', ordenes_cerradas;
    RAISE NOTICE 'Estado CERRADO eliminado completamente del sistema';
END $$;