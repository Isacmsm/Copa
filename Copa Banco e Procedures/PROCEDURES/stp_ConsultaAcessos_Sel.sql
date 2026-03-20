CREATE OR ALTER PROCEDURE [dbo].[stp_ConsultaAcessos_Sel](
    @QuantidadePorPagina INT = 10,
    @Pagina INT = 1,
    @TipoConsulta INT = NULL,
    @DataInicio DATETIME = NULL,
    @DataFim DATETIME = NULL,
    @IdOperador INT = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON

        DECLARE @MsgErro VARCHAR(255)

        IF @TipoConsulta IS NULL
        BEGIN
            SELECT
                S.IdSessao,
                O.idOperador,
                O.Nome AS Operador,
                CONVERT(VARCHAR, S.DataInicio, 103) AS DataInicio,
                CONVERT(VARCHAR, S.DataInicio, 108) AS HoraInicio,
                CONVERT(VARCHAR, S.DataFim, 103) AS DataFim,
                CONVERT(VARCHAR, S.DataFim, 108) AS HoraFim,
                S.ViaIp
            FROM Sys_Sessao S
            INNER JOIN Ism_Operador O ON O.idOperador = S.IdOperador
            WHERE (@DataInicio IS NULL OR S.DataInicio >= @DataInicio)
              AND (@DataFim IS NULL OR S.DataInicio < DATEADD(DAY, 1, @DataFim))
              AND (@IdOperador IS NULL OR S.IdOperador = @IdOperador)
            ORDER BY S.DataInicio DESC
            OFFSET (@Pagina - 1) * @QuantidadePorPagina ROWS
            FETCH NEXT @QuantidadePorPagina ROWS ONLY
        END

        IF @TipoConsulta = 1
        BEGIN
            SELECT COUNT(*) AS TotalRegistros
            FROM Sys_Sessao S
            INNER JOIN Ism_Operador O ON O.idOperador = S.IdOperador
            WHERE (@DataInicio IS NULL OR S.DataInicio >= @DataInicio)
              AND (@DataFim IS NULL OR S.DataInicio < DATEADD(DAY, 1, @DataFim))
              AND (@IdOperador IS NULL OR S.IdOperador = @IdOperador)
        END

        RETURN 0
    END TRY
    BEGIN CATCH
        SET @MsgErro = ERROR_MESSAGE()
        RAISERROR(@MsgErro, 16, 1)
        RETURN 1
    END CATCH
END