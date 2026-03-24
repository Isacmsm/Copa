CREATE PROCEDURE [dbo].[stp_Ism_902_EV01] (
   @Placa VARCHAR(7),
   @IdTransacao INT = NULL OUTPUT
)
AS
BEGIN
   SET NOCOUNT ON
   SET XACT_ABORT ON

   DECLARE @MensagemEnvio VARCHAR(1000)
      
   -- TODO: Montar EV01 - sem a parte fixa
   SET @MensagemEnvio = @Placa

   -- Transmite:
   EXEC dbo.stp_Ism_Despachante
      902,
      @MensagemEnvio,
      @IdTransacao OUTPUT
END



