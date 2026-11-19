-- ==========================================================================
--  HelpFlow - Sistema de Chamados de Suporte Técnico
--  Script 01: Criação do banco de dados e das tabelas
--  SGBD: MySQL
--  Projeto de Extensão em Desenvolvimento de Software - UNINOVE
--  Modelagem: Manoella Assenza de Santana | Scripts: Laura da Silva Brandão
-- ==========================================================================

DROP DATABASE IF EXISTS helpflow;
CREATE DATABASE helpflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE helpflow;

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
