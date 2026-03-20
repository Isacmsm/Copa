USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Autorizacao
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Autorizacao_Sel](
	@Tipo INT = NULL,
	@IdOperador INT = NULL

)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @Tipo = 1 
		BEGIN
			SELECT 
				idOperador,
				Nome
			FROM Ism_Operador
		END

		IF @Tipo = 2 AND @IdOperador IS NOT NULL
		BEGIN
			SELECT 
				AC.idAcao,
				AUT.idAutorizacao,
				ST.Caption AS NomeSt,
				MD.Caption As NomeMd,
				PG.Caption AS NomePag,
				AC.Caption AS NomeAcao
			FROM Ism_Sistema ST
			INNER JOIN Ism_Modulo MD ON ST.idSistema = MD.idSistema
			INNER JOIN Ism_Pagina PG ON MD.idModulo = PG.idModulo
			INNER JOIN Ism_Acao AC ON PG.idPagina = AC.idPagina
			LEFT JOIN Ism_Autorizacao AUT ON AC.idAcao = AUT.idAcao AND aut.idOperador = @IdOperador 
		END


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END

-------------------------------------------------------------------------------


USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Alterar Registros da Tabela Ism_Autorizacao
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Autorizacao_Upt](
	@idAcao VARCHAR(MAX) = NULL,
	@IdOperador INT = NULL

)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		DECLARE @AcoesTemp TABLE
		(
			idAcao INT
		);

		INSERT INTO @AcoesTemp (IdAcao)
		SELECT CAST(VALUE AS INT)
		FROM string_split(@idAcao, ',')

		DELETE AUT FROM Ism_Autorizacao AUT
		WHERE AUT.idOperador = @IdOperador 
		AND AUT.idAcao NOT IN (SELECT idAcao FROM @AcoesTemp)

		INSERT INTO Ism_Autorizacao (idOperador, idAcao)
		SELECT 
			@IdOperador, 
			ACT.idAcao
		FROM @AcoesTemp ACT
		WHERE NOT EXISTS
		(	
			SELECT 1 
			FROM Ism_Autorizacao A
			WHERE A.idOperador = @IdOperador AND ACT.idAcao = A.idAcao
		);

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END