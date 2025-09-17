CREATE DATABASE Renta_Movil;
USE Renta_Movil;

CREATE TABLE Rol (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    nombreRol ENUM('Cliente', 'Administrador', 'SuperAdmin') NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipoDocumento VARCHAR(50) NOT NULL,
    numeroDocumento VARCHAR(50) UNIQUE NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    contraseña VARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    fechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Activo', 'Inactivo', 'Suspendido') DEFAULT 'Activo',
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

CREATE TABLE Empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit VARCHAR(50) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

CREATE TABLE AdministradorEmpresa (
    idAdminEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    idEmpresa INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa)
);

CREATE TABLE CategoriaVehiculo (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE Vehiculo (
    idVehiculo INT AUTO_INCREMENT PRIMARY KEY,
    idEmpresa INT NOT NULL,
    idCategoria INT NOT NULL,
    placa VARCHAR(20) UNIQUE NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),
    color VARCHAR(50),
    precioDia DECIMAL(10,2) NOT NULL,
    tipoTransmision VARCHAR(50),
    tipoCombustible VARCHAR(50),
    capacidad INT,
    kilometraje INT,
    estado ENUM('Disponible', 'Reservado', 'Mantenimiento') DEFAULT 'Disponible',
    FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa),
    FOREIGN KEY (idCategoria) REFERENCES CategoriaVehiculo(idCategoria)
);

CREATE TABLE Reserva (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    idVehiculo INT NOT NULL,
    fechaReserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    estado ENUM('Pendiente', 'Pagada', 'Cancelada', 'Finalizada') DEFAULT 'Pendiente',
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo)
);

CREATE TABLE Contrato (
    idContrato INT AUTO_INCREMENT PRIMARY KEY,
    idReserva INT UNIQUE NOT NULL,
    rutaPDF VARCHAR(255) NOT NULL,
    fechaGeneracion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva)
);

CREATE TABLE MetodoPago (
    idMetodoPago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE Pago (
    idPago INT AUTO_INCREMENT PRIMARY KEY,
    idReserva INT NOT NULL,
    idMetodoPago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fechaPago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Exitoso', 'Fallido', 'Pendiente') DEFAULT 'Pendiente',
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva),
    FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago)
);

CREATE TABLE CalendarioDisponibilidad (
    idCalendario INT AUTO_INCREMENT PRIMARY KEY,
    idVehiculo INT NOT NULL,
    fecha DATE NOT NULL,
    disponible ENUM('Sí', 'No') DEFAULT 'Sí',
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo)
);

CREATE TABLE ReporteMantenimiento (
    idReporte INT AUTO_INCREMENT PRIMARY KEY,
    idVehiculo INT NOT NULL,
    idReserva INT,
    descripcion TEXT,
    bloqueo BOOLEAN DEFAULT FALSE,
    estado ENUM('Pendiente', 'Revisado', 'Cerrado') DEFAULT 'Pendiente',
    fechaReporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva)
);

CREATE TABLE Notificacion (
    idNotificacion INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Leído', 'No leído') DEFAULT 'No leído',
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE LogAcceso (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    fechaHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    direccionIP VARCHAR(45),
    exito ENUM('Sí', 'No') DEFAULT 'Sí',
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE ReporteSistema (
    idReporteSistema INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    tipoReporte VARCHAR(100),
    rutaArchivo VARCHAR(255),
    fechaGeneracion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE RecuperacionCuenta (
    idRecuperacion INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    fechaEnvio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Activo', 'Usado', 'Expirado') DEFAULT 'Activo',
    intentos INT DEFAULT 0
);
