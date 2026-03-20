USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Exclui Registros da Tabela Ism_Jogo
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogo_Del] (
	@idJogo INT = NULL,
	@idTime1 INT = NULL,
	@idTime2 INT = NULL,
	@DataHoraInicio datetime = NULL,
	@DataHoraFinal datetime = NULL,
	@CaminhoArq VARCHAR(100) = NULL,
	@Tipo INT = NULL
	
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255)

		IF @idJogo IS NULL
		BEGIN 
			RAISERROR('Informe o ID do Jogo a ser excluido', 16, 1)
		END

		IF NOT EXISTS (
			SELECT idJogo
			FROM Ism_Jogo
			WHERE idJogo = @idJogo
		)
		BEGIN
			RAISERROR('Operação Cancelada. Não foi possivel identificar o jogo informado pelo ID %d', 16, 1, @idJogo)
		END

		IF EXISTS(
			SELECT IdJogo
			FROM Ism_Jogo
			WHERE IdJogo = @idJogo
			AND Placar1 != 0 AND Placar2 != 0
		)
		BEGIN
			RAISERROR('Operação cancelada. O jogo referente ao ID %d ja foi iniciado', 16, 1, @idJogo)
		END

		DELETE Ism_Jogo
		WHERE idJogo = @IdJogo

		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

