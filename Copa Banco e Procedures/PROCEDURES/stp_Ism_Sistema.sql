USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 23/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Sistema
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Sistema_Sel](
	@IdSistema INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

			SELECT
				idSistema,
				Codigo,
				Caption
			FROM Ism_Sistema
			WHERE idSistema = @idSistema OR @idSistema IS NULL
			

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
-- Data criação: 23/02/2026
-- Descrição: Inserir Registros da Tabela Ism_Sistema
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Sistema_Ins](
	@idSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Sistema
			WHERE Caption = @Caption OR Codigo = @Codigo
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um sistema com informações iguais cadastrado', 16, 1)
		END

		INSERT INTO Ism_Sistema (Codigo, Caption)
		VALUES (@Codigo, @Caption)

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
-- Data criação: 23/02/2026
-- Descrição: Altera Registros da Tabela Ism_Sistema
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Sistema_Upt](
	@IdSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo do sistema não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption do sistema não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Sistema
			WHERE Caption = @Caption OR Codigo = @Codigo AND idSistema != @IdSistema 
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um sistema com informações iguais cadastrado', 16, 1)
		END

		UPDATE Ism_Sistema SET
			Codigo = @Codigo,
			Caption = @Caption
		WHERE idSistema = @IdSistema


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
-- Data criação: 23/02/2026
-- Descrição: Deleta Registros da Tabela Ism_Sistema
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Sistema_Del](
	@idSistema INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @idSistema IS NULL
		BEGIN
			RAISERROR('Operação cancelada. Selecione um sistema para deletar!', 16, 1)
		END

		DELETE Ism_Sistema
		WHERE idSistema = @idSistema

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END




