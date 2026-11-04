create database if not exists hospital_db;
use hospital_db;

create table if not exists pacientes(
id_paciente int auto_increment primary key,
nome_paciente varchar(100) not null,
cpf varchar(14) unique not null,
data_nascimento date not null,
telefone_paciente varchar(20),
convenio varchar(50)
);

create table if not exists medicos(
id_medico int auto_increment primary key,
nome_medico varchar(100) not null,
crm varchar(20) unique not null,
especialidade varchar(100) not null
);

create table if not exists quartos(
id_quarto int auto_increment primary key,
numero_quarto int not null,
andar int not null,
tipo_quarto varchar(50) not null,
status_quarto varchar(20) not null
);

create table if not exists internacoes(
id_internacao int auto_increment primary key,
id_paciente int not null,
id_quarto int not null,
data_entrada date not null,
data_saida date,
valor_diaria decimal(10, 2) not null,
foreign key (id_paciente) references pacientes (id_paciente),
foreign key (id_quarto) references quartos (id_quarto)
);

create table if not exists consultas (
id_consulta int auto_increment primary key,
id_paciente int not null,
id_medico int not null,
data_consulta datetime not null,
status_consulta varchar(50) not null,
valor_consulta decimal(10, 2) not null,
foreign key (id_paciente) references pacientes (id_paciente),
foreign key (id_medico) references medicos (id_medico)
);

CREATE TABLE prescricoes (
id_prescricao int auto_increment primary key,
id_consulta int not null,
medicamento varchar(100) not null,
dosagem varchar(100) not null,
quantidade int not null,
foreign key(id_consulta) references consultas(id_consulta)
);

