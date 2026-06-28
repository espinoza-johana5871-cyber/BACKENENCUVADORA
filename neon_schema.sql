-- ========================================
-- UNIINCUBADORA - Schema Completo
-- Copiar y pegar en Neon SQL Editor
-- ========================================

-- 1. Tabla de usuarios
CREATE TABLE usuarios (
  id_usuario SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  clave VARCHAR(255) NOT NULL,
  rol VARCHAR(20) NOT NULL CHECK (rol IN ('administrador','mentor','emprendedor')),
  estado VARCHAR(10) NOT NULL DEFAULT 'activo' CHECK (estado IN ('activo','inactivo')),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tokens de acceso (Sanctum)
CREATE TABLE tokens_acceso (
  id_token BIGSERIAL PRIMARY KEY,
  tipo_modelo VARCHAR(255) NOT NULL,
  id_modelo BIGINT NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  token VARCHAR(64) NOT NULL UNIQUE,
  permisos TEXT,
  ultimo_uso TIMESTAMP NULL,
  expira_en TIMESTAMP NULL,
  creado_en TIMESTAMP NULL,
  actualizado_en TIMESTAMP NULL
);
CREATE INDEX idx_tokenable ON tokens_acceso(tipo_modelo, id_modelo);

-- 3. Proyectos
CREATE TABLE proyectos (
  id_proyecto SERIAL PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_docente INT NULL,
  nombre_proyecto VARCHAR(200) NOT NULL,
  descripcion TEXT NOT NULL,
  sector_tecnologico VARCHAR(200) NULL,
  problema_resuelve TEXT NULL,
  propuesta_valor TEXT NULL,
  estado VARCHAR(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente','activo','finalizado','rechazado')),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_proyectos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
  CONSTRAINT fk_proyectos_docente FOREIGN KEY (id_docente) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- 4. Asignaciones (mentor-proyecto)
CREATE TABLE asignaciones (
  id_asignacion SERIAL PRIMARY KEY,
  id_proyecto INT NOT NULL,
  id_usuario INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  activo VARCHAR(2) DEFAULT 'si' CHECK (activo IN ('si','no')),
  CONSTRAINT fk_asignaciones_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE,
  CONSTRAINT fk_asignaciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 5. Mentores
CREATE TABLE mentores (
  id_mentor SERIAL PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  especialidad VARCHAR(255) NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mentores_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 6. Emprendedores
CREATE TABLE emprendedores (
  id_emprendedor SERIAL PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  telefono VARCHAR(20) NULL,
  carrera VARCHAR(150) NULL,
  semestre VARCHAR(50) NULL,
  bio TEXT NULL,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_emprendedores_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 7. Etapas
CREATE TABLE etapas (
  id_etapa SERIAL PRIMARY KEY,
  nombre_etapa VARCHAR(100) NOT NULL,
  orden_etapa SMALLINT NOT NULL
);

-- 8. Seguimientos
CREATE TABLE seguimientos (
  id_seguimiento SERIAL PRIMARY KEY,
  id_proyecto INT NOT NULL,
  id_etapa INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NULL,
  id_mentor INT NOT NULL,
  CONSTRAINT fk_seguimientos_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE,
  CONSTRAINT fk_seguimientos_etapa FOREIGN KEY (id_etapa) REFERENCES etapas(id_etapa),
  CONSTRAINT fk_seguimientos_mentor FOREIGN KEY (id_mentor) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 9. Revisiones
CREATE TABLE revisiones (
  id_revision SERIAL PRIMARY KEY,
  id_seguimiento INT NOT NULL,
  fecha_envio DATE NOT NULL,
  observaciones TEXT NULL,
  revisado BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_revisiones_seguimiento FOREIGN KEY (id_seguimiento) REFERENCES seguimientos(id_seguimiento) ON DELETE CASCADE
);

-- 10. Documentos
CREATE TABLE documentos (
  id_documento SERIAL PRIMARY KEY,
  id_proyecto INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  archivo VARCHAR(500) NOT NULL,
  fecha DATE NOT NULL,
  id_usuario INT NOT NULL,
  id_revision INT NULL,
  CONSTRAINT fk_documentos_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE,
  CONSTRAINT fk_documentos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
  CONSTRAINT fk_documentos_revision FOREIGN KEY (id_revision) REFERENCES revisiones(id_revision) ON DELETE SET NULL
);

-- 11. Asesorias
CREATE TABLE asesorias (
  id_asesoria SERIAL PRIMARY KEY,
  id_seguimiento INT NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  descripcion TEXT NULL,
  fecha DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NULL,
  modalidad VARCHAR(10) DEFAULT 'virtual' CHECK (modalidad IN ('virtual','presencial')),
  enlace VARCHAR(500) NULL,
  lugar VARCHAR(300) NULL,
  estado VARCHAR(12) DEFAULT 'programada' CHECK (estado IN ('programada','realizada','cancelada')),
  notas TEXT NULL,
  CONSTRAINT fk_asesorias_seguimiento FOREIGN KEY (id_seguimiento) REFERENCES seguimientos(id_seguimiento) ON DELETE CASCADE
);

-- 12. Notificaciones
CREATE TABLE notificaciones (
  id SERIAL PRIMARY KEY,
  id_usuario INT NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  mensaje VARCHAR(500) NOT NULL,
  url VARCHAR(255) NULL,
  leida BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notificaciones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 13. Entregas
CREATE TABLE entregas (
  id SERIAL PRIMARY KEY,
  proyecto_id INT NOT NULL,
  usuario_id INT NOT NULL,
  descripcion TEXT NOT NULL,
  archivo_nombre VARCHAR(500) NULL,
  archivo_path VARCHAR(500) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_entregas_proyecto FOREIGN KEY (proyecto_id) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE,
  CONSTRAINT fk_entregas_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- ========================================
-- DATOS INICIALES
-- ========================================

-- Etapas
INSERT INTO etapas (nombre_etapa, orden_etapa) VALUES
  ('Ideacion', 1),
  ('Validacion', 2),
  ('Prototipo', 3),
  ('Incubacion', 4),
  ('Escalamiento', 5);

-- Usuarios de prueba
-- admin / admin1234
-- mentor / mentor1234
-- estudiante / estudiante1234
INSERT INTO usuarios (nombre, correo, clave, rol, estado) VALUES
  ('Administrador', 'admin@uniincubadora.edu.ec', '$2y$12$pGrdB.rLTPItiauFDvhDouEa.LuF6SWoIkGfTWJt4zv9JBRhigaIq', 'administrador', 'activo'),
  ('Carlos Mentor', 'mentor@uniincubadora.edu.ec', '$2y$12$1KZh/1X5RZY5HDp2mreSYee87x3Ox7KBKLrCP0OWHJTLsIMUxa7R2', 'mentor', 'activo'),
  ('Maria Emprendedora', 'estudiante@uniincubadora.edu.ec', '$2y$12$VxtG4G7uIbDiz9NI.q5aCe3kGByF9qTb6E1R573OGVmix1VIrmDFS', 'emprendedor', 'activo');
