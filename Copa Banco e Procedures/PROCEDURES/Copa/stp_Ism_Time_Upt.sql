USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Altera Registros da Tabela Ism_Time
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Time_Upt] (
	@IdTime INT = NULL,
	@Nome VARCHAR(50) = NULL,
	@idSessao INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON 

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF NULLIF(TRIM(@Nome), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'O nome do time não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Nome) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O nome do time não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Nome) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O nome do time ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF @IdTime IS NULL OR NOT EXISTS (
			SELECT idTime
			FROM Ism_Time
			WHERE idTime = @IdTime
		) 
		BEGIN
			RAISERROR('Operação cancelada. Selecione um time para Alterar seu registro!', 16, 1)
		END

		IF EXISTS (
			SELECT Nome
			FROM Ism_Time
			WHERE Nome = @Nome
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um time com o nome %s cadastrado', 16, 1, @Nome)
		END

		SELECT @MsgErro = dbo.fn_ConsisteOperadorSessao(@idSessao)
		IF @MsgErro IS NOT NULL
		BEGIN
		   RAISERROR(@MsgErro, 16, 1)
		END

		UPDATE Ism_Time SET
			Nome = @Nome,
			idSessao = @idSessao
		WHERE idTime = @idTime

		RETURN 0
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END
		