-- ============================================================================
-- SCRIPT: Crear Itinerarios de Prueba para Diciembre 2025
-- Proyecto: Sistema de Gestión Cooperativa Eléctrica
-- Fecha: 11/10/2025
-- ============================================================================
-- 
-- DESCRIPCIÓN:
-- Este script crea reclamos técnicos de prueba y los asigna al itinerario
-- de "Cuadrilla Centro" para el mes de diciembre 2025.
-- Algunas OTs quedarán disponibles para tomar, y otras ya estarán tomadas por Pedro.
--
-- DISTRIBUCIÓN POR FECHA:
-- - 3 OTs totales por fecha
--   * 2 OTs tomadas por Pedro (empleado_id = 1)
--   * 1 OT disponible para tomar (empleado_id = NULL)
--
-- FECHAS:
-- 02, 03, 04, 05, 09, 10, 11, 12, 16, 17, 18, 19, 22, 23, 26 de diciembre 2025
--
-- ============================================================================

\c cooperativa_ugarte_db;

-- ============================================================================
-- VERIFICAR PREREQUISITOS
-- ============================================================================
DO $$
DECLARE
    v_cuadrilla_id INTEGER;
    v_cuenta_id INTEGER;
    v_pedro_id INTEGER;
    v_contador INTEGER := 0;
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE '🔍 VERIFICANDO PREREQUISITOS';
    RAISE NOTICE '============================================';
    
    -- Verificar cuadrilla
    SELECT cuadrilla_id INTO v_cuadrilla_id 
    FROM cuadrilla 
    WHERE nombre = 'Cuadrilla Centro' AND activa = true
    LIMIT 1;
    
    IF v_cuadrilla_id IS NULL THEN
        RAISE EXCEPTION '❌ No existe la cuadrilla "Cuadrilla Centro" activa.';
    END IF;
    RAISE NOTICE '✅ Cuadrilla encontrada: ID %', v_cuadrilla_id;
    
    -- Verificar cuentas
    SELECT COUNT(*) INTO v_contador FROM cuenta;
    IF v_contador < 3 THEN
        RAISE EXCEPTION '❌ Se necesitan al menos 3 cuentas en la base de datos.';
    END IF;
    RAISE NOTICE '✅ Cuentas disponibles: %', v_contador;
    
    -- Verificar Pedro (empleado_id = 1)
    SELECT empleado_id INTO v_pedro_id 
    FROM empleado 
    WHERE empleado_id = 1 AND activo = true;
    
    IF v_pedro_id IS NULL THEN
        RAISE EXCEPTION '❌ No existe el empleado Pedro (empleado_id = 1).';
    END IF;
    RAISE NOTICE '✅ Empleado Pedro encontrado: ID %', v_pedro_id;
    
    -- Verificar tipos de reclamo técnico
    SELECT COUNT(*) INTO v_contador 
    FROM detalle_tipo_reclamo dtr
    JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
    WHERE tr.nombre = 'TECNICO';
    
    IF v_contador < 5 THEN
        RAISE EXCEPTION '❌ Se necesitan al menos 5 tipos de reclamos técnicos.';
    END IF;
    RAISE NOTICE '✅ Tipos de reclamos técnicos disponibles: %', v_contador;
    
    RAISE NOTICE '============================================';
END $$;

-- ============================================================================
-- FUNCIÓN AUXILIAR: Crear OT con Itinerario
-- ============================================================================
CREATE OR REPLACE FUNCTION crear_ot_con_itinerario(
    p_fecha DATE,
    p_cuenta_id INTEGER,
    p_detalle_id INTEGER,
    p_descripcion TEXT,
    p_empleado_id INTEGER DEFAULT NULL,
    p_cuadrilla_id INTEGER DEFAULT 1
) RETURNS void AS $$
DECLARE
    v_itinerario_id INTEGER;
    v_reclamo_id INTEGER;
    v_ot_id INTEGER;
    v_observaciones TEXT;
BEGIN
    -- Determinar observaciones según asignación
    IF p_empleado_id IS NOT NULL THEN
        v_observaciones := 'OT tomada por operario';
    ELSE
        v_observaciones := 'Disponible para asignación a itinerario';
    END IF;
    
    -- Buscar o crear itinerario para la fecha
    SELECT itinerario_id INTO v_itinerario_id
    FROM itinerario
    WHERE fecha = p_fecha 
    AND cuadrilla_id = p_cuadrilla_id
    LIMIT 1;
    
    IF v_itinerario_id IS NULL THEN
        INSERT INTO itinerario (cuadrilla_id, fecha, turno, estado, observaciones)
        VALUES (p_cuadrilla_id, p_fecha, 'MAÑANA', 'PLANIFICADO', 
                'Itinerario automático - Diciembre 2025')
        RETURNING itinerario_id INTO v_itinerario_id;
    END IF;
    
    -- Crear reclamo
    INSERT INTO reclamo (
        cuenta_id, detalle_id, descripcion, 
        prioridad_id, estado, fecha_alta
    )
    VALUES (
        p_cuenta_id, 
        p_detalle_id, 
        p_descripcion,
        2, -- Prioridad MEDIA
        CASE WHEN p_empleado_id IS NOT NULL THEN 'EN CURSO' ELSE 'PENDIENTE' END,
        CURRENT_TIMESTAMP
    )
    RETURNING reclamo_id INTO v_reclamo_id;
    
    -- Crear OT
    INSERT INTO orden_trabajo (
        reclamo_id, empleado_id, estado, 
        fecha_programada, observaciones, created_at
    )
    VALUES (
        v_reclamo_id,
        p_empleado_id,
        CASE WHEN p_empleado_id IS NOT NULL THEN 'ASIGNADA' ELSE 'PENDIENTE' END,
        p_fecha,
        v_observaciones,
        CURRENT_TIMESTAMP
    )
    RETURNING ot_id INTO v_ot_id;
    
    -- Vincular OT al itinerario
    INSERT INTO itinerario_detalle (itinerario_id, ot_id, orden, estado)
    VALUES (
        v_itinerario_id,
        v_ot_id,
        (SELECT COALESCE(MAX(orden), 0) + 1 FROM itinerario_detalle WHERE itinerario_id = v_itinerario_id),
        'PENDIENTE'
    );
    
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- CREAR ITINERARIOS Y OTs PARA DICIEMBRE 2025
-- ============================================================================

DO $$
DECLARE
    v_cuentas INTEGER[] := ARRAY[1, 2, 3, 4, 5, 6];
    v_cuenta_idx INTEGER;
    v_detalle_corte INTEGER;
    v_detalle_tension INTEGER;
    v_detalle_poste INTEGER;
    v_detalle_cable INTEGER;
    v_detalle_medidor INTEGER;
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE '📅 CREANDO ITINERARIOS DICIEMBRE 2025';
    RAISE NOTICE '============================================';
    
    -- Obtener IDs de detalles de reclamo técnico
    SELECT detalle_id INTO v_detalle_corte 
    FROM detalle_tipo_reclamo WHERE nombre ILIKE '%corte%' LIMIT 1;
    
    SELECT detalle_id INTO v_detalle_tension 
    FROM detalle_tipo_reclamo WHERE nombre ILIKE '%tensión%' OR nombre ILIKE '%tension%' LIMIT 1;
    
    SELECT detalle_id INTO v_detalle_poste 
    FROM detalle_tipo_reclamo WHERE nombre ILIKE '%poste%' LIMIT 1;
    
    SELECT detalle_id INTO v_detalle_cable 
    FROM detalle_tipo_reclamo WHERE nombre ILIKE '%cable%' LIMIT 1;
    
    SELECT detalle_id INTO v_detalle_medidor 
    FROM detalle_tipo_reclamo WHERE nombre ILIKE '%medidor%' LIMIT 1;
    
    -- Si no existen, usar IDs genéricos
    v_detalle_corte := COALESCE(v_detalle_corte, 1);
    v_detalle_tension := COALESCE(v_detalle_tension, 2);
    v_detalle_poste := COALESCE(v_detalle_poste, 3);
    v_detalle_cable := COALESCE(v_detalle_cable, 4);
    v_detalle_medidor := COALESCE(v_detalle_medidor, 5);
    
    RAISE NOTICE 'Creando itinerarios con 3 OTs por fecha...';
    RAISE NOTICE '  - 2 OTs asignadas a Pedro (empleado_id=1)';
    RAISE NOTICE '  - 1 OT disponible para tomar (empleado_id=NULL)';
    RAISE NOTICE '';
    
    -- ========== 02/12/2025 (Martes) ==========
    RAISE NOTICE '📆 02/12/2025 - Martes';
    PERFORM crear_ot_con_itinerario('2025-12-02', 1, v_detalle_corte, 
        'Corte de luz en sector residencial', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-02', 2, v_detalle_tension, 
        'Baja tensión en zona comercial', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-02', 3, v_detalle_poste, 
        'Poste inclinado - peligro', NULL, 1);
    
    -- ========== 03/12/2025 (Miércoles) ==========
    RAISE NOTICE '📆 03/12/2025 - Miércoles';
    PERFORM crear_ot_con_itinerario('2025-12-03', 4, v_detalle_cable, 
        'Cable cortado en calle principal', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-03', 5, v_detalle_medidor, 
        'Medidor defectuoso - lectura incorrecta', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-03', 6, v_detalle_corte, 
        'Corte intermitente de energía', NULL, 1);
    
    -- ========== 04/12/2025 (Jueves) ==========
    RAISE NOTICE '📆 04/12/2025 - Jueves';
    PERFORM crear_ot_con_itinerario('2025-12-04', 1, v_detalle_tension, 
        'Variaciones de tensión constantes', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-04', 2, v_detalle_poste, 
        'Reemplazo de poste deteriorado', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-04', 3, v_detalle_cable, 
        'Revisión de cables en mal estado', NULL, 1);
    
    -- ========== 05/12/2025 (Viernes) ==========
    RAISE NOTICE '📆 05/12/2025 - Viernes';
    PERFORM crear_ot_con_itinerario('2025-12-05', 4, v_detalle_medidor, 
        'Instalación de nuevo medidor', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-05', 5, v_detalle_corte, 
        'Sin suministro hace 24hs', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-05', 6, v_detalle_tension, 
        'Tensión insuficiente para equipos', NULL, 1);
    
    -- ========== 09/12/2025 (Martes) ==========
    RAISE NOTICE '📆 09/12/2025 - Martes';
    PERFORM crear_ot_con_itinerario('2025-12-09', 1, v_detalle_poste, 
        'Poste con grietas - inspección', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-09', 2, v_detalle_cable, 
        'Cable colgando bajo - peligroso', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-09', 3, v_detalle_corte, 
        'Corte total - zona afectada', NULL, 1);
    
    -- ========== 10/12/2025 (Miércoles) ==========
    RAISE NOTICE '📆 10/12/2025 - Miércoles';
    PERFORM crear_ot_con_itinerario('2025-12-10', 4, v_detalle_medidor, 
        'Medidor quemado por sobretensión', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-10', 5, v_detalle_tension, 
        'Picos de tensión dañan electrodomésticos', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-10', 6, v_detalle_poste, 
        'Poste inclinado por tormenta', NULL, 1);
    
    -- ========== 11/12/2025 (Jueves) ==========
    RAISE NOTICE '📆 11/12/2025 - Jueves';
    PERFORM crear_ot_con_itinerario('2025-12-11', 1, v_detalle_cable, 
        'Empalme en mal estado - chispas', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-11', 2, v_detalle_corte, 
        'Corte frecuente en horario nocturno', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-11', 3, v_detalle_medidor, 
        'Cambio de medidor antiguo', NULL, 1);
    
    -- ========== 12/12/2025 (Viernes) ==========
    RAISE NOTICE '📆 12/12/2025 - Viernes';
    PERFORM crear_ot_con_itinerario('2025-12-12', 4, v_detalle_tension, 
        'Baja tensión afecta todo el edificio', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-12', 5, v_detalle_poste, 
        'Mantenimiento preventivo de poste', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-12', 6, v_detalle_cable, 
        'Cable pelado - riesgo eléctrico', NULL, 1);
    
    -- ========== 16/12/2025 (Martes) ==========
    RAISE NOTICE '📆 16/12/2025 - Martes';
    PERFORM crear_ot_con_itinerario('2025-12-16', 1, v_detalle_corte, 
        'Corte programado por obras', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-16', 2, v_detalle_medidor, 
        'Medidor con display apagado', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-16', 3, v_detalle_tension, 
        'Sobretensión recurrente', NULL, 1);
    
    -- ========== 17/12/2025 (Miércoles) ==========
    RAISE NOTICE '📆 17/12/2025 - Miércoles';
    PERFORM crear_ot_con_itinerario('2025-12-17', 4, v_detalle_poste, 
        'Poste con cableado sobrecargado', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-17', 5, v_detalle_cable, 
        'Revisión general de cableado aéreo', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-17', 6, v_detalle_corte, 
        'Falta de energía total', NULL, 1);
    
    -- ========== 18/12/2025 (Jueves) ==========
    RAISE NOTICE '📆 18/12/2025 - Jueves';
    PERFORM crear_ot_con_itinerario('2025-12-18', 1, v_detalle_medidor, 
        'Medidor con lectura errática', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-18', 2, v_detalle_tension, 
        'Fluctuaciones de voltaje', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-18', 3, v_detalle_poste, 
        'Poste requiere refuerzo estructural', NULL, 1);
    
    -- ========== 19/12/2025 (Viernes) ==========
    RAISE NOTICE '📆 19/12/2025 - Viernes';
    PERFORM crear_ot_con_itinerario('2025-12-19', 4, v_detalle_cable, 
        'Cable en riesgo de ruptura', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-19', 5, v_detalle_corte, 
        'Corte por falla en transformador', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-19', 6, v_detalle_medidor, 
        'Calibración de medidor', NULL, 1);
    
    -- ========== 22/12/2025 (Lunes) ==========
    RAISE NOTICE '📆 22/12/2025 - Lunes';
    PERFORM crear_ot_con_itinerario('2025-12-22', 1, v_detalle_tension, 
        'Tensión irregular post-tormenta', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-22', 2, v_detalle_poste, 
        'Inspección de seguridad de poste', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-22', 3, v_detalle_cable, 
        'Reemplazo de cable deteriorado', NULL, 1);
    
    -- ========== 23/12/2025 (Martes) ==========
    RAISE NOTICE '📆 23/12/2025 - Martes';
    PERFORM crear_ot_con_itinerario('2025-12-23', 4, v_detalle_corte, 
        'Corte en horario comercial', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-23', 5, v_detalle_medidor, 
        'Medidor bloqueado - no registra', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-23', 6, v_detalle_tension, 
        'Baja tensión generalizada', NULL, 1);
    
    -- ========== 26/12/2025 (Viernes) ==========
    RAISE NOTICE '📆 26/12/2025 - Viernes';
    PERFORM crear_ot_con_itinerario('2025-12-26', 1, v_detalle_poste, 
        'Mantenimiento fin de año', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-26', 2, v_detalle_cable, 
        'Revisión preventiva de red', 1, 1);
    PERFORM crear_ot_con_itinerario('2025-12-26', 3, v_detalle_corte, 
        'Cierre técnico de año', NULL, 1);
    
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
    RAISE NOTICE '✅ ITINERARIOS CREADOS EXITOSAMENTE';
    RAISE NOTICE '============================================';
END $$;

-- ============================================================================
-- REPORTE FINAL
-- ============================================================================

DO $$
DECLARE
    v_total_itinerarios INTEGER;
    v_total_ots INTEGER;
    v_ots_asignadas INTEGER;
    v_ots_disponibles INTEGER;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
    RAISE NOTICE '📊 RESUMEN DE ITINERARIOS DICIEMBRE 2025';
    RAISE NOTICE '============================================';
    
    -- Contar itinerarios
    SELECT COUNT(*) INTO v_total_itinerarios
    FROM itinerario
    WHERE fecha BETWEEN '2025-12-01' AND '2025-12-31';
    
    RAISE NOTICE 'Total de itinerarios: %', v_total_itinerarios;
    
    -- Contar OTs totales
    SELECT COUNT(*) INTO v_total_ots
    FROM orden_trabajo
    WHERE fecha_programada BETWEEN '2025-12-01' AND '2025-12-31';
    
    RAISE NOTICE 'Total de OTs creadas: %', v_total_ots;
    
    -- Contar OTs asignadas a Pedro
    SELECT COUNT(*) INTO v_ots_asignadas
    FROM orden_trabajo
    WHERE fecha_programada BETWEEN '2025-12-01' AND '2025-12-31'
    AND empleado_id = 1;
    
    RAISE NOTICE 'OTs asignadas a Pedro: %', v_ots_asignadas;
    
    -- Contar OTs disponibles
    SELECT COUNT(*) INTO v_ots_disponibles
    FROM orden_trabajo
    WHERE fecha_programada BETWEEN '2025-12-01' AND '2025-12-31'
    AND empleado_id IS NULL;
    
    RAISE NOTICE 'OTs disponibles para tomar: %', v_ots_disponibles;
    RAISE NOTICE '';
    RAISE NOTICE '🎯 Distribución por fecha: 3 OTs';
    RAISE NOTICE '   - 2 asignadas a Pedro';
    RAISE NOTICE '   - 1 disponible para tomar';
    RAISE NOTICE '';
    RAISE NOTICE '✨ Los operarios pueden ahora:';
    RAISE NOTICE '   1. Ver itinerario con fechas de diciembre 2025';
    RAISE NOTICE '   2. Ver OTs del día (asignadas + disponibles)';
    RAISE NOTICE '   3. Tomar las OTs disponibles';
    RAISE NOTICE '   4. Trabajar en sus OTs asignadas';
    RAISE NOTICE '';
    RAISE NOTICE '============================================';
END $$;

-- Limpiar función temporal
DROP FUNCTION IF EXISTS crear_ot_con_itinerario;

-- Mensaje final
\echo ''
\echo '✅ Script de itinerarios diciembre 2025 completado'
\echo ''
