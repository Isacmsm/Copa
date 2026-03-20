CREATE OR ALTER PROCEDURE [dbo].[stp_ConsultaConfrontos_Sel](
    @TipoConsulta VARCHAR(50) = NULL,
    @idJogo INT = NULL,
    @idTime1 INT = NULL,
    @idTime2 INT = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON

        DECLARE @MsgErro VARCHAR(255)


        IF @TipoConsulta = 'Confronto' 
        BEGIN
            SELECT 
                T1.idTime AS IdTime1,
                T1.Nome AS NomeTime1,
                T2.idTime AS IdTime2,
                T2.Nome AS NomeTime2,
                CASE 
                    WHEN EXISTS (
                        SELECT 1 FROM Ism_Jogo J 
                        WHERE (J.idTime1 = T1.idTime AND J.idTime2 = T2.idTime)
                           OR (J.idTime1 = T2.idTime AND J.idTime2 = T1.idTime)
                    ) THEN 1 ELSE 0 
                END AS TemJogo
            FROM Ism_Time T1
            CROSS JOIN Ism_Time T2
            WHERE T1.idTime <> T2.idTime
        END

        IF @TipoConsulta = 'Jogos'
        BEGIN
            SELECT 
                IJ.idJogo,
                IJ.idTime1,
                IT1.Nome AS NomeTime1,
                IJ.idTime2,
                IT2.Nome AS NomeTime2,
                IJ.Placar1,
                IJ.Placar2,
                CONVERT(VARCHAR, DataInicio, 23) AS DataInicio,
                CONVERT(VARCHAR, DataInicio, 108) AS HoraInicio,
                CONVERT(VARCHAR, DataFinal, 23) AS DataFinal,
                CONVERT(VARCHAR, DataFinal, 108) AS HoraFinal,
                CASE WHEN IJ.DataInicio <= GETDATE() THEN 1 ELSE 0 END AS JaIniciou,
                CASE WHEN IJ.Placar1 != 0 AND IJ.Placar2 != 0 THEN 1 ELSE 0 END AS TemPlacar
            FROM Ism_Jogo IJ
            INNER JOIN Ism_Time IT1 ON IT1.idTime = IJ.idTime1
            INNER JOIN Ism_Time IT2 ON IT2.idTime = IJ.idTime2
            WHERE (IJ.idTime1 = @idTime1 AND IJ.idTime2 = @idTime2)
                OR (IJ.idTime1 = @idTime2 AND IJ.idTime2 = @idTime1)
        END



        RETURN 0
    END TRY
    BEGIN CATCH
        SET @MsgErro = ERROR_MESSAGE()
        RAISERROR(@MsgErro, 16, 1)
        RETURN 1
    END CATCH
END