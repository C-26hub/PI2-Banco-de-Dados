-- =================================================================
-- DEFINIÇÃO DO DELIMITADOR
-- =================================================================
DELIMITER $$

-- =================================================================
-- Triggers
-- =================================================================

-- 1. TR_Usuarios_BeforeInsert – Normaliza email em minúsculo
DROP TRIGGER IF EXISTS TR_Usuarios_BeforeInsert$$
CREATE TRIGGER TR_Usuarios_BeforeInsert
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END$$

-- 2. TR_Usuarios_BeforeUpdate – Garante email sempre minúsculo
DROP TRIGGER IF EXISTS TR_Usuarios_BeforeUpdate$$
CREATE TRIGGER TR_Usuarios_BeforeUpdate
BEFORE UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
END$$

-- 3. TR_Beneficiarios_Insert_SetDataRegistro – Define data de cadastro
DROP TRIGGER IF EXISTS TR_Beneficiarios_AfterInsert_LogCriacao$$
CREATE TRIGGER TR_Beneficiarios_AfterInsert_LogCriacao
AFTER INSERT ON Beneficiarios
FOR EACH ROW
BEGIN
    INSERT INTO Observacao (idObservacao, descricao, dataHora, Usuarios_idUsuario)
    VALUES (
        NULL,
        CONCAT('Novo beneficiário cadastrado: ', NEW.nome, ' ', NEW.sobrenome),
        NOW(),
        NEW.Usuarios_idUsuario
    );
END$$

-- 4. TR_Beneficiarios_AfterInsert_AddLog – Cria observação automática
DROP TRIGGER IF EXISTS TR_Beneficiarios_AfterInsert_AddLog$$
CREATE TRIGGER TR_Beneficiarios_AfterInsert_AddLog
AFTER INSERT ON Beneficiarios
FOR EACH ROW
BEGIN
    INSERT INTO Observacao (idObservacao, descricao, dataHora, Usuarios_idUsuario)
    VALUES (
        NULL,
        CONCAT('Novo beneficiário cadastrado: ', NEW.nome, ' ', NEW.sobrenome),
        NOW(),
        NEW.Usuarios_idUsuario
    );
END$$

-- 5. TR_Entrega_BeforeInsert_ValidaQuantidade – Evita entrega negativa
DROP TRIGGER IF EXISTS TR_Entrega_BeforeInsert_ValidaQuantidade$$
CREATE TRIGGER TR_Entrega_BeforeInsert_ValidaQuantidade
BEFORE INSERT ON Entrega
FOR EACH ROW
BEGIN
    IF NEW.quantidadeEntregue < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A quantidade entregue não pode ser negativa.';
    END IF;
END$$

-- 6. TR_Entrega_AfterInsert_AtualizaStatusLote – Atualiza lote automaticamente
DROP TRIGGER IF EXISTS TR_Entrega_AfterInsert_AtualizaStatusLote$$
CREATE TRIGGER TR_Entrega_AfterInsert_AtualizaStatusLote
AFTER INSERT ON Entrega
FOR EACH ROW
BEGIN
    UPDATE Lote
    SET status = 'Distribuição'
    WHERE idLote = NEW.Lote_idLote;
END$$

-- 7. TR_Entrega_BeforeUpdate_ConfirmaData – Preenche dataConfirmacao sem atualizar a própria tabela
DROP TRIGGER IF EXISTS TR_Entrega_BeforeUpdate_ConfirmaData$$
CREATE TRIGGER TR_Entrega_BeforeUpdate_ConfirmaData
BEFORE UPDATE ON Entrega
FOR EACH ROW
BEGIN
    IF NEW.status = 'Concluído' AND OLD.status <> 'Concluído' THEN
        SET NEW.dataConfirmacao = NOW();
    END IF;
END$$

-- 8. TR_Lote_BeforeInsert_ValidaQuantidade – Evita lote negativo
DROP TRIGGER IF EXISTS TR_Lote_BeforeInsert_ValidaQuantidade$$
CREATE TRIGGER TR_Lote_BeforeInsert_ValidaQuantidade
BEFORE INSERT ON Lote
FOR EACH ROW
BEGIN
    IF NEW.quantidadekg <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A quantidade em kg deve ser maior que zero.';
    END IF;
END$$

-- 9. TR_Lote_BeforeUpdate_ValidaStatus – Garante status válido
DROP TRIGGER IF EXISTS TR_Lote_BeforeUpdate_ValidaStatus$$
CREATE TRIGGER TR_Lote_BeforeUpdate_ValidaStatus
BEFORE UPDATE ON Lote
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Distribuição','Concluído','Planejamento') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status inválido para Lote.';
    END IF;
END$$

-- 10. TR_Observacao_BeforeInsert_ImpedirTextoVazio – Evita registro vazio
DROP TRIGGER IF EXISTS TR_Observacao_BeforeInsert_ImpedirTextoVazio$$
CREATE TRIGGER TR_Observacao_BeforeInsert_ImpedirTextoVazio
BEFORE INSERT ON Observacao
FOR EACH ROW
BEGIN
    IF TRIM(NEW.descricao) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido inserir uma observação vazia.';
    END IF;
END$$

-- 11. TR_Endereco_BeforeInsert_NormalizaCEP – Formata CEP
DROP TRIGGER IF EXISTS TR_Endereco_BeforeInsert_NormalizaCEP$$
CREATE TRIGGER TR_Endereco_BeforeInsert_NormalizaCEP
BEFORE INSERT ON Endereco
FOR EACH ROW
BEGIN
    SET NEW.CEP = REPLACE(NEW.CEP, '-', '');
END$$

-- 12. TR_Endereco_BeforeInsert_NormalizaCEP – Formata CEP
DROP TRIGGER IF EXISTS TR_Usuarios_AfterUpdate_LogMudancaStatus$$
CREATE TRIGGER TR_Usuarios_AfterUpdate_LogMudancaStatus
AFTER UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status THEN
        INSERT INTO Observacao (idObservacao, descricao, dataHora, Usuarios_idUsuario)
        VALUES (
            NULL,
            CONCAT('Status do usuário ', NEW.nome, ' alterado para ', NEW.status),
            NOW(),
            NEW.idUsuario
        );
    END IF;
END$$

DELIMITER ;
