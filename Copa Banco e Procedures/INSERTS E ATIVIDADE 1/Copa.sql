-- 1. Selecionar todos os times que ganharam pelo menos uma partida
SELECT * FROM Ism_Time
SELECT * FROM Ism_Participacao
SELECT * FROM Ism_Jogo

SELECT DISTINCT 
CASE 
WHEN Placar1 > Placar2 THEN idTime1
WHEN Placar2 > Placar1 THEN idTime2 END AS idTime
FROM Ism_Jogo
WHERE 
(CASE 
WHEN Placar1 > Placar2 THEN idTime1
WHEN Placar2 > Placar1 THEN idTime2 END) is not null

-- RESPOSTA 1
SELECT Nome
FROM Ism_Time
WHERE idTime IN 
	(SELECT DISTINCT
	CASE 
		WHEN Placar1 > Placar2 THEN idTime1
		WHEN Placar2 > Placar1 THEN idTime2 
	END AS idTime
	FROM Ism_Jogo
	WHERE 
		(CASE 
			WHEN Placar1 > Placar2 THEN idTime1
			WHEN Placar2 > Placar1 THEN idTime2 
		END) is not null)

-- 2. Listar todos os times com o total de gols marcados e sofridos e o saldo de gols
SELECT * FROM Ism_Time
SELECT * FROM Ism_Jogo
--RESPOSTA
SELECT T.Nome, 
SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 
	WHEN J.idTime2 = T.idTime THEN J.Placar2 END) 
AS [Gols Marcados],
SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar2 
	WHEN J.idTime2 = T.idTime THEN J.Placar1 END) 
AS [Gols Sofridos],
SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 - J.Placar2
	WHEN J.idTime2 = T.idTime THEN J.Placar2 - J.Placar1 END) 
AS [Saldo de Gols]
FROM Ism_Jogo J
INNER JOIN Ism_Time T ON J.idTime1 = T.idTime OR J.idtime2 = T.idTime
GROUP BY T.Nome

SELECT * FROM Ism_Jogo J
INNER JOIN Ism_Time T ON J.idTime1 = T.idTime OR J.idtime2 = T.idTime

SELECT * FROM Ism_Jogo

-- 3. Listar o artilheiro de cada equipe, exibindo o nome e a quantidade de gols
SELECT * FROM Ism_Time
SELECT * FROM Ism_Jogador
SELECT * FROM Ism_Participacao


SELECT 
T.Nome AS NomeTime,
J.Nome AS NomeJogador, 
SUM(P.GolsMarcados) AS GolsMarcados
FROM Ism_Time T
INNER JOIN Ism_Jogador J ON T.idTime = J.idTime
INNER JOIN Ism_Participacao P ON J.idJogador = P.idJogador
GROUP BY T.Nome, J.Nome

-- Resposta 3
;WITH GolsPorJogador AS (
SELECT 
T.Nome AS NomeTime,
J.Nome AS NomeJogador, 
CASE 
WHEN P.GolsMarcados IS NOT NULL THEN SUM(P.GolsMarcados) 
WHEN P.GolsMarcados IS NULL THEN 0 END AS GolsMarcados,
RANK() OVER (PARTITION BY T.idTime ORDER BY SUM(P.GolsMarcados) DESC) AS [RANK]
FROM Ism_Time T
INNER JOIN Ism_Jogador J ON T.idTime = J.idTime
LEFT JOIN Ism_Participacao P ON J.idJogador = P.idJogador
GROUP BY T.idTime, T.Nome, J.Nome, P.GolsMarcados )
SELECT 
NomeTime,
NomeJogador,
GolsMarcados
FROM GolsPorJogador
WHERE [RANK] = 1;

begin transaction 
delete Ism_Participacao
ROLLBACK


-- 4. Selecionar o jogador que fez mais gols no campeonato

;WITH RANKGOLS AS(
SELECT 
J.Nome AS NomeJogador, 
SUM(P.GolsMarcados) AS GolsMarcados,
RANK() OVER (ORDER BY SUM(P.GolsMarcados) DESC) AS [RANK]
FROM Ism_Time T
INNER JOIN Ism_Jogador J ON T.idTime = J.idTime
INNER JOIN Ism_Participacao P ON J.idJogador = P.idJogador
GROUP BY J.Nome
)
SELECT NomeJogador
FROM RANKGOLS
WHERE [RANK] = 1


-- 5. Listar a classificação dos times com base nos seguintes critérios: 
SELECT * FROM Ism_Jogo
SELECT * FROM Ism_Participacao
SELECT 
T.Nome,
SUM(CASE
	WHEN J.idTime1 = T.idTime AND J.Placar1 > J.Placar2  THEN 3
	WHEN J.idTime1 = T.idTime AND J.Placar1 = J.Placar2  THEN 1
	WHEN J.idTime2 = T.idTime AND J.Placar2 > J.Placar1 THEN 3
	WHEN J.idTime2 = T.idTime AND J.Placar2 = J.Placar1 THEN 1 END) AS Pontos,
SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 - J.Placar2
	WHEN J.idTime2 = T.idTime THEN J.Placar2 - J.Placar1 END) 
AS [Saldo de Gols],
SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 
	WHEN J.idTime2 = T.idTime THEN J.Placar2 END) 
AS [Gols Marcados]
FROM Ism_Jogo J
INNER JOIN Ism_Time T ON J.idTime1 = T.idTime OR J.idtime2 = T.idTime
GROUP BY T.Nome
ORDER BY RANK() OVER(ORDER BY
SUM(CASE
	WHEN J.idTime1 = T.idTime AND J.Placar1 > J.Placar2  THEN 3
	WHEN J.idTime1 = T.idTime AND J.Placar1 = J.Placar2  THEN 1
	WHEN J.idTime2 = T.idTime AND J.Placar2 > J.Placar1 THEN 3
	WHEN J.idTime2 = T.idTime AND J.Placar2 = J.Placar1 THEN 1 END),
	SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 - J.Placar2
	WHEN J.idTime2 = T.idTime THEN J.Placar2 - J.Placar1 END),
	SUM(CASE 
	WHEN J.idTime1 = T.idTime THEN J.Placar1 
	WHEN J.idTime2 = T.idTime THEN J.Placar2 END) DESC) DESC