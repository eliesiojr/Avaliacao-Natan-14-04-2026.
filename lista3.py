import mysql.connector
from datetime import date

# lista 3 parte 1
def realizar_matricula(id_matricula, id_aluno, id_disciplina, id_cursos, semestre):
    try:
        #Conexão com o banco de dados (ajuste usuário e senha)
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="123456",
            database="escola"
        )
        cursor = conn.cursor()


        conn.autocommit = False 
        # Verificando se o aluno existe
        cursor.execute("SELECT id_aluno FROM Alunos WHERE id_aluno = %s", (id_aluno,))
        if not cursor.fetchone():
            raise ValueError(f"Aluno {id_aluno} não encontrado.")
        print(f"Aluno {id_aluno} existe.")

        #Verifica se a disciplina existe
        cursor.execute("SELECT id_disciplina FROM Disciplina WHERE id_disciplina = %s", (id_disciplina,))
        if not cursor.fetchone():
            raise ValueError(f"Disciplina {id_disciplina} não encontrada.")
        print(f"Disciplina {id_disciplina} existe.")

        # Insere a matrícula em Matricula
        data_atual = date.today()
        query_insert = """
            INSERT INTO Matricula (id_matricula,data_matricula, semestre, id_aluno, id_cursos)
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query_insert, (id_matricula, data_atual, semestre, id_aluno, id_cursos))
        print("Matrícula inserida na memória da transação.")

        # Confirma com commit
        conn.commit()
        print("Transação concluída.")

    except Exception as e:
        # Se ocorrer erro em qualquer etapa, executar rollback
        if 'conn' in locals() and conn.is_connected():
            conn.rollback()
            print(f"ERRO! Rollback executado. Motivo: {e}")

    finally:
        # Fecha os cursores e a conexão
        if 'cursor' in locals(): cursor.close()
        if 'conn' in locals() and conn.is_connected(): conn.close()


def realizar_matricula_erro(id_aluno, id_disciplina, id_cursos, semestre):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="123456", 
            database="escola"
        )
        cursor = conn.cursor()
        conn.autocommit = False 

        cursor.execute("SELECT id_aluno FROM Alunos WHERE id_aluno = %s", (id_aluno,))
        if not cursor.fetchone(): raise ValueError("Aluno não encontrado.")
        
        cursor.execute("SELECT id_disciplina FROM Disciplina WHERE id_disciplina = %s", (id_disciplina,))
        if not cursor.fetchone(): raise ValueError("Disciplina não encontrada.")

        #Insere a matrícula
        data_atual = date.today()
        query_insert = "INSERT INTO Matricula (data_matricula, semestre, id_aluno, id_cursos) VALUES (%s, %s, %s, %s)"
        cursor.execute(query_insert, (data_atual, 2026.1, 12, 12))
        print("INSERT foi executado no banco.")


        # Confirma com commit
        conn.commit()

    except Exception as e:
        if 'conn' in locals() and conn.is_connected():
            conn.rollback()
            print(f"ERRO! Rollback executado. A matrícula foi cancelada. Motivo: {e}")

    finally:
        if 'cursor' in locals(): cursor.close()
        if 'conn' in locals() and conn.is_connected(): conn.close()

        # --- Execução do Programa ---

# Teste 1: Caminho feliz
print("TESTE 1: SUCESSO")
realizar_matricula(id_matricula=1,id_aluno=1, id_disciplina=1, id_cursos=1, semestre='2026.1')

# # Teste 2: Caminho com erro
print("\nTESTE 2: ERRO PROPOSITAL")
realizar_matricula_erro(id_aluno=1, id_disciplina=1, id_cursos=1, semestre='2026.1')

# lista 3 parte 2
def conectar():
    # Conexão direta dentro da função
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="123456", 
        database="escola"
    )

def listar_alunos():
    print("\n--- 1. LISTA DE ALUNOS ---")
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT id_aluno, nome, sexo FROM Alunos")
    for aluno in cursor.fetchall():
        print(f"ID: {aluno[0]} | Nome: {aluno[1]} | Sexo: {aluno[2]}")
    conn.close()

def listar_disciplinas():
    print("\n--- 2. LISTA DE DISCIPLINAS ---")
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT id_disciplina, nome_disciplina FROM Disciplina")
    for disc in cursor.fetchall():
        print(f"ID: {disc[0]} | Disciplina: {disc[1]}")
    conn.close()

def listar_matriculas_semestre(semestre):
    print(f"\n--- 3. MATRÍCULAS DO SEMESTRE {semestre} ---")
    conn = conectar()
    cursor = conn.cursor()
    query = """
        SELECT m.id_matricula, a.nome, c.nome_curso 
        FROM Matricula m
        INNER JOIN Alunos a ON m.id_aluno = a.id_aluno
        INNER JOIN Cursos c ON m.id_cursos = c.id_cursos
        WHERE m.semestre = %s
    """
    cursor.execute(query, (semestre,))
    resultados = cursor.fetchall()
    
    if not resultados:
        print("Nenhuma matrícula encontrada para este semestre.")
    for linha in resultados:
        print(f"Matrícula Nº {linha[0]} | Aluno: {linha[1]} | Curso: {linha[2]}")
    conn.close()

def consultar_matricula_aluno(id_aluno):
    print(f"\n--- 4. CONSULTA DE MATRÍCULAS DO ALUNO (ID: {id_aluno}) ---")
    conn = conectar()
    cursor = conn.cursor()
    query = """
        SELECT m.id_matricula, m.semestre, c.nome_curso, m.data_matricula
        FROM Matricula m
        INNER JOIN Cursos c ON m.id_cursos = c.id_cursos
        WHERE m.id_aluno = %s
    """
    cursor.execute(query, (id_aluno,))
    resultados = cursor.fetchall()
    
    if not resultados:
        print("Este aluno não possui matrículas.")
    for linha in resultados:
        print(f"Matrícula Nº {linha[0]} | Semestre: {linha[1]} | Curso: {linha[2]} | Data: {linha[3]}")
    conn.close()

# --- Execução dos Testes ---
listar_alunos()
listar_disciplinas()
listar_matriculas_semestre('2026.1')
consultar_matricula_aluno(1)




# CANCELAMENTO DA MATRICULA
def cancelar_matricula(id_matricula_alvo):
    try:
        # Conexão direta dentro do try
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="123456", 
            database="escola"
        )
        cursor = conn.cursor()
        
        conn.autocommit = False 
        print(f"\n--- Iniciando Transação de Cancelamento (Matrícula: {id_matricula_alvo}) ---")

        # 1. Localizar a matrícula do aluno
        cursor.execute("SELECT id_matricula FROM Matricula WHERE id_matricula = %s", (id_matricula_alvo,))
        if not cursor.fetchone():
            raise ValueError(f"Matrícula {id_matricula_alvo} não existe no banco de dados.")

        # 2. Remover a matrícula
        cursor.execute("DELETE FROM Matricula WHERE id_matricula = %s", (id_matricula_alvo,))
        print("Matrícula removida na memória da transação.")

        # 3. Confirmar a operação com commit
        conn.commit()
        print("Transação confirmada. Cancelamento salvo com sucesso!")

    except Exception as e:
        # Se ocorrer erro, executa o Rollback
        if 'conn' in locals() and conn.is_connected():
            conn.rollback()
            print(f"ERRO! Rollback executado. Transação desfeita. Motivo: {e}")

    finally:
        # Fecha as conexões
        if 'cursor' in locals(): cursor.close()
        if 'conn' in locals() and conn.is_connected(): conn.close()

# --- Execução dos Testes ---
cancelar_matricula(id_matricula_alvo=1)
cancelar_matricula(id_matricula_alvo=9999)