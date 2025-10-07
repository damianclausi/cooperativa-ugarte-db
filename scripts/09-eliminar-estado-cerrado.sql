-- ===========================================
-- MIGRACIÓN: Eliminar estado CERRADO
-- ===========================================
-- Fecha: Octubre 2025
-- Descripción: Elimina cualquier registro con estado 'CERRADO'
--              de las tablas reclamo y orden_trabajo
-- ===========================================

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