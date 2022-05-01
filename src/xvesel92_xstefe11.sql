-------------------------------------------------------------------------------
-- Authors      xvesel92, xstefe11
-- Purpose      This script creates and fills database based on ER diagram
--              from phase 1 and contains SELECTS to fulfill assignment
--              from phase 3.
-------------------------------------------------------------------------------
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
drop sequence stretnutie_donov_seq;


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
  id_cinnost NUMBER,
  id_osoba VARCHAR(10),
  PRIMARY KEY (id_osoba,id_cinnost),
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
    id_osoba VARCHAR(10),
    id_cinnost NUMBER,
    FOREIGN KEY (id_osoba) REFERENCES radovy_clen(id_osoba),
    FOREIGN KEY (id_cinnost) REFERENCES cinnost(id_cinnost),
    PRIMARY KEY (id_osoba,id_cinnost)

);

CREATE TABLE don_stretnutie(
    id_stretnutia NUMBER,
    id_osoba VARCHAR(10),
    FOREIGN KEY (id_stretnutia) REFERENCES stretnutie_donov(id_stretnutie),
    FOREIGN KEY (id_osoba) REFERENCES don(id_osoba),
    PRIMARY KEY (id_stretnutia,id_osoba)
);


INSERT INTO osoba VALUES ('7512315822', 'Don Lasagna', '00420991232112','Cestovinova ulica 120, Rim','najlepsidon@gmail.com');
INSERT INTO osoba VALUES ('5603023019' ,'Frederico Silvester', '00421903399092', 'Pizzova ulica 13,Milano' , 'najomnyzabijak@gmail.com');
INSERT INTO osoba VALUES ('9853104010' , 'Boris Vesely' ,'00421904349690', 'Namestie pizze 18,Bologna' , 'borisvesely@gmail.com');
INSERT INTO osoba VALUES ('0056085084' , 'Nina Stefekova', '00420902344567', 'Mafianska ulica 2 ,Chicago' , 'ninastefekova@gmail.com');
INSERT INTO osoba VALUES ('6203104028' , 'Al Capone', '00420912344548', 'Mafianska ulica 8,Chicago' , 'alcapone123@gmail.com');
INSERT INTO osoba VALUES ('0904101245' , 'Clovek Ludsky', '00421949210092', 'Vymyslena 10,Brno' , 'clovecina@gmail.com');
INSERT INTO osoba VALUES ('0105051234', 'Don Bezclenny', '00421949210123','Neexistujuca ulica 420, Slatina','bezclenny@gmail.com');


INSERT INTO don VALUES ('7512315822', 'Milano');
INSERT INTO don VALUES ('0056085084', 'Puchov');
INSERT INTO don VALUES ('6203104028', 'New York');
INSERT INTO don VALUES ('0105051234', 'Slatina');

INSERT INTO radovy_clen VALUES ('9853104010', '0056085084', '');
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
INSERT INTO uzemie VALUES (NULL,'6203104028',23,'43.156,-75.844', 'Talianska 5, Chicago');



INSERT INTO aliancia VALUES ( 2,'7512315822','0056085084',TO_TIMESTAMP('2000-06-04 12:00:00','YYYY/MM/DD HH:MI:SS'),TO_TIMESTAMP('2005-08-04 03:00:00','YYYY/MM/DD HH:MI:SS'));


INSERT INTO cinnost VALUES (1,1,'34 dni',TO_TIMESTAMP('1980-08-04 01:00:00','YYYY/MM/DD HH:MI:SS'),'kradez');
INSERT INTO cinnost VALUES (2,2,'365 dni',TO_TIMESTAMP('1999-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'vydieranie');
INSERT INTO cinnost VALUES (3,1,'365 dni',TO_TIMESTAMP('1998-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'pranie penazi');
INSERT INTO cinnost VALUES (4,1,'365 dni',TO_TIMESTAMP('1997-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'dovoz cigariet');
INSERT INTO cinnost VALUES (5,2,'365 dni',TO_TIMESTAMP('1996-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'predaj ukradnuteho');
INSERT INTO cinnost VALUES (6,2,'365 dni',TO_TIMESTAMP('1995-08-04 11:00:00','YYYY/MM/DD HH:MI:SS'),'predaj alkoholu');
INSERT INTO cinnost VALUES (7,2,'365 dni',TO_TIMESTAMP('2001-12-15 11:15:52','YYYY/MM/DD HH:MI:SS'),'pasovanie do vezenia');




INSERT INTO don_cinnost VALUES (1,'7512315822');
INSERT INTO don_cinnost VALUES (3,'7512315822');
INSERT INTO don_cinnost VALUES (4,'7512315822');

INSERT INTO don_cinnost VALUES (2,'6203104028');
INSERT INTO don_cinnost VALUES (5,'6203104028');
INSERT INTO don_cinnost VALUES (6,'6203104028');
INSERT INTO don_cinnost VALUES (7,'6203104028');



INSERT INTO clen_cinnost VALUES ('5603023019', 2);
INSERT INTO clen_cinnost VALUES ('5603023019', 5);
INSERT INTO clen_cinnost VALUES ('5603023019', 6);
INSERT INTO clen_cinnost VALUES ('5603023019', 7);


INSERT INTO clen_cinnost VALUES ('9853104010', 1);
INSERT INTO clen_cinnost VALUES ('9853104010', 3);
INSERT INTO clen_cinnost VALUES ('9853104010', 4);


INSERT INTO vrazda VALUES (123,'0056085084','9853104010', 'Brno',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));
INSERT INTO vrazda VALUES (124,'0056085084','9853104010', 'Little Italy 34, New York',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));
INSERT INTO vrazda VALUES (125,'0056085084','9853104010', 'Pizzova Ulica 4, Milano',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));
INSERT INTO vrazda VALUES (126,'0056085084','9853104010', 'Talianska 5, Chicago',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));
INSERT INTO vrazda VALUES (127,'0056085084','9853104010', 'Talianska 5, Chicago',TO_TIMESTAMP('2020-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));


INSERT INTO radovy_clen VALUES ('0904101245', '7512315822', 123);


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




INSERT INTO don_stretnutie VALUES (1,'6203104028');
INSERT INTO don_stretnutie VALUES (1,'0056085084');

INSERT INTO don_stretnutie VALUES (2,'6203104028');
INSERT INTO don_stretnutie VALUES (2,'7512315822');

-- vypise vsetkych donov a ich podriadenych
SELECT o.id_osoba AS id_dona,o.meno AS meno_dona,
       (SELECT K.meno FROM radovy_clen H, osoba K
       WHERE H.id_osoba = K.id_osoba AND d.id_osoba = H.id_osoba_nadriadeny) AS meno_podriadeny
FROM don d, osoba o
WHERE  o.id_osoba = d.id_osoba;

-- vypise vsetky vrazdy a ich majitelov s vykonavatelmi a cielmi
SELECT V.id_vrazda, o.meno AS majitel,
       (SELECT K.meno FROM osoba K, vrazda H
       WHERE K.id_osoba = H.id_osoba_vykonavatel AND V.id_osoba_vykonavatel = K.id_osoba AND H.id_vrazda = V.id_vrazda) AS vykonavatel,
       V.cas, V.miesto, (SELECT Q.meno FROM osoba Q WHERE Q.id_osoba = R.id_osoba) AS meno_ciela
FROM osoba O, vrazda V, radovy_clen R
WHERE O.id_osoba = V.id_osoba_majitel AND R.id_vrazdy = V.id_vrazda;


-- vypise vsetkych donov a ich celkovu vlastnenu rozlohu uzemia
SELECT O.meno AS meno_dona, SUM(U.rozloha) AS celkova_rozloha
FROM osoba O, don D, uzemie U
WHERE O.id_osoba = D.id_osoba AND D.id_osoba = U.id_osoba GROUP BY O.meno;

-- vypise vsetkych donov a spocita ich vlastnene cinnosti
SELECT O.meno AS meno_dona, COUNT(*) AS pocet_cinnosti
FROM osoba O,don D, cinnost C, don_cinnost P
WHERE O.id_osoba = D.id_osoba AND P.id_osoba = D.id_osoba AND P.id_cinnost = C.id_cinnost GROUP BY O.meno;

-- spocita hosti na jednotlivych stretnutiach donov
SELECT S.id_stretnutie, COUNT(*) AS pocet_hosti
FROM stretnutie_donov S, don_stretnutie K
WHERE S.id_stretnutie = K.id_stretnutia GROUP BY S.id_stretnutie;

-- vypise donov ktory nemaju clena
SELECT O.meno
FROM osoba O, don D
WHERE O.id_osoba = D.id_osoba AND NOT EXISTS(SELECT * FROM radovy_clen R WHERE D.id_osoba = R.id_osoba_nadriadeny)
GROUP BY O.meno;

-- vypise vsetkych radovych clenov ktorych donovia sa zucastnia stretnutia
SELECT O.meno, O.domaca_adresa, O.tel_cislo, O.email, R.id_osoba_nadriadeny
FROM radovy_clen R, osoba O
WHERE id_osoba_nadriadeny IN (SELECT id_osoba FROM don_stretnutie) AND O.id_osoba = R.id_osoba;


-- 4. cast--


--prava--
GRANT ALL ON ALIANCIA TO XVESEL92;
GRANT ALL ON DON_CINNOST TO XVESEL92;
GRANT ALL ON CLEN_CINNOST TO XVESEL92;
GRANT ALL ON RADOVY_CLEN TO XVESEL92;
GRANT ALL ON VRAZDA TO XVESEL92;
GRANT ALL ON CINNOST TO XVESEL92;
GRANT ALL ON DON_STRETNUTIE TO XVESEL92;
GRANT ALL ON STRETNUTIE_DONOV TO XVESEL92;
GRANT ALL ON UZEMIE TO XVESEL92;
GRANT ALL ON DON TO XVESEL92;
GRANT ALL ON OSOBA TO XVESEL92;

COMMIT;
--explain plan

-- DROP index indx;
explain plan for
SELECT uzemie.adresa, COUNT(vrazda.miesto) AS pocet_vrazd
FROM vrazda JOIN uzemie ON vrazda.miesto=uzemie.adresa
GROUP BY uzemie.adresa
ORDER BY pocet_vrazd DESC;
SELECT * FROM TABLE(dbms_xplan.display);

create index indx ON vrazda (miesto);

explain plan for
SELECT uzemie.adresa, COUNT(vrazda.miesto) AS pocet_vrazd
FROM vrazda JOIN uzemie ON vrazda.miesto=uzemie.adresa
GROUP BY uzemie.adresa
ORDER BY pocet_vrazd DESC;
SELECT * FROM TABLE(dbms_xplan.display);


--material view--
--
-- nasledujuce spousta xvesel92

DROP MATERIALIZED VIEW myView;
CREATE MATERIALIZED VIEW LOG ON stretnutie_donov with PRIMARY KEY INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW myView

    BUILD IMMEDIATE
    AS
    SELECT S.id_stretnutie, COUNT(*) AS pocet_hosti
    FROM XSTEFE11.stretnutie_donov S, XSTEFE11.don_stretnutie K
    WHERE S.id_stretnutie = K.id_stretnutia GROUP BY S.id_stretnutie;

COMMIT;
SELECT * FROM myView;

-- procedury --

CREATE OR REPLACE PROCEDURE priemerny_vek_donov
IS
    CURSOR donovia IS SELECT * FROM don;
    d don%rowtype;
    cnt NUMBER;
    cntSum NUMBER;
    vek NUMBER;
    rok NUMBER;
    BEGIN
        cnt := 0;
        cntSum := 0;
        vek := 0;
        rok := 0;
        OPEN donovia;
        LOOP
            fetch donovia into d;
            exit when donovia%NOTFOUND;
            cnt := cnt + 1;
            rok := SUBSTR(d.id_osoba,1,2);
            IF (rok > 23) THEN
                rok := 1900 + rok;
            ELSE
                rok := 2000 + rok;
            end IF;
            vek := 2022 - rok;
            cntSum := cntSum + vek;
        end loop;
        IF (cnt = 0) THEN
            raise_application_error(-20001,'nenasli sa ziadny donovia' );
        end if;
        DBMS_OUTPUT.PUT_LINE('Priemerny vek donov je: '|| round((cntSUM/cnt), 2));
end;
/
BEGIN
     PRIEMERNY_VEK_DONOV();
END;


CREATE OR REPLACE PROCEDURE percentualne_vlastnenie_uzemia
    is
    cursor donovia is select * from don;
    d don%rowtype;
    rozloha_celkom number;
    rozloha_don number;
    cnt number;
    menoDon varchar(64);
begin
    OPEN donovia;
    rozloha_celkom := 0;
    select SUM(rozloha) into rozloha_celkom from uzemie;
    if (rozloha_celkom = 0) THEN
            raise_application_error(-20001,'nenasli sa ziadne uzemia');
    end if;
    LOOP
        cnt := 0;
        rozloha_don := 0;
        fetch donovia into d;
        exit when donovia%NOTFOUND;
        select count(*) into cnt from uzemie U where d.id_osoba=U.id_osoba;
        if(cnt != 0) then
            select SUM(U.rozloha) into rozloha_don from uzemie U where d.id_osoba=U.id_osoba;
        end if;
        select O.meno into menoDon from osoba O where d.id_osoba=O.id_osoba;
        if(rozloha_don = 0)then
            DBMS_OUTPUT.PUT_LINE(menoDon || ': 0%');
        else
            DBMS_OUTPUT.PUT_LINE(menoDon || ': ' || round(((rozloha_don*100)/rozloha_celkom),2)||'%');
        end if;
    end loop;
end;
/


BEGIN
     percentualne_vlastnenie_uzemia();
END;

-- trigger na kontrolu ci je datum v buducnosti ak datum nie je zadany je vrazda naplanovana o tyzden
CREATE OR REPLACE TRIGGER kontrola_datum
    BEFORE INSERT OR UPDATE OF cas on vrazda
    FOR EACH ROW
    BEGIN
        if (:NEW.cas is NULL)then
            :NEW.cas:=current_timestamp + 7;
        end if;
        IF(:NEW.cas < CURRENT_TIMESTAMP) then
            raise_application_error(-20001,'cas vo vrazde musi byt v buducnosti');
        end if;
    end;

-- demonstracia

--prejde
INSERT INTO vrazda VALUES (25,'0056085084','9853104010', 'Talianska 5, Chicago',TO_TIMESTAMP('2023-01-01 11:00:00','YYYY/MM/DD HH:MI:SS'));
--prida jeden tyzden
INSERT INTO vrazda VALUES (1215,'0056085084','9853104010', 'Talianska 5, Chicago',NULL);
--neprejde
INSERT INTO vrazda VALUES (1512,'0056085084','9853104010', 'Talianska 5, Chicago',TO_TIMESTAMP('2020-12-15 11:00:00','YYYY/MM/DD HH:MI:SS'));


select * from vrazda;



