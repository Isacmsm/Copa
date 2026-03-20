USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Inserir Registros da Tabela Ism_Jogador
-- ============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogador_Ins] (
	@idJogador INT = NULL,
	@idTime INT = NULL,
	@Nome VARCHAR(50) = NULL,
	@Salario MONEY = NULL, 
	@Tipo INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
	
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @Salario IS NULL
		BEGIN
			RAISERROR(50001,10, 1, 'salario', 'O salario não pode ser vazio!')
		END

		IF @idTime IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'idtime', 'Selecione o time do Jogador')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Nome), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O nome do jogador não pode estar vazio')
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

		IF @Salario < 0
		BEGIN
			RAISERROR(50001, 10, 1, 'salario', 'O salario nao pode ser menor que  0')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT * 
			FROM Ism_Jogador
			WHERE idTime = @idTime AND Nome = @Nome
		)
		BEGIN 
			RAISERROR('Operação cancelada. Ja existe um jogador no time do id %d já cadastrado com o nome %s', 16, 1, @idTime, @Nome)
		END

		INSERT Ism_Jogador (idTime, Nome, Salario)
		VALUES (@idTime, @Nome, @Salario)
	
		RETURN 0
	END TRY
	BEGIN CATCH

		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
		RETURN 1 

	END CATCH
END


