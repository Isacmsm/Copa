USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Exclui Registros da Tabela Ism_Time
-- ===============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Time_Del] (
	@IdTime INT = NULL,
	@Nome VARCHAR(50) = NULL,
	@idSessao INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255)

		IF @IdTime IS NULL
		BEGIN 
			RAISERROR('Operação Cancelada. Selecione o time que deseja excluir!', 16, 1)
		END

		IF NOT EXISTS (
			SELECT idTime
			FROM Ism_Time
			WHERE idTime = @IdTime
		)
		BEGIN
			RAISERROR('Operação Cancelada. Selecione o time que deseja excluir', 16, 1, @IdTime)
		END

		IF EXISTS (
			SELECT IJ.idJogo
			FROM Ism_Jogo IJ
			INNER JOIN Ism_Time IT ON IJ.idTime1 = IT.idTime OR  IJ.idTime2 = IT.idTime
			WHERE IT.idTime = @IdTime
		)
		BEGIN
			RAISERROR('Operação Cancelada. Existe um ou mais jogos associado ao time de ID: %d', 16, 1, @IdTime)
		END

		IF EXISTS (
			SELECT IJ.idJogador
			FROM Ism_Jogador IJ
			INNER JOIN Ism_Time IT ON IJ.idTime = IT.idTime
			WHERE IT.idTime = @IdTime
		)
		BEGIN
			RAISERROR('Operação Cancelada. Existe um ou mais jogadores associado ao time de ID: %d', 16, 1, @IdTime)
		END

		SELECT @MsgErro = dbo.fn_ConsisteOperadorSessao(@idSessao)
		IF @MsgErro IS NOT NULL
		BEGIN
		   RAISERROR(@MsgErro, 16, 1)
		END

		DELETE Ism_Time
		WHERE idTime = @IdTime

		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

