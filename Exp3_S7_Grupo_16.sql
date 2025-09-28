
-- CASO 1: IMPLEMENTACIÓN DEL MODELO

-- TABLAS
CREATE TABLE REGION (
    id_region NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
    nombre_region VARCHAR2(25) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);

CREATE TABLE ESTADO_CIVIL (
    id_estado_civil VARCHAR2(2),
    descripcion_est_civil VARCHAR2(25) NOT NULL,
    CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_estado_civil)
);

CREATE TABLE GENERO (
    id_genero VARCHAR2(3),
    descripcion_genero VARCHAR2(25) NOT NULL,
    CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);

CREATE TABLE TITULO (
    id_titulo VARCHAR2(3),
    descripcion_titulo VARCHAR2(60) NOT NULL,
    CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);

CREATE TABLE IDIOMA (
    id_idioma NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);

-- Sequence para COMUNA
CREATE SEQUENCE seq_comuna
START WITH 1101
INCREMENT BY 6;

CREATE TABLE COMUNA (
    id_comuna NUMBER,
    comuna_nombre VARCHAR2(25) NOT NULL,
    cod_region NUMBER NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region) REFERENCES REGION(id_region)
);

-- Sequence para COMPANIA
CREATE SEQUENCE seq_compania
START WITH 10
INCREMENT BY 5;

CREATE TABLE COMPANIA (
    id_empresa NUMBER,
    nombre_empresa VARCHAR2(50) NOT NULL,
    calle VARCHAR2(50),
    numeracion NUMBER(5),
    renta_promedio NUMBER(10),
    pct_numero NUMBER(4,3),
    cod_comuna NUMBER,
    CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
    CONSTRAINT COMPANIA_UN_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (cod_comuna) REFERENCES COMUNA(id_comuna)
);

CREATE TABLE PERSONAL (
    rut_persona NUMBER(8),
    dv_persona CHAR(1),
    prime_nombre VARCHAR2(25) NOT NULL,
    segundo_nombre VARCHAR2(25),
    primer_apellido VARCHAR2(25) NOT NULL,
    segundo_apellido VARCHAR2(25),
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR2(100),
    calle VARCHAR2(50),
    numeracion NUMBER(5),
    sueldo NUMBER(10),
    cod_comuna NUMBER,
    cod_genero VARCHAR2(3),
    cod_estado_civil VARCHAR2(2),
    cod_empresa NUMBER,
    encargado_rut NUMBER(8),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
    CONSTRAINT PERSONAL_FK_COMUNA FOREIGN KEY (cod_comuna) REFERENCES COMUNA(id_comuna),
    CONSTRAINT PERSONAL_FK_GENERO FOREIGN KEY (cod_genero) REFERENCES GENERO(id_genero),
    CONSTRAINT PERSONAL_FK_ESTADO_CIVIL FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL(id_estado_civil),
    CONSTRAINT PERSONAL_FK_COMPANIA FOREIGN KEY (cod_empresa) REFERENCES COMPANIA(id_empresa),
    CONSTRAINT PERSONAL_FK_ENCARGADO FOREIGN KEY (encargado_rut) REFERENCES PERSONAL(rut_persona)
);

CREATE TABLE TITULACION (
    cod_titulo VARCHAR2(3),
    persona_rut NUMBER(8),
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
    CONSTRAINT TITULACION_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona),
    CONSTRAINT TITULACION_FK_TITULO FOREIGN KEY (cod_titulo) REFERENCES TITULO(id_titulo)
);

CREATE TABLE DOMINIO (
    id_idioma NUMBER(3),
    persona_rut NUMBER(8),
    nivel VARCHAR2(25) NOT NULL,
    CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
    CONSTRAINT DOMINIO_FK_IDIOMA FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma),
    CONSTRAINT DOMINIO_FK_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL(rut_persona)
);

-- CASO 2: MODIFICACIÓN DEL MODELO

-- Restricción email único
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_UN_EMAIL UNIQUE (email);

-- Restricción dígito verificador válido
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_CK_DV CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- Restricción sueldo mínimo
ALTER TABLE PERSONAL
ADD CONSTRAINT PERSONAL_CK_SUELDO CHECK (sueldo >= 450000);


-- CASO 3: POBLAMIENTO DEL MODELO

-- REGION
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

-- IDIOMA
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

-- COMUNA
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'Arica', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'Santiago', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'Temuco', 11);

-- COMPANIA
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'SenTry', 'Los Alamos', 3490, 897000, 0.025, 1101);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.035, 1107);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'TIC spa', 'FLORES S.A.', 4357, 857000, NULL, 1107);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757000, 0.015, 1101);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32', 509, 1857000, 0.025, 1113);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, NULL, 1107);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_numero, cod_comuna) 
VALUES (seq_compania.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113);

COMMIT;


-- CASO 4: RECUPERACIÓN DE DATOS

-- INFORME 1
SELECT 
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección",
    renta_promedio AS "Renta Promedio",
    CASE 
        WHEN pct_numero IS NOT NULL THEN renta_promedio * (1 + pct_numero)
        ELSE NULL
    END AS "Simulación de Renta"
FROM COMPANIA
ORDER BY "Renta Promedio" DESC, "Nombre Empresa" ASC;

-- INFORME 2
SELECT 
    id_empresa AS "ID Empresa",
    nombre_empresa AS "Nombre Empresa",
    renta_promedio AS "Renta Promedio Actual",
    CASE 
        WHEN pct_numero IS NOT NULL THEN pct_numero + 0.15
        ELSE 0.15
    END AS "Porcentaje Aumentado",
    CASE 
        WHEN pct_numero IS NOT NULL THEN renta_promedio * (1 + pct_numero + 0.15)
        ELSE renta_promedio * 1.15
    END AS "Renta Promedio Incrementada"
FROM COMPANIA
ORDER BY "Renta Promedio Actual" ASC, "Nombre Empresa" DESC;

