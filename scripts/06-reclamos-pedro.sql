-- ============================================
-- RECLAMOS TÉCNICOS PARA OPERARIO PEDRO
-- Base: 20 reclamos técnicos distribuidos en estados
-- Operario: Pedro García (empleado_id = 1)
-- ============================================

-- ==================================
-- RECLAMOS PENDIENTES (6 reclamos)
-- ==================================

-- Prioridad ALTA (2 reclamos)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(1, 1, 1, 'Corte de luz intermitente cada 2 horas en zona norte', 'TELEFONO', 'PENDIENTE', NOW() - INTERVAL '2 days'),
(2, 3, 1, 'Transformador con sobrecalentamiento - zona comercial - URGENTE', 'WEB', 'PENDIENTE', NOW() - INTERVAL '1 day');

-- Prioridad MEDIA (2 reclamos)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(3, 2, 2, 'Baja tensión en horario de 18:00 a 22:00 - barrio sur', 'EMAIL', 'PENDIENTE', NOW() - INTERVAL '1 day'),
(4, 3, 2, 'Cableado antiguo requiere inspección preventiva', 'PRESENCIAL', 'PENDIENTE', NOW());

-- Prioridad BAJA (2 reclamos)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(5, 4, 3, 'Medidor marca lecturas inconsistentes desde hace 1 semana', 'WEB', 'PENDIENTE', NOW() - INTERVAL '3 days'),
(6, 4, 3, 'Solicitud de cambio de ubicación de medidor por obra', 'PRESENCIAL', 'PENDIENTE', NOW());

-- ==================================
-- RECLAMOS EN_PROCESO (8 reclamos)
-- ==================================

-- Prioridad ALTA (3 reclamos - trabajos urgentes en progreso)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(7, 3, 1, 'Cables sueltos en poste 245 - Calle San Martín y Belgrano', 'TELEFONO', 'EN_PROCESO', NOW() - INTERVAL '3 days'),
(8, 3, 1, 'Poste inclinado requiere apuntalamiento urgente - Ruta 6', 'TELEFONO', 'EN_PROCESO', NOW() - INTERVAL '3 days'),
(9, 1, 1, 'Cortocircuito en red trifásica zona industrial', 'WEB', 'EN_PROCESO', NOW() - INTERVAL '2 days');

-- Prioridad MEDIA (3 reclamos - trabajos regulares)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(10, 3, 2, 'Fusible de protección quemado - requiere reemplazo', 'EMAIL', 'EN_PROCESO', NOW() - INTERVAL '2 days'),
(11, 2, 2, 'Instalación de protección contra sobretensión', 'PRESENCIAL', 'EN_PROCESO', NOW() - INTERVAL '2 days'),
(12, 3, 2, 'Cambio de conductor por sección insuficiente', 'WEB', 'EN_PROCESO', NOW() - INTERVAL '1 day');

-- Prioridad BAJA (2 reclamos - mantenimiento)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta) VALUES
(1, 8, 3, 'Verificación de instalación eléctrica domiciliaria', 'PRESENCIAL', 'EN_PROCESO', NOW() - INTERVAL '1 day'),
(2, 8, 3, 'Revisión de puesta a tierra en vivienda unifamiliar', 'WEB', 'EN_PROCESO', NOW() - INTERVAL '1 day');

-- ==================================
-- RECLAMOS RESUELTOS (6 reclamos)
-- ==================================

-- Prioridad ALTA (2 reclamos - resueltos recientemente)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta, fecha_cierre) VALUES
(3, 3, 1, 'Reparación de conexión domiciliaria deteriorada', 'TELEFONO', 'RESUELTO', NOW() - INTERVAL '4 days', NOW() - INTERVAL '1 day'),
(4, 1, 1, 'Emergencia: falta total de suministro en manzana completa', 'TELEFONO', 'RESUELTO', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days');

-- Prioridad MEDIA (2 reclamos)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta, fecha_cierre) VALUES
(5, 4, 2, 'Instalación de medidor digital nuevo', 'PRESENCIAL', 'RESUELTO', NOW() - INTERVAL '6 days', NOW() - INTERVAL '2 days'),
(6, 3, 2, 'Reemplazo de cable aéreo dañado por tormenta', 'WEB', 'RESUELTO', NOW() - INTERVAL '7 days', NOW() - INTERVAL '3 days');

-- Prioridad BAJA (2 reclamos)
INSERT INTO reclamo (cuenta_id, detalle_id, prioridad_id, descripcion, canal, estado, fecha_alta, fecha_cierre) VALUES
(7, 4, 3, 'Reubicación de medidor por obra en fachada', 'PRESENCIAL', 'RESUELTO', NOW() - INTERVAL '8 days', NOW() - INTERVAL '4 days'),
(8, 8, 3, 'Verificación y certificación de instalación nueva', 'WEB', 'RESUELTO', NOW() - INTERVAL '10 days', NOW() - INTERVAL '5 days');

-- ==================================
-- ASIGNAR ÓRDENES DE TRABAJO A PEDRO (empleado_id = 1)
-- ==================================

-- Obtener los últimos 20 reclamos insertados y crear órdenes de trabajo
-- Se excluyen los RESUELTOS ya que las órdenes ya estarían completadas

-- PENDIENTES: Crear órdenes asignadas
INSERT INTO orden_trabajo (reclamo_id, empleado_id, fecha_programada, estado, direccion_intervencion)
SELECT r.reclamo_id, 1, 
    CASE 
        WHEN r.prioridad_id = 1 THEN NOW() + INTERVAL '6 hours'  -- Alta: hoy mismo
        WHEN r.prioridad_id = 2 THEN NOW() + INTERVAL '1 day'    -- Media: mañana
        ELSE NOW() + INTERVAL '3 days'                            -- Baja: 3 días
    END,
    'ASIGNADA',
    c.direccion
FROM reclamo r
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
WHERE r.estado = 'PENDIENTE' 
  AND r.descripcion IN (
    'Corte de luz intermitente cada 2 horas en zona norte',
    'Transformador con sobrecalentamiento - zona comercial - URGENTE',
    'Baja tensión en horario de 18:00 a 22:00 - barrio sur',
    'Cableado antiguo requiere inspección preventiva',
    'Medidor marca lecturas inconsistentes desde hace 1 semana',
    'Solicitud de cambio de ubicación de medidor por obra'
  );

-- EN_PROCESO: Crear órdenes en progreso
INSERT INTO orden_trabajo (reclamo_id, empleado_id, fecha_programada, estado, direccion_intervencion)
SELECT r.reclamo_id, 1, NOW() - INTERVAL '1 day', 'EN_PROCESO', c.direccion
FROM reclamo r
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
WHERE r.estado = 'EN_PROCESO'
  AND r.descripcion IN (
    'Cables sueltos en poste 245 - Calle San Martín y Belgrano',
    'Poste inclinado requiere apuntalamiento urgente - Ruta 6',
    'Cortocircuito en red trifásica zona industrial',
    'Fusible de protección quemado - requiere reemplazo',
    'Instalación de protección contra sobretensión',
    'Cambio de conductor por sección insuficiente',
    'Verificación de instalación eléctrica domiciliaria',
    'Revisión de puesta a tierra en vivienda unifamiliar'
  );

-- RESUELTOS: Crear órdenes completadas
INSERT INTO orden_trabajo (reclamo_id, empleado_id, fecha_programada, estado, direccion_intervencion)
SELECT r.reclamo_id, 1, r.fecha_alta, 'COMPLETADA', c.direccion
FROM reclamo r
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
WHERE r.estado = 'RESUELTO'
  AND r.descripcion IN (
    'Reparación de conexión domiciliaria deteriorada',
    'Emergencia: falta total de suministro en manzana completa',
    'Instalación de medidor digital nuevo',
    'Reemplazo de cable aéreo dañado por tormenta',
    'Reubicación de medidor por obra en fachada',
    'Verificación y certificación de instalación nueva'
  );

-- ==================================
-- VERIFICACIÓN
-- ==================================

-- Mostrar resumen de reclamos de Pedro
DO $$
DECLARE
    pendientes INT;
    en_proceso INT;
    resueltos INT;
    total_ots INT;
BEGIN
    SELECT COUNT(*) INTO pendientes FROM reclamo r
    JOIN orden_trabajo ot ON r.reclamo_id = ot.reclamo_id
    WHERE ot.empleado_id = 1 AND r.estado = 'PENDIENTE';
    
    SELECT COUNT(*) INTO en_proceso FROM reclamo r
    JOIN orden_trabajo ot ON r.reclamo_id = ot.reclamo_id
    WHERE ot.empleado_id = 1 AND r.estado = 'EN_PROCESO';
    
    SELECT COUNT(*) INTO resueltos FROM reclamo r
    JOIN orden_trabajo ot ON r.reclamo_id = ot.reclamo_id
    WHERE ot.empleado_id = 1 AND r.estado = 'RESUELTO';
    
    SELECT COUNT(*) INTO total_ots FROM orden_trabajo WHERE empleado_id = 1;
    
    RAISE NOTICE '=== RECLAMOS TÉCNICOS DE PEDRO GARCÍA ===';
    RAISE NOTICE 'Pendientes: %', pendientes;
    RAISE NOTICE 'En Proceso: %', en_proceso;
    RAISE NOTICE 'Resueltos: %', resueltos;
    RAISE NOTICE 'Total Órdenes de Trabajo: %', total_ots;
END $$;
