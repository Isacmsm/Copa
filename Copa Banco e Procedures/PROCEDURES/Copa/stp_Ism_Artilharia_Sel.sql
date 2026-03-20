USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Artilharia
-- ================================================



CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Artilharia_Sel]
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

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

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END