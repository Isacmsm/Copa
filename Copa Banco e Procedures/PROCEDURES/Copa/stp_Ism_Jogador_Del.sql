USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Exclui Registros da Tabela Ism_Jogador
-- ===============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogador_Del](
	@idJogador INT = NULL,
	@idTime INT = NULL,
	@Nome VARCHAR(50) = NULL,
	@Salario MONEY = NULL,
	@Tipo int = null
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idJogador IS NULL
		BEGIN 
			RAISERROR('Informe o ID do Jogador a ser removido dos registros', 16, 1)
		END

		IF NOT EXISTS (
			SELECT idJogador
			FROM Ism_Jogador
			WHERE idJogador = @idJogador
		)
		BEGIN
			RAISERROR('Operação Cancelada. Não foi possivel identificar o Jogador informado pelo ID %d', 16, 1, @idJogador)
		END

		DELETE Ism_Jogador
		WHERE idJogador = @idJogador

		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

