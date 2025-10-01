-- ============================================
-- PPIV Database Initialization Script
-- Sistema de Gestión de Servicios Públicos
-- ============================================

-- Crear la base de datos si no existe
-- (No es necesario en Docker ya que se crea automáticamente)

-- Configuración inicial
SET timezone = 'America/Argentina/Buenos_Aires';
SET default_text_search_config = 'spanish';

-- ============================================
-- CREACIÓN DE TABLAS
-- ============================================

-- Tabla de Servicios (debe crearse primero por FK)
CREATE TABLE servicio (
    servicio_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Socios
CREATE TABLE socio (
    socio_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    activo BOOLEAN DEFAULT true,
    fecha_alta DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Cuentas
CREATE TABLE cuenta (
    cuenta_id SERIAL PRIMARY KEY,
    socio_id INTEGER NOT NULL REFERENCES socio(socio_id) ON DELETE CASCADE,
    numero_cuenta VARCHAR(50) UNIQUE NOT NULL,
    direccion TEXT NOT NULL,
    localidad VARCHAR(100) NOT NULL,
    servicio_id INTEGER NOT NULL REFERENCES servicio(servicio_id),
    principal BOOLEAN DEFAULT false,
    activa BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Medidores
CREATE TABLE medidor (
    medidor_id SERIAL PRIMARY KEY,
    cuenta_id INTEGER NOT NULL REFERENCES cuenta(cuenta_id) ON DELETE CASCADE,
    numero_medidor VARCHAR(50) UNIQUE NOT NULL,
    lat DECIMAL(10, 8),
    lng DECIMAL(11, 8),
    fecha_instalacion DATE,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Lecturas
CREATE TABLE lectura (
    lectura_id SERIAL PRIMARY KEY,
    medidor_id INTEGER NOT NULL REFERENCES medidor(medidor_id) ON DELETE CASCADE,
    fecha DATE NOT NULL,
    estado_anterior INTEGER NOT NULL DEFAULT 0,
    estado_actual INTEGER NOT NULL,
    consumo INTEGER GENERATED ALWAYS AS (estado_actual - estado_anterior) STORED,
    ruta VARCHAR(100),
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tipos de Reclamo
CREATE TABLE tipo_reclamo (
    tipo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Prioridades
CREATE TABLE prioridad (
    prioridad_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    orden INTEGER NOT NULL,
    color VARCHAR(7), -- Para códigos de color hexadecimal
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Reclamos
CREATE TABLE reclamo (
    reclamo_id SERIAL PRIMARY KEY,
    cuenta_id INTEGER NOT NULL REFERENCES cuenta(cuenta_id),
    tipo_id INTEGER NOT NULL REFERENCES tipo_reclamo(tipo_id),
    prioridad_id INTEGER NOT NULL REFERENCES prioridad(prioridad_id),
    fecha_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    canal VARCHAR(50) DEFAULT 'WEB', -- WEB, TELEFONO, EMAIL, PRESENCIAL
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, EN_PROCESO, RESUELTO, CERRADO
    descripcion TEXT NOT NULL,
    adjunto_url TEXT,
    fecha_cierre TIMESTAMP,
    observaciones_cierre TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Empleados
CREATE TABLE empleado (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    legajo VARCHAR(20) UNIQUE NOT NULL,
    rol_interno VARCHAR(100),
    activo BOOLEAN DEFAULT true,
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Órdenes de Trabajo
CREATE TABLE orden_trabajo (
    ot_id SERIAL PRIMARY KEY,
    reclamo_id INTEGER NOT NULL REFERENCES reclamo(reclamo_id),
    empleado_id INTEGER REFERENCES empleado(empleado_id),
    fecha_programada TIMESTAMP,
    fecha_cierre TIMESTAMP,
    observaciones TEXT,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, ASIGNADA, EN_PROCESO, COMPLETADA, CANCELADA
    direccion_intervencion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Materiales
CREATE TABLE material (
    material_id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT NOT NULL,
    unidad VARCHAR(20) NOT NULL, -- UNIDAD, METRO, KILOGRAMO, etc.
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 0,
    costo_unitario DECIMAL(10, 2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Uso de Materiales
CREATE TABLE uso_material (
    uso_id SERIAL PRIMARY KEY,
    ot_id INTEGER NOT NULL REFERENCES orden_trabajo(ot_id) ON DELETE CASCADE,
    material_id INTEGER NOT NULL REFERENCES material(material_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Movimientos de Stock
CREATE TABLE mov_stock (
    mov_id SERIAL PRIMARY KEY,
    material_id INTEGER NOT NULL REFERENCES material(material_id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(20) NOT NULL, -- INGRESO, EGRESO, AJUSTE
    cantidad INTEGER NOT NULL,
    referencia VARCHAR(100), -- Número de compra, OT, etc.
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Facturas
CREATE TABLE factura (
    factura_id SERIAL PRIMARY KEY,
    cuenta_id INTEGER NOT NULL REFERENCES cuenta(cuenta_id),
    periodo DATE NOT NULL, -- Primer día del mes facturado
    importe DECIMAL(10, 2) NOT NULL,
    vencimiento DATE NOT NULL,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, PAGADA, VENCIDA, ANULADA
    numero_externo VARCHAR(50), -- Número de factura del sistema externo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Pagos
CREATE TABLE pago (
    pago_id SERIAL PRIMARY KEY,
    factura_id INTEGER NOT NULL REFERENCES factura(factura_id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monto DECIMAL(10, 2) NOT NULL,
    medio VARCHAR(50) NOT NULL, -- EFECTIVO, TARJETA, TRANSFERENCIA, etc.
    external_ref VARCHAR(100), -- Referencia del sistema de pagos
    estado VARCHAR(50) DEFAULT 'CONFIRMADO', -- PENDIENTE, CONFIRMADO, RECHAZADO
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Roles
CREATE TABLE rol (
    rol_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Usuarios
CREATE TABLE usuario (
    usuario_id SERIAL PRIMARY KEY,
    socio_id INTEGER REFERENCES socio(socio_id),
    empleado_id INTEGER REFERENCES empleado(empleado_id),
    email VARCHAR(150) UNIQUE NOT NULL,
    hash_pass VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT true,
    ultimo_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_usuario_xor CHECK (
        (socio_id IS NOT NULL AND empleado_id IS NULL) OR 
        (socio_id IS NULL AND empleado_id IS NOT NULL)
    )
);

-- Tabla de relación Usuario-Rol (muchos a muchos)
CREATE TABLE usuario_rol (
    usuario_id INTEGER NOT NULL REFERENCES usuario(usuario_id) ON DELETE CASCADE,
    rol_id INTEGER NOT NULL REFERENCES rol(rol_id) ON DELETE CASCADE,
    asignado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, rol_id)
);

-- Tabla de Cuadrillas
CREATE TABLE cuadrilla (
    cuadrilla_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona VARCHAR(100),
    activa BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación Empleado-Cuadrilla
CREATE TABLE empleado_cuadrilla (
    empleado_id INTEGER NOT NULL REFERENCES empleado(empleado_id) ON DELETE CASCADE,
    cuadrilla_id INTEGER NOT NULL REFERENCES cuadrilla(cuadrilla_id) ON DELETE CASCADE,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    fecha_desasignacion DATE,
    activa BOOLEAN DEFAULT true,
    PRIMARY KEY (empleado_id, cuadrilla_id, fecha_asignacion)
);

-- Tabla de Itinerarios
CREATE TABLE itinerario (
    itinerario_id SERIAL PRIMARY KEY,
    cuadrilla_id INTEGER NOT NULL REFERENCES cuadrilla(cuadrilla_id),
    fecha DATE NOT NULL,
    observaciones TEXT,
    estado VARCHAR(50) DEFAULT 'PLANIFICADO', -- PLANIFICADO, EN_EJECUCION, COMPLETADO
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Detalle de Itinerarios
CREATE TABLE itinerario_det (
    itdet_id SERIAL PRIMARY KEY,
    itinerario_id INTEGER NOT NULL REFERENCES itinerario(itinerario_id) ON DELETE CASCADE,
    ot_id INTEGER NOT NULL REFERENCES orden_trabajo(ot_id),
    orden INTEGER NOT NULL,
    hora_estimada TIME,
    completada BOOLEAN DEFAULT false,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ============================================

-- Índices para búsquedas frecuentes
CREATE INDEX idx_socio_dni ON socio(dni);
CREATE INDEX idx_socio_email ON socio(email);
CREATE INDEX idx_cuenta_numero ON cuenta(numero_cuenta);
CREATE INDEX idx_cuenta_socio ON cuenta(socio_id);
CREATE INDEX idx_medidor_numero ON medidor(numero_medidor);
CREATE INDEX idx_lectura_fecha ON lectura(fecha);
CREATE INDEX idx_lectura_medidor ON lectura(medidor_id);
CREATE INDEX idx_reclamo_estado ON reclamo(estado);
CREATE INDEX idx_reclamo_fecha ON reclamo(fecha_alta);
CREATE INDEX idx_ot_estado ON orden_trabajo(estado);
CREATE INDEX idx_ot_fecha_programada ON orden_trabajo(fecha_programada);
CREATE INDEX idx_factura_periodo ON factura(periodo);
CREATE INDEX idx_factura_estado ON factura(estado);
CREATE INDEX idx_pago_fecha ON pago(fecha);
CREATE INDEX idx_material_codigo ON material(codigo);
CREATE INDEX idx_usuario_email ON usuario(email);

-- Índices compuestos para consultas comunes
CREATE INDEX idx_cuenta_servicio_activa ON cuenta(servicio_id, activa);
CREATE INDEX idx_reclamo_cuenta_estado ON reclamo(cuenta_id, estado);
CREATE INDEX idx_factura_cuenta_estado ON factura(cuenta_id, estado);

-- ============================================
-- TRIGGERS PARA ACTUALIZACIÓN AUTOMÁTICA
-- ============================================

-- Función para actualizar el campo updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger a las tablas que tienen updated_at
CREATE TRIGGER update_socio_updated_at BEFORE UPDATE ON socio FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cuenta_updated_at BEFORE UPDATE ON cuenta FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_medidor_updated_at BEFORE UPDATE ON medidor FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reclamo_updated_at BEFORE UPDATE ON reclamo FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orden_trabajo_updated_at BEFORE UPDATE ON orden_trabajo FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_material_updated_at BEFORE UPDATE ON material FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_factura_updated_at BEFORE UPDATE ON factura FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_empleado_updated_at BEFORE UPDATE ON empleado FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_usuario_updated_at BEFORE UPDATE ON usuario FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cuadrilla_updated_at BEFORE UPDATE ON cuadrilla FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_itinerario_updated_at BEFORE UPDATE ON itinerario FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNCIÓN PARA ACTUALIZAR STOCK DE MATERIALES
-- ============================================

CREATE OR REPLACE FUNCTION actualizar_stock_material()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Actualizar stock según el tipo de movimiento
        IF NEW.tipo = 'INGRESO' THEN
            UPDATE material 
            SET stock_actual = stock_actual + NEW.cantidad 
            WHERE material_id = NEW.material_id;
        ELSIF NEW.tipo = 'EGRESO' THEN
            UPDATE material 
            SET stock_actual = stock_actual - NEW.cantidad 
            WHERE material_id = NEW.material_id;
        ELSIF NEW.tipo = 'AJUSTE' THEN
            UPDATE material 
            SET stock_actual = NEW.cantidad 
            WHERE material_id = NEW.material_id;
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Trigger para actualizar stock automáticamente
CREATE TRIGGER trg_actualizar_stock 
    AFTER INSERT ON mov_stock 
    FOR EACH ROW EXECUTE FUNCTION actualizar_stock_material();

-- ============================================
-- DATOS INICIALES
-- ============================================

-- Insertar servicios (Cooperativa Eléctrica "Gobernador Ugarte")
INSERT INTO servicio (nombre, categoria, descripcion) VALUES
('Energía Eléctrica Residencial', 'Eléctrico', 'Suministro eléctrico para uso residencial'),
('Energía Eléctrica Comercial', 'Eléctrico', 'Suministro eléctrico para uso comercial'),
('Energía Eléctrica Industrial', 'Eléctrico', 'Suministro eléctrico para uso industrial'),
('Energía Eléctrica General', 'Eléctrico', 'Suministro eléctrico general');

-- Insertar tipos de reclamo (Cooperativa Eléctrica)
INSERT INTO tipo_reclamo (nombre, descripcion) VALUES
('Falta de Suministro', 'Corte total de energía eléctrica'),
('Fluctuaciones de Tensión', 'Variaciones en el voltaje del suministro'),
('Daños en Red', 'Cables caídos, postes dañados, etc.'),
('Medidor Defectuoso', 'Problemas con el medidor eléctrico'),
('Facturación', 'Reclamos relacionados con facturación'),
('Conexión Nueva', 'Solicitud de nueva conexión eléctrica'),
('Reconexión', 'Solicitud de reconexión del servicio'),
('Calidad del Servicio', 'Problemas con la calidad del suministro eléctrico');

-- Insertar prioridades
INSERT INTO prioridad (nombre, orden, color) VALUES
('Alta', 1, '#FF0000'),
('Media', 2, '#FF8C00'),
('Baja', 3, '#00AA00');

-- Insertar roles de usuario
INSERT INTO rol (nombre, descripcion) VALUES
('ADMIN', 'Administrador del sistema'),
('EMPLEADO', 'Empleado de la empresa'),
('CLIENTE', 'Cliente/Socio del servicio'),
('TECNICO', 'Técnico de campo'),
('SUPERVISOR', 'Supervisor de cuadrillas'),
('FACTURACION', 'Personal de facturación'),
('ATENCION_CLIENTE', 'Personal de atención al cliente');

-- Insertar materiales eléctricos básicos
INSERT INTO material (codigo, descripcion, unidad, stock_actual, stock_minimo, costo_unitario) VALUES
('CAB-TRI-4MM', 'Cable Tripolar 4mm x Metro', 'METRO', 85, 20, 2850.00),
('CAB-BIP-2.5MM', 'Cable Bipolar 2.5mm x Metro', 'METRO', 65, 15, 1950.00),
('MED-MONO-220', 'Medidor Monofásico 220V', 'UNIDAD', 48, 10, 145000.00),
('MED-TRI-380', 'Medidor Trifásico 380V', 'UNIDAD', 23, 5, 285000.00),
('POST-HORM-9M', 'Poste Hormigón 9 metros', 'UNIDAD', 197, 5, 125000.00),
('CRUC-MAD-2M', 'Cruceta Madera 2 metros', 'UNIDAD', 144, 10, 18500.00),
('AISL-PORC-15KV', 'Aislador Porcelana 15KV', 'UNIDAD', 292, 20, 4200.00),
('FUS-NH-100A', 'Fusible NH 100A', 'UNIDAD', 92, 15, 8750.00);

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista de cuentas con información completa
CREATE VIEW v_cuentas_completas AS
SELECT 
    c.cuenta_id,
    c.numero_cuenta,
    c.direccion,
    c.localidad,
    c.principal,
    s.nombre || ' ' || s.apellido AS titular,
    s.dni,
    s.email,
    s.telefono,
    srv.nombre AS servicio,
    c.activa
FROM cuenta c
JOIN socio s ON c.socio_id = s.socio_id
JOIN servicio srv ON c.servicio_id = srv.servicio_id;

-- Vista de reclamos con información completa
CREATE VIEW v_reclamos_completos AS
SELECT 
    r.reclamo_id,
    r.fecha_alta,
    c.numero_cuenta,
    s.nombre || ' ' || s.apellido AS solicitante,
    tr.nombre AS tipo_reclamo,
    p.nombre AS prioridad,
    r.estado,
    r.descripcion,
    r.canal
FROM reclamo r
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN tipo_reclamo tr ON r.tipo_id = tr.tipo_id
JOIN prioridad p ON r.prioridad_id = p.prioridad_id;

-- Vista de órdenes de trabajo con información completa
CREATE VIEW v_ordenes_trabajo_completas AS
SELECT 
    ot.ot_id,
    ot.fecha_programada,
    ot.estado,
    e.nombre || ' ' || e.apellido AS tecnico_asignado,
    r.reclamo_id,
    tr.nombre AS tipo_reclamo,
    c.numero_cuenta,
    s.nombre || ' ' || s.apellido AS solicitante,
    ot.direccion_intervencion
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN tipo_reclamo tr ON r.tipo_id = tr.tipo_id
LEFT JOIN empleado e ON ot.empleado_id = e.empleado_id;

-- Vista de stock de materiales
CREATE VIEW v_stock_materiales AS
SELECT 
    m.material_id,
    m.codigo,
    m.descripcion,
    m.unidad,
    m.stock_actual,
    m.stock_minimo,
    CASE 
        WHEN m.stock_actual <= m.stock_minimo THEN 'CRÍTICO'
        WHEN m.stock_actual <= (m.stock_minimo * 1.5) THEN 'BAJO'
        ELSE 'NORMAL'
    END AS estado_stock,
    m.costo_unitario
FROM material m
WHERE m.activo = true;

-- ============================================
-- FUNCIONES ÚTILES
-- ============================================

-- Función para obtener consumo promedio de un medidor
CREATE OR REPLACE FUNCTION obtener_consumo_promedio(p_medidor_id INTEGER, p_meses INTEGER DEFAULT 6)
RETURNS DECIMAL AS $$
DECLARE
    v_promedio DECIMAL;
BEGIN
    SELECT AVG(consumo) INTO v_promedio
    FROM lectura 
    WHERE medidor_id = p_medidor_id 
    AND fecha >= CURRENT_DATE - INTERVAL '1 month' * p_meses;
    
    RETURN COALESCE(v_promedio, 0);
END;
$$ LANGUAGE plpgsql;

-- Función para calcular próximo vencimiento de factura
CREATE OR REPLACE FUNCTION calcular_proximo_vencimiento(p_cuenta_id INTEGER)
RETURNS DATE AS $$
DECLARE
    v_ultimo_periodo DATE;
    v_proximo_periodo DATE;
BEGIN
    SELECT MAX(periodo) INTO v_ultimo_periodo
    FROM factura 
    WHERE cuenta_id = p_cuenta_id;
    
    IF v_ultimo_periodo IS NULL THEN
        v_proximo_periodo := DATE_TRUNC('month', CURRENT_DATE);
    ELSE
        v_proximo_periodo := v_ultimo_periodo + INTERVAL '1 month';
    END IF;
    
    -- Vencimiento a los 15 días del mes siguiente
    RETURN v_proximo_periodo + INTERVAL '1 month' + INTERVAL '15 days';
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- COMENTARIOS EN TABLAS
-- ============================================

COMMENT ON TABLE socio IS 'Tabla de socios/clientes del sistema';
COMMENT ON TABLE cuenta IS 'Cuentas de servicios asociadas a socios';
COMMENT ON TABLE medidor IS 'Medidores instalados en las cuentas';
COMMENT ON TABLE lectura IS 'Lecturas periódicas de los medidores';
COMMENT ON TABLE reclamo IS 'Reclamos realizados por los socios';
COMMENT ON TABLE orden_trabajo IS 'Órdenes de trabajo generadas por reclamos';
COMMENT ON TABLE material IS 'Inventario de materiales';
COMMENT ON TABLE mov_stock IS 'Movimientos de stock de materiales';
COMMENT ON TABLE factura IS 'Facturas emitidas a las cuentas';
COMMENT ON TABLE pago IS 'Pagos recibidos de las facturas';
COMMENT ON TABLE usuario IS 'Usuarios del sistema (socios y empleados)';

-- ============================================
-- CONFIGURACIÓN FINAL
-- ============================================

-- Configurar secuencias para empezar en números más altos (opcional)
-- ALTER SEQUENCE socio_socio_id_seq RESTART WITH 1001;
-- ALTER SEQUENCE cuenta_cuenta_id_seq RESTART WITH 2001;
-- ALTER SEQUENCE reclamo_reclamo_id_seq RESTART WITH 3001;

VACUUM ANALYZE;

-- Mensaje de finalización
DO $$
BEGIN
    RAISE NOTICE '✅ Base de datos PPIV inicializada correctamente';
    RAISE NOTICE 'Total de tablas creadas: %', (SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE');
    RAISE NOTICE 'Total de vistas creadas: %', (SELECT count(*) FROM information_schema.views WHERE table_schema = 'public');
    RAISE NOTICE '⚡ Total de índices creados: %', (SELECT count(*) FROM pg_indexes WHERE schemaname = 'public');
END $$;