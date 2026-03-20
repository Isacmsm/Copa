USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Participacao
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Participacao_Sel](
	@Tipo INT = NULL,
	@IdJogo INT = NULL

)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @Tipo = 1 
		BEGIN
			SELECT 
			IJ.idJogo,
			IT1.Nome AS NomeTime1,
			IJ.Placar1,
			IT2.Nome AS NomeTime2,
			IJ.Placar2
			FROM
			Ism_Jogo IJ
			INNER JOIN Ism_Time IT1 ON IJ.idTime1 = IT1.idTime
			INNER JOIN Ism_Time IT2 ON IJ.idTime2 = IT2.idTime
		END

		IF @Tipo = 2 
		BEGIN
			;WITH J
			AS 
			(SELECT DISTINCT
			IJ.idJogo,
			IJG.idJogador,
			IJG.idTime,
			CASE
				WHEN IT1.idTime = IJG.idTime then IT1.Nome
				WHEN IT2.idTime = IJG.idTime THEN IT2.Nome
				END AS NomeTime,
			IJG.Nome,
			IJG.Capitao,
			IJG.Tecnico,
			IJG.Suspenso
			FROM
			Ism_Jogo IJ
			INNER JOIN Ism_Time IT1 ON IJ.idTime1 = IT1.idTime
			INNER JOIN Ism_Time IT2 ON IJ.idTime2 = IT2.idTime
			INNER JOIN Ism_Jogador IJG ON IJG.idTime = IJ.idTime1 OR IJG.idTime = IJ.idTime2
			)
			SELECT distinct
			J.Idjogo,
			J.idJogador,
			J.NomeTime,
			J.idTime,
			J.Capitao,
			J.Tecnico,
			J.Suspenso,
			Nome AS NomeJogador,
			isnull (GolsMarcados, 0) as GolsMarcados
			from J
			left join Ism_Participacao ipa on ipa.idJogo = J.idJogo AND ipa.idJogador = J.idJogador
			WHERE J.IDJOGO = @IdJogo
			ORDER BY idTime
		END


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END