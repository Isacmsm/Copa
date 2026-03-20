CREATE FUNCTION [dbo].[fn_ConsisteOperadorSessao] (
    @idSessao INT = NULL
)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE
        @DataFim DATETIME,
        @idOperador INT,
        @CPF VARCHAR(20)

    IF @idSessao IS NULL
    BEGIN
        RETURN 'Sessão não informada'
    END

    SELECT
        @idOperador = idOperador,
        @DataFim = DataFim
    FROM Sys_Sessao (NOLOCK)
    WHERE idSessao = @idSessao

    IF @idOperador IS NULL
    BEGIN
        RETURN 'Sessão não identificada'
    END

    IF @DataFim IS NOT NULL
    BEGIN
        RETURN 'Sessão já encerrada'
    END

    SET @CPF = NULL

    SELECT @CPF = CPF
    FROM Ism_Operador (NOLOCK)
    WHERE idOperador = @idOperador

    IF @CPF IS NULL
    BEGIN
        RETURN 'Operador não cadastrado'
    END

    RETURN NULL
END