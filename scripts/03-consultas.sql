-- ============================================
-- CONSULTAS ESPECÍFICAS PARA COOPERATIVA ELÉCTRICA "GOBERNADOR UGARTE"
-- Adaptadas para los wireframes de Cliente, Operario y Administrativo
-- ============================================

-- ============================================
-- CONSULTAS PARA PERFIL CLIENTE (CL-)
-- ============================================

-- CL-Dashboard: Resumen para cliente
CREATE OR REPLACE FUNCTION dashboard_cliente(p_socio_id INTEGER)
RETURNS JSON AS $$
DECLARE
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'estado_servicio', (
            SELECT json_build_object(
                'activo', bool_and(c.activa),
                'total_cuentas', count(c.cuenta_id),
                'ultimo_consumo', (
                    SELECT l.consumo 
                    FROM lectura l 
                    JOIN medidor m ON l.medidor_id = m.medidor_id
                    JOIN cuenta ct ON m.cuenta_id = ct.cuenta_id
                    WHERE ct.socio_id = p_socio_id
                    ORDER BY l.fecha DESC 
                    LIMIT 1
                )
            )
            FROM cuenta c
            WHERE c.socio_id = p_socio_id
        ),
        'ultimas_facturas', (
            SELECT json_agg(factura_data ORDER BY periodo DESC)
            FROM (
                SELECT json_build_object(
                    'factura_id', f.factura_id,
                    'numero_externo', f.numero_externo,
                    'periodo', f.periodo,
                    'importe', f.importe,
                    'vencimiento', f.vencimiento,
                    'estado', f.estado
                ) as factura_data, f.periodo
                FROM factura f
                JOIN cuenta c ON f.cuenta_id = c.cuenta_id
                WHERE c.socio_id = p_socio_id
                ORDER BY f.periodo DESC
                LIMIT 5
            ) facturas_ordenadas
        ),
        'reclamos_activos', (
            SELECT json_agg(reclamo_data ORDER BY fecha_alta DESC)
            FROM (
                SELECT json_build_object(
                    'reclamo_id', r.reclamo_id,
                    'tipo', tr.nombre,
                    'estado', r.estado,
                    'fecha_alta', r.fecha_alta,
                    'prioridad', p.nombre
                ) as reclamo_data, r.fecha_alta
                FROM reclamo r
                JOIN cuenta c ON r.cuenta_id = c.cuenta_id
                JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
                JOIN prioridad p ON r.prioridad_id = p.prioridad_id
                WHERE c.socio_id = p_socio_id
                AND r.estado != 'RESUELTO'
                ORDER BY r.fecha_alta DESC
            ) reclamos_ordenados
        )
    ) INTO v_resultado;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- CL-Facturas-Listado: Lista de facturas para cliente
CREATE OR REPLACE FUNCTION facturas_cliente(
    p_socio_id INTEGER,
    p_estado VARCHAR(50) DEFAULT NULL,
    p_desde DATE DEFAULT NULL,
    p_hasta DATE DEFAULT NULL
)
RETURNS TABLE (
    factura_id INTEGER,
    numero_externo VARCHAR(50),
    numero_cuenta VARCHAR(50),
    periodo DATE,
    vencimiento DATE,
    importe DECIMAL(10,2),
    estado VARCHAR(50),
    dias_vencimiento INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.factura_id,
        f.numero_externo,
        c.numero_cuenta,
        f.periodo,
        f.vencimiento,
        f.importe,
        f.estado,
        CASE 
            WHEN f.estado = 'PENDIENTE' THEN 
                EXTRACT(DAYS FROM (CURRENT_DATE - f.vencimiento))::INTEGER
            ELSE NULL
        END as dias_vencimiento
    FROM factura f
    JOIN cuenta c ON f.cuenta_id = c.cuenta_id
    WHERE c.socio_id = p_socio_id
    AND (p_estado IS NULL OR f.estado = p_estado)
    AND (p_desde IS NULL OR f.periodo >= p_desde)
    AND (p_hasta IS NULL OR f.periodo <= p_hasta)
    ORDER BY f.periodo DESC, f.vencimiento DESC;
END;
$$ LANGUAGE plpgsql;

-- CL-Factura-Detalle: Detalle de factura específica
CREATE OR REPLACE FUNCTION detalle_factura(p_factura_id INTEGER)
RETURNS JSON AS $$
DECLARE
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'factura', json_build_object(
            'factura_id', f.factura_id,
            'numero_externo', f.numero_externo,
            'periodo', f.periodo,
            'vencimiento', f.vencimiento,
            'importe', f.importe,
            'estado', f.estado
        ),
        'cuenta', json_build_object(
            'numero_cuenta', c.numero_cuenta,
            'direccion', c.direccion,
            'localidad', c.localidad,
            'servicio', srv.nombre
        ),
        'socio', json_build_object(
            'nombre_completo', s.nombre || ' ' || s.apellido,
            'dni', s.dni,
            'email', s.email
        ),
        'consumo', (
            SELECT json_build_object(
                'kwh_consumidos', l.consumo,
                'fecha_lectura', l.fecha,
                'estado_anterior', l.estado_anterior,
                'estado_actual', l.estado_actual
            )
            FROM lectura l
            JOIN medidor m ON l.medidor_id = m.medidor_id
            WHERE m.cuenta_id = c.cuenta_id
            AND DATE_TRUNC('month', l.fecha) = f.periodo
            LIMIT 1
        ),
        'pagos', (
            SELECT COALESCE(json_agg(json_build_object(
                'fecha', p.fecha,
                'monto', p.monto,
                'medio', p.medio,
                'estado', p.estado
            )), '[]'::json)
            FROM pago p
            WHERE p.factura_id = f.factura_id
        )
    ) INTO v_resultado
    FROM factura f
    JOIN cuenta c ON f.cuenta_id = c.cuenta_id
    JOIN socio s ON c.socio_id = s.socio_id
    JOIN servicio srv ON c.servicio_id = srv.servicio_id
    WHERE f.factura_id = p_factura_id;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- CL-Reclamos-Listado: Lista de reclamos del cliente
CREATE OR REPLACE FUNCTION reclamos_cliente(p_socio_id INTEGER)
RETURNS TABLE (
    reclamo_id INTEGER,
    fecha_alta TIMESTAMP,
    tipo_reclamo VARCHAR(100),
    descripcion TEXT,
    estado VARCHAR(50),
    prioridad VARCHAR(50),
    canal VARCHAR(50),
    numero_cuenta VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.reclamo_id,
        r.fecha_alta,
        d.nombre as detalle_reclamo, t.nombre as tipo_reclamo,
        r.descripcion,
        r.estado,
        p.nombre as prioridad,
        r.canal,
        c.numero_cuenta
    FROM reclamo r
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
    JOIN prioridad p ON r.prioridad_id = p.prioridad_id
    WHERE c.socio_id = p_socio_id
    ORDER BY r.fecha_alta DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- CONSULTAS PARA PERFIL OPERARIO (OP-)
-- ============================================

-- OP-Asignados-Lista: Órdenes asignadas al operario
CREATE OR REPLACE FUNCTION ordenes_asignadas_operario(p_empleado_id INTEGER)
RETURNS TABLE (
    ot_id INTEGER,
    reclamo_id INTEGER,
    tipo_reclamo VARCHAR(100),
    prioridad VARCHAR(50),
    prioridad_orden INTEGER,
    direccion TEXT,
    fecha_programada TIMESTAMP,
    estado VARCHAR(50),
    descripcion TEXT,
    zona VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ot.ot_id,
        r.reclamo_id,
        d.nombre as detalle_reclamo, t.nombre as tipo_reclamo,
        p.nombre as prioridad,
        p.orden as prioridad_orden,
        ot.direccion_intervencion as direccion,
        ot.fecha_programada,
        ot.estado,
        r.descripcion,
        'Gobernador Ugarte' as zona
    FROM orden_trabajo ot
    JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
    JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
    JOIN prioridad p ON r.prioridad_id = p.prioridad_id
    WHERE ot.empleado_id = p_empleado_id
    AND ot.estado IN ('ASIGNADA', 'EN CURSO')
    ORDER BY p.orden, ot.fecha_programada;
END;
$$ LANGUAGE plpgsql;

-- OP-Reclamo-Detalle: Detalle completo para el operario
CREATE OR REPLACE FUNCTION detalle_reclamo_operario(p_ot_id INTEGER)
RETURNS JSON AS $$
DECLARE
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'orden_trabajo', json_build_object(
            'ot_id', ot.ot_id,
            'estado', ot.estado,
            'fecha_programada', ot.fecha_programada,
            'direccion_intervencion', ot.direccion_intervencion,
            'observaciones', ot.observaciones
        ),
        'reclamo', json_build_object(
            'reclamo_id', r.reclamo_id,
            'descripcion', r.descripcion,
            'fecha_alta', r.fecha_alta,
            'canal', r.canal,
            'tipo', tr.nombre,
            'prioridad', p.nombre
        ),
        'cliente', json_build_object(
            'nombre_completo', s.nombre || ' ' || s.apellido,
            'telefono', s.telefono,
            'numero_cuenta', c.numero_cuenta,
            'direccion', c.direccion
        ),
        'materiales_usados', (
            SELECT COALESCE(json_agg(json_build_object(
                'material', m.descripcion,
                'codigo', m.codigo,
                'cantidad', um.cantidad,
                'unidad', m.unidad
            )), '[]'::json)
            FROM uso_material um
            JOIN material m ON um.material_id = m.material_id
            WHERE um.ot_id = ot.ot_id
        )
    ) INTO v_resultado
    FROM orden_trabajo ot
    JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
    JOIN cuenta c ON r.cuenta_id = c.cuenta_id
    JOIN socio s ON c.socio_id = s.socio_id
    JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
    JOIN prioridad p ON r.prioridad_id = p.prioridad_id
    WHERE ot.ot_id = p_ot_id;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- OP-Cargar-Insumos: Materiales disponibles
CREATE OR REPLACE FUNCTION materiales_disponibles()
RETURNS TABLE (
    material_id INTEGER,
    codigo VARCHAR(50),
    descripcion TEXT,
    stock_actual INTEGER,
    unidad VARCHAR(20)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.material_id,
        m.codigo,
        m.descripcion,
        m.stock_actual,
        m.unidad
    FROM material m
    WHERE m.activo = true
    AND m.stock_actual > 0
    ORDER BY m.descripcion;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- CONSULTAS PARA PERFIL ADMINISTRATIVO (AD-)
-- ============================================

-- AD-Itinerario-Plan: Planificación de cuadrillas
CREATE OR REPLACE FUNCTION itinerarios_cuadrillas(p_fecha DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    cuadrilla_id INTEGER,
    nombre_cuadrilla VARCHAR(100),
    zona VARCHAR(100),
    total_ordenes INTEGER,
    ordenes_pendientes INTEGER,
    empleados JSON
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.cuadrilla_id,
        c.nombre as nombre_cuadrilla,
        c.zona,
        COUNT(DISTINCT id.ot_id)::INTEGER as total_ordenes,
        COUNT(DISTINCT CASE WHEN NOT COALESCE(id.completada, false) THEN id.ot_id END)::INTEGER as ordenes_pendientes,
        (
            SELECT json_agg(json_build_object(
                'empleado_id', e.empleado_id,
                'nombre_completo', e.nombre || ' ' || e.apellido,
                'rol', e.rol_interno
            ))
            FROM empleado_cuadrilla ec
            JOIN empleado e ON ec.empleado_id = e.empleado_id
            WHERE ec.cuadrilla_id = c.cuadrilla_id
            AND ec.activa = true
        ) as empleados
    FROM cuadrilla c
    LEFT JOIN itinerario i ON c.cuadrilla_id = i.cuadrilla_id AND i.fecha = p_fecha
    LEFT JOIN itinerario_det id ON i.itinerario_id = id.itinerario_id
    WHERE c.activa = true
    GROUP BY c.cuadrilla_id, c.nombre, c.zona
    ORDER BY c.nombre;
END;
$$ LANGUAGE plpgsql;

-- AD-Clientes-ABM: Lista de clientes para administración
CREATE OR REPLACE FUNCTION clientes_administracion(
    p_activo BOOLEAN DEFAULT NULL,
    p_busqueda TEXT DEFAULT NULL
)
RETURNS TABLE (
    socio_id INTEGER,
    nombre_completo TEXT,
    dni VARCHAR(20),
    email VARCHAR(150),
    telefono VARCHAR(20),
    activo BOOLEAN,
    fecha_alta DATE,
    total_cuentas INTEGER,
    ultimo_pago DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.socio_id,
        s.nombre || ' ' || s.apellido as nombre_completo,
        s.dni,
        s.email,
        s.telefono,
        s.activo,
        s.fecha_alta,
        COUNT(DISTINCT c.cuenta_id)::INTEGER as total_cuentas,
        MAX(pago.fecha)::DATE as ultimo_pago
    FROM socio s
    LEFT JOIN cuenta c ON s.socio_id = c.socio_id
    LEFT JOIN factura f ON c.cuenta_id = f.cuenta_id
    LEFT JOIN pago ON f.factura_id = pago.factura_id
    WHERE (p_activo IS NULL OR s.activo = p_activo)
    AND (p_busqueda IS NULL OR 
         LOWER(s.nombre || ' ' || s.apellido) LIKE LOWER('%' || p_busqueda || '%') OR
         s.dni LIKE '%' || p_busqueda || '%' OR
         LOWER(s.email) LIKE LOWER('%' || p_busqueda || '%'))
    GROUP BY s.socio_id, s.nombre, s.apellido, s.dni, s.email, s.telefono, s.activo, s.fecha_alta
    ORDER BY s.apellido, s.nombre;
END;
$$ LANGUAGE plpgsql;

-- AD-Métricas: KPIs para dashboard administrativo
CREATE OR REPLACE FUNCTION metricas_administrativas(
    p_fecha_desde DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    p_fecha_hasta DATE DEFAULT CURRENT_DATE
)
RETURNS JSON AS $$
DECLARE
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'reclamos', json_build_object(
            'total_periodo', (
                SELECT COUNT(*) 
                FROM reclamo 
                WHERE fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'por_estado', (
                SELECT json_object_agg(estado, cantidad)
                FROM (
                    SELECT estado, COUNT(*) as cantidad
                    FROM reclamo 
                    WHERE fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
                    GROUP BY estado
                ) sub
            ),
            'por_tipo', (
                SELECT json_agg(json_build_object(
                    'tipo', tr.nombre,
                    'cantidad', COUNT(*),
                    'porcentaje', ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)
                ))
                FROM reclamo r
                JOIN detalle_tipo_reclamo d ON r.detalle_id = d.detalle_id
    JOIN tipo_reclamo t ON d.tipo_id = t.tipo_id
                WHERE r.fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
                GROUP BY tr.nombre
                ORDER BY COUNT(*) DESC
            ),
            'por_prioridad', (
                SELECT json_agg(json_build_object(
                    'prioridad', p.nombre,
                    'cantidad', COUNT(*),
                    'porcentaje', ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)
                ))
                FROM reclamo r
                JOIN prioridad p ON r.prioridad_id = p.prioridad_id
                WHERE r.fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
                GROUP BY p.nombre, p.orden
                ORDER BY p.orden
            ),
            'tiempo_promedio_resolucion', (
                SELECT ROUND(AVG(EXTRACT(HOURS FROM (fecha_cierre - fecha_alta))), 1)
                FROM reclamo 
                WHERE estado = 'RESUELTO'
                AND fecha_cierre IS NOT NULL
                AND fecha_alta::date BETWEEN p_fecha_desde AND p_fecha_hasta
            )
        ),
        'operaciones', json_build_object(
            'ordenes_completadas', (
                SELECT COUNT(*)
                FROM orden_trabajo
                WHERE estado = 'COMPLETADA'
                AND fecha_cierre::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'ordenes_pendientes', (
                SELECT COUNT(*)
                FROM orden_trabajo
                WHERE estado IN ('PENDIENTE', 'ASIGNADA', 'EN CURSO')
            ),
            'cuadrillas_activas', (
                SELECT COUNT(*)
                FROM cuadrilla
                WHERE activa = true
            )
        ),
        'facturacion', json_build_object(
            'facturas_emitidas', (
                SELECT COUNT(*)
                FROM factura
                WHERE periodo BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'importe_facturado', (
                SELECT COALESCE(SUM(importe), 0)
                FROM factura
                WHERE periodo BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'importe_cobrado', (
                SELECT COALESCE(SUM(p.monto), 0)
                FROM pago p
                JOIN factura f ON p.factura_id = f.factura_id
                WHERE p.fecha::date BETWEEN p_fecha_desde AND p_fecha_hasta
            ),
            'porcentaje_cobranza', (
                SELECT CASE 
                    WHEN SUM(f.importe) > 0 THEN 
                        ROUND(SUM(COALESCE(p.monto, 0)) * 100.0 / SUM(f.importe), 1)
                    ELSE 0 
                END
                FROM factura f
                LEFT JOIN pago p ON f.factura_id = p.factura_id 
                    AND p.fecha::date BETWEEN p_fecha_desde AND p_fecha_hasta
                WHERE f.periodo BETWEEN p_fecha_desde AND p_fecha_hasta
            )
        )
    ) INTO v_resultado;
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- EJEMPLOS DE USO
-- ============================================

/*
-- Dashboard de cliente (socio_id = 1)
SELECT dashboard_cliente(1);

-- Facturas del cliente en septiembre 2024
SELECT * FROM facturas_cliente(1, NULL, '2024-09-01', '2024-09-30');

-- Detalle de factura específica
SELECT detalle_factura(1);

-- Reclamos del cliente
SELECT * FROM reclamos_cliente(1);

-- Órdenes asignadas al operario (empleado_id = 1)
SELECT * FROM ordenes_asignadas_operario(1);

-- Detalle de orden de trabajo para operario
SELECT detalle_reclamo_operario(1);

-- Materiales disponibles
SELECT * FROM materiales_disponibles();

-- Itinerarios de cuadrillas para hoy
SELECT * FROM itinerarios_cuadrillas(CURRENT_DATE);

-- Clientes activos
SELECT * FROM clientes_administracion(true);

-- Métricas del último mes
SELECT metricas_administrativas();
*/