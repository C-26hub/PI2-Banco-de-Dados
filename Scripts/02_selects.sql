-- 1. Todos os usuários (tabela Usuarios)
SELECT idUsuario, CPF, nome, sobrenome, email, status, nivelAcesso
FROM Usuarios;

-- 2. Beneficiários + usuário (Gestor/Técnico) responsável
SELECT b.idBeneficiario, b.nome AS nome_ben, b.sobrenome AS sobrenome_ben,
       b.CPF AS CPF_ben, b.telefone, b.associacao,
       u.idUsuario, u.nome AS nome_usuario, u.sobrenome AS sobrenome_usuario
FROM Beneficiarios b
JOIN Usuarios u ON b.Usuarios_idUsuario = u.idUsuario;

-- 3. Entregas pendentes (JOIN em Beneficiarios e Lote)
SELECT e.idEntrega, e.status, e.quantidadeEntregue, e.dataEntrega,
       b.idBeneficiario, b.nome, b.sobrenome,
       l.idLote, l.tipoSemente
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
JOIN Lote l ON e.Lote_idLote = l.idLote
WHERE e.status = 'Pendente';

-- 4. Total de unidades entregues por lote
SELECT l.idLote, l.tipoSemente, SUM(e.quantidadeEntregue) AS totalEntregue
FROM Lote l
LEFT JOIN Entrega e ON l.idLote = e.Lote_idLote
GROUP BY l.idLote, l.tipoSemente;

-- 5. Lotes em Planejamento ou Distribuição
SELECT idLote, tipoSemente, quantidadekg, status, dataAquisicao, origem
FROM Lote
WHERE status IN ('Planejamento','Distribuição')
ORDER BY dataAquisicao DESC;

-- 6. Beneficiários que nunca receberam entregas
SELECT b.idBeneficiario, b.nome, b.sobrenome, b.CPF
FROM Beneficiarios b
WHERE NOT EXISTS (
  SELECT 1 FROM Entrega e WHERE e.Beneficiarios_idBeneficiario = b.idBeneficiario
);

-- 7. Usuários e quantas observações cada um registrou (mostrar > 0)
SELECT u.idUsuario, u.nome, u.sobrenome, COUNT(o.idObservacao) AS totalObservacoes
FROM Usuarios u
LEFT JOIN Observacao o ON u.idUsuario = o.Usuarios_idUsuario
GROUP BY u.idUsuario, u.nome, u.sobrenome
HAVING COUNT(o.idObservacao) > 0
ORDER BY totalObservacoes DESC;

-- 8. Última data de entrega por beneficiário (correlated subquery)
SELECT b.idBeneficiario, b.nome, b.sobrenome,
       (
         SELECT MAX(e2.dataEntrega)
         FROM Entrega e2
         WHERE e2.Beneficiarios_idBeneficiario = b.idBeneficiario
       ) AS ultimaEntrega
FROM Beneficiarios b;

-- 9. Top 5 beneficiários por soma de quantidadeEntregue
SELECT b.idBeneficiario, b.nome, b.sobrenome, SUM(e.quantidadeEntregue) AS somaQtd
FROM Beneficiarios b
JOIN Entrega e ON b.idBeneficiario = e.Beneficiarios_idBeneficiario
GROUP BY b.idBeneficiario, b.nome, b.sobrenome
ORDER BY somaQtd DESC
LIMIT 5;

-- 10. Lote(s) com maior quantidadekg
SELECT l.idLote, l.tipoSemente, l.quantidadekg
FROM Lote l
WHERE l.quantidadekg = (SELECT MAX(quantidadekg) FROM Lote);

-- 11. Relatório detalhado: entrega + beneficiário + endereço + lote
SELECT e.idEntrega, e.dataEntrega, e.quantidadeEntregue, e.status AS statusEntrega,
       b.idBeneficiario, b.nome AS nome_ben, b.sobrenome AS sobrenome_ben, b.CPF,
       addr.rua, addr.cidade, addr.estado, addr.CEP,
       l.idLote, l.tipoSemente
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
LEFT JOIN Endereco addr ON addr.Beneficiarios_idBeneficiario = b.idBeneficiario
LEFT JOIN Lote l ON e.Lote_idLote = l.idLote
ORDER BY e.dataEntrega DESC;

-- 12. Média de quantidade entregue por lote (considera apenas entregas existentes)
SELECT l.idLote, l.tipoSemente, AVG(e.quantidadeEntregue) AS mediaEntregue
FROM Lote l
JOIN Entrega e ON l.idLote = e.Lote_idLote
GROUP BY l.idLote, l.tipoSemente;

-- 13. Entregas realizadas nos últimos 30 dias
SELECT e.idEntrega, e.dataEntrega, e.quantidadeEntregue, b.nome, b.sobrenome
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
WHERE e.dataEntrega >= (NOW() - INTERVAL 30 DAY)
ORDER BY e.dataEntrega DESC;

-- 14. Quantidade de beneficiários por cidade
SELECT addr.cidade, COUNT(b.idBeneficiario) AS totalBeneficiarios
FROM Beneficiarios b
LEFT JOIN Endereco addr ON b.idBeneficiario = addr.Beneficiarios_idBeneficiario
GROUP BY addr.cidade
ORDER BY totalBeneficiarios DESC;

-- 15. Entregas referenciando lote inexistente (deveria retornar 0)
SELECT e.*
FROM Entrega e
LEFT JOIN Lote l ON e.Lote_idLote = l.idLote
WHERE l.idLote IS NULL;

-- 16. Total entregue por mês/ano
SELECT DATE_FORMAT(e.dataEntrega, '%Y-%m') AS mes_ano, SUM(e.quantidadeEntregue) AS totalMes
FROM Entrega e
GROUP BY mes_ano
ORDER BY mes_ano DESC;

-- 17. Beneficiários cuja soma de entregas é maior que a média soma de entregas entre beneficiários
SELECT b.idBeneficiario, b.nome, b.sobrenome, SUM(e.quantidadeEntregue) AS somaEntregas
FROM Beneficiarios b
JOIN Entrega e ON b.idBeneficiario = e.Beneficiarios_idBeneficiario
GROUP BY b.idBeneficiario, b.nome, b.sobrenome
HAVING SUM(e.quantidadeEntregue) > (
  SELECT AVG(sub.total)
  FROM (
    SELECT SUM(e2.quantidadeEntregue) AS total
    FROM Entrega e2
    GROUP BY e2.Beneficiarios_idBeneficiario
  ) AS sub
);

-- 18. Última observação por usuário usando ROW_NUMBER()
SELECT idUsuario, descricao, dataHora
FROM (
  SELECT u.idUsuario, o.descricao, o.dataHora,
         ROW_NUMBER() OVER (PARTITION BY u.idUsuario ORDER BY o.dataHora DESC) AS rn
  FROM Usuarios u
  LEFT JOIN Observacao o ON u.idUsuario = o.Usuarios_idUsuario
) t
WHERE rn = 1;

-- 19. Entregas com categoria de tamanho (pequena/média/grande) e texto de status
SELECT e.idEntrega, b.nome AS beneficiario, l.tipoSemente,
       e.quantidadeEntregue,
       CASE
         WHEN e.quantidadeEntregue <= 5 THEN 'Pequena'
         WHEN e.quantidadeEntregue <= 15 THEN 'Média'
         ELSE 'Grande'
       END AS categoriaEntrega,
       CASE e.status WHEN 'Concluído' THEN 'OK' WHEN 'Pendente' THEN 'Aguardando' ELSE e.status END AS status_legivel
FROM Entrega e
JOIN Beneficiarios b ON e.Beneficiarios_idBeneficiario = b.idBeneficiario
JOIN Lote l ON e.Lote_idLote = l.idLote;

-- 20. União de pessoas — usuários e beneficiários (mesma estrutura de colunas)
SELECT idUsuario AS idPessoa, nome, sobrenome, 'Usuario' AS tipoPessoa, email AS contato
FROM Usuarios
UNION
SELECT idBeneficiario AS idPessoa, nome, sobrenome, 'Beneficiario' AS tipoPessoa, NULL AS contato
FROM Beneficiarios;
