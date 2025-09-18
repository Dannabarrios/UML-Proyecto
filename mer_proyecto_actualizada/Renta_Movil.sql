CREATE DATABASE Renta_Movil;
USE Renta_Movil;

CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY AUTO_INCREMENT,
    NombreUsuario VARCHAR(255) NOT NULL,
    Contraseña VARCHAR(255) NOT NULL,
    EstadoUsuario BOOLEAN DEFAULT TRUE, 
    TipoAutenticacion VARCHAR(50) NOT NULL, 
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UltimoAcceso TIMESTAMP NULL
);

CREATE TABLE Roles (
    RolID INT PRIMARY KEY AUTO_INCREMENT,
    NombreRol VARCHAR(50) NOT NULL, 
    Descripcion VARCHAR(255)
);

CREATE TABLE Usuario_Rol (
    UsuarioID INT,
    RolID INT,
    FechaAsignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UsuarioID, RolID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (RolID) REFERENCES Roles(RolID)
);

CREATE TABLE Permisos (
    PermisoID INT PRIMARY KEY AUTO_INCREMENT,
    NombrePermiso VARCHAR(50) NOT NULL, 
    Descripcion VARCHAR(255)
);

CREATE TABLE Rol_Permiso (
    RolID INT,
    PermisoID INT,
    FechaAsignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (RolID, PermisoID),
    FOREIGN KEY (RolID) REFERENCES Roles(RolID),
    FOREIGN KEY (PermisoID) REFERENCES Permisos(PermisoID)
);

CREATE TABLE Auditoria (
    AuditoriaID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT,
    Accion VARCHAR(255),
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Descripcion VARCHAR(500),
    IP_Origen VARCHAR(50),
    Aplicacion VARCHAR(255),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Configuracion_Seguridad (
    ConfiguracionID INT PRIMARY KEY AUTO_INCREMENT,
    NombreConfiguracion VARCHAR(100),
    ValorConfiguracion VARCHAR(100),
    Descripcion VARCHAR(255)
);

CREATE TABLE Sesion_Usuario (
    SesionID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT,
    FechaInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FechaFin TIMESTAMP NULL,
    IP_Origen VARCHAR(50),
    EstadoSesion VARCHAR(50) DEFAULT 'Activo',
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Log_Errores (
    ErrorID INT PRIMARY KEY AUTO_INCREMENT,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UsuarioID INT,
    TipoError VARCHAR(100),
    Descripcion VARCHAR(500),
    IP_Origen VARCHAR(50),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE Politicas_Contraseñas (
    PoliticaID INT PRIMARY KEY AUTO_INCREMENT,
    MinLongitud INT DEFAULT 8,
    MaxLongitud INT DEFAULT 20,
    RequiereMayusculas BOOLEAN DEFAULT TRUE,
    RequiereNumeros BOOLEAN DEFAULT TRUE,
    RequiereSimbolos BOOLEAN DEFAULT TRUE,
    CaducidadDias INT DEFAULT 90
);

CREATE TABLE Empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nit VARCHAR(50) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    estado VARCHAR(50) DEFAULT 'Activa'
);

CREATE TABLE PerfilUsuario (
    idPerfil INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    tipoDocumento VARCHAR(50) NOT NULL,
    numeroDocumento VARCHAR(50) UNIQUE NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    estado VARCHAR(50) DEFAULT 'Activo',
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
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
    estado VARCHAR(50) DEFAULT 'Disponible',
    fotoPrincipal LONGBLOB NULL,
    FOREIGN KEY (idEmpresa) REFERENCES Empresa(idEmpresa),
    FOREIGN KEY (idCategoria) REFERENCES CategoriaVehiculo(idCategoria)
);

CREATE TABLE DocumentoVehiculo (
    idDocVehiculo INT AUTO_INCREMENT PRIMARY KEY,
    idVehiculo INT NOT NULL,
    tipoDocumento VARCHAR(50) NOT NULL,
    numeroDocumento VARCHAR(100),
    fechaEmision DATE,
    fechaVencimiento DATE,
    rutaArchivo VARCHAR(255),
    estado VARCHAR(50) DEFAULT 'Vigente',
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo)
);

CREATE TABLE DocumentoUsuario (
    idDocUsuario INT AUTO_INCREMENT PRIMARY KEY,
    idPerfil INT NOT NULL,
    tipoDocumento VARCHAR(50) NOT NULL,
    numeroDocumento VARCHAR(100),
    fechaVencimiento DATE,
    rutaArchivo VARCHAR(255),
    FOREIGN KEY (idPerfil) REFERENCES PerfilUsuario(idPerfil)
);

CREATE TABLE Reserva (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    idVehiculo INT NOT NULL,
    fechaReserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo)
);

CREATE TABLE Contrato (
    idContrato INT AUTO_INCREMENT PRIMARY KEY,
    idReserva INT UNIQUE NOT NULL,
    rutaPDF VARCHAR(255) NOT NULL,
    condiciones TEXT NOT NULL, 
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
    estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva),
    FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago)
);

CREATE TABLE ReporteMantenimiento (
    idReporte INT AUTO_INCREMENT PRIMARY KEY,
    idVehiculo INT NOT NULL,
    idReserva INT,
    descripcion TEXT,
    bloqueo BOOLEAN DEFAULT FALSE,
    estado VARCHAR(50) DEFAULT 'Pendiente',
    fechaReporte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo),
    FOREIGN KEY (idReserva) REFERENCES Reserva(idReserva)
);

CREATE TABLE Notificacion (
    idNotificacion INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) DEFAULT 'No leido',
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

CREATE TABLE RecuperacionCuenta (
    idRecuperacion INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    fechaEnvio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) DEFAULT 'Activo',
    intentos INT DEFAULT 0,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
