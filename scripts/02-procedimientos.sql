-- ============================================
-- PROCEDIMIENTOS ALMACENADOS PARA PPIV_DB
-- ============================================

-- 1. PROCEDIMIENTO PARA CREAR NUEVA CUENTA
-- ============================================

CREATE OR REPLACE FUNCTION crear_nueva_cuenta(
    p_socio_id INTEGER,
    p_numero_cuenta VARCHAR(50),
    p_direccion TEXT,
    p_localidad VARCHAR(100),
    p_servicio_id INTEGER,
    p_es_principal BOOLEAN DEFAULT false
)
RETURNS INTEGER AS $$
DECLARE
    v_cuenta_id INTEGER;
    v_socio_existe BOOLEAN;
    v_servicio_existe BOOLEAN;
    v_numero_existe BOOLEAN;
BEGIN
    -- Verificar que el socio existe
    SELECT EXISTS(SELECT 1 FROM socio WHERE socio_id = p_socio_id AND activo = true) INTO v_socio_existe;
    IF NOT v_socio_existe THEN
        RAISE EXCEPTION 'El socio con ID % no existe o no está activo', p_socio_id;
    END IF;
    
    -- Verificar que el servicio existe
    SELECT EXISTS(SELECT 1 FROM servicio WHERE servicio_id = p_servicio_id AND activo = true) INTO v_servicio_existe;
    IF NOT v_servicio_existe THEN
        RAISE EXCEPTION 'El servicio con ID % no existe o no está activo', p_servicio_id;
    END IF;
    
    -- Verificar que el número de cuenta no existe
    SELECT EXISTS(SELECT 1 FROM cuenta WHERE numero_cuenta = p_numero_cuenta) INTO v_numero_existe;
    IF v_numero_existe THEN
        RAISE EXCEPTION 'El número de cuenta % ya existe', p_numero_cuenta;
    END IF;
    
    -- Si es principal, desmarcar otras cuentas principales del mismo socio
    IF p_es_principal THEN
        UPDATE cuenta SET principal = false 
        WHERE socio_id = p_socio_id AND principal = true;
    END IF;
    
    -- Crear la cuenta
    INSERT INTO cuenta (socio_id, numero_cuenta, direccion, localidad, servicio_id, principal)
    VALUES (p_socio_id, p_numero_cuenta, p_direccion, p_localidad, p_servicio_id, p_es_principal)
    RETURNING cuenta_id INTO v_cuenta_id;
    
    RETURN v_cuenta_id;
END;
$$ LANGUAGE plpgsql;

-- 2. PROCEDIMIENTO PARA REGISTRAR LECTURA
-- ============================================

CREATE OR REPLACE FUNCTION registrar_lectura(
    p_medidor_id INTEGER,
    p_estado_actual INTEGER,
    p_fecha DATE DEFAULT CURRENT_DATE,
    p_ruta VARCHAR(100) DEFAULT NULL,
    p_observaciones TEXT DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_lectura_id INTEGER;
    v_ultimo_estado INTEGER;
    v_medidor_existe BOOLEAN;
BEGIN
    -- Verificar que el medidor existe
    SELECT EXISTS(SELECT 1 FROM medidor WHERE medidor_id = p_medidor_id AND activo = true) INTO v_medidor_existe;
    IF NOT v_medidor_existe THEN
        RAISE EXCEPTION 'El medidor con ID % no existe o no está activo', p_medidor_id;
    END IF;
    
    -- Obtener el último estado
    SELECT COALESCE(MAX(estado_actual), 0) INTO v_ultimo_estado
    FROM lectura 
    WHERE medidor_id = p_medidor_id;
    
    -- Validar que el nuevo estado sea mayor al anterior
    IF p_estado_actual < v_ultimo_estado THEN
        RAISE EXCEPTION 'El estado actual (%) no puede ser menor al último estado registrado (%)', 
                        p_estado_actual, v_ultimo_estado;
    END IF;
    
    -- Insertar la lectura
    INSERT INTO lectura (medidor_id, fecha, estado_anterior, estado_actual, ruta, observaciones)
    VALUES (p_medidor_id, p_fecha, v_ultimo_estado, p_estado_actual, p_ruta, p_observaciones)
    RETURNING lectura_id INTO v_lectura_id;
    
    RETURN v_lectura_id;
END;
$$ LANGUAGE plpgsql;

-- 3. PROCEDIMIENTO PARA CREAR RECLAMO CON OT
-- ============================================

CREATE OR REPLACE FUNCTION crear_reclamo_con_ot(
    p_cuenta_id INTEGER,
    p_tipo_id INTEGER,
    p_prioridad_id INTEGER,
    p_descripcion TEXT,
    p_canal VARCHAR(50) DEFAULT 'WEB',
    p_empleado_id INTEGER DEFAULT NULL,
    p_fecha_programada TIMESTAMP DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
    v_reclamo_id INTEGER;
    v_ot_id INTEGER;
    v_cuenta_existe BOOLEAN;
    v_direccion TEXT;
    v_resultado JSON;
BEGIN
    -- Verificar que la cuenta existe
    SELECT EXISTS(SELECT 1 FROM cuenta WHERE cuenta_id = p_cuenta_id AND activa = true) INTO v_cuenta_existe;
    IF NOT v_cuenta_existe THEN
        RAISE EXCEPTION 'La cuenta con ID % no existe o no está activa', p_cuenta_id;
    END IF;
    
    -- Obtener dirección de la cuenta
    SELECT direccion INTO v_direccion FROM cuenta WHERE cuenta_id = p_cuenta_id;
    
    -- Crear el reclamo
    INSERT INTO reclamo (cuenta_id, tipo_id, prioridad_id, descripcion, canal)
    VALUES (p_cuenta_id, p_tipo_id, p_prioridad_id, p_descripcion, p_canal)
    RETURNING reclamo_id INTO v_reclamo_id;
    
    -- Crear la orden de trabajo
    INSERT INTO orden_trabajo (reclamo_id, empleado_id, fecha_programada, direccion_intervencion)
    VALUES (v_reclamo_id, p_empleado_id, p_fecha_programada, v_direccion)
    RETURNING ot_id INTO v_ot_id;
    
    -- Actualizar estado del reclamo si se asignó empleado
    IF p_empleado_id IS NOT NULL THEN
        UPDATE reclamo SET estado = 'EN CURSO' WHERE reclamo_id = v_reclamo_id;
        UPDATE orden_trabajo SET estado = 'ASIGNADA' WHERE ot_id = v_ot_id;
    END IF;
    
    -- Retornar información
    SELECT json_build_object(
        'reclamo_id', v_reclamo_id,
        'ot_id', v_ot_id,
        'estado_reclamo', CASE WHEN p_empleado_id IS NOT NULL THEN 'EN CURSO' ELSE 'PENDIENTE' END,
        'estado_ot', CASE WHEN p_empleado_id IS NOT NULL THEN 'ASIGNADA' ELSE 'PENDIENTE' END
    ) INTO v_resultado;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- 4. PROCEDIMIENTO PARA COMPLETAR ORDEN DE TRABAJO
-- ============================================

CREATE OR REPLACE FUNCTION completar_orden_trabajo(
    p_ot_id INTEGER,
    p_observaciones TEXT DEFAULT NULL,
    p_materiales_usados JSON DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_reclamo_id INTEGER;
    v_ot_existe BOOLEAN;
    v_material JSON;
BEGIN
    -- Verificar que la OT existe y no está completada
    SELECT EXISTS(
        SELECT 1 FROM orden_trabajo 
        WHERE ot_id = p_ot_id AND estado NOT IN ('COMPLETADA', 'CANCELADA')
    ) INTO v_ot_existe;
    
    IF NOT v_ot_existe THEN
        RAISE EXCEPTION 'La orden de trabajo con ID % no existe o ya está completada/cancelada', p_ot_id;
    END IF;
    
    -- Obtener el reclamo asociado
    SELECT reclamo_id INTO v_reclamo_id FROM orden_trabajo WHERE ot_id = p_ot_id;
    
    -- Procesar materiales usados si se proporcionaron
    IF p_materiales_usados IS NOT NULL THEN
        FOR v_material IN SELECT * FROM json_array_elements(p_materiales_usados)
        LOOP
            INSERT INTO uso_material (ot_id, material_id, cantidad)
            VALUES (
                p_ot_id,
                (v_material->>'material_id')::INTEGER,
                (v_material->>'cantidad')::INTEGER
            );
            
            -- Registrar egreso de stock
            INSERT INTO mov_stock (material_id, tipo, cantidad, referencia, observaciones)
            VALUES (
                (v_material->>'material_id')::INTEGER,
                'EGRESO',
                (v_material->>'cantidad')::INTEGER,
                'OT-' || p_ot_id::text,
                'Uso en orden de trabajo'
            );
        END LOOP;
    END IF;
    
    -- Completar la orden de trabajo
    UPDATE orden_trabajo 
    SET estado = 'COMPLETADA',
        fecha_cierre = CURRENT_TIMESTAMP,
        observaciones = COALESCE(p_observaciones, observaciones)
    WHERE ot_id = p_ot_id;
    
    -- Actualizar el reclamo
    UPDATE reclamo 
    SET estado = 'RESUELTO',
        fecha_cierre = CURRENT_TIMESTAMP
    WHERE reclamo_id = v_reclamo_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 5. PROCEDIMIENTO PARA GENERAR FACTURA
-- ============================================

CREATE OR REPLACE FUNCTION generar_factura(
    p_cuenta_id INTEGER,
    p_periodo DATE,
    p_importe DECIMAL(10,2),
    p_dias_vencimiento INTEGER DEFAULT 30
)
RETURNS INTEGER AS $$
DECLARE
    v_factura_id INTEGER;
    v_cuenta_existe BOOLEAN;
    v_numero_externo VARCHAR(50);
    v_vencimiento DATE;
BEGIN
    -- Verificar que la cuenta existe
    SELECT EXISTS(SELECT 1 FROM cuenta WHERE cuenta_id = p_cuenta_id AND activa = true) INTO v_cuenta_existe;
    IF NOT v_cuenta_existe THEN
        RAISE EXCEPTION 'La cuenta con ID % no existe o no está activa', p_cuenta_id;
    END IF;
    
    -- Verificar que no existe factura para el mismo período
    IF EXISTS(SELECT 1 FROM factura WHERE cuenta_id = p_cuenta_id AND periodo = p_periodo) THEN
        RAISE EXCEPTION 'Ya existe una factura para la cuenta % en el período %', p_cuenta_id, p_periodo;
    END IF;
    
    -- Generar número externo
    v_numero_externo := 'FAC-' || LPAD(p_cuenta_id::text, 6, '0') || '-' || TO_CHAR(p_periodo, 'MMYYYY');
    
    -- Calcular vencimiento
    v_vencimiento := p_periodo + INTERVAL '1 month' + (p_dias_vencimiento || ' days')::INTERVAL;
    
    -- Crear la factura
    INSERT INTO factura (cuenta_id, periodo, importe, vencimiento, numero_externo)
    VALUES (p_cuenta_id, p_periodo, p_importe, v_vencimiento, v_numero_externo)
    RETURNING factura_id INTO v_factura_id;
    
    RETURN v_factura_id;
END;
$$ LANGUAGE plpgsql;

-- 6. PROCEDIMIENTO PARA REGISTRAR PAGO
-- ============================================

CREATE OR REPLACE FUNCTION registrar_pago(
    p_factura_id INTEGER,
    p_monto DECIMAL(10,2),
    p_medio VARCHAR(50),
    p_external_ref VARCHAR(100) DEFAULT NULL,
    p_fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
RETURNS INTEGER AS $$
DECLARE
    v_pago_id INTEGER;
    v_factura_existe BOOLEAN;
    v_importe_factura DECIMAL(10,2);
    v_total_pagado DECIMAL(10,2);
BEGIN
    -- Verificar que la factura existe y está pendiente
    SELECT EXISTS(SELECT 1 FROM factura WHERE factura_id = p_factura_id AND estado = 'PENDIENTE') INTO v_factura_existe;
    IF NOT v_factura_existe THEN
        RAISE EXCEPTION 'La factura con ID % no existe o no está pendiente de pago', p_factura_id;
    END IF;
    
    -- Obtener importe de la factura
    SELECT importe INTO v_importe_factura FROM factura WHERE factura_id = p_factura_id;
    
    -- Calcular total ya pagado
    SELECT COALESCE(SUM(monto), 0) INTO v_total_pagado 
    FROM pago 
    WHERE factura_id = p_factura_id AND estado = 'CONFIRMADO';
    
    -- Verificar que no se exceda el importe
    IF (v_total_pagado + p_monto) > v_importe_factura THEN
        RAISE EXCEPTION 'El pago de % excede el saldo pendiente de %', 
                        p_monto, (v_importe_factura - v_total_pagado);
    END IF;
    
    -- Registrar el pago
    INSERT INTO pago (factura_id, fecha, monto, medio, external_ref)
    VALUES (p_factura_id, p_fecha, p_monto, p_medio, p_external_ref)
    RETURNING pago_id INTO v_pago_id;
    
    -- Actualizar estado de la factura si está completamente pagada
    IF (v_total_pagado + p_monto) = v_importe_factura THEN
        UPDATE factura SET estado = 'PAGADA' WHERE factura_id = p_factura_id;
    END IF;
    
    RETURN v_pago_id;
END;
$$ LANGUAGE plpgsql;

-- 7. PROCEDIMIENTO PARA PLANIFICAR ITINERARIO
-- ============================================

CREATE OR REPLACE FUNCTION planificar_itinerario(
    p_cuadrilla_id INTEGER,
    p_fecha DATE,
    p_ordenes_trabajo INTEGER[],
    p_observaciones TEXT DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_itinerario_id INTEGER;
    v_ot_id INTEGER;
    v_orden INTEGER := 1;
    v_hora_estimada TIME := '08:00:00';
BEGIN
    -- Verificar que la cuadrilla existe
    IF NOT EXISTS(SELECT 1 FROM cuadrilla WHERE cuadrilla_id = p_cuadrilla_id AND activa = true) THEN
        RAISE EXCEPTION 'La cuadrilla con ID % no existe o no está activa', p_cuadrilla_id;
    END IF;
    
    -- Crear el itinerario
    INSERT INTO itinerario (cuadrilla_id, fecha, observaciones)
    VALUES (p_cuadrilla_id, p_fecha, p_observaciones)
    RETURNING itinerario_id INTO v_itinerario_id;
    
    -- Agregar órdenes de trabajo al itinerario
    FOREACH v_ot_id IN ARRAY p_ordenes_trabajo
    LOOP
        -- Verificar que la OT existe y está disponible
        IF NOT EXISTS(
            SELECT 1 FROM orden_trabajo 
            WHERE ot_id = v_ot_id AND estado IN ('PENDIENTE', 'ASIGNADA')
        ) THEN
            RAISE EXCEPTION 'La orden de trabajo % no existe o no está disponible para planificar', v_ot_id;
        END IF;
        
        -- Agregar al detalle del itinerario
        INSERT INTO itinerario_det (itinerario_id, ot_id, orden, hora_estimada)
        VALUES (v_itinerario_id, v_ot_id, v_orden, v_hora_estimada);
        
        -- Actualizar estado de la OT
        UPDATE orden_trabajo SET estado = 'ASIGNADA' WHERE ot_id = v_ot_id;
        
        -- Incrementar orden y hora estimada
        v_orden := v_orden + 1;
        v_hora_estimada := v_hora_estimada + INTERVAL '2 hours';
    END LOOP;
    
    RETURN v_itinerario_id;
END;
$$ LANGUAGE plpgsql;

-- 8. FUNCIÓN PARA OBTENER DASHBOARD DE RECLAMOS
-- ============================================

CREATE OR REPLACE FUNCTION dashboard_reclamos(
    p_fecha_desde DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    p_fecha_hasta DATE DEFAULT CURRENT_DATE
)
RETURNS JSON AS $$
DECLARE
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'periodo', json_build_object(
            'desde', p_fecha_desde,
            'hasta', p_fecha_hasta
        ),
        'totales', json_build_object(
            'total_reclamos', (
                SELECT COUNT(*) 
                FROM reclamo 
                WHERE fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'pendientes', (
                SELECT COUNT(*) 
                FROM reclamo 
                WHERE estado = 'PENDIENTE' 
                AND fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'en_proceso', (
                SELECT COUNT(*) 
                FROM reclamo 
                WHERE estado = 'EN CURSO' 
                AND fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'resueltos', (
                SELECT COUNT(*) 
                FROM reclamo 
                WHERE estado = 'RESUELTO'
                AND fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            )
        ),
        'por_tipo', (
            SELECT json_agg(json_build_object(
                'tipo', tr.nombre,
                'cantidad', COUNT(*),
                'porcentaje', ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
            ))
            FROM reclamo r
            JOIN tipo_reclamo tr ON r.tipo_id = tr.tipo_id
            WHERE r.fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            GROUP BY tr.nombre
            ORDER BY COUNT(*) DESC
        ),
        'por_prioridad', (
            SELECT json_agg(json_build_object(
                'prioridad', p.nombre,
                'cantidad', COUNT(*),
                'porcentaje', ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)
            ))
            FROM reclamo r
            JOIN prioridad p ON r.prioridad_id = p.prioridad_id
            WHERE r.fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            GROUP BY p.nombre, p.orden
            ORDER BY p.orden
        ),
        'tiempo_promedio_resolucion', (
            SELECT ROUND(AVG(EXTRACT(DAYS FROM (fecha_cierre - fecha_alta))), 2)
            FROM reclamo 
            WHERE estado = 'RESUELTO'
            AND fecha_cierre IS NOT NULL
            AND fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
        )
    ) INTO v_resultado;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- EJEMPLOS DE USO
-- ============================================

/*
-- Crear una nueva cuenta
SELECT crear_nueva_cuenta(1, 'CTA-100-2024', 'Nueva Dirección 123', 'Ciudad', 1, true);

-- Registrar una lectura
SELECT registrar_lectura(1, 1500, CURRENT_DATE, 'RUTA-A', 'Lectura normal');

-- Crear reclamo con orden de trabajo
SELECT crear_reclamo_con_ot(1, 1, 2, 'Problema de suministro', 'TELEFONO', 1, CURRENT_TIMESTAMP + INTERVAL '1 day');

-- Completar orden de trabajo con materiales
SELECT completar_orden_trabajo(1, 'Trabajo completado satisfactoriamente', 
    '[{"material_id": 1, "cantidad": 2}, {"material_id": 3, "cantidad": 4}]');

-- Generar factura
SELECT generar_factura(1, '2024-10-01', 2500.00, 30);

-- Registrar pago
SELECT registrar_pago(1, 2500.00, 'TRANSFERENCIA', 'TRF-123456');

-- Planificar itinerario
SELECT planificar_itinerario(1, CURRENT_DATE + INTERVAL '1 day', ARRAY[1, 2, 3], 'Itinerario zona centro');

-- Obtener dashboard
SELECT dashboard_reclamos('2024-09-01', '2024-10-01');
*/