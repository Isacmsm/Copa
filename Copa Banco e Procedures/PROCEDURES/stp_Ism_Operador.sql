USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Operador
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Operador_Sel](
	@IdOperador INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		SELECT
			idOperador,
			Cpf,
			Nome,
			Senha
		FROM Ism_Operador IOP
		WHERE idOperador = @IdOperador OR @IdOperador is null

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END


-- ------------------------------------------------------------------------------------------
USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Inserir Registros da Tabela Ism_Operador
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Operador_Ins](
	@idOperador INT = NULL,
	@CPF VARCHAR(11) = NULL,
	@NOME VARCHAR(50) = NULL,
	@SENHA VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

			IF NULLIF(TRIM(@CPF), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode estar vazio')
			SET @Erro = 1
		END

		IF @CPF LIKE '%[A-Za-z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter letras!')
			SET @Erro = 1
		END

		IF LEN(@CPF) < 11
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter menos que 11 caracteres')
			SET @Erro = 1
		END

		IF LEN(@CPF) > 11
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter mais que 11 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@NOME), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@NOME) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode conter números!')
			SET @Erro = 1
		END

		IF LEN(@NOME) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@SENHA), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha não pode ser vazia!')
			SET @Erro = 1
		END

		IF @SENHA NOT LIKE '%[0-9]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve contem pelo menos um número')
			SET @Erro = 1
		END


		IF @SENHA NOT LIKE '%[A-Z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve conter pelo menos uma letra maiuscula')
			SET @Erro = 1
		END

		IF @SENHA NOT LIKE '%[a-z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve conter pelo menos uma letra minuscula')
			SET @Erro = 1
		END

		IF LEN(@SENHA) < 6
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'O senha não pode ter menos que 6 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Operador
			WHERE Cpf = @CPF
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um Operador com esse CPF cadastrado!', 16, 1)
		END

		INSERT INTO Ism_Operador (Cpf, Nome, Senha)
		VALUES (@CPF, @NOME, @SENHA)

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END


-- --------------------------------------------------------------------------
USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Altera Registros da Tabela Ism_Operador
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Operador_Upt](
	@idOperador INT = NULL,
	@CPF VARCHAR(11) = NULL,
	@NOME VARCHAR(50) = NULL,
	@SENHA VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF NULLIF(TRIM(@CPF), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode estar vazio')
			SET @Erro = 1
		END

		IF @CPF LIKE '%[A-Za-z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter letras!')
			SET @Erro = 1
		END

		IF LEN(@CPF) < 11
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter menos que 11 caracteres')
			SET @Erro = 1
		END

		IF LEN(@CPF) > 11
		BEGIN
			RAISERROR(50001, 10, 1, 'cpf', 'O campo CPF não pode conter mais que 11 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@NOME), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@NOME) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode conter números!')
			SET @Erro = 1
		END

		IF LEN(@NOME) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'nome', 'O campo Nome não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@SENHA), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha não pode ser vazia!')
			SET @Erro = 1
		END

		IF @SENHA NOT LIKE '%[0-9]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve contem pelo menos um número')
			SET @Erro = 1
		END


		IF @SENHA NOT LIKE '%[A-Z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve conter pelo menos uma letra maiuscula')
			SET @Erro = 1
		END

		IF @SENHA NOT LIKE '%[a-z]%'
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'A senha deve conter pelo menos uma letra minuscula')
			SET @Erro = 1
		END

		IF LEN(@SENHA) < 6
		BEGIN
			RAISERROR(50001, 10, 1, 'senha', 'O senha não pode ter menos que 6 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Operador
			WHERE Cpf = @CPF AND @idOperador != idOperador
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um Operador com esse CPF cadastrado!', 16, 1)
		END

		UPDATE Ism_Operador SET
			Cpf = @CPF,
			Nome = @NOME,
			Senha = @SENHA
		WHERE idOperador = @idOperador


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END


------------------------------------------------------------------
USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Deleta Registros da Tabela Ism_Operador
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Operador_Del](
	@idOperador INT = NULL,
	@CPF VARCHAR(11) = NULL,
	@NOME VARCHAR(50) = NULL,
	@SENHA VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @idOperador IS NULL
		BEGIN
			RAISERROR('Operação cancelada. Selecione um operador a excluir', 16, 1)
		END

		DELETE Ism_Operador
		WHERE idOperador = @idOperador

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END




