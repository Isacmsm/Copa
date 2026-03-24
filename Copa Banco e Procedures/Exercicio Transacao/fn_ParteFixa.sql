CREATE OR ALTER FUNCTION [dbo].[fn_ParteFixa] (
   @CodigoTransacao VARCHAR(3),
   @TamanhoTransacao INT
)
RETURNS VARCHAR(37)
AS
BEGIN
   -- TODO: Implementar lógica de retorno da parte fixa
   DECLARE @NumSeqTran VARCHAR(6) = NULL, @idTran INT = NULL, @Quantidade INT = NULL, 
   @QuantidadeReplica INT = NULL, @CodCliente VARCHAR(11) = NULL, @DiaJuliano INT = NULL

   SELECT @idTran = ISNULL(MAX(idTransacao), 0) + 1 FROM Ism_Transacao
   SET @Quantidade = 6
   SET @QuantidadeReplica = @QUANTIDADE - LEN(@idTran)
   SET @NumSeqTran = CONCAT(REPLICATE ('0', @QuantidadeReplica), CAST(@idTran AS VARCHAR))
   

   SET @Quantidade = 11
   SET @QuantidadeReplica = @QUANTIDADE - LEN('1234')
   SET @CodCliente = CONCAT('1234', REPLICATE ('0', @QuantidadeReplica))

   SET @TamanhoTransacao = @TamanhoTransacao + 37

   SELECT @DiaJuliano =  DATEPART(dayofyear, GETDATE()) 



   RETURN CONCAT(
   @NumSeqTran,
   @CodigoTransacao,
   '4',
   @CodCliente,
   'RN',
   'RN',
   'BR',
   '1',
   RIGHT('0000' + CAST(@TamanhoTransacao AS VARCHAR), 4),
   '00',
   RIGHT('000' + CAST(@DiaJuliano AS VARCHAR), 3)
   )
END



