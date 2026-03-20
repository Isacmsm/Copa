USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Procedure de sair da sessão.
-- ============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Sys_FechaSessao] (
	@idSessao INT = NULL
)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @MsgErro VARCHAR(255)

		SELECT @MsgErro = dbo.fn_ConsisteOperadorSessao(@idSessao)
		IF @MsgErro IS NOT NULL
		BEGIN
		   RAISERROR(@MsgErro, 16, 1)
		END

		UPDATE Sys_Sessao SET
			DataFim = GETDATE()
		WHERE IdSessao = @IdSessao AND DataFim IS NULL
		

		RETURN 0
	END TRY
	BEGIN CATCH
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)
		RETURN 1
	END CATCH
END


