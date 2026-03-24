CREATE PROCEDURE [dbo].[stp_Ism_Despachante] (
    @CodigoTransacao INT,
    @MensagemEnvio VARCHAR(1000),
    @idTransacao INTEGER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    DECLARE 
        @ParteFixa VARCHAR(37),
        @StatusTransacao INT, 
        @CodigoRetorno INT, 
        @MensagemRetorno VARCHAR(1000)

	IF @CodigoTransacao NOT IN (902)
	BEGIN
		RAISERROR('Transação não implementada', 16, 1, @CodigoTransacao)
	END
    
    -- TODO: Adicionar lógica de montagem da parte fixa
    SET @MensagemEnvio = dbo.fn_ParteFixa(@CodigoTransacao, LEN(@MensagemEnvio)) + @MensagemEnvio

    INSERT INTO Ism_Transacao (
        CodigoTransacao, 
        MensagemEnvio) 
    VALUES (
        @CodigoTransacao,
        @MensagemEnvio)

    SET @IdTransacao = SCOPE_IDENTITY()

    EXECUTE @StatusTransacao = [dbo].[stp_Ism_Bin] 
        @MensagemEnvio = @MensagemEnvio,
        @MensagemRetorno = @MensagemRetorno OUTPUT

    IF @StatusTransacao < 0
    BEGIN
        SET @CodigoRetorno = -999
    END
    ELSE
    BEGIN
        SET @CodigoRetorno = SUBSTRING(@MensagemRetorno, 38, 3)
    END

    UPDATE Ism_Transacao SET 
        MensagemRetorno = @MensagemRetorno, 
        StatusTransacao = @StatusTransacao, 
        CodigoRetorno = @CodigoRetorno
    WHERE idTransacao = @idTransacao

    RETURN 0
END



