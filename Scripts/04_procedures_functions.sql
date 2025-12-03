-- =================================================================
-- DEFINIÇÃO DO DELIMITADOR
-- =================================================================
DELIMITER $$

-- =================================================================
-- PROCEDURES (SP) - DML e Relatórios
-- =================================================================

-- 1. SP_InserirNovoUsuario (DML - INSERT)
-- Insere um novo usuário.
DROP PROCEDURE IF EXISTS SP_InserirNovoUsuario$$
CREATE PROCEDURE SP_InserirNovoUsuario(
    IN p_idUsuario INT,
    IN p_CPF VARCHAR(14),
    IN p_nome VARCHAR(45),
    IN p_sobrenome VARCHAR(45),
    IN p_email VARCHAR(45),
    IN p_status ENUM("Ativo", "Inativo"),
    IN p_senha VARCHAR(45),
    IN p_nivelAcesso ENUM("Gestor", "Técnico")
)
BEGIN
    INSERT INTO Usuarios (idUsuario, CPF, nome, sobrenome, email, status, senha, nivelAcesso)
    VALUES (p_idUsuario, p_CPF, p_nome, p_sobrenome, p_email, p_status, p_senha, p_nivelAcesso);
    
    SELECT 'Usuário inserido com sucesso!' AS Mensagem;
END$$

-- 2. SP_AtualizarStatusBeneficiario (DML - UPDATE)
-- Atualiza o status de um beneficiário.
DROP PROCEDURE IF EXISTS SP_AtualizarStatusBeneficiario$$
CREATE PROCEDURE SP_AtualizarStatusBeneficiario(
    IN p_idBeneficiario INT,
    IN p_novoStatus ENUM("Ativo", "Inativo")
)
BEGIN
    UPDATE Beneficiarios
    SET status = p_novoStatus
    WHERE idBeneficiario = p_idBeneficiario;
    
    SELECT CONCAT('Status do Beneficiário ', p_idBeneficiario, ' atualizado para ', p_novoStatus) AS Mensagem;
END$$

-- 3. SP_RegistrarEntrega (DML - INSERT)
-- Registra uma nova entrega.
DROP PROCEDURE IF EXISTS SP_RegistrarEntrega$$
CREATE PROCEDURE SP_RegistrarEntrega(
    IN p_idEntrega INT,
    IN p_status ENUM("Concluído", "Pendente"),
    IN p_quantidadeEntregue INT,
    IN p_dataEntrega DATETIME,
    IN p_dataConfirmacao DATETIME,
    IN p_Beneficiarios_idBeneficiario INT,
    IN p_Lote_idLote INT
)
BEGIN
    INSERT INTO Entrega (idEntrega, status, quantidadeEntregue, dataEntrega, fotoComprovante, dataConfirmacao, Beneficiarios_idBeneficiario, Lote_idLote)
    VALUES (p_idEntrega, p_status, p_quantidadeEntregue, p_dataEntrega, 0x01, p_dataConfirmacao, p_Beneficiarios_idBeneficiario, p_Lote_idLote);
    
    SELECT 'Entrega registrada com sucesso!' AS Mensagem;
END$$

-- 4. SP_BuscarLotesPorStatus (Relatório - SELECT)
-- Busca todos os lotes com um status específico.
DROP PROCEDURE IF EXISTS SP_BuscarLotesPorStatus$$
CREATE PROCEDURE SP_BuscarLotesPorStatus(
    IN p_status ENUM("Distribuição", "Concluído", "Planejamento")
)
BEGIN
    SELECT idLote, tipoSemente, quantidadekg, dataAquisicao, origem
    FROM Lote
    WHERE status = p_status
    ORDER BY dataAquisicao DESC;
END$$

-- 5. SP_RelatorioEntregasPendentes (Relatório - SELECT com JOIN)
-- Lista entregas pendentes com detalhes do beneficiário e lote.
DROP PROCEDURE IF EXISTS SP_RelatorioEntregasPendentes$$
CREATE PROCEDURE SP_RelatorioEntregasPendentes()
BEGIN
    SELECT 
        e.idEntrega, e.dataEntrega, e.quantidadeEntregue,
        b.nome AS nome_beneficiario, b.sobrenome AS sobrenome_beneficiario,
        l.tipoSemente
    FROM Entrega e
    JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
    JOIN Lote l ON e.Lote_idLote = l.idLote
    WHERE e.status = 'Pendente';
END$$

-- 6. SP_ContarBeneficiariosPorCidade (Relatório - Agregação)
-- Conta quantos beneficiários estão em uma cidade específica.
DROP PROCEDURE IF EXISTS SP_ContarBeneficiariosPorCidade$$
CREATE PROCEDURE SP_ContarBeneficiariosPorCidade(
    IN p_cidade VARCHAR(45)
)
BEGIN
    SELECT 
        COUNT(b.idBeneficiario) AS totalBeneficiarios
    FROM Beneficiarios b
    JOIN Endereco addr ON b.idBeneficiario = addr.Beneficiarios_idBeneficiario
    WHERE addr.cidade = p_cidade;
END$$

-- 7. SP_DeletarObservacaoAntiga (DML - DELETE)
-- Deleta observações mais antigas que um número de dias.
DROP PROCEDURE IF EXISTS SP_DeletarObservacaoAntiga$$
CREATE PROCEDURE SP_DeletarObservacaoAntiga(
    IN p_dias INT
)
BEGIN
    DECLARE v_old_safe_updates INT;

    -- Guarda configuração atual de safe updates desta sessão
    SET v_old_safe_updates = @@SQL_SAFE_UPDATES;
    -- Desliga safe updates só dentro desta procedure
    SET SQL_SAFE_UPDATES = 0;

    DELETE FROM Observacao
    WHERE dataHora < (NOW() - INTERVAL p_dias DAY);

    -- Restaura configuração original de safe updates
    SET SQL_SAFE_UPDATES = v_old_safe_updates;

    SELECT CONCAT('Observações mais antigas que ', p_dias, ' dias deletadas.') AS Mensagem;
END$$

-- 8. SP_BuscarUsuarioPorEmail (SELECT Simples)
-- Busca um usuário pelo email.
DROP PROCEDURE IF EXISTS SP_BuscarUsuarioPorEmail$$
CREATE PROCEDURE SP_BuscarUsuarioPorEmail(
    IN p_email VARCHAR(45)
)
BEGIN
    SELECT idUsuario, nome, sobrenome, nivelAcesso
    FROM Usuarios
    WHERE email = p_email;
END$$

-- =================================================================
-- FUNÇÕES (FN) - Cálculos e Retorno Simples
-- =================================================================

-- 9. FN_CalcularTotalEntregueLote (Função - Cálculo)
-- Retorna a quantidade total entregue para um lote.
DROP FUNCTION IF EXISTS FN_CalcularTotalEntregueLote$$
CREATE FUNCTION FN_CalcularTotalEntregueLote(
    p_idLote INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    
    SELECT COALESCE(SUM(quantidadeEntregue), 0) INTO total
    FROM Entrega
    WHERE Lote_idLote = p_idLote;
    
    RETURN total;
END$$

-- 10. FN_VerificarStatusAtivoUsuario (Função - Booleana)
-- Retorna 1 se o usuário estiver 'Ativo', 0 caso contrário.
DROP FUNCTION IF EXISTS FN_VerificarStatusAtivoUsuario$$
CREATE FUNCTION FN_VerificarStatusAtivoUsuario(
    p_idUsuario INT
)
RETURNS TINYINT
READS SQL DATA
BEGIN
    DECLARE status_ativo TINYINT;
    
    SELECT CASE WHEN status = 'Ativo' THEN 1 ELSE 0 END INTO status_ativo
    FROM Usuarios
    WHERE idUsuario = p_idUsuario;
    
    RETURN status_ativo;
END$$

-- 11. FN_ContarEntregasBeneficiario (Função - Contagem)
-- Retorna o número total de entregas para um beneficiário.
DROP FUNCTION IF EXISTS FN_ContarEntregasBeneficiario$$
CREATE FUNCTION FN_ContarEntregasBeneficiario(
    p_idBeneficiario INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_entregas INT;
    
    SELECT COUNT(idEntrega) INTO total_entregas
    FROM Entrega
    WHERE Beneficiarios_idBeneficiario = p_idBeneficiario;
    
    RETURN total_entregas;
END$$

-- 12. FN_ObterNomeCompletoUsuario (Função - String)
-- Retorna o nome completo do usuário (Nome + Sobrenome).
DROP FUNCTION IF EXISTS FN_ObterNomeCompletoUsuario$$
CREATE FUNCTION FN_ObterNomeCompletoUsuario(
    p_idUsuario INT
)
RETURNS VARCHAR(91) -- 45 + 45 + 1 (espaço)
READS SQL DATA
BEGIN
    DECLARE nome_completo VARCHAR(91);
    
    SELECT CONCAT(nome, ' ', sobrenome) INTO nome_completo
    FROM Usuarios
    WHERE idUsuario = p_idUsuario;
    
    RETURN nome_completo;
END$$

-- 13. FN_CalcularMediaEntregueLote (Função - Cálculo)
-- Retorna a média de quantidade entregue por entrega para um lote.
DROP FUNCTION IF EXISTS FN_CalcularMediaEntregueLote$$
CREATE FUNCTION FN_CalcularMediaEntregueLote(
    p_idLote INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE media DECIMAL(10,2);
    
    SELECT COALESCE(AVG(quantidadeEntregue), 0.00) INTO media
    FROM Entrega
    WHERE Lote_idLote = p_idLote;
    
    RETURN media;
END$$

-- 14. FN_ObterCEPBeneficiario (Função - Simples)
-- Retorna o CEP do beneficiário.
DROP FUNCTION IF EXISTS FN_ObterCEPBeneficiario$$
CREATE FUNCTION FN_ObterCEPBeneficiario(
    p_idBeneficiario INT
)
RETURNS VARCHAR(9)
READS SQL DATA
BEGIN
    DECLARE cep_beneficiario VARCHAR(9);
    
    SELECT CEP INTO cep_beneficiario
    FROM Endereco
    WHERE Beneficiarios_idBeneficiario = p_idBeneficiario;
    
    RETURN cep_beneficiario;
END$$

DELIMITER ;
