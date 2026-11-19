-- ==========================================================================
--  HelpFlow - Sistema de Chamados de Suporte Técnico
--  SCRIPT COMPLETO PARA COMPILADORES ONLINE (OneCompiler, DB-Fiddle, etc.)
--  Cria as tabelas, insere os dados, mostra cada tabela e executa as consultas.
--  Não cria nem apaga o banco: usa o banco que o próprio site fornece.
--  Para MySQL instalado no computador, use os scripts 01, 02 e 03.
-- ==========================================================================

-- Remove as tabelas caso o script seja executado mais de uma vez
-- (ordem inversa por causa das chaves estrangeiras)
DROP TABLE IF EXISTS CHAMADO;
DROP TABLE IF EXISTS STATUS;
DROP TABLE IF EXISTS TECNICO;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS EMPRESA;

-- ==========================================================================
--  PARTE 1: CRIAÇÃO DAS TABELAS
-- ==========================================================================

-- --------------------------------------------------------------------------
-- EMPRESA: empresas clientes atendidas pela HelpFlow
-- --------------------------------------------------------------------------
CREATE TABLE EMPRESA (
    ID_EMPRESA    INT          NOT NULL AUTO_INCREMENT,
    CNPJ          CHAR(14)     NOT NULL,
    NOME_EMPRESA  VARCHAR(100) NOT NULL,
    CONSTRAINT PK_EMPRESA PRIMARY KEY (ID_EMPRESA),
    CONSTRAINT UQ_EMPRESA_CNPJ UNIQUE (CNPJ)
);

-- --------------------------------------------------------------------------
-- USUARIO: funcionários das empresas clientes que abrem chamados
-- Relacionamento: EMPRESA (1,1) possui (0,n) USUARIO
-- --------------------------------------------------------------------------
CREATE TABLE USUARIO (
    ID_USUARIO  INT          NOT NULL AUTO_INCREMENT,
    ID_EMPRESA  INT          NOT NULL,
    NOME        VARCHAR(100) NOT NULL,
    EMAIL       VARCHAR(150) NOT NULL,
    TELEFONE    CHAR(11),
    CONSTRAINT PK_USUARIO PRIMARY KEY (ID_USUARIO),
    CONSTRAINT UQ_USUARIO_EMAIL UNIQUE (EMAIL),
    CONSTRAINT FK_USUARIO_EMPRESA FOREIGN KEY (ID_EMPRESA)
        REFERENCES EMPRESA (ID_EMPRESA)
);

-- --------------------------------------------------------------------------
-- TECNICO: técnicos da HelpFlow que atendem os chamados
-- --------------------------------------------------------------------------
CREATE TABLE TECNICO (
    ID_TECNICO     INT          NOT NULL AUTO_INCREMENT,
    NOME           VARCHAR(100) NOT NULL,
    TELEFONE       CHAR(11),
    ESPECIALIDADE  VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_TECNICO PRIMARY KEY (ID_TECNICO)
);

-- --------------------------------------------------------------------------
-- STATUS: situações possíveis de um chamado
-- --------------------------------------------------------------------------
CREATE TABLE STATUS (
    ID_STATUS         INT          NOT NULL AUTO_INCREMENT,
    SITUACAO          VARCHAR(30)  NOT NULL,
    DESCRICAO_STATUS  VARCHAR(150) NOT NULL,
    CONSTRAINT PK_STATUS PRIMARY KEY (ID_STATUS),
    CONSTRAINT UQ_STATUS_SITUACAO UNIQUE (SITUACAO)
);

-- --------------------------------------------------------------------------
-- CHAMADO: solicitações de suporte abertas pelos usuários
-- Relacionamentos:
--   USUARIO (1,1) abre    (0,n) CHAMADO
--   TECNICO (0,1) atende  (0,n) CHAMADO  -> o chamado pode ainda não ter técnico
--   STATUS  (1,1) define  (0,n) CHAMADO
-- DATA_FECHAMENTO fica NULL enquanto o chamado não for encerrado
-- --------------------------------------------------------------------------
CREATE TABLE CHAMADO (
    ID_CHAMADO       INT          NOT NULL AUTO_INCREMENT,
    ID_USUARIO       INT          NOT NULL,
    ID_TECNICO       INT          NULL,
    ID_STATUS        INT          NOT NULL,
    DATA_ABERTURA    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DESCRICAO        VARCHAR(255) NOT NULL,
    CATEGORIA        VARCHAR(50)  NOT NULL,
    DATA_FECHAMENTO  DATETIME     NULL,
    CONSTRAINT PK_CHAMADO PRIMARY KEY (ID_CHAMADO),
    CONSTRAINT FK_CHAMADO_USUARIO FOREIGN KEY (ID_USUARIO)
        REFERENCES USUARIO (ID_USUARIO),
    CONSTRAINT FK_CHAMADO_TECNICO FOREIGN KEY (ID_TECNICO)
        REFERENCES TECNICO (ID_TECNICO),
    CONSTRAINT FK_CHAMADO_STATUS FOREIGN KEY (ID_STATUS)
        REFERENCES STATUS (ID_STATUS),
    CONSTRAINT CK_CHAMADO_DATAS CHECK (DATA_FECHAMENTO IS NULL OR DATA_FECHAMENTO >= DATA_ABERTURA)
);

-- ==========================================================================
--  PARTE 2: INSERÇÃO DE DADOS DE EXEMPLO (fictícios)
-- ==========================================================================

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

-- ==========================================================================
--  PARTE 3: VISUALIZAR O BANCO (dados de cada tabela)
-- ==========================================================================

SELECT 'empresas clientes' AS '>>> TABELA 1 de 5: EMPRESA';
SELECT ID_EMPRESA, NOME_EMPRESA, CNPJ FROM EMPRESA;

SELECT 'funcionarios que abrem chamados' AS '>>> TABELA 2 de 5: USUARIO';
SELECT ID_USUARIO, NOME, EMAIL, TELEFONE, ID_EMPRESA FROM USUARIO;

SELECT 'equipe de suporte' AS '>>> TABELA 3 de 5: TECNICO';
SELECT ID_TECNICO, NOME, ESPECIALIDADE, TELEFONE FROM TECNICO;

SELECT 'situacoes do chamado' AS '>>> TABELA 4 de 5: STATUS';
SELECT ID_STATUS, SITUACAO, DESCRICAO_STATUS FROM STATUS;

SELECT 'chamados de suporte' AS '>>> TABELA 5 de 5: CHAMADO';
SELECT ID_CHAMADO, ID_USUARIO, ID_TECNICO, ID_STATUS, CATEGORIA, DESCRICAO,
       DATA_ABERTURA, DATA_FECHAMENTO
FROM CHAMADO;

-- ==========================================================================
--  PARTE 4: CONSULTAS (relatorios do sistema)
-- ==========================================================================

SELECT 'Usuarios e suas empresas' AS '>>> CONSULTA 1';
SELECT  U.ID_USUARIO, U.NOME AS USUARIO, U.EMAIL, E.NOME_EMPRESA AS EMPRESA
FROM USUARIO U
INNER JOIN EMPRESA E ON E.ID_EMPRESA = U.ID_EMPRESA
ORDER BY E.NOME_EMPRESA, U.NOME;

SELECT 'Chamados em aberto e tecnico responsavel' AS '>>> CONSULTA 2';
SELECT  C.ID_CHAMADO, U.NOME AS USUARIO, E.NOME_EMPRESA AS EMPRESA,
        C.CATEGORIA, S.SITUACAO,
        COALESCE(T.NOME, 'Sem tecnico') AS TECNICO,
        C.DATA_ABERTURA
FROM CHAMADO C
INNER JOIN USUARIO U ON U.ID_USUARIO = C.ID_USUARIO
INNER JOIN EMPRESA E ON E.ID_EMPRESA = U.ID_EMPRESA
INNER JOIN STATUS  S ON S.ID_STATUS  = C.ID_STATUS
LEFT  JOIN TECNICO T ON T.ID_TECNICO = C.ID_TECNICO
WHERE S.SITUACAO <> 'Fechado'
ORDER BY C.DATA_ABERTURA;

SELECT 'Quantidade de chamados por situacao' AS '>>> CONSULTA 3';
SELECT  S.SITUACAO, COUNT(C.ID_CHAMADO) AS QUANTIDADE
FROM STATUS S
LEFT JOIN CHAMADO C ON C.ID_STATUS = S.ID_STATUS
GROUP BY S.ID_STATUS, S.SITUACAO
ORDER BY S.ID_STATUS;

SELECT 'Desempenho dos tecnicos' AS '>>> CONSULTA 4';
SELECT  T.NOME AS TECNICO, T.ESPECIALIDADE,
        COUNT(C.ID_CHAMADO) AS TOTAL,
        SUM(C.DATA_FECHAMENTO IS NOT NULL) AS RESOLVIDOS,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, C.DATA_ABERTURA, C.DATA_FECHAMENTO)) / 60, 1) AS MEDIA_HORAS
FROM TECNICO T
LEFT JOIN CHAMADO C ON C.ID_TECNICO = T.ID_TECNICO
GROUP BY T.ID_TECNICO, T.NOME, T.ESPECIALIDADE
ORDER BY TOTAL DESC, TECNICO;

SELECT 'Chamados por empresa' AS '>>> CONSULTA 5';
SELECT  E.NOME_EMPRESA AS EMPRESA, COUNT(C.ID_CHAMADO) AS TOTAL_CHAMADOS
FROM EMPRESA E
LEFT JOIN USUARIO U ON U.ID_EMPRESA = E.ID_EMPRESA
LEFT JOIN CHAMADO C ON C.ID_USUARIO = U.ID_USUARIO
GROUP BY E.ID_EMPRESA, E.NOME_EMPRESA
ORDER BY TOTAL_CHAMADOS DESC, EMPRESA;
