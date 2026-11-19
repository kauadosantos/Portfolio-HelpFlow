# HelpFlow – Banco de Dados (MySQL)

Banco de dados do sistema de chamados de suporte técnico da HelpFlow.

## Arquivos
| Arquivo | Conteúdo |
|---|---|
| `01_criacao.sql` | Criação do banco `helpflow` e das 5 tabelas, com PK, FK e tipos de dados |
| `02_insercao.sql` | Dados de exemplo (fictícios): 4 empresas, 6 usuários, 4 técnicos, 4 status e 10 chamados |
| `03_consultas.sql` | 5 consultas com JOIN |
| `DER_logico_HelpFlow.png` | Modelo lógico (DER) |

## Tabelas
- **EMPRESA**: empresas clientes atendidas pela HelpFlow
- **USUARIO**: funcionários das empresas que abrem chamados
- **TECNICO**: técnicos da HelpFlow que atendem os chamados
- **STATUS**: situações possíveis de um chamado (Aberto, Em atendimento, Aguardando cliente, Fechado)
- **CHAMADO**: solicitações de suporte, ligadas a um usuário, a um status e (opcionalmente) a um técnico

## Relacionamentos
- Uma **empresa** possui de 1 a N **usuários**; cada usuário pertence a 1 empresa
- Um **usuário** abre de 0 a N **chamados**; cada chamado é aberto por 1 usuário
- Um **técnico** atende de 0 a N **chamados**; um chamado tem 0 ou 1 técnico (pode ainda não ter sido atribuído)
- Um **status** classifica de 0 a N **chamados**; cada chamado tem 1 status

## Consultas
1. Usuários e a empresa em que trabalham
2. Chamados em aberto, com usuário, empresa, situação e técnico
3. Quantidade de chamados por situação
4. Desempenho dos técnicos (total, resolvidos e tempo médio de resolução)
5. Quantidade de chamados por empresa

## Como executar
- **MySQL instalado no computador** (Workbench, linha de comando): execute os scripts na ordem `01`, `02` e `03`.
- **Compiladores online** (OneCompiler, DB-Fiddle etc.): use o arquivo `HelpFlow_completo_online.sql`. Esses sites já fornecem um banco pronto e não permitem criar ou apagar bancos (`CREATE/DROP DATABASE`), então esse arquivo cria só as tabelas, insere os dados e roda as consultas.
