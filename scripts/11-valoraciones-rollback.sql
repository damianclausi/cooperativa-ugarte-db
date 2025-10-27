-- ============================================================================
-- SCRIPT: Rollback del Sistema de Valoración de Reclamos
-- Proyecto: Sistema de Gestión Cooperativa Eléctrica
-- Fecha: 27/10/2025
-- Versión: 1.12 Rollback
-- ============================================================================
-- 
-- DESCRIPCIÓN:
-- Este script revierte completamente los cambios del sistema de valoraciones,
-- eliminando la tabla, índices, triggers, funciones y vistas creadas.
--
-- ADVERTENCIA:
-- Este script eliminará PERMANENTEMENTE todos los datos de valoraciones.
-- Asegúrese de hacer un backup antes de ejecutar.
--
-- USO:
-- psql -U coop_user -d cooperativa_ugarte_db -f 11-valoraciones-rollback.sql
--
-- ============================================================================

\c cooperativa_ugarte_db;

DO $$
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'INICIANDO ROLLBACK DEL SISTEMA DE VALORACIONES';
    RAISE NOTICE '============================================';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 1: Eliminar vistas
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '📋 Eliminando vistas...';
END $$;

DROP VIEW IF EXISTS v_valoraciones_por_empleado CASCADE;
DROP VIEW IF EXISTS v_valoraciones_por_tipo_reclamo CASCADE;
DROP VIEW IF EXISTS v_valoraciones_detalle CASCADE;
DROP VIEW IF EXISTS v_estadisticas_valoraciones CASCADE;

DO $$
BEGIN
    RAISE NOTICE '✓ Vistas eliminadas correctamente';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 2: Eliminar triggers
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '🔧 Eliminando triggers...';
END $$;

DROP TRIGGER IF EXISTS trg_validar_valoracion ON valoracion;

DO $$
BEGIN
    RAISE NOTICE '✓ Triggers eliminados correctamente';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 3: Eliminar funciones
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '⚙️ Eliminando funciones...';
END $$;

DROP FUNCTION IF EXISTS validar_reclamo_para_valoracion() CASCADE;

DO $$
BEGIN
    RAISE NOTICE '✓ Funciones eliminadas correctamente';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 4: Verificar y reportar datos a eliminar
-- ============================================================================

DO $$
DECLARE
    v_total_valoraciones INTEGER;
BEGIN
    RAISE NOTICE '📊 Verificando datos existentes...';
    
    SELECT COUNT(*) INTO v_total_valoraciones FROM valoracion;
    
    IF v_total_valoraciones > 0 THEN
        RAISE WARNING 'Se eliminarán % valoraciones existentes', v_total_valoraciones;
    ELSE
        RAISE NOTICE '✓ No hay valoraciones en la base de datos';
    END IF;
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 5: Eliminar tabla valoracion (incluye índices automáticamente)
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '🗑️ Eliminando tabla valoracion...';
END $$;

DROP TABLE IF EXISTS valoracion CASCADE;

DO $$
BEGIN
    RAISE NOTICE '✓ Tabla valoracion eliminada correctamente';
    RAISE NOTICE '✓ Todos los índices asociados eliminados automáticamente';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- PASO 6: Verificación final
-- ============================================================================

DO $$
DECLARE
    v_tabla_existe BOOLEAN;
BEGIN
    RAISE NOTICE '🔍 Verificación final...';
    
    -- Verificar que la tabla no existe
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'valoracion'
    ) INTO v_tabla_existe;
    
    IF v_tabla_existe THEN
        RAISE EXCEPTION '❌ ERROR: La tabla valoracion aún existe después del rollback';
    ELSE
        RAISE NOTICE '✓ Confirmado: Tabla valoracion eliminada';
    END IF;
    
    -- Verificar que las vistas no existen
    IF EXISTS (
        SELECT 1 FROM information_schema.views 
        WHERE table_schema = 'public' 
        AND table_name LIKE 'v_valoraciones%'
    ) THEN
        RAISE EXCEPTION '❌ ERROR: Algunas vistas de valoraciones aún existen';
    ELSE
        RAISE NOTICE '✓ Confirmado: Vistas eliminadas';
    END IF;
    
    -- Verificar que la función no existe
    IF EXISTS (
        SELECT 1 FROM pg_proc 
        WHERE proname = 'validar_reclamo_para_valoracion'
    ) THEN
        RAISE EXCEPTION '❌ ERROR: La función validar_reclamo_para_valoracion aún existe';
    ELSE
        RAISE NOTICE '✓ Confirmado: Funciones eliminadas';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
    RAISE NOTICE '✅ ROLLBACK COMPLETADO EXITOSAMENTE';
    RAISE NOTICE '============================================';
    RAISE NOTICE '';
    RAISE NOTICE 'El sistema de valoraciones ha sido completamente eliminado.';
    RAISE NOTICE 'La base de datos ha vuelto al estado anterior.';
    RAISE NOTICE '';
END $$;

-- ============================================================================
-- Mensaje final
-- ============================================================================

\echo ''
\echo '📝 RESUMEN DEL ROLLBACK:'
\echo '  - Tabla valoracion: ELIMINADA'
\echo '  - Índices (5): ELIMINADOS'
\echo '  - Vistas (4): ELIMINADAS'
\echo '  - Triggers (1): ELIMINADO'
\echo '  - Funciones (1): ELIMINADA'
\echo ''
\echo '⚠️  IMPORTANTE: Todos los datos de valoraciones han sido eliminados permanentemente.'
\echo ''
\echo '✅ Rollback finalizado correctamente'
\echo ''
