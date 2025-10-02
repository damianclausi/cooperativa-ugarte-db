-- ============================================
-- DATOS DE PRUEBA PARA COOPERATIVA ELÉCTRICA "GOBERNADOR UGARTE"
-- ============================================

-- Insertar socios de prueba (Cooperativa Eléctrica)
INSERT INTO socio (nombre, apellido, dni, email, telefono) VALUES
('Juan Carlos', 'Pérez', '20345678', 'juancarlos.perez@gmail.com', '2226123456'),
('María Elena', 'González', '27456789', 'mariaelena.gonzalez@hotmail.com', '2226234567'),
('Roberto Daniel', 'Martínez', '23567890', 'roberto.martinez@outlook.com', '2226345678'),
('Ana Sofía', 'Rodríguez', '31678901', 'ana.rodriguez@yahoo.com', '2226456789'),
('Carlos Alberto', 'Fernández', '18789012', 'carlos.fernandez@gmail.com', '2226567890'),
('Laura Beatriz', 'López', '25890123', 'laura.lopez@gmail.com', '2226678901'),
('Miguel Ángel', 'Sánchez', '29901234', 'miguel.sanchez@hotmail.com', '2226789012'),
('Patricia Isabel', 'Díaz', '33012345', 'patricia.diaz@outlook.com', '2226890123'),
('José Luis', 'Morales', '21123456', 'jose.morales@gmail.com', '2226901234'),
('Carmen Rosa', 'Vega', '24234567', 'carmen.vega@hotmail.com', '2226012345'),
('Diego Sebastián', 'Herrera', '26345678', 'diego.herrera@gmail.com', '2226123789'),
('Silvia Mónica', 'Castro', '30456789', 'silvia.castro@yahoo.com', '2226234890');

-- Insertar cuentas de prueba (Cooperativa Eléctrica)
INSERT INTO cuenta (socio_id, numero_cuenta, direccion, localidad, servicio_id, principal) VALUES
(1, '001001', 'Av. San Martín 1234', 'Gobernador Ugarte', 4, true),
(2, '001002', 'Calle Belgrano 567', 'Gobernador Ugarte', 4, true),
(3, '001003', 'Rivadavia 890', 'Gobernador Ugarte', 4, true),
(4, '001004', 'Mitre 123', 'Gobernador Ugarte', 4, true),
(5, '001005', 'Sarmiento 456', 'Gobernador Ugarte', 4, true),
(6, '001006', 'Moreno 789', 'Gobernador Ugarte', 4, true),
(7, '001007', 'Alsina 321', 'Gobernador Ugarte', 4, true),
(8, '001008', 'Córdoba 654', 'Gobernador Ugarte', 4, true),
(9, '001009', 'Tucumán 987', 'Gobernador Ugarte', 4, true),
(10, '001010', 'Roca 456', 'Gobernador Ugarte', 4, true),
(11, '001011', 'Lavalle 789', 'Gobernador Ugarte', 4, true),
(12, '001012', 'Urquiza 321', 'Gobernador Ugarte', 4, true);

-- Insertar medidores de prueba (Medidores eléctricos)
INSERT INTO medidor (cuenta_id, numero_medidor, lat, lng, fecha_instalacion) VALUES
(1, 'ME-001234', -38.9517, -68.0583, '2023-03-15'),
(2, 'ME-001235', -38.9523, -68.0591, '2023-04-20'),
(3, 'ME-001236', -38.9510, -68.0575, '2023-05-10'),
(4, 'ME-001237', -38.9530, -68.0595, '2023-06-05'),
(5, 'ME-001238', -38.9505, -68.0570, '2023-07-12'),
(6, 'ME-001239', -38.9535, -68.0600, '2023-08-18'),
(7, 'ME-001240', -38.9500, -68.0565, '2023-09-22'),
(8, 'ME-001241', -38.9540, -68.0605, '2023-10-25'),
(9, 'ME-001242', -38.9495, -68.0560, '2023-11-30'),
(10, 'ME-001243', -38.9545, -68.0610, '2024-01-15');

-- Insertar lecturas de prueba (Consumo eléctrico en kWh)
INSERT INTO lectura (medidor_id, fecha, estado_anterior, estado_actual, observaciones) VALUES
-- Medidor 1 (ME-001234)
(1, '2024-08-01', 15420, 15650, 'Lectura normal'),
(1, '2024-09-01', 15650, 15885, 'Lectura normal'),
(1, '2024-10-01', 15885, 16120, 'Lectura normal'),
-- Medidor 2 (ME-001235)
(2, '2024-08-01', 8750, 8920, 'Lectura normal'),
(2, '2024-09-01', 8920, 9095, 'Lectura normal'),
(2, '2024-10-01', 9095, 9270, 'Lectura normal'),
-- Medidor 3 (ME-001236)
(3, '2024-08-01', 12300, 12580, 'Lectura normal'),
(3, '2024-09-01', 12580, 12865, 'Lectura normal'),
(3, '2024-10-01', 12865, 13150, 'Lectura normal'),
-- Medidor 4 (ME-001237)
(4, '2024-08-01', 6850, 6995, 'Lectura normal'),
(4, '2024-09-01', 6995, 7140, 'Lectura normal'),
(4, '2024-10-01', 7140, 7285, 'Lectura normal'),
-- Medidor 5 (ME-001238)
(5, '2024-08-01', 18900, 19250, 'Lectura normal'),
(5, '2024-09-01', 19250, 19605, 'Lectura normal'),
(5, '2024-10-01', 19605, 19960, 'Lectura normal'),
-- Medidor 6 (ME-001239)
(6, '2024-08-01', 11200, 11430, 'Lectura normal'),
(6, '2024-09-01', 11430, 11665, 'Lectura normal'),
(6, '2024-10-01', 11665, 11900, 'Lectura normal'),
-- Medidor 7 (ME-001240)
(7, '2024-08-01', 14750, 15020, 'Lectura normal'),
(7, '2024-09-01', 15020, 15290, 'Lectura normal'),
(7, '2024-10-01', 15290, 15560, 'Lectura normal'),
-- Medidor 8 (ME-001241)
(8, '2024-08-01', 9500, 9720, 'Lectura normal'),
(8, '2024-09-01', 9720, 9945, 'Lectura normal'),
(8, '2024-10-01', 9945, 10170, 'Lectura normal'),
-- Medidor 9 (ME-001242)
(9, '2024-08-01', 16800, 17150, 'Lectura normal'),
(9, '2024-09-01', 17150, 17505, 'Lectura normal'),
(9, '2024-10-01', 17505, 17860, 'Lectura normal'),
-- Medidor 10 (ME-001243)
(10, '2024-08-01', 7250, 7425, 'Lectura normal'),
(10, '2024-09-01', 7425, 7600, 'Lectura normal'),
(10, '2024-10-01', 7600, 7775, 'Lectura normal');

-- Insertar empleados de prueba (Cooperativa Eléctrica)
INSERT INTO empleado (nombre, apellido, legajo, rol_interno) VALUES
('Pedro Ramón', 'García', 'EMP-001', 'Técnico Electricista'),
('Ana María', 'Fernández', 'EMP-002', 'Supervisora de Cuadrilla'),
('Luis Alberto', 'Martínez', 'EMP-003', 'Técnico de Líneas'),
('Carmen Alicia', 'López', 'EMP-004', 'Atención al Socio'),
('Jorge Eduardo', 'Rodríguez', 'EMP-005', 'Técnico de Mantenimiento'),
('Raúl Domingo', 'Sánchez', 'EMP-006', 'Montajista de Líneas'),
('Mónica Estela', 'Díaz', 'EMP-007', 'Administrativa Contable'),
('Fernando José', 'Morales', 'EMP-008', 'Operador de Red'),
('Sandra Beatriz', 'Vega', 'EMP-009', 'Técnica en Medidores'),
('Daniel Ricardo', 'Castro', 'EMP-010', 'Guardia de Emergencias');

-- Insertar cuadrillas de prueba (Zonas de Gobernador Ugarte)
INSERT INTO cuadrilla (nombre, zona) VALUES
('Cuadrilla Centro', 'Zona Centro'),
('Cuadrilla Norte', 'Zona Norte'),
('Cuadrilla Sur', 'Zona Sur'),
('Cuadrilla Emergencias', 'Toda la Ciudad'),
('Cuadrilla Mantenimiento', 'Red General');

-- Asignar empleados a cuadrillas
INSERT INTO empleado_cuadrilla (empleado_id, cuadrilla_id) VALUES
(1, 1), -- Pedro Electricista en Centro
(2, 1), -- Ana Supervisora en Centro
(3, 2), -- Luis Técnico en Norte
(5, 3), -- Jorge Mantenimiento en Sur
(6, 2), -- Raúl Montajista en Norte
(8, 1), -- Fernando Operador en Centro
(9, 5), -- Sandra Medidores en Mantenimiento
(10, 4); -- Daniel en Emergencias

-- Insertar reclamos de prueba (Cooperativa Eléctrica)
INSERT INTO reclamo (cuenta_id, tipo_id, prioridad_id, descripcion, canal) VALUES
(1, 1, 1, 'Corte total de energía eléctrica desde las 14:00 hs', 'TELEFONO'),
(3, 3, 1, 'Cable caído en la vereda frente al domicilio', 'WEB'),
(5, 2, 2, 'Fluctuaciones de tensión que dañaron electrodomésticos', 'PRESENCIAL'),
(7, 4, 2, 'El medidor eléctrico no registra consumo correctamente', 'TELEFONO'),
(9, 5, 3, 'Consulta sobre facturación de período agosto 2024', 'WEB'),
(2, 1, 1, 'Sin suministro eléctrico por tormenta', 'TELEFONO'),
(4, 6, 3, 'Solicitud de nueva conexión para ampliación', 'PRESENCIAL'),
(6, 3, 2, 'Poste de luz inclinado por viento', 'WEB'),
(8, 2, 2, 'Variaciones de tensión en horario nocturno', 'EMAIL'),
(10, 7, 1, 'Solicitud de reconexión del servicio', 'TELEFONO');

-- Insertar órdenes de trabajo (Cooperativa Eléctrica)
INSERT INTO orden_trabajo (reclamo_id, empleado_id, fecha_programada, estado, direccion_intervencion) VALUES
(1, 1, '2024-10-02 09:00:00', 'EN_PROCESO', 'Av. San Martín 1234'),
(2, 3, '2024-10-02 14:00:00', 'COMPLETADA', 'Calle Belgrano 567'),
(3, 1, '2024-10-03 10:00:00', 'ASIGNADA', 'Sarmiento 456'),
(4, 9, '2024-10-03 15:00:00', 'PENDIENTE', 'Mitre 123'),
(5, 1, '2024-10-04 08:00:00', 'ASIGNADA', 'Tucumán 987'),
(6, 10, '2024-10-01 20:00:00', 'COMPLETADA', 'Calle Belgrano 567'),
(7, 2, '2024-10-05 10:00:00', 'PENDIENTE', 'Moreno 789'),
(8, 6, '2024-10-04 14:00:00', 'ASIGNADA', 'Córdoba 654'),
(9, 8, '2024-10-03 16:00:00', 'EN_PROCESO', 'Córdoba 654'),
(10, 10, '2024-10-02 08:00:00', 'COMPLETADA', 'Roca 456');

-- Insertar itinerarios
INSERT INTO itinerario (cuadrilla_id, fecha, observaciones) VALUES
(1, '2024-10-02', 'Recorrido matutino centro'),
(2, '2024-10-02', 'Recorrido zona norte');

-- Insertar detalle de itinerarios
INSERT INTO itinerario_det (itinerario_id, ot_id, orden, hora_estimada) VALUES
(1, 1, 1, '09:00:00'),
(1, 2, 2, '14:00:00'),
(2, 3, 1, '10:00:00');

-- Insertar facturas de prueba (Cooperativa Eléctrica)
INSERT INTO factura (cuenta_id, periodo, importe, vencimiento, numero_externo) VALUES
-- Facturas de Septiembre 2024
(1, '2024-09-01', 18750.00, '2024-10-15', 'CE-001001-092024'),
(2, '2024-09-01', 12980.50, '2024-10-15', 'CE-001002-092024'),
(3, '2024-09-01', 21450.75, '2024-10-15', 'CE-001003-092024'),
(4, '2024-09-01', 9850.00, '2024-10-15', 'CE-001004-092024'),
(5, '2024-09-01', 28500.25, '2024-10-15', 'CE-001005-092024'),
(6, '2024-09-01', 16750.00, '2024-10-15', 'CE-001006-092024'),
(7, '2024-09-01', 19200.50, '2024-10-15', 'CE-001007-092024'),
(8, '2024-09-01', 14670.75, '2024-10-15', 'CE-001008-092024'),
(9, '2024-09-01', 25850.00, '2024-10-15', 'CE-001009-092024'),
(10, '2024-09-01', 11340.25, '2024-10-15', 'CE-001010-092024'),
-- Facturas de Agosto 2024
(1, '2024-08-01', 17890.00, '2024-09-15', 'CE-001001-082024'),
(2, '2024-08-01', 11950.50, '2024-09-15', 'CE-001002-082024'),
(3, '2024-08-01', 20100.75, '2024-09-15', 'CE-001003-082024'),
(4, '2024-08-01', 8750.00, '2024-09-15', 'CE-001004-082024'),
(5, '2024-08-01', 26800.25, '2024-09-15', 'CE-001005-082024');

-- Insertar algunos pagos (Cooperativa Eléctrica)
INSERT INTO pago (factura_id, fecha, monto, medio, external_ref) VALUES
-- Pagos de facturas de agosto (ya vencidas)
(11, '2024-09-10 10:30:00', 17890.00, 'TRANSFERENCIA', 'TRF-230910-001'),
(12, '2024-09-12 15:45:00', 11950.50, 'DEBITO_AUTOMATICO', 'DA-230912-002'),
(13, '2024-09-14 12:20:00', 20100.75, 'PAGO_FACIL', 'PF-230914-003'),
(15, '2024-09-08 09:15:00', 26800.25, 'RAPIPAGO', 'RP-230908-005'),
-- Pagos de facturas de septiembre
(1, '2024-10-01 14:30:00', 18750.00, 'TRANSFERENCIA', 'TRF-241001-006'),
(4, '2024-10-03 11:45:00', 9850.00, 'DEBITO_AUTOMATICO', 'DA-241003-007'),
(6, '2024-10-02 16:20:00', 16750.00, 'TARJETA_CREDITO', 'TC-241002-008');

-- Insertar usuarios de prueba (Cooperativa Eléctrica)
INSERT INTO usuario (socio_id, email, hash_pass) VALUES
(1, 'juancarlos.perez@gmail.com', '$2b$10$example_hash_cliente_1'),
(2, 'mariaelena.gonzalez@hotmail.com', '$2b$10$example_hash_cliente_2'),
(3, 'roberto.martinez@outlook.com', '$2b$10$example_hash_cliente_3'),
(4, 'ana.rodriguez@yahoo.com', '$2b$10$example_hash_cliente_4'),
(5, 'carlos.fernandez@gmail.com', '$2b$10$example_hash_cliente_5'),
(6, 'laura.lopez@gmail.com', '$2b$10$example_hash_cliente_6');

INSERT INTO usuario (empleado_id, email, hash_pass) VALUES
(1, 'pedro.electricista@cooperativa-ugarte.com.ar', '$2b$10$example_hash_emp_1'),
(2, 'ana.supervisora@cooperativa-ugarte.com.ar', '$2b$10$example_hash_emp_2'),
(4, 'carmen.atencion@cooperativa-ugarte.com.ar', '$2b$10$example_hash_emp_4'),
(7, 'monica.administradora@cooperativa-ugarte.com.ar', '$2b$10$example_hash_emp_7'),
(10, 'daniel.emergencias@cooperativa-ugarte.com.ar', '$2b$10$example_hash_emp_10');

-- Asignar roles a usuarios (Cooperativa Eléctrica)
INSERT INTO usuario_rol (usuario_id, rol_id) VALUES
-- Clientes/Socios
(1, 1), -- Juan Carlos Pérez como CLIENTE
(2, 1), -- María Elena González como CLIENTE  
(3, 1), -- Roberto Daniel Martínez como CLIENTE
(4, 1), -- Ana Sofía Rodríguez como CLIENTE
(5, 1), -- Carlos Alberto Fernández como CLIENTE
(6, 1), -- Laura Beatriz López como CLIENTE
-- Empleados
(7, 2), -- Pedro Electricista como OPERARIO
(8, 2), -- Ana Supervisora como OPERARIO
(9, 2), -- Carmen Atención como OPERARIO
(10, 3), -- Mónica Administradora como ADMIN
(11, 2); -- Daniel Emergencias como OPERARIO

-- Insertar movimientos de stock (Materiales Eléctricos)
INSERT INTO mov_stock (material_id, tipo, cantidad, referencia, observaciones) VALUES
-- Ingresos iniciales de stock
(1, 'INGRESO', 100, 'COMPRA-ELE-001', 'Stock inicial de cables tripolares'),
(2, 'INGRESO', 80, 'COMPRA-ELE-001', 'Stock inicial de cables bipolares'),
(3, 'INGRESO', 50, 'COMPRA-ELE-002', 'Medidores monofásicos nuevos'),
(4, 'INGRESO', 25, 'COMPRA-ELE-002', 'Medidores trifásicos para industrias'),
(5, 'INGRESO', 200, 'COMPRA-ELE-003', 'Postes de hormigón standard'),
(6, 'INGRESO', 150, 'COMPRA-ELE-003', 'Crucetas de madera'),
(7, 'INGRESO', 300, 'COMPRA-ELE-004', 'Aisladores de porcelana'),
(8, 'INGRESO', 100, 'COMPRA-ELE-004', 'Fusibles NH de seguridad'),
-- Egresos por uso en trabajos
(1, 'EGRESO', 15, 'OT-001', 'Uso en reparación de línea'),
(3, 'EGRESO', 2, 'OT-002', 'Reemplazo de medidores'),
(5, 'EGRESO', 3, 'OT-003', 'Instalación nuevo poste'),
(7, 'EGRESO', 8, 'OT-004', 'Mantenimiento línea MT');

-- Insertar uso de materiales en órdenes de trabajo (Cooperativa Eléctrica)
INSERT INTO uso_material (ot_id, material_id, cantidad) VALUES
-- OT 1: Reparación de corte eléctrico
(1, 1, 15), -- 15 metros de cable tripolar
(1, 7, 4),  -- 4 aisladores
(1, 8, 2),  -- 2 fusibles
-- OT 2: Reemplazo de medidor
(2, 3, 1),  -- 1 medidor monofásico
(2, 2, 3),  -- 3 metros de cable bipolar
-- OT 6: Reparación de cable caído
(6, 1, 25), -- 25 metros de cable tripolar
(6, 6, 1),  -- 1 cruceta
(6, 7, 6),  -- 6 aisladores
-- OT 8: Instalación nuevo poste
(8, 5, 1),  -- 1 poste de hormigón
(8, 6, 2),  -- 2 crucetas
(8, 7, 8),  -- 8 aisladores
-- OT 10: Reconexión de servicio
(10, 2, 5), -- 5 metros de cable bipolar
(10, 8, 1); -- 1 fusible

-- Actualizar algunos estados (Cooperativa Eléctrica)
UPDATE reclamo SET estado = 'EN_PROCESO' WHERE reclamo_id IN (1, 3, 9);
UPDATE reclamo SET estado = 'RESUELTO' WHERE reclamo_id IN (2, 6, 10);
UPDATE orden_trabajo SET estado = 'EN_PROCESO' WHERE ot_id IN (1, 9);
UPDATE orden_trabajo SET estado = 'COMPLETADA' WHERE ot_id IN (2, 6, 10);
UPDATE factura SET estado = 'PAGADA' WHERE factura_id IN (1, 4, 6, 11, 12, 13, 15);

-- Mensaje de finalización
DO $$
BEGIN
    RAISE NOTICE 'Datos de prueba de Cooperativa Eléctrica "Gobernador Ugarte" insertados correctamente';
    RAISE NOTICE 'Socios: %', (SELECT count(*) FROM socio);
    RAISE NOTICE 'Cuentas: %', (SELECT count(*) FROM cuenta);
    RAISE NOTICE 'Medidores: %', (SELECT count(*) FROM medidor);
    RAISE NOTICE 'Lecturas: %', (SELECT count(*) FROM lectura);
    RAISE NOTICE 'Reclamos: %', (SELECT count(*) FROM reclamo);
    RAISE NOTICE 'Órdenes de trabajo: %', (SELECT count(*) FROM orden_trabajo);
    RAISE NOTICE 'Facturas: %', (SELECT count(*) FROM factura);
    RAISE NOTICE 'Pagos: %', (SELECT count(*) FROM pago);
    RAISE NOTICE 'Empleados: %', (SELECT count(*) FROM empleado);
    RAISE NOTICE 'Cuadrillas: %', (SELECT count(*) FROM cuadrilla);
END $$;