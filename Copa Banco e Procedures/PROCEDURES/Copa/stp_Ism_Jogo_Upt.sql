USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Altera Registros da Tabela Ism_Jogo
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogo_Upt] (
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

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @Tipo = 1
		BEGIN
			IF @DataHoraInicio IS NULL
			BEGIN
				RAISERROR(50001, 10, 1, 'dataInicio', 'Informe a data de início do jogo')
				RAISERROR(50001, 10, 1, 'horaInicio', 'Informe a hora de início do jogo')
				SET @Erro = 1
			END

			IF @DataHoraFinal IS NULL
			BEGIN
				RAISERROR(50001, 10, 1, 'dataFinal', 'Informe a data final do jogo')
				RAISERROR(50001, 10, 1, 'horaFinal', 'Informe a hora final do jogo')
				SET @Erro = 1
			END

			IF @idTime1 IS NULL 
			BEGIN 
				RAISERROR(50001, 10, 1, 'idtime1', 'Selecione um time!')
				SET @Erro = 1
			END

			IF @idTime2 IS NULL
			BEGIN 
				RAISERROR(50001, 10, 1, 'idtime2', 'Selecione um time!')
				SET @Erro = 1
			END

			IF @idTime1 = @idTime2
			BEGIN
				RAISERROR(50001, 10, 1, 'idtime1', 'Os dois times que irão jogar devem ser diferentes')
				RAISERROR(50001, 10, 1, 'idtime2', 'Os dois times que irão jogar devem ser diferentes')
				SET @Erro = 1
			END

			IF @DataHoraInicio IS NOT NULL AND @DataHoraFinal IS NOT NULL
			BEGIN
				IF @DataHoraFinal <= @DataHoraInicio
				BEGIN
					RAISERROR(50001, 10, 1, 'dataInicio', 'A data de início não pode ser maior ou igual à data final')
					RAISERROR(50001, 10, 1, 'dataFinal', 'A data final deve ser posterior à data de início')
					RAISERROR(50001, 10, 1, 'horaInicio', 'A hora de início não pode ser igual ou maior que a hora final')
					RAISERROR(50001, 10, 1, 'horaFinal', 'A hora final deve ser posterior à hora de início')
					SET @Erro = 1
				END
			END

			IF @Erro = 1 RETURN 1

			IF @idJogo IS NULL
			BEGIN 
				RAISERROR('Informe o ID do Jogo', 16, 1)
			END

			IF NOT EXISTS (
				SELECT idJogo
				FROM Ism_Jogo
				WHERE idJogo = @idJogo
			)
			BEGIN
				RAISERROR('Operação cancelada. Não foi possivel identificar o Jogo informado pelo ID %d', 16, 1, @idJogo)
			END

			IF NOT EXISTS (
				SELECT 1
				FROM Ism_Time
				WHERE idTime = @idTime1
			)
			BEGIN
				RAISERROR('Operação cancelada. Não foi possivel identificar o Time informado pelo ID %d', 16, 1, @idTime1)
			END


			IF NOT EXISTS (
				SELECT 1
				FROM Ism_Time
				WHERE idTime = @idTime2
			)
			BEGIN
				RAISERROR('Operação cancelada. Não foi possivel identificar o Time informado pelo ID %d', 16, 1, @idTime2)
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

		

		
			UPDATE Ism_Jogo SET
				idTime1 = @idTime1,
				idTime2 = @idTime2,
				DataInicio = @DataHoraInicio,
				DataFinal = @DataHoraFinal
			WHERE idJogo = @idJogo
		END




		IF @Tipo = 2 
		BEGIN
			IF @CaminhoArq IS NULL
			BEGIN
				RAISERROR('Operação cancelada. O caminho do arquivo veio nulo', 16, 1)
			END

			SELECT 
			@DataHoraFinal = DataFinal
			FROM Ism_Jogo
			WHERE idJogo = @idJogo

			IF @DataHoraFinal > GETDATE()
			BEGIN
				RAISERROR('Operação cancelada. O Jogo não terminou, nenhuma sumula pode ser adicionada', 16, 1)
			END



			UPDATE Ism_Jogo 
			SET CaminhoArq = @CaminhoArq
			WHERE idJogo = @idJogo
			
		END

		IF @Tipo = 3 
		BEGIN
			UPDATE Ism_Jogo 
			SET CaminhoArq = NULL
			WHERE idJogo = @idJogo
		END

		RETURN 0
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END
		