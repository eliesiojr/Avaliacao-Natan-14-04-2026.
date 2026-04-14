import mysql.connector
from datetime import date
import subprocess

# OBS: a Função de realizar backup com o mysqldump pode não funcionar pois no python nao achei uma biblioteca que utilize essa função,
# de forma que para ela funcionar eu precisei passar o caminho do mysqldump direto no codigo.


# CONEXÃO

def conectar(usar_banco=True):
    try:
        if usar_banco:
            return mysql.connector.connect(host="localhost", user="root", password="123456", database="escola")
        return mysql.connector.connect(host="localhost", user="root", password="123456")
    except mysql.connector.Error as err:
        print(f"[ERRO DE CONEXÃO] {err}")
        return None

# TRANSAÇÕES


def realizar_matricula_distribuida(id_matricula, id_aluno, id_disciplina, id_cursos, semestre):
    conn = conectar()
    if not conn: return
    try:
        cursor = conn.cursor()
        conn.autocommit = False 
        
        print("\n[2PC - FASE 1] Preparando Transação...")
        cursor.execute("SELECT id_aluno FROM vw_Alunos_Global WHERE id_aluno = %s", (id_aluno,))
        if not cursor.fetchone():
            raise ValueError(f"Aluno {id_aluno} não encontrado na rede distribuída (Visão Global).")
        
        cursor.execute("SELECT vagas FROM Disciplina WHERE id_disciplina = %s FOR UPDATE", (id_disciplina,))
        res = cursor.fetchone()
        if not res or res[0] <= 0:
            raise ValueError(f"Vagas esgotadas ou disciplina {id_disciplina} inexistente.")

        print("[2PC - FASE 2] Efetivando Commit Global...")
        
        query_mat = "INSERT INTO Matricula (id_matricula, data_matricula, semestre, id_aluno, id_cursos) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(query_mat, (id_matricula, date.today(), semestre, id_aluno, id_cursos))
        
        cursor.execute("UPDATE Disciplina SET vagas = vagas - 1 WHERE id_disciplina = %s", (id_disciplina,))
        
        conn.commit()
        print("[SUCESSO] Matrícula realizada em todos os nós.")

    except Exception as e:
        if conn: conn.rollback()
        print(f"[FALHA] Rollback Global executado. Motivo: {e}")
    finally:
        conn.close()

def cancelar_matricula(id_matricula_alvo):
    conn = conectar()
    if not conn: return
    try:
        cursor = conn.cursor()
        conn.autocommit = False 
        cursor.execute("SELECT id_matricula FROM Matricula WHERE id_matricula = %s", (id_matricula_alvo,))
        if not cursor.fetchone():
            raise ValueError("Matrícula não localizada.")

        cursor.execute("DELETE FROM Matricula WHERE id_matricula = %s", (id_matricula_alvo,))
        conn.commit()
        print(f"[OK] Matrícula {id_matricula_alvo} cancelada.")
    except Exception as e:
        if conn: conn.rollback()
        print(f"[ERRO] Falha ao cancelar: {e}")
    finally:
        conn.close()


# CONSULTAS


def listar_alunos():
    print("\n--- ALUNOS (VISÃO GLOBAL: GOIANÉSIA + ANÁPOLIS) ---")
    conn = conectar()
    if not conn: return
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM vw_Alunos_Global")
    for a in cursor.fetchall():
        print(f"ID: {a[0]} | Nome: {a[1]} | Sexo: {a[2]} | Campus: {a[3]}")
    conn.close()

def listar_disciplinas():
    print("\n--- DISCIPLINAS E VAGAS ---")
    conn = conectar()
    if not conn: return
    cursor = conn.cursor()
    cursor.execute("SELECT id_disciplina, nome_disciplina, vagas FROM Disciplina")
    for d in cursor.fetchall():
        print(f"ID: {d[0]} | Nome: {d[1]} | Vagas: {d[2]}")
    conn.close()

def listar_matriculas_por_semestre(semestre):
    print(f"\n--- MATRÍCULAS DO SEMESTRE: {semestre} ---")
    conn = conectar()
    if not conn: return
    try:
        cursor = conn.cursor()
        query = """
            SELECT m.id_matricula, a.nome, c.nome_curso, m.data_matricula
            FROM Matricula m
            INNER JOIN vw_Alunos_Global a ON m.id_aluno = a.id_aluno
            INNER JOIN Cursos c ON m.id_cursos = c.id_cursos
            WHERE m.semestre = %s
        """
        cursor.execute(query, (semestre,))
        res = cursor.fetchall()
        if not res:
            print("Nenhum registro encontrado para este período.")
        else:
            for m in res:
                print(f"Matrícula: {m[0]} | Aluno: {m[1]} | Curso: {m[2]} | Data: {m[3]}")
    finally:
        conn.close()

def consultar_matricula_aluno(id_aluno):
    print(f"\n--- MATRÍCULAS DO ALUNO ID: {id_aluno} ---")
    conn = conectar()
    if not conn: return
    cursor = conn.cursor()
    query = """
        SELECT m.id_matricula, m.semestre, c.nome_curso
        FROM Matricula m
        INNER JOIN Cursos c ON m.id_cursos = c.id_cursos
        WHERE m.id_aluno = %s
    """
    cursor.execute(query, (id_aluno,))
    resultados = cursor.fetchall()
    if not resultados:
        print("Este aluno não possui matrículas.")
    for m in resultados:
        print(f"Matrícula: {m[0]} | Semestre: {m[1]} | Curso: {m[2]}")
    conn.close()


#  BACKUP E RECUPERAÇÃO

def realizar_backup():
    try:
        print("\n--- Iniciando Backup ---")
        caminho_mysqldump = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"
        with open("backup_escola.sql", "w") as f:
            subprocess.run([caminho_mysqldump, "-u", "root", "-p123456", "escola"], stdout=f, check=True)
        print("[RECUPERAÇÃO] Arquivo 'backup_escola.sql' gerado com sucesso.")
    except Exception as e: 
        print(f"Erro no backup: {e}")

def simular_falha_e_restaurar():
    print("\n--- Restaurando Sistema ---")
    try:
        conn = conectar(usar_banco=False)
        cursor = conn.cursor()
        print("[RECUPERAÇÃO] Apagando banco de dados atual...")
        cursor.execute("DROP DATABASE IF EXISTS escola")
        cursor.execute("CREATE DATABASE escola")
        conn.commit()
        conn.close()
        
        print("[RECUPERAÇÃO] Restaurando dados a partir do arquivo SQL...")
        caminho_mysql = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
        cmd = f'"{caminho_mysql}" -u root -p123456 escola < backup_escola.sql'
        subprocess.run(cmd, shell=True, check=True)
        print("[RECUPERAÇÃO] Banco restaurado com sucesso! Tudo voltou ao normal.")
    except Exception as e: 
        print(f"Erro na restauração: {e}")


# MENU PRINCIPAL (MAIN)


def main():
    while True:
        print("\n" + "="*50)
        print("      SISTEMA ACADÊMICO DISTRIBUÍDO (GOI/ANA)     ")
        print("="*50)
        print(" TRANSAÇÕES")
        print(" [1] Realizar Matrícula")
        print(" [2] Cancelar Matrícula")
        print("\n CONSULTAS")
        print(" [3] Listar Alunos (Visão Global)")
        print(" [4] Listar Disciplinas e Vagas")
        print(" [5] Buscar Matrículas por Semestre")
        print(" [6] Consultar Matrículas de um Aluno Específico")
        print("\n RECUPERAÇÃO ")
        print(" [7] Gerar Backup do Sistema (.sql)")
        print(" [8] Simular Falha e Restaurar Banco")
        print("\n [0] Sair")
        print("="*50)
        
        op = input("Selecione uma opção: ")

        match op:
            case '1':
                try:
                    id_m = int(input("ID da Matrícula (Crie um número): "))
                    id_a = int(input("ID do Aluno: "))
                    id_c = int(input("ID do Curso: "))
                    id_d = int(input("ID da Disciplina: "))
                    sem = input("Semestre (Ex: 2026.1): ")
                    realizar_matricula_distribuida(id_m, id_a, id_d, id_c, sem)
                except ValueError:
                    print("Erro: Verifique se os IDs digitados são números válidos.")
            
            case '2':
                try:
                    id_m = int(input("ID da Matrícula a ser cancelada: "))
                    cancelar_matricula(id_m)
                except ValueError: 
                    print("Erro: ID inválido.")
            
            case '3':
                listar_alunos()
            
            case '4':
                listar_disciplinas()
            
            case '5':
                sem = input("Digite o semestre desejado (Ex: 2026.1): ")
                listar_matriculas_por_semestre(sem)
            
            case '6':
                try:
                    id_a = int(input("ID do Aluno: "))
                    consultar_matricula_aluno(id_a)
                except ValueError:
                    print("Erro: ID inválido.")
            
            case '7':
                realizar_backup()
            
            case '8':
                simular_falha_e_restaurar()
            
            case '0':
                print("Encerrando o sistema...")
                break
            
            case _:
                print("Opção inválida! Escolha um número do menu.")

if __name__ == "__main__":
    main()