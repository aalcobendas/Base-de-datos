CREATE OR REPLACE VIEW topoldsales (ISVN) AS 
SELECT ISVN FROM (SELECT ISVN, sum(qtty) total FROM SINGLES JOIN SALE_LINE USING (ISVN) GROUP BY ISVN)
MINUS SELECT ISVN FROM (SELECT ISVN, playdatetime FROM PLAYBACKS WHERE playdatetime>=(sysdate-30));

CREATE OR REPLACE VIEW topsalesofbanned AS SELECT * FROM (SELECT * FROM topoldsales JOIN 
(SELECT ISVN, sum(qtty) total FROM SALE_LINE GROUP BY ISVN) USING (ISVN) ORDER BY total DESC)
WHERE ROWNUM <=3;


CREATE OR REPLACE VIEW TOPFIVEWEEKPEAK AS SELECT * FROM (SELECT artist FROM discs JOIN(SELECT isvn, trackN FROM playbacks 
WHERE sysdate-playdatetime<=7) USING (ISVN) GROUP BY (artist) ORDER BY COUNT ('x') DESC) WHERE ROWNUM<=5;


CREATE OR REPLACE VIEW mng_tot AS (SELECT mng_name, surname, month, COUNT ('X') times FROM 
(SELECT mng_name, mng_surn1 surname, TO_CHAR(playdatetime, 'YYYY/MM') month FROM DISCS 
JOIN PLAYBACKS USING (ISVN)) GROUP BY (mng_name, surname, month));

CREATE OR REPLACE VIEW soundboss (month, times, name, surname) AS
SELECT * FROM (SELECT month, MAX(times) times FROM mng_tot GROUP BY (month)) 
JOIN mng_tot USING (month, times) ORDER BY month;



CREATE OR REPLACE VIEW reproduced AS (SELECT ISVN, month, COUNT ('X') times FROM 
(SELECT ISVN, TO_CHAR(playdatetime, 'YYYY/MM') month FROM SINGLES 
JOIN PLAYBACKS USING (ISVN)) GROUP BY (ISVN, month));

CREATE OR REPLACE VIEW wreckhit (month, times, ISVN) AS
SELECT * FROM (SELECT month, MIN(times) times FROM reproduced GROUP BY (month)) 
JOIN reproduced USING (month, times) ORDER BY month;