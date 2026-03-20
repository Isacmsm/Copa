USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Autor: Isac Macedo
-- Data criação: 24/02/2026
-- Descrição: Select Paginação
-- ================================================

CREATE OR ALTER PROCEDURE [dbo].[stp_Paginacao_Sel](
	@QuantidadePorPagina INT = 10,
	@Pagina INT = 1,
	@TipoConsulta INT = NULL,
	@Pesquisa VARCHAR(50) = NULL,
	@valorInicio MONEY = NULL,
	@valorFim MONEY = NULL
)
AS
BEGIN
	BEGIN TRY 
		SET NOCOUNT ON
		
		DECLARE @MsgErro VARCHAR(255)

		DECLARE @T TABLE (
			Codigo INT,
			Descricao VARCHAR(100),
			Valor MONEY,
			DataInclusao DATETIME
		)

		DECLARE @Count INT = 1

		WHILE @Count <= 300
		BEGIN
			INSERT INTO @T (Codigo, Descricao, Valor, DataInclusao)
			VALUES (@Count, 'Item' + CONVERT(VARCHAR, @Count), @Count * 20, GETDATE())
			SET @Count = @Count + 1
		END

		IF @Pesquisa IS NOT NULL
		BEGIN
			IF ISNUMERIC(@Pesquisa) = 1
			BEGIN
				DELETE @T
				WHERE Codigo <> @Pesquisa
			END

			IF ISNUMERIC(@Pesquisa) = 0
			BEGIN
				DELETE @T
				WHERE CHARINDEX(@Pesquisa, Descricao) = 0
			END
		END

		IF @valorInicio > 0
		BEGIN
			DELETE @T
			WHERE Valor < @valorInicio
		END

		IF @valorFim > 0
		BEGIN
			DELETE @T
			WHERE Valor > @valorFim
		END


		IF @TipoConsulta IS NULL
		BEGIN
			SELECT 
				Codigo,
				Descricao,
				Valor,
				DataInclusao
			FROM @T
			ORDER BY Codigo
			OFFSET (@Pagina - 1) * @QuantidadePorPagina ROWS
			FETCH NEXT @QuantidadePorPagina ROWS ONLY
		END


		IF @TipoConsulta = 1
		BEGIN
			SELECT COUNT(*) AS TotalRegistros
			FROM @T
		END
		


		RETURN 0
	END TRY
	BEGIN CATCH 
		SET @MsgErro = ERROR_MESSAGE()
		RAISERROR(@MsgErro, 16, 1)

		RETURN 1
	END CATCH
END
