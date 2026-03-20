USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Selecionar Registros da Tabela Ism_Jogador
-- ===============================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogador_Sel](
	@Tipo INT = NULL,
	@IdJogador INT = NULL,
	@IdTime INT = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		-- ===========================
        -- Tipo 1: Consulta Principal
        -- ===========================

		IF @Tipo = 1
		BEGIN
		SELECT 
			idJogador,
			IJ.idTime,
			IT.Nome AS NomeTime,
			IJ.Nome,
			IJ.Salario,
			IJ.Capitao,
			IJ.Tecnico,
			IJ.Suspenso
		FROM Ism_Jogador IJ
		INNER JOIN Ism_Time IT ON IT.idTime = IJ.idTime
		WHERE (@IdJogador IS NULL OR idJogador = @IdJogador)
				AND (@IdTime IS NULL OR ij.idTime = @IdTime)
		END

		-- ===========================
        -- Tipo 2: Consulta do Select
        -- ===========================

		IF @Tipo = 2
		BEGIN
		SELECT 
			idTime,
			Nome
			FROM Ism_Time
		END


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END
