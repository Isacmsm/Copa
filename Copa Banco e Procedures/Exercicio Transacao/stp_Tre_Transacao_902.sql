CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Transacao_902] (
    @Placa VARCHAR(7) = NULL
) AS
BEGIN
   BEGIN TRY
      SET NOCOUNT ON

      DECLARE 
         @MsgErro VARCHAR(255), 
         @idTransacao INT, 
         @CodigoRetorno INT

      IF @Placa IS NULL OR @Placa = 'N/PLACA'
        BEGIN
            RAISERROR('Placa não informada', 16, 1)
            
        END

      IF LEN(@Placa) < 7
        BEGIN
            RAISERROR('Placa inválida', 16, 1)
            
        END

      EXEC dbo.stp_Ism_902_EV01
         @Placa = @Placa,
         @idTransacao = @idTransacao OUTPUT

      -- TODO: Selecionar o código de retorno da transação
      
      SELECT 
        @CodigoRetorno = [CodigoRetorno]
      FROM Ism_Transacao
      WHERE idTransacao = @idTransacao

      -- TODO: Se o código de retorno for <> 0, mostrar a mensagem de erro da transação
      
      IF @CodigoRetorno = -999
        BEGIN
            RAISERROR('Transação inválida', 16, 1)
        END

        
        SELECT *
        FROM dbo.fn_Ism_Rev_Consulta_902(@idTransacao)

   
      

      RETURN 0
   END TRY
   BEGIN CATCH
      SET @MsgErro = ERROR_MESSAGE()
      RAISERROR(@MsgErro, 16, 1)

      RETURN 1
   END CATCH
END



