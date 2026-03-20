USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Classificação
-- ================================================



CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Classificacao_Sel]
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

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
		AS [SaldodeGols],
		SUM(CASE 
			WHEN J.idTime1 = T.idTime THEN J.Placar1 
			WHEN J.idTime2 = T.idTime THEN J.Placar2 END) 
		AS [GolsMarcados]
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

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END