-- ==============================================
-- CONJUNTO DE DATOS PARA PROTOTIPO COWORKING
-- ==============================================

-- 1. MIEMBROS (5 perfiles variados)
INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
VALUES ('Carlos', 'Martínez', 'carlos.martinez@gmail.com', '3201234567', 'freelancer', 'activo');

INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
VALUES ('María', 'Rodríguez', 'maria.rodriguez@techcorp.com', '3159876543', 'empresa', 'activo');

INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
VALUES ('Juan', 'López', 'juan.lopez@outlook.com', '3187654321', 'individual', 'activo');

INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
VALUES ('Ana', 'García', 'ana.garcia@startup.co', '3145678901', 'empresa', 'activo');

INSERT INTO miembros (nombre, apellido, email, telefono, tipo_miembro, estado) 
VALUES ('Pedro', 'Hernández', 'pedro.hernandez@yahoo.com', '3112345678', 'freelancer', 'activo');

-- 2. EMPRESAS (2 compañías)
INSERT INTO empresas (nombre_empresa, nit, direccion, telefono, contacto_principal) 
VALUES ('TechCorp Solutions SAS', '900123456-7', 'Calle 72 #10-34, Bogotá', '6017891234', 2);

INSERT INTO empresas (nombre_empresa, nit, direccion, telefono, contacto_principal) 
VALUES ('Startup Innovación Ltda', '900654321-2', 'Carrera 15 #93-45, Bogotá', '6013456789', 4);

-- 3. SUSCRIPCIONES (Relacionar miembros con planes)
-- Carlos con plan Básico
INSERT INTO suscripciones (id_miembro, id_plan, fecha_inicio, fecha_fin, estado) 
VALUES (1, 1, TO_DATE('2025-10-01', 'YYYY-MM-DD'), TO_DATE('2026-10-01', 'YYYY-MM-DD'), 'activa');

-- María con plan Profesional
INSERT INTO suscripciones (id_miembro, id_plan, fecha_inicio, fecha_fin, estado) 
VALUES (2, 2, TO_DATE('2025-09-15', 'YYYY-MM-DD'), TO_DATE('2026-09-15', 'YYYY-MM-DD'), 'activa');

-- Juan con plan Básico
INSERT INTO suscripciones (id_miembro, id_plan, fecha_inicio, fecha_fin, estado) 
VALUES (3, 1, TO_DATE('2025-11-01', 'YYYY-MM-DD'), TO_DATE('2026-11-01', 'YYYY-MM-DD'), 'activa');

-- Ana con plan Empresa
INSERT INTO suscripciones (id_miembro, id_plan, fecha_inicio, fecha_fin, estado) 
VALUES (4, 3, TO_DATE('2025-08-01', 'YYYY-MM-DD'), TO_DATE('2026-08-01', 'YYYY-MM-DD'), 'activa');

-- Pedro con plan Profesional
INSERT INTO suscripciones (id_miembro, id_plan, fecha_inicio, fecha_fin, estado) 
VALUES (5, 2, TO_DATE('2025-10-15', 'YYYY-MM-DD'), TO_DATE('2026-10-15', 'YYYY-MM-DD'), 'activa');

-- 4. ESPACIOS ADICIONALES (complementar los 3 existentes)
INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, piso, precio_hora, equipamiento, estado) 
VALUES ('Sala Juntas B', 'sala_reunion', 6, '1', 35000, 'Proyector, WiFi, TV 50 pulgadas', 'disponible');

INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, piso, precio_hora, equipamiento, estado) 
VALUES ('Escritorio 102', 'escritorio', 1, '1', 8000, 'WiFi, Lámpara LED, Enchufe', 'disponible');

-- 5. RESERVAS (Diferentes escenarios de uso)
-- Carlos reserva Sala Juntas A
INSERT INTO reservas (id_miembro, id_espacio, fecha_reserva, hora_inicio, hora_fin, proposito, estado) 
VALUES (1, 1, TO_DATE('2025-11-10', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2025-11-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-10 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Reunión con cliente importante', 'confirmada');

-- María reserva Oficina Privada 201
INSERT INTO reservas (id_miembro, id_espacio, fecha_reserva, hora_inicio, hora_fin, proposito, estado) 
VALUES (2, 3, TO_DATE('2025-11-09', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2025-11-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Jornada de desarrollo sprint', 'confirmada');

-- Juan reserva Sala Juntas B
INSERT INTO reservas (id_miembro, id_espacio, fecha_reserva, hora_inicio, hora_fin, proposito, estado) 
VALUES (3, 4, TO_DATE('2025-11-12', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2025-11-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Sesión de brainstorming', 'confirmada');

-- Ana reserva Sala Juntas A
INSERT INTO reservas (id_miembro, id_espacio, fecha_reserva, hora_inicio, hora_fin, proposito, estado) 
VALUES (4, 1, TO_DATE('2025-11-11', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2025-11-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-11 17:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Presentación inversionistas', 'confirmada');

-- Pedro reserva Escritorio 102
INSERT INTO reservas (id_miembro, id_espacio, fecha_reserva, hora_inicio, hora_fin, proposito, estado) 
VALUES (5, 5, TO_DATE('2025-11-08', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2025-11-08 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-11-08 13:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Trabajo de diseño freelance', 'completada');

-- 6. PAGOS (Transacciones financieras)
-- Pago suscripción Carlos
INSERT INTO pagos (id_miembro, id_suscripcion, concepto, monto, metodo_pago, estado) 
VALUES (1, 1, 'Pago mensual plan Básico - Octubre 2025', 150000, 'transferencia', 'pagado');

-- Pago suscripción María
INSERT INTO pagos (id_miembro, id_suscripcion, concepto, monto, metodo_pago, estado) 
VALUES (2, 2, 'Pago mensual plan Profesional - Octubre 2025', 350000, 'tarjeta', 'pagado');

-- Pago reserva Juan
INSERT INTO pagos (id_miembro, id_reserva, concepto, monto, metodo_pago, estado) 
VALUES (3, 3, 'Reserva Sala Juntas B - 2 horas', 70000, 'tarjeta', 'pagado');

-- Pago suscripción Ana
INSERT INTO pagos (id_miembro, id_suscripcion, concepto, monto, metodo_pago, estado) 
VALUES (4, 4, 'Pago mensual plan Empresa - Noviembre 2025', 800000, 'transferencia', 'pagado');

-- Pago combinado Pedro (suscripción + reserva)
INSERT INTO pagos (id_miembro, id_suscripcion, concepto, monto, metodo_pago, estado) 
VALUES (5, 5, 'Pago mensual plan Profesional - Noviembre 2025', 350000, 'transferencia', 'pendiente');

-- 7. RECURSOS (Inventario de equipamiento)
INSERT INTO recursos (nombre_recurso, tipo_recurso, id_espacio, cantidad, estado) 
VALUES ('Proyector Epson EB-X41', 'proyector', 1, 1, 'disponible');

INSERT INTO recursos (nombre_recurso, tipo_recurso, id_espacio, cantidad, estado) 
VALUES ('Pizarra Blanca 180x120', 'pizarra', 1, 2, 'disponible');

INSERT INTO recursos (nombre_recurso, tipo_recurso, id_espacio, cantidad, estado) 
VALUES ('Router WiFi AC1200', 'wifi', 3, 1, 'disponible');

INSERT INTO recursos (nombre_recurso, tipo_recurso, id_espacio, cantidad, estado) 
VALUES ('Impresora HP LaserJet', 'impresora', NULL, 1, 'disponible');

INSERT INTO recursos (nombre_recurso, tipo_recurso, id_espacio, cantidad, estado) 
VALUES ('TV Samsung 50 pulgadas', 'otro', 4, 1, 'disponible');

COMMIT;

-- ==============================================
-- CONSULTAS DE VERIFICACIÓN
-- ==============================================

-- Ver todos los miembros activos
SELECT * FROM miembros WHERE estado = 'activo';

-- Ver reservas con información del miembro y espacio
SELECT 
    r.id_reserva,
    m.nombre || ' ' || m.apellido AS miembro,
    e.nombre_espacio,
    r.fecha_reserva,
    r.proposito,
    r.estado
FROM reservas r
JOIN miembros m ON r.id_miembro = m.id_miembro
JOIN espacios e ON r.id_espacio = e.id_espacio
ORDER BY r.fecha_reserva DESC;

-- Ver pagos realizados
SELECT 
    p.id_pago,
    m.nombre || ' ' || m.apellido AS miembro,
    p.concepto,
    p.monto,
    p.metodo_pago,
    p.estado
FROM pagos p
JOIN miembros m ON p.id_miembro = m.id_miembro
ORDER BY p.fecha_pago DESC;

-- Ver suscripciones activas con plan
SELECT 
    m.nombre || ' ' || m.apellido AS miembro,
    pl.nombre_plan,
    pl.precio_mensual,
    s.fecha_inicio,
    s.fecha_fin
FROM suscripciones s
JOIN miembros m ON s.id_miembro = m.id_miembro
JOIN planes pl ON s.id_plan = pl.id_plan
WHERE s.estado = 'activa';
