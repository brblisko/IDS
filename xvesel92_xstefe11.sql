alter table VRAZDA
    drop constraint ID_OSOBA_VYKONAVATEL
/

drop table ALIANCIA
/

drop table DON_CINNOST
/

drop table CLEN_CINNOST
/

drop table RADOVY_CLEN
/

drop table VRAZDA
/

drop table CINNOST
/

drop table DON_STRETNUTIE
/

drop table STRETNUTIE_DONOV
/

drop table UZEMIE
/

drop table DON
/

drop table OSOBA
/

drop sequence uzemie_seq;

drop sequence don_cinnost_seq;
drop sequence clen_cinnost_seq;
drop sequence stretnutie_donov_seq;
drop sequence don_stretnutie_seq;


CREATE TABLE osoba(
  id_osoba VARCHAR(10),
  meno VARCHAR(64),
  tel_cislo NUMBER,
  domaca_adresa VARCHAR(64),
  email VARCHAR(32),
  PRIMARY KEY(id_osoba),
  CHECK(REGEXP_LIKE(
      tel_cislo, '^(421|420)[0-9]{9}$')),
  CHECK(REGEXP_LIKE(
      id_osoba, '^[0-9]{9,10}$')),
  CHECK(REGEXP_LIKE(
      email, '^[a-z]+[a-z0-9.]*@[a-z0-9.-]+.[a-z]{2,}$'))
);


CREATE TABLE don(
    id_osoba VARCHAR(10),
    hl_sidlo VARCHAR(64),
    FOREIGN KEY (id_osoba) REFERENCES osoba(id_osoba),
    PRIMARY KEY (id_osoba)
);


CREATE TABLE vrazda(
  id_vrazda NUMBER,
  id_osoba_majitel VARCHAR(10),
  id_osoba_vykonavatel VARCHAR(10),
  miesto VARCHAR(64),
  cas TIMESTAMP,
  PRIMARY KEY(id_vrazda),
  FOREIGN KEY(id_osoba_majitel) REFERENCES don(id_osoba)
);

CREATE TABLE radovy_clen(
    id_osoba VARCHAR(10),
    id_osoba_nadriadeny VARCHAR(10),
    id_vrazdy NUMBER,
    FOREIGN KEY (id_vrazdy) REFERENCES vrazda(id_vrazda),
    FOREIGN KEY (id_osoba_nadriadeny) REFERENCES don(id_osoba),
    FOREIGN KEY (id_osoba) REFERENCES osoba(id_osoba),
    PRIMARY KEY (id_osoba)
);

ALTER TABLE vrazda
    ADD CONSTRAINT id_osoba_vykonavatel
        FOREIGN KEY(id_osoba_vykonavatel) REFERENCES  radovy_clen(id_osoba);



CREATE TABLE aliancia(
  id_aliancia NUMBER,
  id_osoba_1 VARCHAR(10),
  id_osoba_2 VARCHAR(10),
  trva_od TIMESTAMP,
  trva_do TIMESTAMP,
  FOREIGN KEY (id_osoba_1) REFERENCES don(id_osoba),
  FOREIGN KEY (id_osoba_2) REFERENCES don(id_osoba),
  PRIMARY KEY(id_aliancia)
);

CREATE TABLE uzemie(
  id_uzemie NUMBER,
  id_osoba VARCHAR(10),
  rozloha NUMBER,
  gps_suradnice VARCHAR(20),
  adresa VARCHAR(64),
  FOREIGN KEY (id_osoba) REFERENCES don(id_osoba),
  PRIMARY KEY (id_uzemie)
);

CREATE TABLE cinnost(
  id_cinnost NUMBER,
  id_uzemie NUMBER,
  doba_trvania VARCHAR(32),
  cas_zacatia TIMESTAMP,
  typ VARCHAR(64),
  FOREIGN KEY (id_uzemie) REFERENCES uzemie(id_uzemie),
  PRIMARY KEY (id_cinnost)
);

CREATE TABLE don_cinnost(
  id_majitel NUMBER,
  id_cinnost NUMBER,
  id_osoba VARCHAR(10),
  PRIMARY KEY (id_osoba),
  FOREIGN KEY (id_cinnost) REFERENCES cinnost(id_cinnost),
  FOREIGN KEY (id_osoba) REFERENCES don(id_osoba)
);

CREATE TABLE stretnutie_donov(
    id_stretnutie NUMBER,
    id_uzemie NUMBER,
    PRIMARY KEY (id_stretnutie),
    FOREIGN KEY (id_uzemie) REFERENCES uzemie(id_uzemie)
);

CREATE  TABLE clen_cinnost(
    id_pracovnici NUMBER,
    id_osoba VARCHAR(10),
    id_cinnost NUMBER,
    FOREIGN KEY (id_osoba) REFERENCES radovy_clen(id_osoba),
    FOREIGN KEY (id_cinnost) REFERENCES cinnost(id_cinnost),
    PRIMARY KEY (id_pracovnici)

);

CREATE TABLE don_stretnutie(
    id_hostia NUMBER,
    id_stretnutia NUMBER,
    id_osoba VARCHAR(10),
    PRIMARY KEY (id_hostia),
    FOREIGN KEY (id_stretnutia) REFERENCES stretnutie_donov(id_stretnutie),
    FOREIGN KEY (id_osoba) REFERENCES don(id_osoba)
);


INSERT INTO osoba VALUES ('7512315822', 'Don Lasagna', '00420991232112','Cestovinova ulica 120, Rim','najlepsidon@gmail.com');
INSERT INTO osoba VALUES ('5603023019' ,'Frederico Silvester', '00421903399092', 'Pizzova ulica 13,Milano' , 'najomnyzabijak@gmail.com');
INSERT INTO osoba VALUES ('985310401' , 'Boris Vesely' ,'00421904349690', 'Namestie pizze 18,Bologna' , 'borisvesely@gmail.com');
INSERT INTO osoba VALUES ('0056085084' , 'Nina Stefekova', '00420902344567', 'Mafianska ulica 2 ,Chicago' , 'ninastefekova@gmail.com');
INSERT INTO osoba VALUES ('6203104028' , 'Al Capone', '00420912344548', 'Mafianska ulica 8,Chicago' , 'alcapone123@gmail.com');

INSERT INTO don VALUES ('7512315822', 'Milano');
INSERT INTO don VALUES ('0056085084', 'Puchov');
INSERT INTO don VALUES ('6203104028', 'New York');

INSERT INTO radovy_clen VALUES ('985310401', '0056085084', '');
INSERT INTO radovy_clen VALUES ('5603023019', '6203104028', '');





CREATE SEQUENCE uzemie_seq
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER uzemie_inc
BEFORE INSERT ON uzemie
FOR EACH ROW
BEGIN
SELECT uzemie_seq.nextval
INTO :NEW.id_uzemie
FROM DUAL;
END;

INSERT INTO uzemie VALUES (NULL,'7512315822',32,'43.156,-75.844', 'Little Italy 34, New York');
INSERT INTO uzemie VALUES (NULL,'0056085084',17,'43.156,-75.844', 'Pizzova Ulica 4, Milano');
INSERT INTO uzemie VALUES (NULL,'6203104028',23,'43.156,-75.844', ' Talianska 5, Chicago');


INSERT INTO aliancia VALUES ( 2,'7512315822','0056085084',TO_TIMESTAMP('2000-06-04 12:00:00','YYYY/MM/DD HH:MI:SS'),TO_TIMESTAMP('2005-08-04 03:00:00','YYYY/MM/DD HH:MI:SS'));


INSERT INTO cinnost VALUES (1,1,'34 dni',TO_TIMESTAMP('1980-08-04 01:00:00','YYYY/MM/DD HH:MI:SS'),'kradez');
INSERT INTO cinnost VALUES (2,2,'365 dni',TO_TIMESTAMP('1999-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'vydieranie');



CREATE SEQUENCE don_cinnost_seq
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER don_cinnost_inc
BEFORE INSERT ON don_cinnost
FOR EACH ROW
BEGIN
SELECT don_cinnost_seq.nextval
INTO :NEW.id_majitel
FROM DUAL;
END;

INSERT INTO don_cinnost VALUES (NULL,1,'7512315822');
INSERT INTO don_cinnost VALUES (NULL,2,'6203104028');

CREATE SEQUENCE clen_cinnost_seq
START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER clen_cinnost_inc
BEFORE INSERT ON clen_cinnost
FOR EACH ROW
BEGIN
SELECT clen_cinnost_seq.nextval
INTO :NEW.id_pracovnici
FROM DUAL;
END;

INSERT INTO clen_cinnost VALUES (NULL, '5603023019', 2);
INSERT INTO clen_cinnost VALUES (NULL, '985310401', 1);


INSERT INTO vrazda VALUES (123,'0056085084','985310401', 'Brno',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));

CREATE SEQUENCE stretnutie_donov_seq
START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER stretnutie_donov_inc
BEFORE INSERT ON stretnutie_donov
FOR EACH ROW
BEGIN
SELECT stretnutie_donov_seq.nextval
INTO :NEW.id_stretnutie
FROM DUAL;
END;


INSERT INTO stretnutie_donov VALUES (NULL,1);
INSERT INTO stretnutie_donov VALUES (NULL,2);


CREATE SEQUENCE don_stretnutie_seq
START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER don_stretnutie_inc
BEFORE INSERT ON don_stretnutie
FOR EACH ROW
BEGIN
SELECT don_stretnutie_seq.nextval
INTO :NEW.id_hostia
FROM DUAL;
END;

INSERT INTO don_stretnutie VALUES (NULL,1,'6203104028');
INSERT INTO don_stretnutie VALUES (NULL,1,'0056085084');

INSERT INTO don_stretnutie VALUES (NULL,2,'6203104028');
INSERT INTO don_stretnutie VALUES (NULL,2,'7512315822');