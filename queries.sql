WITH solistas AS (SELECT A.name artist FROM ARTISTS A LEFT OUTER JOIN MEMBERS M ON (A.name = M.group_name) GROUP BY A.name
HAVING COUNT ('x')=1),
discosolitarios AS (SELECT isvn, artist FROM solistas JOIN DISCS USING (artist)),
cantautores AS (SELECT artist FROM discosolitarios D JOIN TRACKS T ON (D.isvn=T.isvn AND D.artist=T.writer))
SELECT artist FROM solistas MINUS SELECT artist FROM cantautores;

WITH bands AS (SELECT group_name artist FROM MEMBERS GROUP BY group_name HAVING COUNT ('x')>1),
bandworks AS (SELECT ISVN, artist FROM bands B JOIN DISCS D USING(artist)),
playtracks AS (SELECT playdatetime, T.trackN, T.isvn FROM TRACKS T JOIN PLAYBACKS B ON T.trackN=B.trackN AND
T.side=B.side AND T.ISVN= B.ISVN)
SELECT artist, max(playdatetime) AS lasttime FROM bandworks B JOIN playtracks P ON B.ISVN = P.ISVN GROUP BY artist;

WITH songs AS (SELECT rel_date, D.ISVN, title_s FROM TRACKS T JOIN DISCS D ON (T.ISVN = D.ISVN)),
played AS (SELECT station, T.isvn, title_s FROM PLAYBACKS P JOIN TRACKS T ON (T.ISVN=P.ISVN AND T.trackN=P.trackN AND T.side=P.side)),
eldest AS (SELECT station FROM played JOIN songs USING (ISVN, title_s) GROUP BY station
ORDER BY TO_DATE(round(AVG(TO_NUMBER(TO_CHAR(rel_date, 'J')))), 'J') ASC),
vintage AS (SELECT station FROM played P JOIN songs S ON P.ISVN=S.ISVN AND P.title_s=S.title_s WHERE 
rel_date <= (sysdate -10950) GROUP BY station ORDER BY COUNT('X') DESC)
SELECT * FROM eldest WHERE ROWNUM <=1 UNION ALL SELECT * FROM vintage WHERE ROWNUM <=1;

WITH tops AS (SELECT title_s,D.ISVN,trackN,side FROM SINGLES D JOIN TRACKS T ON (T.ISVN=D.ISVN)),
played AS (SELECT title_s FROM PLAYBACKS P JOIN tops S ON (S.ISVN=P.ISVN AND S.trackN = P.trackN AND S.side=P.side)
WHERE TO_CHAR (playdatetime, 'DD/MM/YY')  = TO_CHAR ((sysdate-1), 'DD/MM/YY')
GROUP BY title_s ORDER BY count('x') DESC)
SELECT * FROM played WHERE ROWNUM<=10;

WITH beginners AS (SELECT artist, min(rel_date) AS inicio FROM DISCS GROUP BY artist ORDER BY inicio ASC),
babies AS (SELECT artist, max(rel_date) AS fin FROM DISCS GROUP BY artist ORDER BY fin DESC),
longevo AS (SELECT artist, (fin-inicio) AS edad FROM beginners JOIN babies USING(artist) GROUP BY artist, (fin-inicio) ORDER BY edad DESC)
SELECT artist FROM longevo WHERE ROWNUM <=1;