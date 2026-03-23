USE [dbTreinamento]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[stp_AcoesOperadorImprimir_Sel](
    @DataInicio DATETIME = NULL,
    @DataFim DATETIME = NULL,
    @IdOperador INT = NULL,
    @TipoOperacao VARCHAR(15) = NULL,
    @TipoConsulta VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON

        DECLARE @MsgErro VARCHAR(255)

        IF @TipoConsulta = 'Principal'
        BEGIN
            SELECT 
	            'Pagina Time' AS Pagina,
	            TipoOperacao,
	            UsuarioOperacao,
	            DataOperacao 
            FROM Ism_TimeHistorico TH
            INNER JOIN Sys_Sessao S ON TH.idSessao = S.IdSessao
            WHERE (@DataInicio IS NULL OR TH.DataOperacao >= @DataInicio)
                AND (@DataFim IS NULL OR TH.DataOperacao < DATEADD(DAY, 1, @DataFim))
                AND (@IdOperador IS NULL OR S.IdOperador = @IdOperador)
                AND (@TipoOperacao IS NULL OR TH.TipoOperacao IN (SELECT value FROM STRING_SPLIT(@TipoOperacao, ',')))
            ORDER BY TH.DataOperacao DESC
        END

        IF @TipoConsulta = 'Operador'
        BEGIN
            SELECT 
                Nome,
                Cpf
            FROM Ism_Operador
            where idOperador = @IdOperador
        END


        RETURN 0
    END TRY
    BEGIN CATCH
        SET @MsgErro = ERROR_MESSAGE()
        RAISERROR(@MsgErro, 16, 1)
        RETURN 1
    END CATCH
END