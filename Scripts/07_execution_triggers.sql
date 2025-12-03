-- TESTES DE TRIGGERS
SELECT '--- Teste de Triggers ---' AS Info;

-- 1 e 2 – Email normalizado
INSERT INTO Usuarios VALUES
(200, '000.000.000-00', 'Teste', 'Trigger', 'EMAIL@TESTE.COM', 'Ativo', '123', 'Técnico');

SELECT email FROM Usuarios WHERE idUsuario = 200;

-- 3 e 4 – Beneficiário gera log automático
INSERT INTO Beneficiarios (idBeneficiario, nome, sobrenome, CPF, telefone, status, associacao, Usuarios_idUsuario)
VALUES (200, 'Trigger', 'Benef', '111.222.333-44', 81900000000, 'Ativo', 'Associação X', 1);

SELECT * FROM Observacao ORDER BY dataHora DESC LIMIT 1;

-- 5 – Quantidade negativa em entrega (erro)
-- Deve gerar erro
-- INSERT INTO Entrega VALUES (999,'Concluído',-5,NOW(),0x01,NOW(),1,1);

-- 6 – Atualização automática de status de lote
INSERT INTO Entrega (idEntrega,status,quantidadeEntregue,dataEntrega,fotoComprovante,dataConfirmacao,Beneficiarios_idBeneficiario,Lote_idLote)
VALUES (201,'Concluído',10,NOW(),0x01,NOW(),1,1);

SELECT status FROM Lote WHERE idLote = 1;

-- 7 – Atualização automática de dataConfirmacao
UPDATE Entrega SET status='Concluído' WHERE idEntrega=2;
SELECT idEntrega, status, dataConfirmacao FROM Entrega WHERE idEntrega=2;

-- 8 e 9 – Teste validações de lote
-- INSERT INTO Lote VALUES (999,'Teste',0,NOW(),'X',0x01,'Planejamento');  -- deve dar erro
-- UPDATE Lote SET status='Invalido' WHERE idLote=1;  -- deve dar erro

-- 10 – Observação vazia
-- Deve dar erro
-- INSERT INTO Observacao (idObservacao,texto,dataHora,Usuarios_idUsuario) VALUES (NULL,'   ',NOW(),1);

-- 11 – Normalização do CEP
INSERT INTO Endereco VALUES ('Rua Teste','Cidade','PE','50000-999',200);
SELECT CEP FROM Endereco WHERE Beneficiarios_idBeneficiario = 200;

-- 12 – Log de mudança de status em usuarios
UPDATE Usuarios SET status='Inativo' WHERE idUsuario=200;

SELECT texto FROM Observacao ORDER BY dataHora DESC LIMIT 1;
