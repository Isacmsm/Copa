USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 24/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Pagina
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Pagina_Sel](
	@Tipo INT = NULL,
	@idPagina INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)


		IF @Tipo = 1
		BEGIN
			SELECT 
				ISP.idPagina,
				ISP.idModulo,
				IM.Caption AS NomeModulo,
				ISP.Codigo,
				ISP.Caption
			FROM Ism_Pagina ISP
			INNER JOIN Ism_Modulo IM ON ISP.idModulo = IM.idModulo
			WHERE idPagina = @idPagina OR @idPagina IS NULL
		END

		IF @Tipo = 2 
		BEGIN
			SELECT
				IM.idModulo,
				IM.idSistema,
				IST.Caption AS NomeSistema,
				IM.Codigo,
				IM.Caption
			FROM Ism_Modulo IM
			INNER JOIN Ism_Sistema IST ON IM.idSistema = IST.idSistema
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
-- Data criação: 24/02/2026
-- Descrição: Inserir Registros da Tabela Ism_Pagina
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Pagina_Ins](
	@idPagina INT = NULL,
	@idModulo INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idModulo IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idModulo', 'Selecione um modulo!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Pagina
			WHERE Caption = @Caption OR Codigo = @Codigo
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe uma pagina com informações iguais cadastrado', 16, 1)
		END

		INSERT INTO Ism_Pagina(idModulo, Codigo, Caption)
		VALUES (@idModulo, @Codigo, @Caption)

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
-- Data criação: 24/02/2026
-- Descrição: Altera Registros da Tabela Ism_Pagina
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Pagina_Upt](
	@idPagina INT = NULL,
	@idModulo INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idModulo IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idModulo', 'Selecione um sistema!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Codigo) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da pagina não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da pagina não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Pagina
			WHERE Caption = @Caption OR Codigo = @Codigo AND idModulo = @idModulo AND @idPagina != idPagina
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe uma pagina com informações iguais cadastrado', 16, 1)
		END

		UPDATE Ism_Pagina SET
			idModulo = @idModulo,
			Codigo = @Codigo,
			Caption = @Caption
		WHERE idPagina = @idPagina


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
-- Data criação: 24/02/2026
-- Descrição: Exclui Registros da Tabela Ism_Pagina
-- ===============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Pagina_Del](
	@IdPagina INT = NULL,
	@IdModulo INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @IdPagina IS NULL
		BEGIN 
			RAISERROR('Informe o ID do modulo a ser removido dos registros', 16, 1)
		END


		DELETE Ism_Pagina
		WHERE IdPagina = @IdPagina


		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

