-- ==========================================================================
--  HelpFlow - Sistema de Chamados de Suporte Técnico
--  Script 02: Inserção de dados de exemplo (dados fictícios)
--  Executar depois do script 01_criacao.sql
-- ==========================================================================

USE helpflow;

-- Empresas clientes
INSERT INTO EMPRESA (CNPJ, NOME_EMPRESA) VALUES
('12345678000190', 'Padaria Pão Dourado'),
('23456789000101', 'Auto Peças Avenida'),
('34567890000112', 'Clínica Sorriso Feliz'),
('45678901000123', 'Mercadinho Bom Preço');

-- Usuários (funcionários das empresas que abrem chamados)
INSERT INTO USUARIO (ID_EMPRESA, NOME, EMAIL, TELEFONE) VALUES
(1, 'Carlos Pereira',  'carlos@paodourado.com.br',  '11987650001'),
(1, 'Fernanda Lima',   'fernanda@paodourado.com.br', '11987650002'),
(2, 'Roberto Alves',   'roberto@autopecasav.com.br', '11987650003'),
(3, 'Juliana Costa',   'juliana@sorrisofeliz.com.br', '11987650004'),
(3, 'Marcos Oliveira', 'marcos@sorrisofeliz.com.br', '11987650005'),
(4, 'Patrícia Rocha',  'patricia@bompreco.com.br',  '11987650006');

-- Técnicos da HelpFlow
INSERT INTO TECNICO (NOME, TELEFONE, ESPECIALIDADE) VALUES
('Lucas Martins',  '11976540001', 'Redes e Internet'),
('Ana Beatriz',    '11976540002', 'Hardware'),
('Diego Ferreira', '11976540003', 'Software e Sistemas'),
('Camila Ribeiro', '11976540004', 'Impressoras e Periféricos');

-- Status possíveis de um chamado
INSERT INTO STATUS (SITUACAO, DESCRICAO_STATUS) VALUES
('Aberto',             'Chamado registrado, aguardando um técnico'),
('Em atendimento',     'Técnico atribuído e trabalhando na solução'),
('Aguardando cliente', 'Técnico aguardando retorno ou informação do cliente'),
('Fechado',            'Problema resolvido e chamado encerrado');

-- Chamados
INSERT INTO CHAMADO (ID_USUARIO, ID_TECNICO, ID_STATUS, DATA_ABERTURA, DESCRICAO, CATEGORIA, DATA_FECHAMENTO) VALUES
(1, 1,    4, '2026-11-03 08:15:00', 'Internet do caixa caiu e a maquininha não conecta',     'Redes',      '2026-11-03 10:40:00'),
(3, 3,    4, '2026-11-04 09:30:00', 'Sistema de vendas fechando sozinho ao emitir nota',     'Software',   '2026-11-05 14:20:00'),
(4, 4,    4, '2026-11-06 13:05:00', 'Impressora da recepção não imprime as fichas',          'Impressora', '2026-11-06 15:00:00'),
(2, 2,    2, '2026-11-10 07:50:00', 'Computador do escritório não liga',                     'Hardware',   NULL),
(5, 3,    3, '2026-11-11 11:20:00', 'Erro ao acessar o sistema de agendamento de pacientes', 'Software',   NULL),
(6, 1,    2, '2026-11-12 16:45:00', 'Wi-Fi lento na área de atendimento',                    'Redes',      NULL),
(3, NULL, 1, '2026-11-14 10:10:00', 'Leitor de código de barras parou de funcionar',         'Periféricos', NULL),
(1, NULL, 1, '2026-11-15 08:05:00', 'Solicitação de cadastro de novo usuário no sistema',    'Software',   NULL),
(4, 2,    4, '2026-11-15 09:00:00', 'Monitor piscando no consultório 2',                     'Hardware',   '2026-11-15 12:30:00'),
(6, NULL, 1, '2026-11-16 14:30:00', 'Impressora fiscal travando o papel',                    'Impressora', NULL);
