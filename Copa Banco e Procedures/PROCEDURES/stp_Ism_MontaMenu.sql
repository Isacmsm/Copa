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

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_MontaMenu] (
	@TipoConsulta VARCHAR(50),
	@IdOperador INT = NULL,
	@CodigoSistema VARCHAR(50) = NULL,
	@CodigoModulo VARCHAR(50) = NULL,
	@CodigoPagina VARCHAR(50) = NULL,
	@CodigoAcao VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON 

		DECLARE @MsgErro VARCHAR(255)

		IF @TipoConsulta = 'C_MENU'
		BEGIN
			SELECT 
				S.Codigo AS CodigoSistema,
				S.Caption AS CaptionSistema,
				M.Codigo AS CodigoModulo,
				M.Caption AS CaptionModulo,
				P.Codigo AS CodigoPagina,
				P.Caption AS CaptionPagina
			FROM Ism_Sistema S
			INNER JOIN Ism_Modulo M ON S.idSistema = M.idSistema
			INNER JOIN Ism_Pagina P ON M.idModulo = P.idModulo
			WHERE EXISTS (
				SELECT *
				FROM Ism_Acao A
				INNER JOIN Ism_Autorizacao U ON U.idAcao = A.idAcao AND U.idOperador = @IdOperador
				WHERE P.idPagina = A.idPagina
			)
			order by S.Codigo, M.Codigo, P.idPagina
		END

		IF @TipoConsulta = 'C_Acao'
		BEGIN
			SELECT 
			A.idAcao,
			A.[Procedure] AS NomeProcedure
			FROM Ism_Acao A
			INNER JOIN Ism_Pagina P ON A.idPagina = P.idPagina
			INNER JOIN Ism_Modulo M ON P.idModulo = M.idModulo
			INNER JOIN Ism_Sistema S ON M.idSistema = S.idSistema
			INNER JOIN Ism_Autorizacao AU ON A.idAcao = AU.idAcao AND AU.idOperador = @IdOperador
			WHERE S.Codigo = @CodigoSistema
				AND M.Codigo = @CodigoModulo
				AND P.Codigo = @CodigoPagina
				AND A.Codigo = @CodigoAcao
		END

		IF @TipoConsulta = 'C_Botao'
		BEGIN
			SELECT 
				A.idAcao,
				A.Codigo,
				A.Caption
			FROM Ism_Acao A
			INNER JOIN Ism_Pagina P ON A.idPagina = P.idPagina
			INNER JOIN Ism_Modulo M ON P.idModulo = M.idModulo
			INNER JOIN Ism_Sistema S ON M.idSistema = S.idSistema
			INNER JOIN Ism_Autorizacao AU ON A.idAcao = AU.idAcao AND AU.idOperador = @IdOperador
			WHERE S.Codigo = @CodigoSistema
				AND M.Codigo = @CodigoModulo
				AND P.Codigo = @CodigoPagina
		END

		RETURN 0
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
	END CATCH
END
		


