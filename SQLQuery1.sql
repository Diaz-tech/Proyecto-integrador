-- Crear la base de datos
CREATE DATABASE sistema_reservas_vuelos;
USE sistema_reservas_vuelos;

-- Tabla de clientes/pasajeros
CREATE TABLE pasajeros (
    id INT PRIMARY KEY AUTO_INCREMENT,        -- Identificador único del pasajero
    nombre_completo VARCHAR(100) NOT NULL,    -- Nombre completo del pasajero
    email VARCHAR(100) UNIQUE,               -- Email único para contacto
    telefono VARCHAR(20),                    -- Teléfono de contacto
    fecha_registro DATE DEFAULT CURRENT_DATE -- Fecha en que se registró
);

-- Tabla de aeropuertos (origen y destino)
CREATE TABLE aeropuertos (
    id INT PRIMARY KEY AUTO_INCREMENT,        -- Identificador único del aeropuerto
    codigo_iata VARCHAR(3) UNIQUE NOT NULL,  -- Código IATA (ej: BOG, MDE)
    nombre VARCHAR(100) NOT NULL,            -- Nombre completo del aeropuerto
    ciudad VARCHAR(50) NOT NULL,             -- Ciudad donde está ubicado
    pais VARCHAR(50) NOT NULL               -- País donde está ubicado
);

-- Tabla de vuelos disponibles
CREATE TABLE vuelos (
    id INT PRIMARY KEY AUTO_INCREMENT,        -- Identificador único del vuelo
    codigo_vuelo VARCHAR(10) UNIQUE NOT NULL,-- Código de vuelo (ej: AV123)
    aeropuerto_origen_id INT NOT NULL,       -- Aeropuerto de origen (relación)
    aeropuerto_destino_id INT NOT NULL,      -- Aeropuerto de destino (relación)
    fecha_salida DATETIME NOT NULL,          -- Fecha y hora de salida
    fecha_llegada DATETIME NOT NULL,         -- Fecha y hora de llegada
    precio_base DECIMAL(10, 2) NOT NULL,     -- Precio base del vuelo
    asientos_disponibles INT NOT NULL,       -- Cantidad de asientos disponibles
    FOREIGN KEY (aeropuerto_origen_id) REFERENCES aeropuertos(id),
    FOREIGN KEY (aeropuerto_destino_id) REFERENCES aeropuertos(id)
);

-- Tabla de reservas (la parte central del sistema)
CREATE TABLE reservas (
    id INT PRIMARY KEY AUTO_INCREMENT,        -- Identificador único de la reserva
    pasajero_id INT NOT NULL,                -- ID del pasajero que hace la reserva
    vuelo_id INT NOT NULL,                   -- ID del vuelo reservado
    fecha_reserva DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha en que se hizo la reserva
    numero_pasajeros INT NOT NULL,           -- Número de pasajeros en la reserva
    asiento VARCHAR(10),                     -- Número de asiento asignado
    precio_total DECIMAL(10, 2) NOT NULL,    -- Precio total de la reserva
    estado ENUM('pendiente', 'confirmada', 'cancelada') DEFAULT 'pendiente',
    FOREIGN KEY (pasajero_id) REFERENCES pasajeros(id),
    FOREIGN KEY (vuelo_id) REFERENCES vuelos(id)
);

-- Tabla de pagos
CREATE TABLE pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,        -- Identificador único del pago
    reserva_id INT NOT NULL,                 -- Reserva a la que pertenece el pago
    monto DECIMAL(10, 2) NOT NULL,           -- Monto pagado
    metodo_pago ENUM('tarjeta', 'transferencia', 'efectivo'), -- Método de pago
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha del pago
    estado ENUM('pendiente', 'completado', 'fallido') DEFAULT 'pendiente',
    FOREIGN KEY (reserva_id) REFERENCES reservas(id)
);

-- Insertar datos de ejemplo en aeropuertos
INSERT INTO aeropuertos (codigo_iata, nombre, ciudad, pais) VALUES
('BOG', 'Aeropuerto Internacional El Dorado', 'Bogotá', 'Colombia'),
('MDE', 'Aeropuerto Internacional José María Córdova', 'Medellín', 'Colombia'),
('CTG', 'Aeropuerto Internacional Rafael Núñez', 'Cartagena', 'Colombia'),
('PEI', 'Aeropuerto Internacional Matecaña', 'Pereira', 'Colombia');

-- Insertar datos de ejemplo en vuelos
INSERT INTO vuelos (codigo_vuelo, aeropuerto_origen_id, aeropuerto_destino_id, 
                   fecha_salida, fecha_llegada, precio_base, asientos_disponibles) VALUES
('AV1001', 1, 2, '2023-12-15 08:00:00', '2023-12-15 09:00:00', 150.00, 120),
('AV1002', 2, 3, '2023-12-16 10:30:00', '2023-12-16 12:00:00', 200.00, 100),
('AV1003', 1, 4, '2023-12-17 14:45:00', '2023-12-17 15:45:00', 120.00, 80);

-- Consulta para verificar los datos
SELECT * FROM aeropuertos;
SELECT * FROM vuelos;