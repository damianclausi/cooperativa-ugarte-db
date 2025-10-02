-- ============================================
-- SCRIPT DE AUTENTICACIÓN
-- Crea 11 usuarios de prueba con bcrypt
-- ============================================

\c cooperativa_ugarte_db;

-- Paso 1: Insertar roles si no existen
INSERT INTO rol (nombre, descripcion) 
VALUES 
    ('CLIENTE', 'Socio de la cooperativa'),
    ('OPERARIO', 'Empleado operativo'),
    ('ADMIN', 'Administrador del sistema')
ON CONFLICT (nombre) DO NOTHING;

-- Paso 2: Función para crear usuarios
CREATE OR REPLACE FUNCTION crear_usuario_sistema(
    p_email VARCHAR(255),
    p_hash_pass TEXT,
    p_socio_id INTEGER DEFAULT NULL,
    p_empleado_id INTEGER DEFAULT NULL,
    p_roles VARCHAR(50)[] DEFAULT ARRAY['CLIENTE']::VARCHAR(50)[]
) RETURNS INTEGER AS $$
DECLARE
    v_usuario_id INTEGER;
    v_rol_id INTEGER;
    v_rol VARCHAR(50);
    v_existing_user INTEGER;
BEGIN
    -- Verificar si el usuario ya existe
    SELECT usuario_id INTO v_existing_user FROM usuario WHERE email = p_email;
    
    IF v_existing_user IS NOT NULL THEN
        RAISE NOTICE '⚠️ Usuario ya existe: % (ID: %)', p_email, v_existing_user;
        RETURN v_existing_user;
    END IF;
    
    -- Insertar usuario
    INSERT INTO usuario (email, hash_pass, socio_id, empleado_id, activo)
    VALUES (p_email, p_hash_pass, p_socio_id, p_empleado_id, TRUE)
    RETURNING usuario_id INTO v_usuario_id;
    
    -- Asignar roles
    FOREACH v_rol IN ARRAY p_roles LOOP
        SELECT rol_id INTO v_rol_id FROM rol WHERE nombre = v_rol;
        
        IF v_rol_id IS NOT NULL THEN
            INSERT INTO usuario_rol (usuario_id, rol_id)
            VALUES (v_usuario_id, v_rol_id)
            ON CONFLICT (usuario_id, rol_id) DO NOTHING;
        END IF;
    END LOOP;
    
    RAISE NOTICE '✅ Usuario creado: % (ID: %)', p_email, v_usuario_id;
    RETURN v_usuario_id;
END;
$$ LANGUAGE plpgsql;

-- Paso 3: Crear usuarios con hash bcrypt
DO $$
DECLARE
    v_password_hash TEXT := '$2b$10$iaIWZ5j.t4Rn9qaMzVyvgeqLZDSvkvYAla.2yIieco0/KVYMhnLFG';
    v_socio_id INTEGER;
    v_empleado_id INTEGER;
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE '🔐 CREANDO USUARIOS DE PRUEBA';
    RAISE NOTICE '============================================';
    
    -- ========================================
    -- CLIENTES (6)
    -- ========================================
    RAISE NOTICE '👥 Creando CLIENTES...';
    
    -- Cliente 1: María Elena González
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'mariaelena.gonzalez@hotmail.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('María Elena', 'González', '12345678', '3564-123456', 
                'mariaelena.gonzalez@hotmail.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'mariaelena.gonzalez@hotmail.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- Cliente 2: Roberto Carlos Martínez
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'robertocarlos.martinez@gmail.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('Roberto Carlos', 'Martínez', '23456789', '3564-234567', 
                'robertocarlos.martinez@gmail.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'robertocarlos.martinez@gmail.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- Cliente 3: Ana Paula Fernández
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'anapaula.fernandez@yahoo.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('Ana Paula', 'Fernández', '34567890', '3564-345678', 
                'anapaula.fernandez@yahoo.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'anapaula.fernandez@yahoo.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- Cliente 4: Juan Manuel López
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'juanmanuel.lopez@outlook.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('Juan Manuel', 'López', '45678901', '3564-456789', 
                'juanmanuel.lopez@outlook.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'juanmanuel.lopez@outlook.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- Cliente 5: Silvia Raquel Rodríguez
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'silviaraquel.rodriguez@gmail.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('Silvia Raquel', 'Rodríguez', '56789012', '3564-567890', 
                'silviaraquel.rodriguez@gmail.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'silviaraquel.rodriguez@gmail.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- Cliente 6: Carlos Alberto Sánchez
    SELECT socio_id INTO v_socio_id 
    FROM socio 
    WHERE email = 'carlosalberto.sanchez@hotmail.com' 
    LIMIT 1;
    
    IF v_socio_id IS NULL THEN
        INSERT INTO socio (nombre, apellido, dni, telefono, email, fecha_alta)
        VALUES ('Carlos Alberto', 'Sánchez', '67890123', '3564-678901', 
                'carlosalberto.sanchez@hotmail.com', CURRENT_DATE)
        RETURNING socio_id INTO v_socio_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'carlosalberto.sanchez@hotmail.com',
        v_password_hash,
        v_socio_id,
        NULL,
        ARRAY['CLIENTE']
    );
    
    -- ========================================
    -- OPERARIOS (3)
    -- ========================================
    RAISE NOTICE '🔧 Creando OPERARIOS...';
    
    -- Operario 1: Pedro Electricista
    SELECT empleado_id INTO v_empleado_id 
    FROM empleado 
    WHERE legajo = 'EMP-001' 
    LIMIT 1;
    
    IF v_empleado_id IS NULL THEN
        INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
        VALUES ('Pedro', 'Martínez', 'EMP-001', 'OPERARIO', CURRENT_DATE)
        RETURNING empleado_id INTO v_empleado_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'pedro.electricista@cooperativa-ugarte.com.ar',
        v_password_hash,
        NULL,
        v_empleado_id,
        ARRAY['OPERARIO']
    );
    
    -- Operario 2: Juan Operario
    SELECT empleado_id INTO v_empleado_id 
    FROM empleado 
    WHERE legajo = 'EMP-002' 
    LIMIT 1;
    
    IF v_empleado_id IS NULL THEN
        INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
        VALUES ('Juan', 'García', 'EMP-002', 'OPERARIO', CURRENT_DATE)
        RETURNING empleado_id INTO v_empleado_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'juan.operario@cooperativa-ugarte.com.ar',
        v_password_hash,
        NULL,
        v_empleado_id,
        ARRAY['OPERARIO']
    );
    
    -- Operario 3: Luis Técnico
    SELECT empleado_id INTO v_empleado_id 
    FROM empleado 
    WHERE legajo = 'EMP-003' 
    LIMIT 1;
    
    IF v_empleado_id IS NULL THEN
        INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
        VALUES ('Luis', 'Herrera', 'EMP-003', 'OPERARIO', CURRENT_DATE)
        RETURNING empleado_id INTO v_empleado_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'luis.tecnico@cooperativa-ugarte.com.ar',
        v_password_hash,
        NULL,
        v_empleado_id,
        ARRAY['OPERARIO']
    );
    
    -- ========================================
    -- ADMINISTRADORES (2)
    -- ========================================
    RAISE NOTICE '👑 Creando ADMINISTRADORES...';
    
    -- Admin 1: Mónica Administradora
    SELECT empleado_id INTO v_empleado_id 
    FROM empleado 
    WHERE legajo = 'ADM-001' 
    LIMIT 1;
    
    IF v_empleado_id IS NULL THEN
        INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
        VALUES ('Mónica', 'Torres', 'ADM-001', 'ADMINISTRADOR', CURRENT_DATE)
        RETURNING empleado_id INTO v_empleado_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'monica.administradora@cooperativa-ugarte.com.ar',
        v_password_hash,
        NULL,
        v_empleado_id,
        ARRAY['ADMIN']
    );
    
    -- Admin 2: Carlos Admin
    SELECT empleado_id INTO v_empleado_id 
    FROM empleado 
    WHERE legajo = 'ADM-002' 
    LIMIT 1;
    
    IF v_empleado_id IS NULL THEN
        INSERT INTO empleado (nombre, apellido, legajo, rol_interno, fecha_ingreso)
        VALUES ('Carlos', 'Administrador', 'ADM-002', 'ADMINISTRADOR', CURRENT_DATE)
        RETURNING empleado_id INTO v_empleado_id;
    END IF;
    
    PERFORM crear_usuario_sistema(
        'carlos.admin@cooperativa-ugarte.com.ar',
        v_password_hash,
        NULL,
        v_empleado_id,
        ARRAY['ADMIN']
    );
    
    RAISE NOTICE '============================================';
    RAISE NOTICE '✅ USUARIOS CREADOS: 11 total';
    RAISE NOTICE '============================================';
END $$;

-- Paso 4: Vista para consultar usuarios
CREATE OR REPLACE VIEW v_usuarios_completos AS
SELECT 
    u.usuario_id,
    u.email,
    u.activo,
    COALESCE(s.nombre, e.nombre) AS nombre,
    COALESCE(s.apellido, e.apellido) AS apellido,
    s.dni AS socio_dni,
    e.legajo AS empleado_legajo,
    e.rol_interno AS empleado_rol,
    ARRAY_AGG(r.nombre) AS roles,
    u.created_at
FROM usuario u
LEFT JOIN socio s ON u.socio_id = s.socio_id
LEFT JOIN empleado e ON u.empleado_id = e.empleado_id
LEFT JOIN usuario_rol ur ON u.usuario_id = ur.usuario_id
LEFT JOIN rol r ON ur.rol_id = r.rol_id
GROUP BY u.usuario_id, u.email, u.activo, s.nombre, s.apellido, 
         e.nombre, e.apellido, s.dni, e.legajo, e.rol_interno, u.created_at;

-- Verificación final
SELECT 
    roles[1] AS rol,
    COUNT(*) AS cantidad
FROM v_usuarios_completos
GROUP BY roles[1]
ORDER BY rol;

\echo '✅ Script de autenticación completado';