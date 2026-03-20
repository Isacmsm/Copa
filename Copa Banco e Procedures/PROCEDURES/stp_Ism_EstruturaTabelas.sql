USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 24/02/2026
-- Descrição: Retorna um datatable
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_EstruturaTabelas](
	@TipoConsulta VARCHAR(50) = NULL,
	@Chave VARCHAR(100) = NULL,
	@ConsultaComposta VARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		IF @TipoConsulta = 'Time'
		BEGIN
			SELECT
				IdTime,
				Nome
			FROM Ism_Time
			WHERE (CHARINDEX(@Chave, Nome) > 0 OR @Chave IS NULL) 
		END

		IF @TipoConsulta = 'Jogador'
		BEGIN
			SELECT
				IdJogador,
				Nome
			FROM Ism_Jogador
			WHERE (CHARINDEX(@Chave, Nome) > 0 OR @Chave IS NULL)
					AND (idTime = @ConsultaComposta OR @ConsultaComposta = NULL)
		END

		IF @TipoConsulta = 'Operador'
		BEGIN
			SELECT
				idOperador AS IdOperador,
				Nome
			FROM Ism_Operador
			WHERE (CHARINDEX(@Chave, Nome) > 0 OR @Chave IS NULL)
			ORDER BY Nome
		END

		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END
