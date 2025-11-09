-- ==============================================
-- BASE DE DATOS COWORKING - ORACLE
-- Schema Simple para Prototipo
-- ==============================================


-- Tabla de Miembros/Usuarios
CREATE TABLE miembros (
    id_miembro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    telefono VARCHAR2(20),
    tipo_miembro VARCHAR2(50) CHECK (tipo_miembro IN ('individual', 'empresa', 'freelancer')),
    fecha_registro DATE DEFAULT SYSDATE,
    estado VARCHAR2(20) CHECK (estado IN ('activo', 'inactivo', 'suspendido')) DEFAULT 'activo',
    CONSTRAINT email_format CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'))
);

-- Tabla de Empresas (para miembros corporativos)
CREATE TABLE empresas (
    id_empresa NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_empresa VARCHAR2(200) NOT NULL,
    nit VARCHAR2(50) UNIQUE,
    direccion VARCHAR2(300),
    telefono VARCHAR2(20),
    contacto_principal NUMBER,
    fecha_registro DATE DEFAULT SYSDATE,
    CONSTRAINT fk_contacto_empresa FOREIGN KEY (contacto_principal) REFERENCES miembros(id_miembro)
);

-- Tabla de Planes/Membresías
CREATE TABLE planes (
    id_plan NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_plan VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500),
    precio_mensual NUMBER(10,2) NOT NULL,
    horas_incluidas NUMBER,
    acceso_salas VARCHAR2(20) CHECK (acceso_salas IN ('ilimitado', 'limitado', 'no_incluido')),
    estado VARCHAR2(20) CHECK (estado IN ('activo', 'inactivo')) DEFAULT 'activo'
);

-- Tabla de Suscripciones (relación miembro-plan)
CREATE TABLE suscripciones (
    id_suscripcion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_miembro NUMBER NOT NULL,
    id_plan NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado VARCHAR2(20) CHECK (estado IN ('activa', 'cancelada', 'vencida')) DEFAULT 'activa',
    CONSTRAINT fk_suscripcion_miembro FOREIGN KEY (id_miembro) REFERENCES miembros(id_miembro),
    CONSTRAINT fk_suscripcion_plan FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
);

-- Tabla de Espacios/Salas
CREATE TABLE espacios (
    id_espacio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_espacio VARCHAR2(100) NOT NULL,
    tipo_espacio VARCHAR2(50) CHECK (tipo_espacio IN ('sala_reunion', 'escritorio', 'oficina_privada', 'area_comun')),
    capacidad NUMBER NOT NULL,
    piso VARCHAR2(10),
    precio_hora NUMBER(10,2),
    equipamiento VARCHAR2(500), -- Descripción de recursos disponibles
    estado VARCHAR2(20) CHECK (estado IN ('disponible', 'mantenimiento', 'no_disponible')) DEFAULT 'disponible'
);

-- Tabla de Reservas/Bookings
CREATE TABLE reservas (
    id_reserva NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_miembro NUMBER NOT NULL,
    id_espacio NUMBER NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIMESTAMP NOT NULL,
    hora_fin TIMESTAMP NOT NULL,
    proposito VARCHAR2(200),
    estado VARCHAR2(20) CHECK (estado IN ('confirmada', 'cancelada', 'completada')) DEFAULT 'confirmada',
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_reserva_miembro FOREIGN KEY (id_miembro) REFERENCES miembros(id_miembro),
    CONSTRAINT fk_reserva_espacio FOREIGN KEY (id_espacio) REFERENCES espacios(id_espacio),
    CONSTRAINT check_horario CHECK (hora_fin > hora_inicio)
);

-- Tabla de Pagos/Facturas
CREATE TABLE pagos (
    id_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_miembro NUMBER NOT NULL,
    id_suscripcion NUMBER,
    id_reserva NUMBER,
    concepto VARCHAR2(200) NOT NULL,
    monto NUMBER(10,2) NOT NULL,
    fecha_pago DATE DEFAULT SYSDATE,
    metodo_pago VARCHAR2(50) CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia', 'otro')),
    estado VARCHAR2(20) CHECK (estado IN ('pendiente', 'pagado', 'vencido')) DEFAULT 'pendiente',
    CONSTRAINT fk_pago_miembro FOREIGN KEY (id_miembro) REFERENCES miembros(id_miembro),
    CONSTRAINT fk_pago_suscripcion FOREIGN KEY (id_suscripcion) REFERENCES suscripciones(id_suscripcion),
    CONSTRAINT fk_pago_reserva FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- Tabla de Recursos/Equipamiento
CREATE TABLE recursos (
    id_recurso NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_recurso VARCHAR2(100) NOT NULL,
    tipo_recurso VARCHAR2(50) CHECK (tipo_recurso IN ('proyector', 'pizarra', 'wifi', 'impresora', 'otro')),
    id_espacio NUMBER,
    cantidad NUMBER DEFAULT 1,
    estado VARCHAR2(20) CHECK (estado IN ('disponible', 'en_uso', 'mantenimiento')) DEFAULT 'disponible',
    CONSTRAINT fk_recurso_espacio FOREIGN KEY (id_espacio) REFERENCES espacios(id_espacio)
);

-- ==============================================
-- ÍNDICES para optimización de consultas
-- ==============================================

CREATE INDEX idx_miembro_email ON miembros(email);
CREATE INDEX idx_reserva_fecha ON reservas(fecha_reserva);
CREATE INDEX idx_reserva_espacio ON reservas(id_espacio);
CREATE INDEX idx_suscripcion_miembro ON suscripciones(id_miembro);
CREATE INDEX idx_pago_miembro ON pagos(id_miembro);

-- ==============================================
-- DATOS DE EJEMPLO para testing
-- ==============================================

-- Insertar planes básicos
INSERT INTO planes (nombre_plan, descripcion, precio_mensual, horas_incluidas, acceso_salas) 
VALUES ('Básico', 'Acceso a áreas comunes', 150000, 20, 'limitado');

INSERT INTO planes (nombre_plan, descripcion, precio_mensual, horas_incluidas, acceso_salas) 
VALUES ('Profesional', 'Escritorio dedicado + salas', 350000, 80, 'ilimitado');

INSERT INTO planes (nombre_plan, descripcion, precio_mensual, horas_incluidas, acceso_salas) 
VALUES ('Empresa', 'Oficina privada', 800000, NULL, 'ilimitado');

-- Insertar espacios
INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, piso, precio_hora, equipamiento) 
VALUES ('Sala Juntas A', 'sala_reunion', 8, '2', 45000, 'Proyector, Pizarra, WiFi');

INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, piso, precio_hora, equipamiento) 
VALUES ('Escritorio 101', 'escritorio', 1, '1', 8000, 'WiFi, Enchufe');

INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, piso, precio_hora, equipamiento) 
VALUES ('Oficina Privada 201', 'oficina_privada', 4, '2', 60000, 'Escritorios, WiFi, Pizarra');

COMMIT;
