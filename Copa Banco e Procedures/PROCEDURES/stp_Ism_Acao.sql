USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 24/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Acao
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Acao_Sel](
	@Tipo INT = NULL,
	@idAcao INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)


		IF @Tipo = 1
		BEGIN
			SELECT
				IA.idAcao,
				IA.idPagina,
				IPA.Caption AS NomePagina,
				IA.Codigo,
				IA.Caption,
				IA.[Procedure]
			FROM Ism_Acao IA
			INNER JOIN Ism_Pagina IPA ON IA.idPagina = IPA.idPagina
			WHERE idAcao = @idAcao OR @idAcao IS NULL
			
		END

		IF @Tipo = 2 
		BEGIN
			SELECT 
				ISP.idPagina,
				ST.Caption AS NomeSistema,
				IM.Caption AS NomeModulo,
				ISP.Caption
			FROM Ism_Pagina ISP
			INNER JOIN Ism_Modulo IM ON ISP.idModulo = IM.idModulo
			INNER JOIN Ism_Sistema ST ON IM.idSistema = ST.idSistema
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
-- Descrição: Inserir Registros da Tabela Ism_Acao
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Acao_Ins](
	@idAcao INT = NULL,
	@idPagina INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL,
	@Procedure VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idPagina IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idPagina', 'Selecione uma Pagina!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da ação não pode ser numérico')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O nome da ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O nome da ação não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O nome da ação não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Procedure), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'procedure', 'A Procedure da Ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Procedure) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'procedure', 'A Procedure da Ação não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Procedure) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'procedure', 'A Procedure da Ação não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Acao
			WHERE Caption = @Caption AND Codigo = @Codigo AND [Procedure] = @Procedure
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um sistema com informações iguais cadastrado', 16, 1)
		END

		INSERT INTO Ism_Acao(idPagina, Codigo, Caption, [Procedure])
		VALUES (@idPagina, @Codigo, @Caption, @Procedure)

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
-- Descrição: Altera Registros da Tabela Ism_Acao
-- ================================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Acao_Upt](
	@idAcao INT = NULL,
	@idPagina INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL,
	@Procedure VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255), @Erro BIT


		IF @idPagina IS NULL
		BEGIN                                   
			RAISERROR(50001, 10, 1, 'idPagina', 'Selecione um ação!')
			SET @Erro = 1
		END

			IF NULLIF(TRIM(@Codigo), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Codigo) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'codigo', 'O codigo da ação não pode ser numérico')
			SET @Erro = 1
		END


		IF NULLIF(TRIM(@Caption), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Caption) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da ação não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Caption) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'O caption da ação não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF NULLIF(TRIM(@Procedure), '') IS NULL
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'A procedure da ação não pode estar vazio')
			SET @Erro = 1
		END

		IF ISNUMERIC(@Procedure) = 1
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'A procedure da ação não pode ser numérico')
			SET @Erro = 1
		END

		IF LEN(@Procedure) < 3
		BEGIN
			RAISERROR(50001, 10, 1, 'caption', 'A procedure da ação não pode ter menos que 3 caracteres')
			SET @Erro = 1
		END

		IF @Erro = 1 RETURN 1

		IF EXISTS (
			SELECT *
			FROM
			Ism_Acao
			WHERE Caption = @Caption AND Codigo = @Codigo OR @Procedure = [Procedure] AND idPagina = @idPagina AND @idAcao != @idAcao
		)
		BEGIN
			RAISERROR('Operação cancelada. Ja existe um ação com informações iguais cadastrado', 16, 1)
		END

		UPDATE Ism_Acao SET
			idPagina = @idPagina,
			Codigo = @Codigo,
			Caption = @Caption,
			[Procedure] = @Procedure

		WHERE idAcao = idAcao


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
-- Descrição: Exclui Registros da Tabela Ism_Acao
-- ===============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Acao_Del](
	@idAcao INT = NULL,
	@idPagina INT = NULL,
	@Codigo VARCHAR(50) = NULL,
	@Caption VARCHAR(50) = NULL,
	@Procedure VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255), @Erro BIT

		IF @idAcao IS NULL
		BEGIN 
			RAISERROR('Informe o ID da Ação a ser removido dos registros', 16, 1)
		END


		DELETE Ism_Acao
		WHERE @idAcao = idAcao


		RETURN 0 
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END

