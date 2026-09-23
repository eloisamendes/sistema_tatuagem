from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
# Importa todos os módulos de rotas juntos em uma única linha:
from rotas import clientes, senioridade, tatuadores, agendamentos

# 1. Primeiro cria a aplicação FastAPI:
app = FastAPI()

# 2. Configura o middleware de CORS:
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. Registra todas as rotas depois que o 'app' já existe:
app.include_router(clientes.router)
app.include_router(senioridade.router)
app.include_router(tatuadores.router)
app.include_router(agendamentos.router)


@app.get("/")
def inicio():
    return {"mensagem": "API do estúdio de tatuagem funcionando!"}