CREATE OR ALTER PROCEDURE [dbo].[stp_ConsultaAcoes_Sel](
    @IdSessao INT = NULL,
    @IdOperador INT = NULL,
    @TipoConsulta VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON

        DECLARE @MsgErro VARCHAR(255)

        IF @TipoConsulta = 'Historico'
        BEGIN
            SELECT
	            'Pagina Time' AS Pagina,
	            TipoOperacao,
	            UsuarioOperacao,
	             DataOperacao 
            FROM Ism_TimeHistorico
            WHERE idSessaoOperacao = @IdSessao
        END


        IF @TipoConsulta = 'Operador'
        BEGIN
            SELECT 
                Cpf,
                Nome
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