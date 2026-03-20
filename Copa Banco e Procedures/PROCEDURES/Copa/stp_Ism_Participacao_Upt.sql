USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Altera Registros da Tabela Ism_Participacao
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Participacao_Upt] (
	@idJogo INT = NULL,
	@idJogador INT = NULL,
	@IdTime INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON 

		DECLARE @MsgErro VARCHAR(255), @DataInicio datetime, @DataFinal datetime

		IF @idJogo IS NULL 
		BEGIN 
			RAISERROR('Insira idJogo', 16, 1)
		END

		IF @idJogador IS NULL
		BEGIN 
			RAISERROR('Insira idJogador', 16, 1)
		END

		

		IF NOT EXISTS (
			SELECT idJogador
			FROM Ism_Jogador
			WHERE idJogador = @idJogador
		)
		BEGIN
			RAISERROR('Operação cancelada. Não foi possivel identificar o Jogador informado pelo ID %d', 16, 1, @idJogador)
		END


		IF NOT EXISTS (
			SELECT idJogo
			FROM Ism_Jogo
			WHERE idJogo = @idJogo
		)
		BEGIN
			RAISERROR('Operação cancelada. Não foi possivel identificar o Jogo informado pelo ID %d', 16, 1, @idJogo)
		END


		SELECT 
			@DataInicio = DataInicio,
			@DataFinal = DataFinal
		FROM Ism_Jogo
		WHERE idJogo = @idJogo

		IF GETDATE() NOT BETWEEN @DataInicio AND @DataFinal
		BEGIN
			RAISERROR('Operação cancelada. Esse jogo não foi iniciado ou ja terminou', 16, 1)
		END

		IF EXISTS (
			SELECT 1
			FROM Ism_Jogador
			WHERE (@idJogador = idJogador) AND (Tecnico = 1 OR Suspenso = 1)
		)
		BEGIN
			RAISERROR('Operação cancelada. Um tecnico ou um jogador suspenso não pode marcar gols', 16, 1)
		END


		IF NOT EXISTS (
			SELECT 1
			FROM Ism_Participacao
			WHERE idJogo = @idJogo AND idJogador = @idJogador
		)
		BEGIN
			INSERT INTO Ism_Participacao (idJogo, idJogador, GolsMarcados)
			VALUES (@idJogo, @idJogador, 1)
		END
		ELSE
		BEGIN
			UPDATE Ism_Participacao SET
				idJogo = @idJogo,
				idJogador = @idJogador,
				GolsMarcados = GolsMarcados + 1
			WHERE idJogo = @idJogo AND idJogador = @idJogador
		END

	
			UPDATE Ism_Jogo SET
			Placar1 = CASE  WHEN @IdTime = idTime1 THEN Placar1 + 1 else Placar1 end,
			Placar2 = CASE  WHEN @IdTime = idTime2 THEN Placar2 + 1 else Placar2 end
			WHERE idJogo = @idJogo

		RETURN 0
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END
		