INSERT INTO ARTISTAS(nombre, nacionalidad, idioma)
SELECT DISTINCT artist, nationality, language FROM vinyl;

INSERT INTO DISCOGRAFICAS(nombredf, tlf)
SELECT DISTINCT publisher, TO_NUMBER(pub_phone) FROM vinyl;

INSERT INTO MANAGERS(nombre, ap1, ap2, tlf)
SELECT DISTINCT mng_name, mng_surn1, mng_surn2,TO_NUMBER(mng_phone) FROM vinyl;

INSERT INTO ESTUDIOS(nombreest, direccionest, nombrepers, appers1, appers2)
SELECT DISTINCT rec_studio, rs_address, tech_name, tech_surn1, tech_surn2 FROM vinyl;

INSERT INTO EMISORAS(nombre, dir, url, email, tlf)
SELECT DISTINCT station, st_Address, st_web, st_email, TO_NUMBER(st_phone) FROM hits;

INSERT INTO VINILOS(titdisco, grupo, velrot, tamagu, discografica, fecha, isvn, managertlf, color)
SELECT DISTINCT album, artist, speed, hole, publisher,TO_DATE(rel_date,'DD-MM-YYYY'), TO_NUMBER(ISVN), TO_NUMBER(mng_phone), color FROM vinyl;

INSERT INTO MAQUETACIONES(empresa1, dir1, fotografo1, dibujante1, maquetador1, empresa2, dir2,
fotografo2, dibujante2, maquetador2, isvn)
SELECT DISTINCT mk1_comp, mk1_addr, SUBSTR(mk1_phtg, 15), mk1_draw, SUBSTR(mk1_layt, 9),
mk2_comp, mk2_addr, SUBSTR(mk2_phtg, 15), mk2_draw, SUBSTR(mk2_layt, 9), TO_NUMBER(ISVN) FROM vinyl;

INSERT INTO TEMAS(titulo, cara, pista, duracion, autor, isvn, estudio)
SELECT DISTINCT title, side, TO_NUMBER(track), duration, writer, TO_NUMBER(ISVN), rec_studio FROM vinyl;

INSERT INTO MIEMBROS(nombreart, rol, grupo)
SELECT DISTINCT member1, rol1, artist FROM vinyl WHERE rol1 IS NOT NULL;
INSERT INTO MIEMBROS(nombreart, rol, grupo)
SELECT DISTINCT member2, rol2, artist FROM vinyl WHERE member2 IS NOT NULL AND rol2 IS NOT NULL;
INSERT INTO MIEMBROS(nombreart, rol, grupo)
SELECT DISTINCT member3, rol3, artist FROM vinyl WHERE member3 IS NOT NULL AND rol3 IS NOT NULL;
INSERT INTO MIEMBROS(nombreart, rol, grupo)
SELECT DISTINCT member4, rol4, artist FROM vinyl WHERE member4 IS NOT NULL AND rol4 IS NOT NULL;
INSERT INTO MIEMBROS(nombreart, rol, grupo)
SELECT DISTINCT member5, rol5, artist FROM vinyl WHERE member5 IS NOT NULL AND rol5 IS NOT NULL;

INSERT INTO ALBUMES(coplanz, coptot, titdisco, isvn)
SELECT DISTINCT TO_NUMBER(rel_copies), TO_NUMBER(tot_copies), album, TO_NUMBER(ISVN) FROM vinyl WHERE format='LP vinyl';

INSERT INTO SINGLES(mejorp, tmpotop, isvn)
SELECT MAX(TO_NUMBER(rel_copies)), MAX(TO_NUMBER(tot_copies)), TO_NUMBER(ISVN) FROM vinyl 
WHERE format='single'
GROUP BY ISVN;

INSERT INTO CLIENTES(nombre,ap1,ap2,dni,fechanac, tlf, email, cpostal)
SELECT DISTINCT cl_name, cl_surn1, cl_surn2, TO_NUMBER(cl_dni), TO_DATE(cl_birth, 'DD-MONTH-YYYY'), TO_NUMBER(cl_phone), cl_email, cl_address FROM purchases WHERE cl_dni IS NOT NULL;

INSERT INTO PEDIDOS (fechac, fechae, grupo, titdisco, cliente, tlf, isvn)
SELECT DISTINCT TO_DATE(order_date, 'DD-MM-YYYY'), TO_DATE(delvr_date, 'DD-MM-YYYY'), artist, album, TO_NUMBER(cl_dni), TO_NUMBER(cl_phone), ISVN 
FROM purchases
NATURAL JOIN vinyl where cl_dni is not NULL AND order_date<= delvr_date;

INSERT INTO TOPS(isvn, tema, fecha, hora, emisora) 
WITH TMP AS (SELECT DISTINCT TO_NUMBER(REPLACE(hits.artist, 'ISVN:', '')) a_isvn, hits.title a_title,
TO_DATE(playdate, 'DD-MM-YYYY') a_playdate, hits.playtime a_playtime, hits.station a_station FROM hits
INNER JOIN VINILOS ON VINILOS.isvn = TO_NUMBER(REPLACE(hits.artist, 'ISVN:', ''))
WHERE hits.artist LIKE 'ISVN:%')
SELECT DISTINCT a_isvn, a_title, a_playdate, a_playtime, a_station FROM TMP;


