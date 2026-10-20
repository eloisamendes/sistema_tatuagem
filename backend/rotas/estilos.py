from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from database import conectar

router = APIRouter()

class Estilo(BaseModel):
    descricao: str  

@router.get("")
def listar_estilos():
    conn = conectar()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM estilo")
    estilos = cursor.fetchall()
    conn.close()
    return estilos

@router.get("/{id}")
def buscar_estilo(id: int):
    conn = conectar()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM estilo WHERE idestilo = %s", (id,))
    estilo = cursor.fetchone()
    conn.close()
    if not estilo:
        raise HTTPException(status_code=404, detail="Estilo não encontrado")
    return estilo

@router.post("")
def criar_estilo(estilo: Estilo):
    conn = conectar()
    cursor = conn.cursor(dictionary=True)
    
    # 1. Padroniza o texto (remove espaços extras)
    descricao_limpa = estilo.descricao.strip()
    
    # 2. Verifica se já existe um estilo com essa mesma descrição (ignorando maiúsculas/minúsculas)
    cursor.execute("SELECT * FROM estilo WHERE LOWER(descricao) = LOWER(%s)", (descricao_limpa,))
    existente = cursor.fetchone()
    
    if existente:
        conn.close()
        raise HTTPException(status_code=400, detail="Este estilo já está cadastrado!")
    
    # 3. Se não existir, insere
    cursor.execute("INSERT INTO estilo (descricao) VALUES (%s)", (descricao_limpa,))
    conn.commit()
    conn.close()
    return {"mensagem": "Estilo cadastrado com sucesso"}

@router.put("/{id}")
def atualizar_estilo(id: int, estilo: Estilo):
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("UPDATE estilo SET descricao=%s WHERE idestilo=%s", (estilo.descricao.strip(), id))
    conn.commit()
    conn.close()
    return {"mensagem": "Estilo atualizado com sucesso"}

@router.delete("/{id}")
def deletar_estilo(id: int):
    conn = conectar()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM estilo WHERE idestilo = %s", (id,))
        conn.commit()
        conn.close()
        return {"mensagem": "Estilo deletado com sucesso"}
    except Exception as erro:
        conn.rollback()
        conn.close()
        raise HTTPException(status_code=400, detail="Não foi possível excluir este estilo. Verifique se algum tatuador já foi marcado com ele.")