
-- CRIAÇÃO DO BANCO E ESTRUTURAS DISTRIBUÍDAS

CREATE DATABASE Escola;
USE Escola;

-- Fragmento 1: Goianésia
CREATE TABLE Alunos_Campus_Goianesia(
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL,
    campus VARCHAR(50) DEFAULT 'Goianésia'
);

-- Fragmento 2: Anápolis
CREATE TABLE Alunos_Campus_Anapolis(
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL,
    campus VARCHAR(50) DEFAULT 'Anápolis'
);

-- Visão Global (Transparência de Fragmentação)
CREATE OR REPLACE VIEW vw_Alunos_Global AS
SELECT * FROM Alunos_Campus_Goianesia
UNION ALL
SELECT * FROM Alunos_Campus_Anapolis;


CREATE TABLE Cursos(
    id_cursos INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL
);


CREATE TABLE Disciplina(
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(30) NOT NULL,
    vagas INT DEFAULT 10,
    CONSTRAINT chk_vagas_positivo CHECK (vagas >= 0)
);

CREATE TABLE Curso_Disciplina(
    Id_curso_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    id_disciplina INT NOT NULL,
    id_cursos INT NOT NULL,
    UNIQUE (id_disciplina, id_cursos),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id_disciplina),
    FOREIGN KEY (id_cursos) REFERENCES Cursos(id_cursos)
);

CREATE TABLE Matricula(
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    data_matricula DATE NOT NULL,
    semestre VARCHAR(6) NOT NULL,
    id_aluno INT NOT NULL,
    id_cursos INT NOT NULL,
    UNIQUE(semestre, id_aluno, id_cursos),
    
    FOREIGN KEY (id_cursos) REFERENCES Cursos(id_cursos)
);

-- SEGURANÇA

CREATE USER IF NOT EXISTS 'aluno_teste'@'localhost' IDENTIFIED BY '123';
CREATE USER IF NOT EXISTS 'prof_teste'@'localhost' IDENTIFIED BY '123';

-- Permissões
GRANT SELECT ON escola.* TO 'aluno_teste'@'localhost';
GRANT SELECT, UPDATE, DELETE ON escola.Matricula TO 'prof_teste'@'localhost';
GRANT SELECT ON escola.vw_Alunos_Global TO 'prof_teste'@'localhost';

-- Revogações Específicas
REVOKE DELETE ON escola.Matricula FROM 'prof_teste'@'localhost';



-- INSERINDO OS DADOS


INSERT INTO Cursos (nome_curso) VALUES
('CC'), ('Engenharia de Software'), ('Sistemas de Informação'), ('Administração'), 
('Direito'), ('Medicina'), ('Engenharia Civil'), ('Arquitetura'), ('Psicologia'), ('Matemática');

INSERT INTO Disciplina (nome_disciplina) VALUES
('Banco de Dados'), ('Algoritmos e Lógica'), ('Cálculo I'), ('Direito Penal'), 
('Anatomia Humana'), ('Física I'), ('Estruturas de Dados'), ('Engenharia de Requisitos'), 
('Psicologia Cognitiva'), ('Gestão de Projetos');


INSERT INTO Alunos_Campus_Goianesia (id_aluno, nome, sexo, data_nascimento) VALUES
(1, 'Ana Silva', 'F', '2001-05-14'),
(2, 'Bruno Souza', 'M', '2000-08-22'),
(3, 'Carlos Eduardo', 'M', '1999-11-30'),
(4, 'Daniela Costa', 'F', '2002-02-10'),
(5, 'Eduardo Lima', 'M', '2001-07-25');

INSERT INTO Alunos_Campus_Anapolis (id_aluno, nome, sexo, data_nascimento) VALUES
(6, 'Fernanda Alves', 'F', '2003-01-05'),
(7, 'Gustavo Rocha', 'M', '1998-12-12'),
(8, 'Helena Ribeiro', 'F', '2000-04-18'),
(9, 'Igor Mendes', 'M', '2001-09-09'),
(10, 'Juliana Martins', 'F', '2002-06-20');

INSERT INTO Curso_Disciplina (id_disciplina, id_cursos) VALUES
(1, 1), (2, 1), (3, 1), (7, 1), (8, 2), (4, 5), (5, 6), (6, 7), (9, 9), (10, 4);

INSERT INTO Matricula (data_matricula, semestre, id_aluno, id_cursos) VALUES
('2026-02-01', '2026.1', 1, 1),
('2026-02-02', '2026.1', 2, 1),
('2026-02-03', '2026.1', 3, 2),
('2026-02-04', '2026.1', 4, 5),
('2026-02-05', '2026.1', 5, 6),
('2026-02-06', '2026.1', 6, 1),
('2026-02-07', '2026.1', 7, 7),
('2026-02-08', '2026.1', 8, 9),
('2026-02-09', '2026.1', 9, 4),
('2026-02-10', '2026.1', 10, 1);



-- REALIZAR CONSULTAS


-- Alunos homens em CC
SELECT a.nome, a.campus
FROM vw_Alunos_Global as a
INNER JOIN Matricula as m ON a.id_aluno = m.id_aluno 
INNER JOIN Cursos as c ON c.id_cursos = m.id_cursos
WHERE c.nome_curso = 'CC' AND a.sexo = 'M';

-- Alunas mulheres em CC
SELECT a.nome, a.campus
FROM vw_Alunos_Global as a
INNER JOIN Matricula as m ON a.id_aluno = m.id_aluno 
INNER JOIN Cursos as c ON c.id_cursos = m.id_cursos
WHERE c.nome_curso = 'CC' AND a.sexo = 'F';

-- Nome do aluno e do curso matriculado
SELECT a.nome, c.nome_curso, a.campus
FROM vw_Alunos_Global AS a
INNER JOIN Matricula as m ON a.id_aluno = m.id_aluno
INNER JOIN Cursos as c ON c.id_cursos = m.id_cursos;

-- Nome do aluno no semestre 2026.1
SELECT a.nome, m.semestre, a.campus
FROM vw_Alunos_Global as a
INNER JOIN Matricula as m ON a.id_aluno = m.id_aluno 
WHERE m.semestre = '2026.1';

-- Nome do aluno e disciplinas vinculadas ao seu curso
SELECT a.nome, d.nome_disciplina, a.campus
FROM vw_Alunos_Global AS a 
INNER JOIN Matricula AS m ON a.id_aluno = m.id_aluno
INNER JOIN Curso_Disciplina as cd ON m.id_cursos = cd.id_cursos
INNER JOIN Disciplina AS d ON d.id_disciplina = cd.id_disciplina
WHERE m.semestre = '2026.1';