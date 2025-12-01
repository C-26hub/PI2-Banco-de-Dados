-- 1) View com beneficiários e seus usuários responsáveis
CREATE OR REPLACE VIEW vw_beneficiarios_usuarios AS
SELECT 
    b.idBeneficiario, b.nome AS nomeBeneficiario, b.sobrenome AS sobrenomeBeneficiario,
    b.CPF, b.status AS statusBeneficiario, b.associacao,
    u.idUsuario, u.nome AS nomeUsuario, u.sobrenome AS sobrenomeUsuario, u.nivelAcesso
FROM Beneficiarios b
JOIN Usuarios u ON b.Usuarios_idUsuario = u.idUsuario;

-- 2) Relatório completo de entregas
CREATE OR REPLACE VIEW vw_entregas_completas AS
SELECT 
    e.idEntrega, e.status AS statusEntrega, e.quantidadeEntregue, e.dataEntrega,
    b.idBeneficiario, b.nome AS nomeBeneficiario, b.sobrenome, b.CPF,
    l.idLote, l.tipoSemente, l.origem, l.status AS statusLote
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
JOIN Lote l ON e.Lote_idLote = l.idLote;

-- 3) Beneficiários que nunca receberam nenhuma entrega
CREATE OR REPLACE VIEW vw_beneficiarios_sem_entrega AS
SELECT 
    b.idBeneficiario, b.nome, b.sobrenome, b.CPF
FROM Beneficiarios b
WHERE NOT EXISTS (
    SELECT 1 FROM Entrega e 
    WHERE e.Beneficiarios_idBeneficiario = b.idBeneficiario
);

-- 4) Total entregue por lote
CREATE OR REPLACE VIEW vw_total_por_lote AS
SELECT 
    l.idLote, l.tipoSemente, 
    COALESCE(SUM(e.quantidadeEntregue), 0) AS totalEntregue
FROM Lote l
LEFT JOIN Entrega e ON l.idLote = e.Lote_idLote
GROUP BY l.idLote, l.tipoSemente;

-- 5) Entregas com endereço do beneficiário
CREATE OR REPLACE VIEW vw_entregas_endereco AS
SELECT 
    e.idEntrega, e.dataEntrega, e.quantidadeEntregue, 
    b.idBeneficiario, b.nome AS nomeBeneficiario, b.CPF,
    addr.rua, addr.cidade, addr.estado, addr.CEP,
    l.idLote, l.tipoSemente
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
LEFT JOIN Endereco addr ON addr.Beneficiarios_idBeneficiario = b.idBeneficiario
JOIN Lote l ON e.Lote_idLote = l.idLote;

-- 6) Última entrega de cada beneficiário
CREATE OR REPLACE VIEW vw_ultima_entrega_beneficiario AS
SELECT 
    b.idBeneficiario, b.nome, b.sobrenome,
    (
        SELECT MAX(e2.dataEntrega)
        FROM Entrega e2 
        WHERE e2.Beneficiarios_idBeneficiario = b.idBeneficiario
    ) AS ultimaEntrega
FROM Beneficiarios b;

-- 7) Última observação registrada por cada usuário
CREATE OR REPLACE VIEW vw_ultima_observacao_usuario AS
SELECT idUsuario, descricao, dataHora
FROM (
    SELECT 
        u.idUsuario, o.descricao, o.dataHora,
        ROW_NUMBER() OVER (PARTITION BY u.idUsuario ORDER BY o.dataHora DESC) AS rn
    FROM Usuarios u
    LEFT JOIN Observacao o ON u.idUsuario = o.Usuarios_idUsuario
) t
WHERE rn = 1;

-- 8) Quantidade de beneficiários por cidade
CREATE OR REPLACE VIEW vw_beneficiarios_por_cidade AS
SELECT 
    addr.cidade, 
    COUNT(b.idBeneficiario) AS totalBeneficiarios
FROM Beneficiarios b
LEFT JOIN Endereco addr 
    ON b.idBeneficiario = addr.Beneficiarios_idBeneficiario
GROUP BY addr.cidade;

-- 9) Entregas categorizadas
CREATE OR REPLACE VIEW vw_entregas_categorizadas AS
SELECT 
    e.idEntrega, b.nome AS beneficiario, l.tipoSemente,
    e.quantidadeEntregue,
    CASE
        WHEN e.quantidadeEntregue <= 5 THEN 'Pequena'
        WHEN e.quantidadeEntregue <= 15 THEN 'Média'
        ELSE 'Grande'
    END AS categoriaEntrega,
    e.status
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
JOIN Lote l ON e.Lote_idLote = l.idLote;

-- 10) União de usuários e beneficiários
CREATE OR REPLACE VIEW vw_todas_as_pessoas AS
SELECT 
    idUsuario AS idPessoa, nome, sobrenome, 'Usuario' AS tipo, email AS contato
FROM Usuarios
UNION
SELECT 
    idBeneficiario AS idPessoa, nome, sobrenome, 'Beneficiario' AS tipo, NULL AS contato
FROM Beneficiarios;
