USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Time
-- ================================================



CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Time_Sel] (
	@idTime INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

			SELECT
				IdTime,
				Nome
			FROM Ism_Time
			WHERE idTime = @idTime OR @idTime IS NULL

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END