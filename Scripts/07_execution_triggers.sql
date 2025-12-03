-- TESTES DE TRIGGERS
SELECT '--- Teste de Triggers ---' AS Info;

-- 1 e 2 – Email normalizado (usuário fictício, dados verossímeis)
INSERT INTO Usuarios VALUES
(200, '123.456.789-00', 'Marcos', 'Pereira', 'MARCOS.PEREIRA@EXEMPLO.COM', 'Ativo', '123', 'Técnico');

SELECT email FROM Usuarios WHERE idUsuario = 200;

-- 3 e 4 – Beneficiário cadastrado gera observação automática
INSERT INTO Beneficiarios (idBeneficiario, nome, sobrenome, CPF, telefone, status, associacao, Usuarios_idUsuario)
VALUES (200, 'Alison', 'Oliveira', '987.654.321-00', 81992345678, 'Ativo', 'Associação de Agricultores de Recife', 1);

SELECT * FROM Observacao ORDER BY dataHora DESC LIMIT 1;

-- 5 – Quantidade negativa em entrega (erro esperado)
-- Deve gerar erro por causa da trigger de validação de quantidade
-- INSERT INTO Entrega VALUES (999,'Concluído',-5,NOW(),0x01,NOW(),1,1);

-- 6 – Atualização automática de status de lote após nova entrega
INSERT INTO Entrega (idEntrega,status,quantidadeEntregue,dataEntrega,fotoComprovante,dataConfirmacao,Beneficiarios_idBeneficiario,Lote_idLote)
VALUES (201,'Concluído',10,NOW(),0x01,NOW(),1,1);

SELECT status FROM Lote WHERE idLote = 1;

-- 7 – Atualização automática de dataConfirmacao quando entrega é concluída
UPDATE Entrega SET status='Concluído' WHERE idEntrega=2;
SELECT idEntrega, status, dataConfirmacao FROM Entrega WHERE idEntrega=2;

-- 8 e 9 – Teste das validações de lote (mantidos comentados pois geram erro proposital)
-- INSERT INTO Lote VALUES (999,'Lote de Teste',0,NOW(),'Fornecedor X',0x01,'Planejamento');  -- deve dar erro por quantidade inválida
-- UPDATE Lote SET status='Indefinido' WHERE idLote=1;  -- deve dar erro por status inválido

-- 10 – Observação vazia (mantido comentado, gera erro proposital)
-- INSERT INTO Observacao (idObservacao,descricao,dataHora,Usuarios_idUsuario) VALUES (NULL,'   ',NOW(),1);

-- 11 – Normalização do CEP para endereço de beneficiário
INSERT INTO Endereco VALUES ('Rua das Palmeiras','Recife','PE','50740-900',200);
SELECT CEP FROM Endereco WHERE Beneficiarios_idBeneficiario = 200;

-- 12 – Log de mudança de status em usuários
UPDATE Usuarios SET status='Inativo' WHERE idUsuario=200;

SELECT descricao FROM Observacao ORDER BY dataHora DESC LIMIT 1;
