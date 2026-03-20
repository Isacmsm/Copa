USE [dbTreinamento]
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- Autor: Isac Macedo
-- Data criação: 05/02/2026
-- Descrição: Alterar Registros da Tabela Ism_Jogador
-- ============================================


CREATE OR ALTER PROCEDURE [dbo].[stp_Ism_Jogador_Upt] (
    @Tipo        INT  = NULL,
    @IdJogador   INT  = NULL,
    @IdTime      INT  = NULL,
    @Nome        VARCHAR(50) = NULL,
    @Salario     MONEY = NULL,
    @IdCapitao   INT  = NULL,
    @IdTecnico   INT  = NULL,
    @IdsSuspensos VARCHAR(MAX) = NULL
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON
        DECLARE @MsgErro VARCHAR(255), @Erro BIT

        -- ===========================
        -- Tipo 1: Update individual
        -- ===========================
        IF @Tipo = 1
        BEGIN
            IF @Salario IS NULL
            BEGIN
                RAISERROR(50001, 10, 1, 'salario', 'O salario não pode ser vazio!')
                SET @Erro = 1
            END
            IF @IdTime IS NULL
            BEGIN
                RAISERROR(50001, 10, 1, 'idtime', 'Selecione o time do Jogador')
                SET @Erro = 1
            END
            IF NULLIF(TRIM(@Nome), '') IS NULL
            BEGIN
                RAISERROR(50001, 10, 1, 'nome', 'O nome do jogador não pode estar vazio')
                SET @Erro = 1
            END
            IF ISNUMERIC(@Nome) = 1
            BEGIN
                RAISERROR(50001, 10, 1, 'nome', 'O nome do time não pode ser numérico')
                SET @Erro = 1
            END
            IF LEN(@Nome) < 3
            BEGIN
                RAISERROR(50001, 10, 1, 'nome', 'O nome do time ter menos que 3 caracteres')
                SET @Erro = 1
            END
            IF @Salario < 0
            BEGIN
                RAISERROR(50001, 10, 1, 'salario', 'O salario nao pode ser menor que 0')
                SET @Erro = 1
            END
            IF @Erro = 1 RETURN 1

            IF NOT EXISTS (SELECT IdTime FROM Ism_Time WHERE IdTime = @IdTime)
            BEGIN
                RAISERROR('Esse ID de time não existe', 16, 1)
            END
            IF NOT EXISTS (SELECT IdJogador FROM Ism_Jogador WHERE IdJogador = @IdJogador)
            BEGIN
                RAISERROR('Operação cancelada. Não foi possivel identificar o Jogador informado pelo ID %d', 16, 1, @IdJogador)
            END
            IF EXISTS (
                SELECT Nome FROM Ism_Jogador
                WHERE Nome = @Nome AND IdTime = @IdTime AND IdJogador != @IdJogador
            )
            BEGIN
                RAISERROR('Operação cancelada. Ja existe um jogador com o Nome %s no Time de ID %d', 16, 1, @Nome, @IdJogador)
            END

            UPDATE Ism_Jogador SET
                IdTime  = @IdTime,
                Nome    = @Nome,
                Salario = @Salario
            WHERE IdJogador = @IdJogador
        END

        -- ===========================
        -- Tipo 2: Update EditAll
        -- ===========================
        IF @Tipo = 2
        BEGIN
            IF @IdTime IS NULL
            BEGIN
                RAISERROR('Selecione um time', 16, 1)
            END

            IF NOT EXISTS (SELECT IdTime FROM Ism_Time WHERE IdTime = @IdTime)
            BEGIN
                RAISERROR('Esse ID de time não existe', 16, 1)
            END

            IF NOT EXISTS 
            (SELECT 
                IdJogador 
                FROM Ism_Jogador 
                WHERE IdJogador = @IdCapitao OR idJogador = @IdTecnico)
            BEGIN
                RAISERROR('Operação cancelada. Não foi possivel identificar  o id do tecnico e capitao', 16, 1, @IdJogador)
            END

             IF EXISTS (
                SELECT 1 FROM Ism_Jogador 
                WHERE IdJogador = @IdCapitao AND IdJogador = @IdTecnico
            )
            BEGIN
                RAISERROR('O capitão e o técnico não podem ser o mesmo jogador', 16, 1)
            END

            BEGIN TRANSACTION
            UPDATE Ism_Jogador SET
                Capitao  = 0,
                Tecnico  = 0,
                Suspenso = 0
            WHERE IdTime = @IdTime

            -- Aplica capitao
            IF @IdCapitao IS NOT NULL
                UPDATE Ism_Jogador SET Capitao = 1 WHERE IdJogador = @IdCapitao

            -- Aplica tecnico
            IF @IdTecnico IS NOT NULL
                UPDATE Ism_Jogador SET Tecnico = 1 WHERE IdJogador = @IdTecnico

            -- Aplica suspensos
            IF NULLIF(TRIM(@IdsSuspensos), '') IS NOT NULL
                UPDATE Ism_Jogador SET Suspenso = 1
                WHERE IdJogador IN (
                    SELECT value FROM STRING_SPLIT(@IdsSuspensos, ',')
                )

            COMMIT TRANSACTION
        END

        RETURN 0
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK

        SET @MsgErro = ERROR_MESSAGE()
        RAISERROR(@MsgErro, 16, 1)
    END CATCH
END