
--  15 Pesquisas --

-- Listar todos os pacientes e seus respectivos convênios --
select nome_paciente, cpf, convenio
from pacientes;

-- Buscar todos os médicos da especialidade "Cardiologia" --
select nome_medico, crm 
from medicos 
where especialidade = 'Cardiologia';

-- Listar quartos disponíveis no momento --
select numero_quarto, andar, tipo_quarto 
from quartos 
where status_quarto = 'Livre';

-- Detalhar as consultas realizadas com nome do paciente e do médico --
select
    c.id_consulta,
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta,
    c.valor_consulta
from consultas c
join pacientes p on c.id_paciente = p.id_paciente
join medicos m on c.id_medico = m.id_medico;

-- Calcular o valor total gasto por cada paciente em consultas --
select
    p.nome_paciente,
    SUM(c.valor_consulta) as total_gasto_consultas
from consultas c
join pacientes p on c.id_paciente = p.id_paciente
group by p.id_paciente, p.nome_paciente;

-- Contar o número de consultas realizadas por médico
select 
    m.nome_medico,
    COUNT(c.id_consulta) as total_consultas
from medicos m
left join consultas c on m.id_medico = c.id_medico
group by m.id_medico, m.nome_medico;

-- Listar internações ativas ou finalizadas com a duração em dias
select 
    p.nome_paciente,
    q.numero_quarto,
    i.data_entrada,
    i.data_saida,
    DATEDIFF(IFNULL(i.data_saida, CURRENT_DATE), i.data_entrada) as total_dias
from internacoes i
join pacientes p on i.id_paciente = p.id_paciente
join quartos q on i.id_quarto = q.id_quarto;

-- Buscar todas as prescrições médicas da paciente "Ana Silva"
select
    p.nome_paciente,
    c.data_consulta,
    pr.medicamento,
    pr.dosagem,
    pr.quantidade
from prescricoes pr
join consultas c on pr.id_consulta = c.id_consulta
join pacientes p on c.id_paciente = p.id_paciente
where p.nome_paciente = 'Ana Silva';

-- Média de valor da diária das internações por tipo de quarto
select
    q.tipo_quarto,
    ROUND(avg(i.valor_diaria), 2) as media_valor_diaria
from internacoes i
join quartos q on i.id_quarto = q.id_quarto
group by q.tipo_quarto;

-- Pacientes que tiveram mais de 1 consulta registrada
select 
    p.nome_paciente,
    COUNT(c.id_consulta) as qtd_consultas
from pacientes p
join consultas c on p.id_paciente = c.id_paciente
group by p.id_paciente, p.nome_paciente
having COUNT(c.id_consulta) > 1;

-- Calcular o custo total estimado de cada internação (Dias x Diária)
select
    i.id_internacao,
    p.nome_paciente,
    i.valor_diaria,
    DATEDIFF(IFNULL(i.data_saida, CURRENT_DATE), i.data_entrada) as dias,
    (DATEDIFF(IFNULL(i.data_saida, CURRENT_DATE), i.data_entrada) * i.valor_diaria) as valor_total_internacao
from internacoes i
join pacientes p on i.id_paciente = p.id_paciente;

-- Listar os medicamentos mais receitados em ordem decrescente de quantidade total
select 
    medicamento,
    SUM(quantidade) as total_unidades_prescritas
from prescricoes
group by medicamento
order by total_unidades_prescritas desc;

-- Buscar pacientes que já ficaram internados em quartos do tipo "UTI"
select distinct
    p.nome_paciente,
    p.cpf,
    p.convenio
from internacoes i
join pacientes p on i.id_paciente = p.id_paciente
join quartos q on i.id_quarto = q.id_quarto
where q.tipo_quarto = 'UTI';

-- Médicos que ainda não realizaram nenhuma consulta cadastrada
select 
    m.nome_medico,
    m.crm,
    m.especialidade
from medicos m
left join consultas c on m.id_medico = c.id_medico
where c.id_consulta is null;

-- Valor total arrecadado pelo hospital juntando consultas e diárias de internações
select
    (select IFNULL(SUM(valor_consulta), 0) from consultas) as total_consultas,
    (select IFNULL(SUM(DATEDIFF(IFNULL(data_saida, CURRENT_DATE), data_entrada) * valor_diaria), 0) from internacoes) as total_internacoes,
    (
        (select IFNULL(SUM(valor_consulta), 0) from consultas) + 
        (select IFNULL(SUM(DATEDIFF(IFNULL(data_saida, CURRENT_DATE), data_entrada) * valor_diaria), 0) from internacoes)
    ) as faturamento_geral_hospital;