USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Jogo
-- ================================================



CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogo_Sel](
	@Tipo INT = NULL,
	@idJogo INT = NULL
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
				IJ.idTime1,
				IT1.Nome AS NomeTime1,
				IJ.idTime2,
				IT2.Nome AS NomeTime2,
				IJ.Placar1,
				IJ.Placar2,
				CONVERT(VARCHAR, DataInicio, 23) AS DataInicio,
				CONVERT(VARCHAR, DataInicio, 108) AS HoraInicio,
				CONVERT(VARCHAR, DataFinal, 23) AS DataFinal,
				CONVERT(VARCHAR, DataFinal, 108) AS HoraFinal,
				IJ.CaminhoArq
			FROM Ism_Jogo IJ
			INNER JOIN Ism_Time IT1 ON IT1.idTime = IJ.idTime1
			INNER JOIN Ism_Time IT2 ON IT2.idTime = IJ.idTime2
			WHERE idJogo = @idJogo OR @idJogo IS NULL
		END

		IF @Tipo = 2
		BEGIN
			SELECT *
			FROM 
			Ism_Time
		END

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END