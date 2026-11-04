#  Sistema de Gestão Hospitalar — Banco de Dados SQL

Este repositório contém a modelagem, população e scripts SQL avançados para um **Sistema de Gestão Hospitalar (`hospital_db`)**. O projeto inclui a criação do esquema relacional, inserção de dados iniciais, views para relatórios, índices de desempenho, procedures, triggers, funções e um conjunto de consultas analíticas.

---

##  Sumário
- [Visão Geral](#-visão-geral)
- [Estrutura do Banco de Dados](#-estrutura-do-banco-de-dados)
- [Funcionalidades e Recursos Avançados](#-funcionalidades-e-recursos-avançados)
- [Como Executar](#-como-executar)
- [Consultas de Exemplo (Queries)](#-consultas-de-exemplo-queries)

---

##  Visão Geral

O banco de dados foi construído para gerenciar o fluxo principal de um ambiente hospitalar, englobando:
- **Pacientes:** Cadastro com dados pessoais, contatos e convênio.
- **Médicos:** Registro com CRM e especialidades médicas.
- **Quartos:** Controle de aposentos (UTI, Enfermaria, Apartamento, Suíte VIP) e status de ocupação.
- **Consultas:** Histórico de consultas entre médicos e pacientes.
- **Internações:** Registro de entrada/saída de pacientes em quartos, com valores diários.
- **Prescrições:** Medicamentos, dosagens e quantidades vinculadas a cada consulta.

---

##  Estrutura do Banco de Dados

### Tabelas Criadas:
1. `pacientes` — Dados cadastrais dos pacientes.
2. `medicos` — Registro profissional e especialidades dos médicos.
3. `quartos` — Localização, tipo e status do quarto.
4. `internacoes` — Registro de internações com datas de entrada/saída e valores diários (FKs: `pacientes`, `quartos`).
5. `consultas` — Registro de atendimentos (FKs: `pacientes`, `medicos`).
6. `prescricoes` — Prescrição de medicamentos por consulta (FK: `consultas`).
7. `log_internacoes` — Tabela de auditoria para acompanhamento de internações.

---

##  Funcionalidades e Recursos Avançados

O script de estrutura avançada inclui 15 objetos no banco de dados:

###  Views (Visualizações)
- `vw_detalhes_consultas`: Cruzamento detalhado entre consultas, pacientes e médicos.
- `vw_historico_internacoes`: Cálculo automático de dias de permanência e status da internação.
- `vw_prescricoes_detalhadas`: Histórico completo de medicamentos prescritos por paciente.
- `vw_faturamento_por_medico`: Totalização do faturamento gerado por cada médico.
- `vw_status_quartos`: Monitoramento em tempo real dos quartos e ocupações.

###  Índices (Indexação e Performance)
- `idx_pacientes_cpf`: Busca rápida de pacientes via CPF.
- `idx_medicos_crm`: Otimização de consultas por CRM.
- `idx_consultas_data`: Agiliza relatórios e buscas por período de atendimento.
- `idx_internacoes_datas`: Performance em filtros por datas de entrada e saída.
- `idx_pacientes_convenio`: Filtragem ágil por plano de saúde.

###  Procedures, Triggers e Functions
- **Procedure `sp_agendar_consulta`:** Realiza o agendamento de consultas.
- **Procedure `sp_alta_hospitalar`:** Atualiza a data de saída da internação e libera automaticamente o quarto.
- **Trigger `trg_after_insert_internacao`:** Registra automaticamente um log de auditoria ao realizar uma nova internação.
- **Function `fn_total_gasto_paciente`:** Retorna a receita total gerada por um paciente (Consultas + Diárias de Internação).

---

