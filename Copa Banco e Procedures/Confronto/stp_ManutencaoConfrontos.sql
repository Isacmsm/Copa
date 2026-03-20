CREATE OR ALTER PROCEDURE [dbo].[stp_ManutencaoConfrontos](
    @JogosJson NVARCHAR(MAX) = NULL,
    @Tipo VARCHAR(1) = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON
        DECLARE @MsgErro VARCHAR(255)
        DECLARE @IdJogoErro INT

        IF @Tipo = 'I'
        BEGIN
            IF EXISTS (
                SELECT 1 FROM OPENJSON(@JogosJson) j
                WHERE JSON_VALUE(j.value, '$.idTime1') = JSON_VALUE(j.value, '$.idTime2')
            )
            BEGIN
                RAISERROR('Operação cancelada. Os dois times de um confronto devem ser diferentes.', 16, 1)
                RETURN 1
            END

            IF EXISTS (
                SELECT 1 FROM OPENJSON(@JogosJson) j
                WHERE NOT EXISTS (SELECT 1 FROM Ism_Time WHERE idTime = JSON_VALUE(j.value, '$.idTime1'))
            )
            BEGIN
                RAISERROR('Operação cancelada. Um dos times informados não foi encontrado.', 16, 1)
                RETURN 1
            END

            IF EXISTS (
                SELECT 1 FROM OPENJSON(@JogosJson) j
                WHERE NOT EXISTS (SELECT 1 FROM Ism_Time WHERE idTime = JSON_VALUE(j.value, '$.idTime2'))
            )
            BEGIN
                RAISERROR('Operação cancelada. Um dos times informados não foi encontrado.', 16, 1)
                RETURN 1
            END

            IF EXISTS (
                SELECT 1 FROM OPENJSON(@JogosJson) j
                WHERE JSON_VALUE(j.value, '$.dataInicio') IS NULL
                   OR JSON_VALUE(j.value, '$.horaInicio') IS NULL
                   OR JSON_VALUE(j.value, '$.dataFinal') IS NULL
                   OR JSON_VALUE(j.value, '$.horaFinal') IS NULL
            )
            BEGIN
                RAISERROR('Operação cancelada. Preencha todos os campos de data e hora.', 16, 1)
                RETURN 1
            END

            IF EXISTS (
                SELECT 1 FROM OPENJSON(@JogosJson) j
                WHERE CONVERT(DATETIME, JSON_VALUE(j.value, '$.dataFinal') + ' ' + JSON_VALUE(j.value, '$.horaFinal'))
                   <= CONVERT(DATETIME, JSON_VALUE(j.value, '$.dataInicio') + ' ' + JSON_VALUE(j.value, '$.horaInicio'))
            )
            BEGIN
                RAISERROR('Operação cancelada. A data final deve ser posterior à data de início.', 16, 1)
                RETURN 1
            END

            INSERT INTO Ism_Jogo (idTime1, idTime2, DataInicio, DataFinal)
            SELECT
                JSON_VALUE(j.value, '$.idTime1'),
                JSON_VALUE(j.value, '$.idTime2'),
                CONVERT(DATETIME, JSON_VALUE(j.value, '$.dataInicio') + ' ' + JSON_VALUE(j.value, '$.horaInicio')),
                CONVERT(DATETIME, JSON_VALUE(j.value, '$.dataFinal') + ' ' + JSON_VALUE(j.value, '$.horaFinal'))
            FROM OPENJSON(@JogosJson) j
        END

        IF @Tipo = 'E'
        BEGIN
            SELECT TOP 1 @IdJogoErro = IJ.idJogo
            FROM OPENJSON(@JogosJson) j
            INNER JOIN Ism_Jogo IJ
                ON (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime1') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime2'))
                OR (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime2') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime1'))
            WHERE IJ.Placar1 != 0 AND IJ.Placar2 != 0

            IF @IdJogoErro IS NOT NULL
            BEGIN
                RAISERROR('Operação cancelada. O jogo referente ao ID %d já possui placar.', 16, 1, @IdJogoErro)
                RETURN 1
            END

            SET @IdJogoErro = NULL

            SELECT TOP 1 @IdJogoErro = IJ.idJogo
            FROM OPENJSON(@JogosJson) j
            INNER JOIN Ism_Jogo IJ
                ON (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime1') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime2'))
                OR (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime2') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime1'))
            WHERE IJ.DataInicio <= GETDATE()

            IF @IdJogoErro IS NOT NULL
            BEGIN
                RAISERROR('Operação cancelada. O jogo referente ao ID %d já foi iniciado.', 16, 1, @IdJogoErro)
                RETURN 1
            END

            DELETE IJ
            FROM Ism_Jogo IJ
            INNER JOIN OPENJSON(@JogosJson) j
                ON (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime1') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime2'))
                OR (IJ.idTime1 = JSON_VALUE(j.value, '$.idTime2') AND IJ.idTime2 = JSON_VALUE(j.value, '$.idTime1'))
        END

        RETURN 0
    END TRY
    BEGIN CATCH
        SET @MsgErro = ERROR_MESSAGE()
        RAISERROR(@MsgErro, 16, 1)
        RETURN 1
    END CATCH
END