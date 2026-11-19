-- ==========================================================================
--  HelpFlow - Sistema de Chamados de Suporte Técnico
--  Script 03: Consultas (SELECT)
--  Executar depois dos scripts 01 e 02
-- ==========================================================================

USE helpflow;

-- --------------------------------------------------------------------------
-- Consulta 1: Listagem de usuários com a empresa em que trabalham
-- (relaciona USUARIO e EMPRESA)
-- --------------------------------------------------------------------------
SELECT  U.ID_USUARIO,
        U.NOME        AS USUARIO,
        U.EMAIL,
        E.NOME_EMPRESA AS EMPRESA
FROM USUARIO U
INNER JOIN EMPRESA E ON E.ID_EMPRESA = U.ID_EMPRESA
ORDER BY E.NOME_EMPRESA, U.NOME;

-- --------------------------------------------------------------------------
-- Consulta 2: Chamados em aberto (não fechados), com quem abriu,
-- a empresa, a situação e o técnico responsável
-- LEFT JOIN em TECNICO para mostrar também chamados ainda sem técnico
-- --------------------------------------------------------------------------
SELECT  C.ID_CHAMADO,
        C.DATA_ABERTURA,
        U.NOME         AS USUARIO,
        E.NOME_EMPRESA AS EMPRESA,
        C.CATEGORIA,
        C.DESCRICAO,
        S.SITUACAO,
        COALESCE(T.NOME, 'Sem técnico atribuído') AS TECNICO
FROM CHAMADO C
INNER JOIN USUARIO U ON U.ID_USUARIO = C.ID_USUARIO
INNER JOIN EMPRESA E ON E.ID_EMPRESA = U.ID_EMPRESA
INNER JOIN STATUS  S ON S.ID_STATUS  = C.ID_STATUS
LEFT  JOIN TECNICO T ON T.ID_TECNICO = C.ID_TECNICO
WHERE S.SITUACAO <> 'Fechado'
ORDER BY C.DATA_ABERTURA;

-- --------------------------------------------------------------------------
-- Consulta 3: Quantidade de chamados por situação
-- --------------------------------------------------------------------------
SELECT  S.SITUACAO,
        COUNT(C.ID_CHAMADO) AS QUANTIDADE
FROM STATUS S
LEFT JOIN CHAMADO C ON C.ID_STATUS = S.ID_STATUS
GROUP BY S.ID_STATUS, S.SITUACAO
ORDER BY S.ID_STATUS;

-- --------------------------------------------------------------------------
-- Consulta 4: Desempenho dos técnicos - chamados atendidos, resolvidos
-- e tempo médio de resolução em horas
-- --------------------------------------------------------------------------
SELECT  T.NOME          AS TECNICO,
        T.ESPECIALIDADE,
        COUNT(C.ID_CHAMADO)                AS TOTAL_CHAMADOS,
        SUM(C.DATA_FECHAMENTO IS NOT NULL) AS RESOLVIDOS,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, C.DATA_ABERTURA, C.DATA_FECHAMENTO)) / 60, 1) AS MEDIA_HORAS_RESOLUCAO
FROM TECNICO T
LEFT JOIN CHAMADO C ON C.ID_TECNICO = T.ID_TECNICO
GROUP BY T.ID_TECNICO, T.NOME, T.ESPECIALIDADE
ORDER BY TOTAL_CHAMADOS DESC, TECNICO;

-- --------------------------------------------------------------------------
-- Consulta 5: Quantidade de chamados por empresa cliente
-- --------------------------------------------------------------------------
SELECT  E.NOME_EMPRESA AS EMPRESA,
        COUNT(C.ID_CHAMADO) AS TOTAL_CHAMADOS
FROM EMPRESA E
LEFT JOIN USUARIO U ON U.ID_EMPRESA = E.ID_EMPRESA
LEFT JOIN CHAMADO C ON C.ID_USUARIO = U.ID_USUARIO
GROUP BY E.ID_EMPRESA, E.NOME_EMPRESA
ORDER BY TOTAL_CHAMADOS DESC, EMPRESA;
