-- Criando o banco de dados
CREATE DATABASE Escola

-- Criando as tabelas
CREATE TABLE Alunos(
    id_aluno int auto_increment primary key,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL
    
);

CREATE TABLE Cursos(
    id_cursos INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL
);

CREATE TABLE Matricula(
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    data_matricula DATE NOT NULL,
    semestre VARCHAR(6) NOT NULL,
    id_aluno INT,
    id_cursos INT,
    UNIQUE(id_aluno, id_cursos)

    FOREIGN KEY (id_aluno) REFERENCES Alunos(id_aluno),
    FOREIGN KEY (id_cursos) REFERENCES Cursos(id_cursos)

);

CREATE TABLE Disciplina(
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(30) NOT NULL

);

CREATE TABLE Curso_Disciplina(
    Id_curso_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    id_disciplina INT NOT NULL,
    id_cursos INT NOT NULL,
    UNIQUE (id_disciplina, id_cursos),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id_disciplina),
    FOREIGN KEY (id_cursos) REFERENCES Cursos(id_cursos)
);


-- INSERINDO OS DADOS
INSERT INTO Cursos (nome_curso) VALUES
('CC'), 
('Engenharia de Software'), 
('Sistemas de Informação'), 
('Administração'), 
('Direito'),
('Medicina'), 
('Engenharia Civil'), 
('Arquitetura'), 
('Psicologia'), 
('Matemática');

INSERT INTO Disciplina (nome_disciplina) VALUES
('Banco de Dados'), 
('Algoritmos e Lógica'), 
('Cálculo I'), 
('Direito Penal'), 
('Anatomia Humana'),
('Física I'), 
('Estruturas de Dados'), 
('Engenharia de Requisitos'), 
('Psicologia Cognitiva'), 
('Gestão de Projetos');

INSERT INTO Alunos (nome, sexo, data_nascimento) VALUES
('Ana Silva', 'F', '2001-05-14'),
('Bruno Souza', 'M', '2000-08-22'),
('Carlos Eduardo', 'M', '1999-11-30'),
('Daniela Costa', 'F', '2002-02-10'),
('Eduardo Lima', 'M', '2001-07-25'),
('Fernanda Alves', 'F', '2003-01-05'),
('Gustavo Rocha', 'M', '1998-12-12'),
('Helena Ribeiro', 'F', '2000-04-18'),
('Igor Mendes', 'M', '2001-09-09'),
('Juliana Martins', 'F', '2002-06-20');

INSERT INTO Curso_Disciplina (id_disciplina, id_cursos) VALUES
(1, 1), -- Banco de Dados -> CC
(2, 1), -- Algoritmos -> CC
(3, 1), -- Cálculo I -> CC
(7, 1), -- Estruturas de Dados -> CC
(8, 2), -- Engenharia de Requisitos -> Engenharia de Software
(4, 5), -- Direito Penal -> Direito
(5, 6), -- Anatomia Humana -> Medicina
(6, 7), -- Física I -> Engenharia Civil
(9, 9), -- Psicologia Cognitiva -> Psicologia
(10, 4); -- Gestão de Projetos -> Administração

INSERT INTO Matricula (data_matricula, semestre, id_aluno, id_cursos) VALUES
('2026-02-01', '2026.1', 1, 1), -- Ana -> CC
('2026-02-02', '2026.1', 2, 1), -- Bruno -> CC
('2026-02-03', '2026.1', 3, 2), -- Carlos -> Eng. Software
('2026-02-04', '2026.1', 4, 5), -- Daniela -> Direito
('2026-02-05', '2026.1', 5, 6), -- Eduardo -> Medicina
('2026-02-06', '2026.1', 6, 1), -- Fernanda -> CC
('2026-02-07', '2026.1', 7, 7), -- Gustavo -> Eng. Civil
('2026-02-08', '2026.1', 8, 9), -- Helena -> Psicologia
('2026-02-09', '2026.1', 9, 4), -- Igor -> Administração
('2026-02-10', '2026.1', 10, 1); -- Juliana -> CC


-- Realizando as consultas no banco de dados

-- alunos
SELECT a.nome
FROM Alunos as a
INNER JOIN Matricula as m
ON a.id_aluno = m.id_aluno 
INNER JOIN Cursos as c 
ON c.id_cursos = m.id_cursos
WHERE c.nome_curso = 'CC' AND a.sexo = 'M';

-- alunas
SELECT a.nome
FROM Alunos as a
INNER JOIN Matricula as m
ON a.id_aluno = m.id_aluno 
INNER JOIN Cursos as c 
ON c.id_cursos = m.id_cursos
WHERE c.nome_curso = 'CC' AND a.sexo = 'F';

-- nome e curso
SELECT a.nome, c.nome_curso
FROM Alunos AS a
INNER JOIN Matricula as m 
ON a.id_aluno = m.id_aluno
INNER JOIN Cursos as c 
ON c.id_cursos = m.id_cursos;

-- nome do alunoo no semestre 2026.1\
SELECT a.nome, m.semestre
FROM Alunos as a
INNER JOIN Matricula as m
ON a.id_aluno = m.id_aluno 
WHERE m.semestre = '2026.1';

-- nome do aluno e disciplina
SELECT a.nome, d.nome_disciplina
FROM Alunos AS a 
INNER JOIN Matricula AS m 
ON a.id_aluno = m.id_aluno
INNER JOIN Curso_Disciplina as cd 
ON m.id_cursos = cd.id_cursos
INNER JOIN Disciplina AS d 
ON d.id_disciplina = cd.id_disciplina
WHERE m.semestre = '2026.1';


