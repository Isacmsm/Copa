USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Selecionar Registros de Time e Jogador 
-- para a tela Aproveitamento.
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Aproveitamento_Sel](
	@Tipo INT = NULL
	

)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @Tipo = 1 
		BEGIN
			SELECT
				idTime,
				Nome
			FROM Ism_Time
		END

		IF @Tipo = 2 
		BEGIN
			SELECT 
				idJogador,
				idTime,
				Nome
			FROM Ism_Jogador
		END


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END

-------------------------------------------------------------------------------


USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Receber um json e voltar com dados adicionais 
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Aproveitamento_Upt](
	@Json VARCHAR(MAX) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255)
		DECLARE @Times TABLE (
			IdTime INT, 
			NomeTime VARCHAR(100),
			Gols INT,
			FolhaPagamento MONEY,
			Aproveitamento DECIMAL(10,2));

		DECLARE @Jogadores TABLE (
			IdJogador INT, 
			IdTime INT, 
			NomeJogador VARCHAR(100), 
			Gols INT, 
			Salario MONEY, 
			Aproveitamento DECIMAL(10,2));
		
		INSERT INTO @Times (IdTime, NomeTime)
		SELECT 
			t.idTime, 
			t.NomeTime
		FROM OPENJSON(@Json) WITH (
			idTime VARCHAR(10)  '$.Id',
			NomeTime VARCHAR(50) '$.Nome'
		) t

		INSERT INTO @Jogadores (IdJogador,IdTime, NomeJogador)
		SELECT 
			j.idJogador,
			t.idTime,
			j.NomeJogador
		FROM OPENJSON(@Json) WITH (
			idTime VARCHAR(10)  '$.Id',
			jogadores NVARCHAR(MAX) AS JSON
		) t
		CROSS APPLY OPENJSON(t.Jogadores) WITH (
			idJogador VARCHAR(10) '$.Id',
			NomeJogador VARCHAR(50) '$.Nome'
		) j
		

		UPDATE J
		SET J.Salario = JG.Salario
		FROM @Jogadores AS J
		INNER JOIN Ism_Jogador AS Jg ON J.IdJogador = JG.idJogador

		UPDATE J
		SET J.Gols = P.Gols
		FROM @Jogadores AS J
		INNER JOIN (select 
						idJogador,
						SUM(GolsMarcados) AS Gols
					from Ism_Participacao
					group by idJogador
		) AS P ON J.IdJogador = P.idJogador
		
		UPDATE J
		SET J.Aproveitamento = CAST(p.golsMarcados AS DECIMAL(10,2))/p.JogosJogados
		FROM @Jogadores AS J
		INNER JOIN (SELECT
						idJogador,
						SUM(GolsMarcados) as golsMarcados,
						COUNT (*) as JogosJogados
					FROM Ism_Participacao
					GROUP BY idJogador
		) AS P ON J.IdJogador = P.idJogador
		
		UPDATE T
		SET T.Gols = P.Gols
		FROM @Times AS T
		INNER JOIN (select 
						jog.idTime,
						SUM(GolsMarcados) AS Gols
					from Ism_Participacao part
					inner join Ism_Jogador jog on part.idJogador = jog.idJogador
					group by jog.idTime
		) AS P ON T.IdTime = P.idTime

		UPDATE T
		SET T.FolhaPagamento = Jog.FolhaPagamento
		FROM @Times AS T
		INNER JOIN (select
						idTime,
						sum(Salario) as FolhaPagamento
					from Ism_Jogador
					group by idTime
		) as Jog ON T.IdTime = Jog.idTime

		UPDATE T
		SET T.Aproveitamento = (CAST(J.Pontos AS DECIMAL(10,2))/ (Jogos * 3)) * 100
		FROM @Times AS T
		INNER JOIN (SELECT 
						T.Nome,
						T.idTime,
						SUM(CASE
							WHEN J.idTime1 = T.idTime AND J.Placar1 > J.Placar2  THEN 3
							WHEN J.idTime1 = T.idTime AND J.Placar1 = J.Placar2  THEN 1
							WHEN J.idTime2 = T.idTime AND J.Placar2 > J.Placar1 THEN 3
							WHEN J.idTime2 = T.idTime AND J.Placar2 = J.Placar1 THEN 1 END) AS Pontos,
						COUNT(*) AS Jogos
					FROM Ism_Jogo J
					INNER JOIN Ism_Time T ON J.idTime1 = T.idTime OR J.idtime2 = T.idTime
					GROUP BY T.Nome, T.idTime
		) AS J ON T.IdTime = J.idTime

		SELECT (
			SELECT
				T.IdTime AS [id],
				T.NomeTime AS [nome],
				T.Aproveitamento AS [aproveitamento],
				T.FolhaPagamento AS [folhaPagamento],
				T.Gols AS [gols],
				(
					SELECT 
						J.IdJogador as [id],
						J.NomeJogador as [nome],
						J.Gols as [gols],
						J.Salario [salario],
						J.Aproveitamento as [aproveitamento]
					FROM @Jogadores J
					WHERE J.IdTime = T.IdTime
					FOR JSON PATH
				) AS [jogadores]
			FROM @Times T
			FOR JSON PATH
		) AS Json

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END