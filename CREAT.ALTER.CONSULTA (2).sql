/*- Alice Bianca da Silva Cavalcanti
- Lorrana Gomes Ferreira
- Nicolas Alves Martins 
- Roberto Braga de Oliveira Filho*/


create database universidade;
use universidade;

create table Curso(
 nome varchar (55) not null,
 id int (10),
 telefone char(13) unique,
 primary key (id)
);

create table Turma(
 ano int(4) not null,
 semestre int not null,
 idCurso int (10),
 id int (10),
 foreign key (idCurso) references Curso (id),
 primary key (id)
);

create table Aluno(
 matricula char(10),
 cpf char (11),
 nome varchar (55) not null,
 sexo enum ('feminino', 'masculino', 'prefiro não imformar'),
 telefone char(13) unique,
 endereco varchar(100),
 idCurso int (10),
 idTurma int (10),
 TipodeFormacao enum ('graduação', 'mestrado', 'doutorado'),
 foreign key (idCurso) references Curso (id),
 foreign key (idTurma) references Turma (id),
 primary key (matricula)
);

create table Disciplina(
 nome varchar (55) not null,
 descricao text,
 professor varchar (55) not null,
 id int (10),
 horas time,
 nivel enum ('básico', 'médio', 'avançado'),
 idCurso int (10) not null,
 foreign key (idCurso) references Curso (id),
 primary key (id)
);

create table Professor(
 cpf char (11),
 nome varchar (55) not null,
 sexo enum ('feminino', 'masculino', 'prefiro não imformar'),
 telefone char(13) unique,
 id int (10),
 idCurso int (10) not null,
 idTurma int (10),
 foreign key (idCurso) references Curso (id),
 foreign key (idturma) references Turma (id),
 primary key (id)
);

alter table Professor add column email varchar(255) not null after nome;
alter table Disciplina add column status enum('cursando', 'cursada', 'não cursada') not null default 'não cursada';
alter table Disciplina change column professor idProfessor int(10);
alter table Disciplina add constraint fk_idProfessor foreign key (idProfessor) references Professor(id);
alter table  Disciplina change column  horas cargahoraria time;

create table Avaliacao(
 id int(10) auto_increment,
 idAluno char(10),
 idDisciplina int(10),
 nota decimal(4,2) not null,
 data date not null,
 foreign key (idAluno) references Aluno(matricula),
 foreign key (idDisciplina) references Disciplina(id),
 primary key (id)
);

/*consultas*/

/*Liste o nome e o email dos professores.*/
select nome, email from Professor;

/*Liste o nome e carga horária de todas as disciplinas.*/
select nome, CargaHoraria from Disciplina;

/*Liste o nome e a carga horária de todas as disciplinas que já foram cursadas.*/
select nome, CargaHoraria from Disciplina where status = 'cursada';

/*Liste o nome dos professores que ministram disciplinas com carga horária de 80 horas.*/
select Professor.nome from Disciplina inner join Professor on Disciplina.idProfessor = Professor.id 
where Disciplina.cargahoraria = '80:00:00';

/*Liste as notas da disciplina de Lógica de programação.*/
select A.nota, A.data, Al.nome as Aluno from Avaliacao A inner join Disciplina D on A.idDisciplina = D.id 
inner join Aluno Al on A.idAluno = Al.matricula where D.nome = 'Lógica de programação';

/*Liste as disciplinas que ainda não foram cursadas.*/
select nome from Disciplina where status = 'não cursada';

/*Retorne o total de horas das disciplinas cursadas.*/
select sum(cargahoraria) as totalHoras from disciplina where status = 'cursada';

/*Retorne a média de todas as notas de provas.*/
select round(avg(nota),2) as media from avaliacao ;

/*Liste todos os nomes dos alunos e as disciplinas de cada turma.*/
SELECT 
    Al.nome AS Aluno, 
    T.id,
    T.ano, 
    T.semestre, 
    D.nome AS Disciplina
FROM 
    Aluno Al
JOIN 
    Turma T ON Al.idTurma = T.id
JOIN 
    Disciplina D ON Al.idCurso = D.idCurso
ORDER BY
    T.id;
    
/*Retorne o número de alunos, a disciplina e o nome do professor da turma que possui mais alunos.*/
SELECT 
    T.id AS TurmaID,
    COUNT(Al.matricula) AS NumeroDeAlunos,
    D.nome AS Disciplina,
    P.nome AS Professor
FROM 
    Aluno Al
JOIN 
    Turma T ON Al.idTurma = T.id
JOIN 
    Disciplina D ON T.idCurso = D.idCurso
JOIN 
    Professor P ON D.idProfessor = P.id
GROUP BY 
    T.id, D.nome, P.nome
ORDER BY 
    NumeroDeAlunos DESC
LIMIT 1;

