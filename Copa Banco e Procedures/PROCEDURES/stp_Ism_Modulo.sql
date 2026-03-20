USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 23/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Modulo
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Modulo_Sel](
	@Tipo INT = NULL,
	@idModulo INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)


		IF @Tipo = 1
		BEGIN
			SELECT
				IM.idModulo,
				IM.idSistema,
				IST.Caption AS NomeSistema,
				IM.Codigo,
				IM.Caption
			FROM Ism_Modulo IM
			INNER JOIN Ism_Sistema IST ON IM.idSistema = IST.idSistema
			WHERE idModulo = @idModulo OR @idModulo IS NULL
		END

		IF @Tipo = 2 
		BEGIN
			SELECT *
			FROM Ism_Sistema
		END
			

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END


-------------------------------------------------------------

USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================
-- Autor: Isac Macedo
-- Data criação: 23/02/2026
-- Descrição: Inserir Registros da Tabela Ism_Modulo
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Modulo_Ins](
	@idModulo INT = NULL,
	@idSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idSistema IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idSistema', 'Selecione um sistema!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Modulo
			WHERE Caption = @Caption OR Codigo = @Codigo AND idSistema = @idSistema
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um modulo com informações iguais cadastrado', 16, 1)
		END

		INSERT INTO Ism_Modulo(idSistema, Codigo, Caption)
		VALUES (@idSistema, @Codigo, @Caption)

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END




---------------------------------------------------------
USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 23/02/2026
-- Descrição: Altera Registros da Tabela Ism_Modulo
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Modulo_Upt](
	@IdModulo INT = NULL,
	@IdSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idSistema IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idSistema', 'Selecione um sistema!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do modulo não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do modulo não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Modulo
			WHERE Caption = @Caption OR Codigo = @Codigo AND idModulo != @IdModulo AND @IdSistema = idSistema
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um modulo com informações iguais cadastrado', 16, 1)
		END

		UPDATE Ism_Modulo SET
			idSistema = @IdSistema,
			Codigo = @Codigo,
			Caption = @Caption
		WHERE idModulo = @IdModulo


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END





-------------------------------------------------------------------
USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 23/02/2026
-- Descrição: Exclui Registros da Tabela Ism_Modulo
-- ===============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Modulo_Del](
	@IdModulo INT = NULL,
	@IdSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @IdModulo IS NULL
		BEGIN 
			RAISERROR('Informe o ID do modulo a ser removido dos registros', 16, 1)
		END


		DELETE Ism_Modulo
		WHERE idModulo = @IdModulo


		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

