-- =============================================
-- CONSULTORIO MÉDICO - SCRIPT COMPLETO
-- =============================================

-- =============================================
-- ELIMINACIÓN DE OBJETOS EXISTENTES
-- =============================================

DROP TABLE PAGO CASCADE CONSTRAINTS;
DROP TABLE DOSIS CASCADE CONSTRAINTS;
DROP TABLE RECETA CASCADE CONSTRAINTS;
DROP TABLE MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE MEDICO CASCADE CONSTRAINTS;
DROP TABLE DIGITADOR CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE BANCO CASCADE CONSTRAINTS;
DROP TABLE TIPO_RECETA CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;
DROP TABLE TIPO_MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE VIA_ADMINISTRACION CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE METODO_PAGO CASCADE CONSTRAINTS;

-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

-- Tablas maestras
CREATE TABLE REGION (
    cod_region NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE CIUDAD (
    cod_ciudad NUMBER(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    cod_region NUMBER(5) NOT NULL,
    CONSTRAINT ciudad_region_fk FOREIGN KEY (cod_region) REFERENCES REGION(cod_region)
);

CREATE TABLE COMUNA (
    cod_comuna NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    cod_ciudad NUMBER(5) NOT NULL,
    CONSTRAINT comuna_ciudad_fk FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD(cod_ciudad)
);

CREATE TABLE ESPECIALIDAD (
    cod_especialidad NUMBER(5) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE TIPO_MEDICAMENTO (
    cod_tipo NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE VIA_ADMINISTRACION (
    cod_via NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE TIPO_RECETA (
    cod_tipo NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE METODO_PAGO (
    cod_metodo NUMBER(4) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE BANCO (
    cod_banco NUMBER(2) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);

CREATE TABLE DIAGNOSTICO (
    cod_diagnostico NUMBER(3) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);

-- Tablas principales
CREATE TABLE DIGITADOR (
    id_digitador NUMBER(20) PRIMARY KEY,
    pnombre VARCHAR2(25) NOT NULL,
    papellido VARCHAR2(25) NOT NULL,
    dv_digitador CHAR(1) NOT NULL,
    CONSTRAINT ck_dv_digitador CHECK (dv_digitador IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

CREATE TABLE MEDICO (
    rut_med NUMBER(8) PRIMARY KEY,
    dv_med CHAR(1) NOT NULL,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25),
    especialidad VARCHAR2(25),
    telefono NUMBER(11) UNIQUE NOT NULL,
    cod_especialidad NUMBER(5),
    CONSTRAINT medico_especialidad_fk FOREIGN KEY (cod_especialidad) REFERENCES ESPECIALIDAD(cod_especialidad),
    CONSTRAINT ck_dv_med CHECK (dv_med IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

CREATE TABLE PACIENTE (
    rut_pac VARCHAR2(25) PRIMARY KEY,
    dv_pac CHAR(1) NOT NULL,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    telefono NUMBER(11),
    calle VARCHAR2(25) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    comuna NUMBER(5) NOT NULL,
    ciudad NUMBER(5) NOT NULL,
    region NUMBER(5) NOT NULL,
    fecha_nacimiento DATE,
    CONSTRAINT paciente_comuna_fk FOREIGN KEY (comuna) REFERENCES COMUNA(cod_comuna),
    CONSTRAINT paciente_ciudad_fk FOREIGN KEY (ciudad) REFERENCES CIUDAD(cod_ciudad),
    CONSTRAINT paciente_region_fk FOREIGN KEY (region) REFERENCES REGION(cod_region),
    CONSTRAINT ck_dv_pac CHECK (dv_pac IN ('0','1','2','3','4','5','6','7','8','9','K'))
);

CREATE TABLE MEDICAMENTO (
    cod_medicamento NUMBER(7) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL,
    tipo_medicamento NUMBER(3) NOT NULL,
    via_administra NUMBER(3) NOT NULL,
    stock NUMBER(10) DEFAULT 0,
    dosis_recomendada VARCHAR2(50),
    precio_unitario NUMBER(10,2),
    CONSTRAINT medicamento_tipo_fk FOREIGN KEY (tipo_medicamento) REFERENCES TIPO_MEDICAMENTO(cod_tipo),
    CONSTRAINT medicamento_via_fk FOREIGN KEY (via_administra) REFERENCES VIA_ADMINISTRACION(cod_via),
    CONSTRAINT ck_precio_medicamento CHECK (precio_unitario BETWEEN 1000 AND 2000000)
);

CREATE TABLE RECETA (
    cod_receta NUMBER(7) PRIMARY KEY,
    observaciones VARCHAR2(500) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    id_digitador NUMBER(20) NOT NULL,
    pac_rut VARCHAR2(25) NOT NULL,
    id_diagnostico NUMBER(3) NOT NULL,
    med_rut NUMBER(8) NOT NULL,
    id_tipo_receta NUMBER(3) NOT NULL,
    CONSTRAINT receta_digitador_fk FOREIGN KEY (id_digitador) REFERENCES DIGITADOR(id_digitador),
    CONSTRAINT receta_paciente_fk FOREIGN KEY (pac_rut) REFERENCES PACIENTE(rut_pac),
    CONSTRAINT receta_diagnostico_fk FOREIGN KEY (id_diagnostico) REFERENCES DIAGNOSTICO(cod_diagnostico),
    CONSTRAINT receta_medico_fk FOREIGN KEY (med_rut) REFERENCES MEDICO(rut_med),
    CONSTRAINT receta_tipo_fk FOREIGN KEY (id_tipo_receta) REFERENCES TIPO_RECETA(cod_tipo)
);

CREATE TABLE DOSIS (
    id_medicamento NUMBER(7),
    id_receta NUMBER(7),
    descripcion_dosis VARCHAR2(25) NOT NULL,
    CONSTRAINT dosis_pk PRIMARY KEY (id_medicamento, id_receta),
    CONSTRAINT dosis_medicamento_fk FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTO(cod_medicamento),
    CONSTRAINT dosis_receta_fk FOREIGN KEY (id_receta) REFERENCES RECETA(cod_receta)
);

CREATE TABLE PAGO (
    cod_boleta NUMBER(6) PRIMARY KEY,
    id_receta NUMBER(7) NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_total VARCHAR2(25) NOT NULL,
    metodo_pago NUMBER(4) NOT NULL,
    id_banco NUMBER(2),
    CONSTRAINT pago_receta_fk FOREIGN KEY (id_receta) REFERENCES RECETA(cod_receta),
    CONSTRAINT pago_metodo_fk FOREIGN KEY (metodo_pago) REFERENCES METODO_PAGO(cod_metodo),
    CONSTRAINT pago_banco_fk FOREIGN KEY (id_banco) REFERENCES BANCO(cod_banco)
);

-- =============================================
-- INSERTAR DATOS DE PRUEBA
-- =============================================

-- Datos maestros básicos
INSERT INTO METODO_PAGO (cod_metodo, nombre) VALUES (1, 'EFECTIVO');
INSERT INTO METODO_PAGO (cod_metodo, nombre) VALUES (2, 'TARJETA');
INSERT INTO METODO_PAGO (cod_metodo, nombre) VALUES (3, 'TRANSFERENCIA');

INSERT INTO TIPO_RECETA (cod_tipo, nombre) VALUES (1, 'DIGITAL');
INSERT INTO TIPO_RECETA (cod_tipo, nombre) VALUES (2, 'MAGISTRAL');
INSERT INTO TIPO_RECETA (cod_tipo, nombre) VALUES (3, 'RETENIDA');
INSERT INTO TIPO_RECETA (cod_tipo, nombre) VALUES (4, 'GENERAL');
INSERT INTO TIPO_RECETA (cod_tipo, nombre) VALUES (5, 'VETERINARIA');

INSERT INTO TIPO_MEDICAMENTO (cod_tipo, nombre) VALUES (1, 'GENÉRICO');
INSERT INTO TIPO_MEDICAMENTO (cod_tipo, nombre) VALUES (2, 'MARCA');

INSERT INTO VIA_ADMINISTRACION (cod_via, nombre) VALUES (1, 'ORAL');
INSERT INTO VIA_ADMINISTRACION (cod_via, nombre) VALUES (2, 'INYECTABLE');
INSERT INTO VIA_ADMINISTRACION (cod_via, nombre) VALUES (3, 'TÓPICA');

-- Región, Ciudad, Comuna
INSERT INTO REGION (cod_region, nombre) VALUES (1, 'Región Metropolitana');
INSERT INTO CIUDAD (cod_ciudad, nombre, cod_region) VALUES (1, 'Santiago', 1);
INSERT INTO COMUNA (nombre, cod_ciudad) VALUES ('Santiago Centro', 1);

-- Especialidades
INSERT INTO ESPECIALIDAD (nombre) VALUES ('Medicina General');
INSERT INTO ESPECIALIDAD (nombre) VALUES ('Pediatría');
INSERT INTO ESPECIALIDAD (nombre) VALUES ('Cardiología');

-- Bancos
INSERT INTO BANCO (cod_banco, nombre) VALUES (1, 'Banco de Chile');
INSERT INTO BANCO (cod_banco, nombre) VALUES (2, 'Banco Estado');

-- Diagnósticos
INSERT INTO DIAGNOSTICO (cod_diagnostico, nombre) VALUES (1, 'Hipertensión');
INSERT INTO DIAGNOSTICO (cod_diagnostico, nombre) VALUES (2, 'Diabetes');
INSERT INTO DIAGNOSTICO (cod_diagnostico, nombre) VALUES (3, 'Gripe');
INSERT INTO DIAGNOSTICO (cod_diagnostico, nombre) VALUES (4, 'Resfrío Común');

-- Digitador
INSERT INTO DIGITADOR (id_digitador, pnombre, papellido, dv_digitador) 
VALUES (1001, 'Juan', 'Pérez', '5');

-- Médico
INSERT INTO MEDICO (rut_med, dv_med, pnombre, papellido, telefono, cod_especialidad) 
VALUES (12345678, '9', 'Carlos', 'López', 912345678, 1);

-- Paciente (usando código de comuna 1 que se generó automáticamente)
INSERT INTO PACIENTE (rut_pac, dv_pac, pnombre, calle, numeracion, comuna, ciudad, region, fecha_nacimiento) 
VALUES ('98765432', '1', 'Ana', 'Calle Principal', 123, 1, 1, 1, DATE '1980-05-15');

-- Medicamentos
INSERT INTO MEDICAMENTO (cod_medicamento, nombre, tipo_medicamento, via_administra, precio_unitario, stock) 
VALUES (1001, 'Paracetamol', 1, 1, 2500, 100);

INSERT INTO MEDICAMENTO (cod_medicamento, nombre, tipo_medicamento, via_administra, precio_unitario, stock) 
VALUES (1002, 'Amoxicilina', 2, 1, 4500, 50);

INSERT INTO MEDICAMENTO (cod_medicamento, nombre, tipo_medicamento, via_administra, precio_unitario, stock) 
VALUES (1003, 'Ibuprofeno', 1, 1, 3200, 75);

-- Receta
INSERT INTO RECETA (cod_receta, observaciones, fecha_emision, id_digitador, pac_rut, id_diagnostico, med_rut, id_tipo_receta) 
VALUES (5001, 'Tomar cada 8 horas por 5 días. Reposo relativo.', SYSDATE, 1001, '98765432', 3, 12345678, 1);

-- Dosis
INSERT INTO DOSIS (id_medicamento, id_receta, descripcion_dosis) 
VALUES (1001, 5001, '1 tableta cada 8 hrs');

INSERT INTO DOSIS (id_medicamento, id_receta, descripcion_dosis) 
VALUES (1003, 5001, '1 tableta cada 12 hrs');

-- Pago
INSERT INTO PAGO (cod_boleta, id_receta, fecha_pago, monto_total, metodo_pago, id_banco) 
VALUES (100001, 5001, SYSDATE, '15000', 1, 1);

COMMIT;

-- =============================================
-- CONSULTAS DE VERIFICACIÓN
-- =============================================

-- Verificar tablas creadas
SELECT 'TABLAS CREADAS: ' || COUNT(*) || ' tablas' as verificacion
FROM user_tables;

-- Verificar datos insertados
SELECT 'PACIENTES: ' || COUNT(*) || ' registros' as datos FROM paciente
UNION ALL
SELECT 'MÉDICOS: ' || COUNT(*) || ' registros' FROM medico
UNION ALL
SELECT 'MEDICAMENTOS: ' || COUNT(*) || ' registros' FROM medicamento
UNION ALL
SELECT 'RECETAS: ' || COUNT(*) || ' registros' FROM receta
UNION ALL
SELECT 'PAGOS: ' || COUNT(*) || ' registros' FROM pago;

-- Consulta demostrativa: Recetas con información completa
SELECT 
    'Receta #' || r.cod_receta as receta,
    p.pnombre || ' ' || p.rut_pac as paciente,
    m.pnombre || ' ' || m.papellido as medico,
    d.nombre as diagnostico,
    tr.nombre as tipo_receta
FROM receta r
JOIN paciente p ON r.pac_rut = p.rut_pac
JOIN medico m ON r.med_rut = m.rut_med
JOIN diagnostico d ON r.id_diagnostico = d.cod_diagnostico
JOIN tipo_receta tr ON r.id_tipo_receta = tr.cod_tipo;

-- Consulta demostrativa: Medicamentos por receta
SELECT 
    'Receta #' || r.cod_receta as receta,
    med.nombre as medicamento,
    dos.descripcion_dosis as dosis,
    '$' || med.precio_unitario as precio
FROM receta r
JOIN dosis dos ON r.cod_receta = dos.id_receta
JOIN medicamento med ON dos.id_medicamento = med.cod_medicamento;

-- =============================================
-- MENSAJE FINAL
-- =============================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================================');
    DBMS_OUTPUT.PUT_LINE('BASE DE DATOS IMPLEMENTADA EXITOSAMENTE');
    DBMS_OUTPUT.PUT_LINE('Consultorio Médico Municipalidad Santa Gema');
    DBMS_OUTPUT.PUT_LINE('=============================================');
END;
/