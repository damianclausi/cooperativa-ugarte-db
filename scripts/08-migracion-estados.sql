-- ===========================================
-- MIGRACIÓN: Actualizar estados EN_PROCESO → EN CURSO
-- ===========================================
-- Fecha: Octubre 2025
-- Descripción: Cambia todos los estados 'EN_PROCESO' a 'EN CURSO'
--              en las tablas reclamo y orden_trabajo
-- ===========================================

-- Verificar si la migración ya se aplicó
DO $$
DECLARE
    migracion_aplicada BOOLEAN := FALSE;
BEGIN
    -- Verificar si ya no existen estados EN_PROCESO (indica migración aplicada)
    IF NOT EXISTS (
        SELECT 1 FROM reclamo WHERE estado = 'EN_PROCESO'
        UNION
        SELECT 1 FROM orden_trabajo WHERE estado = 'EN_PROCESO'
    ) THEN
        migracion_aplicada := TRUE;
    END IF;

    IF migracion_aplicada THEN
        RAISE NOTICE 'La migración de estados ya se aplicó. Saltando...';
        RETURN;
    END IF;

    RAISE NOTICE 'Aplicando migración de estados EN_PROCESO → EN CURSO...';
END $$;

-- Actualizar estados en tabla reclamo
UPDATE reclamo SET estado = 'EN CURSO' WHERE estado = 'EN_PROCESO';

-- Actualizar estados en tabla orden_trabajo
UPDATE orden_trabajo SET estado = 'EN CURSO' WHERE estado = 'EN_PROCESO';

-- Verificar cambios
DO $$
DECLARE
    reclamos_actualizados INT;
    ordenes_actualizadas INT;
BEGIN
    SELECT COUNT(*) INTO reclamos_actualizados FROM reclamo WHERE estado = 'EN CURSO';
    SELECT COUNT(*) INTO ordenes_actualizadas FROM orden_trabajo WHERE estado = 'EN CURSO';

    RAISE NOTICE '=== MIGRACIÓN COMPLETADA ===';
    RAISE NOTICE 'Reclamos con estado EN CURSO: %', reclamos_actualizados;
    RAISE NOTICE 'Órdenes de trabajo con estado EN CURSO: %', ordenes_actualizadas;
    RAISE NOTICE 'Estados EN_PROCESO actualizados exitosamente a EN CURSO';
END $$;