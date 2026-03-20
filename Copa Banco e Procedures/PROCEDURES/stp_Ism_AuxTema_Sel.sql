USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 25/02/2026
-- Descrição: Muda o tema do Operador no banco
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_AuxTema_Upt](
	@IdOperador INT = NULL,
	@Tema BIT = NULL

)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @IdOperador IS NULL RAISERROR('Operação cancelada. Operador não informado', 16, 1)

		IF @Tema IS NULL RAISERROR('Operação cancelada. Tema não informado', 16, 1)


		UPDATE Ism_Operador 
		SET Tema = @Tema
		WHERE idOperador = @IdOperador

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END


