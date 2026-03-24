CREATE OR ALTER FUNCTION [dbo].[fn_Ism_Rev_Consulta_902] (
    @idTransacao INT
)
RETURNS TABLE
AS
RETURN (
    SELECT
        -- Envio (sem dados internos da parte fixa)
        SUBSTRING(MensagemEnvio, 1, 37)   AS inParteFixa,
        SUBSTRING(MensagemEnvio, 38, 7)   AS inPlaca,

        -- Retorno - parte fixa
        SUBSTRING(MensagemRetorno, 1, 37)  AS outParteFixa,

        -- Retorno - código e erro
        SUBSTRING(MensagemRetorno, 38, 3)  AS outCodigoRetorno,
        CASE SUBSTRING(MensagemRetorno, 38, 3)
            WHEN '000' THEN NULL
            WHEN '001' THEN 'Nenhum registro encontrado'
            WHEN '017' THEN 'Veículo não cadastrado e com ocorrência de roubo/furto'
            WHEN '018' THEN 'Veículo não cadastrado e com sinalização de alarme'
            WHEN '019' THEN 'Veículo cadastrado e com sinalização de alarme'
            WHEN '048' THEN 'Veículo cadastrado e com ocorrência de roubo/furto'
            WHEN '056' THEN 'Placa inválida'
            ELSE 'Erro desconhecido'
        END AS outMensagemErro,

        
        SUBSTRING(MensagemRetorno, 41, 21) AS outCodigoIdentificacaoVeiculo,
        SUBSTRING(MensagemRetorno, 62, 7)  AS outPlaca,
        SUBSTRING(MensagemRetorno, 69, 11) AS outRenavam,
        SUBSTRING(MensagemRetorno, 80, 10) AS outSituacaoVeiculo,
        SUBSTRING(MensagemRetorno, 90, 4)  AS outMunicipioEmplacamento,
        SUBSTRING(MensagemRetorno, 94, 2)  AS outUFJurisdicao,
        SUBSTRING(MensagemRetorno, 96, 1)  AS outTipoRemarcacaoChassi,
        SUBSTRING(MensagemRetorno, 97, 13) AS outTipoMontagem,
        SUBSTRING(MensagemRetorno, 110, 2) AS outTipoVeiculo,
        SUBSTRING(MensagemRetorno, 112, 6) AS outMarcaModelo,
        SUBSTRING(MensagemRetorno, 118, 1) AS outEspecieVeiculo,
        SUBSTRING(MensagemRetorno, 119, 3) AS outTipoCarroceria,
        SUBSTRING(MensagemRetorno, 122, 2) AS outCor,
        SUBSTRING(MensagemRetorno, 124, 4) AS outAnoModelo,
        SUBSTRING(MensagemRetorno, 128, 4) AS outAnoFabricacao,
        SUBSTRING(MensagemRetorno, 132, 3) AS outPotencia,
        SUBSTRING(MensagemRetorno, 135, 4) AS outCilindradas,
        SUBSTRING(MensagemRetorno, 139, 2) AS outCombustivel,
        SUBSTRING(MensagemRetorno, 141, 21) AS outNumeroMotor,
        SUBSTRING(MensagemRetorno, 162, 5) AS outCMT,
        SUBSTRING(MensagemRetorno, 167, 5) AS outPBT,
        SUBSTRING(MensagemRetorno, 172, 5) AS outCapacidadeCarga,
        SUBSTRING(MensagemRetorno, 177, 11) AS outProcedencia,
        SUBSTRING(MensagemRetorno, 188, 21) AS outNumeroCaixaCambio,
        SUBSTRING(MensagemRetorno, 209, 1) AS outTipoDocProprietario,
        SUBSTRING(MensagemRetorno, 210, 14) AS outNumeroIdentProprietario,
        SUBSTRING(MensagemRetorno, 224, 21) AS outNumeroCarroceria,
        SUBSTRING(MensagemRetorno, 245, 3) AS outCapacidadePassageiros,
        SUBSTRING(MensagemRetorno, 248, 2) AS outRestricao1,
        SUBSTRING(MensagemRetorno, 250, 2) AS outRestricao2,
        SUBSTRING(MensagemRetorno, 252, 2) AS outRestricao3,
        SUBSTRING(MensagemRetorno, 254, 2) AS outRestricao4,
        SUBSTRING(MensagemRetorno, 256, 2) AS outNumeroEixos,
        SUBSTRING(MensagemRetorno, 258, 21) AS outNumeroEixoTraseiro,
        SUBSTRING(MensagemRetorno, 279, 21) AS outNumeroEixoAuxiliar,
        SUBSTRING(MensagemRetorno, 300, 1) AS outTipoDocumentoImportador,
        SUBSTRING(MensagemRetorno, 301, 14) AS outNumeroIdentificacaoImportador,
        SUBSTRING(MensagemRetorno, 315, 7) AS outCodigoOrgaoRFB,
        SUBSTRING(MensagemRetorno, 322, 5) AS outNumeroREDA,
        SUBSTRING(MensagemRetorno, 327, 10) AS outNumeroDI,
        SUBSTRING(MensagemRetorno, 337, 8) AS outDataRegistroDI,
        SUBSTRING(MensagemRetorno, 345, 1) AS outTipoDocumentoFaturado,
        SUBSTRING(MensagemRetorno, 346, 14) AS outNumeroIdentificacaoFaturado,
        SUBSTRING(MensagemRetorno, 360, 2) AS outUfDestinoFaturamento,
        SUBSTRING(MensagemRetorno, 362, 8) AS outDataLimiteRestricaoTributaria,
        SUBSTRING(MensagemRetorno, 370, 8) AS outDataUltimaAtualizacao,
        SUBSTRING(MensagemRetorno, 378, 2) AS outTipoOperacaoImportacaoVeiculo,
        SUBSTRING(MensagemRetorno, 380, 15) AS outNumeroProcessoImportacao,
        SUBSTRING(MensagemRetorno, 395, 8) AS outDataBaixaTransfOutroPais,
        SUBSTRING(MensagemRetorno, 403, 5) AS outCodigoPaisTransf,
        SUBSTRING(MensagemRetorno, 408, 1) AS outIndicadorMultaExigivelRENAINF,
        SUBSTRING(MensagemRetorno, 409, 1) AS outIndicadorComunicacaoVenda,
        SUBSTRING(MensagemRetorno, 410, 1) AS outIndicadorPendenciaEmissao,
        SUBSTRING(MensagemRetorno, 411, 1) AS outIndicadorRestricaoRENAJUD,
        SUBSTRING(MensagemRetorno, 412, 2) AS outIndicadorOcorrenciaRecall1,
        SUBSTRING(MensagemRetorno, 414, 2) AS outIndicadorOcorrenciaRecall2,
        SUBSTRING(MensagemRetorno, 416, 2) AS outIndicadorOcorrenciaRecall3,
        SUBSTRING(MensagemRetorno, 418, 2) AS outIndicadorRecallMontadora,
        SUBSTRING(MensagemRetorno, 420, 2) AS outCodigoCategoriaVeiculoMRE,
        SUBSTRING(MensagemRetorno, 422, 1) AS outTipoDocProprietarioIndicado,
        SUBSTRING(MensagemRetorno, 423, 14) AS outNumeroDocPropietarioIndicado,
        SUBSTRING(MensagemRetorno, 437, 8) AS outDataUltimaAtualizacaoMRE,
        SUBSTRING(MensagemRetorno, 445, 1) AS outIndicadorEmplacamentoEletronico,
        SUBSTRING(MensagemRetorno, 446, 1) AS outOrigemIndicacaoPropiedade,
        SUBSTRING(MensagemRetorno, 447, 1) AS outIndicadorRestricaoRBF,
        SUBSTRING(MensagemRetorno, 448, 1) AS outIndicadorPlacaVeicular,
        SUBSTRING(MensagemRetorno, 449, 2) AS outIndicadorRestricoes,
        MensagemEnvio,
        MensagemRetorno

    FROM Ism_Transacao
    WHERE idTransacao = @idTransacao
)