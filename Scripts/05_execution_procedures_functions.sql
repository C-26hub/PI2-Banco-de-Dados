-- =================================================================
-- EXECUÇÃO DE TESTES (Para validar as rotinas)
-- =================================================================

-- Teste de Procedures
SELECT '--- Teste de Procedures ---' AS Info;
CALL SP_InserirNovoUsuario(21, '616.717.818-90', 'Novo', 'Aluno', 'novo.aluno@ads.com', 'Ativo', 'senha123', 'Técnico');
CALL SP_AtualizarStatusBeneficiario(3, 'Ativo');
CALL SP_RegistrarEntrega(21, 'Pendente', 10, NOW(), NOW(), 1, 1);
CALL SP_BuscarLotesPorStatus('Concluído');
CALL SP_RelatorioEntregasPendentes();
CALL SP_ContarBeneficiariosPorCidade('Recife');
CALL SP_DeletarObservacaoAntiga(1000);
CALL SP_BuscarUsuarioPorEmail('ana@gmail.com');

-- Teste de Funções
SELECT '--- Teste de Funções ---' AS Info;
SELECT FN_CalcularTotalEntregueLote(1) AS TotalEntregueLote1;
SELECT FN_VerificarStatusAtivoUsuario(1) AS StatusAtivoUsuario1;
SELECT FN_ContarEntregasBeneficiario(1) AS TotalEntregasBeneficiario1;
SELECT FN_ObterNomeCompletoUsuario(1) AS NomeCompletoUsuario1;
SELECT FN_CalcularMediaEntregueLote(1) AS MediaEntregueLote1;
SELECT FN_ObterCEPBeneficiario(1) AS CEPBeneficiario1;

-- Restaura o delimitador padrão
DELIMITER ;
