USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 27/02/2026
-- Descrição: Procedure para o menu dinamico
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_AbreSessao] (
	@Cpf VARCHAR(11) = NULL,
	@Senha VARCHAR(50) = NULL,
	@ViaIp VARCHAR(80) = NULL,
	@Tipo INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON 

		DECLARE @MsgErro VARCHAR(255), @ERRO BIT

		IF @Cpf IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'Informe o CPF')
			SET @ERRO = 1
		END
		
		IF @Senha IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'Informe a Senha')
			SET @ERRO = 1
		END

		IF NOT EXISTS(
			SELECT *
			FROM Ism_Operador
			WHERE Cpf = @Cpf AND Senha = @Senha
		)
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'Acesso negado')
			SET @ERRO = 1
		END

		IF @ERRO = 1 RETURN 1
		
		IF @TIPO = 0
		BEGIN
			DECLARE @idOperador INT = NULL
			DECLARE @idSessao INT = NULL

			SELECT @idOperador = idOperador
			FROM Ism_Operador
			WHERE Cpf = @Cpf

			BEGIN TRANSACTION

			UPDATE Sys_Sessao SET
				DataFim = GETDATE()
			WHERE idOperador = @idOperador AND DataFim IS NULL

			INSERT INTO Sys_Sessao (
				idOperador,
				DataInicio,
				ViaIp
			)
			SELECT
				idOperador = @idOperador,
				DataInicio = GETDATE(),
				ViaIp = @ViaIp

			SET @idSessao = SCOPE_IDENTITY()

			COMMIT TRANSACTION

			SELECT @idSessao AS idSessao
		END

		IF @Tipo = 1
		BEGIN
			SELECT 
				IdOperador, 
				Nome,
				Tema
			FROM Ism_Operador
			WHERE CPF = @Cpf AND Senha = @Senha
		END


		RETURN 0
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END
		


