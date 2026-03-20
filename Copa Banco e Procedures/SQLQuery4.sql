SELECT 
    T1.Nome AS NomeTime1,
    T2.Nome AS NomeTime2,
    J.idJogo
FROM Ism_Time T1
CROSS JOIN Ism_Time T2
LEFT JOIN Ism_Jogo J 
    ON (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
    OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
WHERE T1.idTime <> T2.idTime



SELECT DISTINCT
    t1.idTime,
    T1.Nome AS NomeTime1,
    t2.idTime,
    T2.Nome AS NomeTime2
FROM Ism_Time T1
CROSS JOIN Ism_Time T2
LEFT JOIN Ism_Jogo J 
    ON (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
    OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
WHERE T1.idTime <> T2.idTime


SELECT 
    t1.idTime,
    T1.Nome AS NomeTime1,
    t2.idTime,
    T2.Nome AS NomeTime2,
    J.idJogo
FROM Ism_Time T1
CROSS JOIN Ism_Time T2
LEFT JOIN Ism_Jogo J 
    ON (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
    OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
WHERE T1.idTime <> T2.idTime AND J.idJogo IS NULL


SELECT 
    T1.idTime AS IdTime1,
    T1.Nome AS NomeTime1,
    T2.idTime AS IdTime2,
    T2.Nome AS NomeTime2,
    J.idJogo
FROM Ism_Time T1
CROSS JOIN Ism_Time T2
LEFT JOIN Ism_Jogo J 
    ON (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
    OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
WHERE T1.idTime <> T2.idTime



--=========================================================
SELECT 
    T1.idTime AS IdTime1,
    T1.Nome AS NomeTime1,
    T2.idTime AS IdTime2,
    T2.Nome AS NomeTime2,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM Ism_Jogo J 
            WHERE (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
               OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
        ) THEN 1 ELSE 0 
    END AS TemJogo
FROM Ism_Time T1
CROSS JOIN Ism_Time T2
WHERE T1.idTime <> T2.idTime
--=========================================================