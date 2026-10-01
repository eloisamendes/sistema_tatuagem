// Endereço da API backend
const API = 'http://127.0.0.1:8000'

// Elementos do formulário e do botão de enviar
const formAgendamento = document.getElementById('form-agendamento')
const botaoSubmit = document.getElementById('btn-submit-agendamento')
const blocoStatus = document.getElementById('bloco-status')

// Limpa o formulário e devolve para o modo de cadastro
function limparFormulario() {
  formAgendamento.reset()
  delete formAgendamento.dataset.idAgendamento
  botaoSubmit.textContent = 'Cadastrar'
  botaoSubmit.classList.remove('btn-success')
  botaoSubmit.classList.add('btn-primary')
  blocoStatus.style.display = 'none'   // Esconde o status de novo
}

// ─── Busca os clientes na API e preenche o <select> ───
async function carregarClientes() {
  try {
    const resposta = await fetch(`${API}/clientes`)
    const clientes = await resposta.json()

    const select = document.getElementById('idcliente')
    select.innerHTML = '<option value="">Cliente...</option>'

    clientes.forEach(c => {
      select.innerHTML += `<option value="${c.idcliente}">${c.nome}</option>`
    })
  } catch (erro) {
    console.error('Erro ao carregar clientes:', erro)
  }
}

// ─── Busca os tatuadores na API e preenche o <select> ───
async function carregarTatuadores() {
  try {
    const resposta = await fetch(`${API}/tatuadores`)
    const tatuadores = await resposta.json()

    const select = document.getElementById('idtatuador')
    select.innerHTML = '<option value="">Tatuador...</option>'

    tatuadores.forEach(t => {
      select.innerHTML += `<option value="${t.idtatuador}">${t.nometatuador}</option>`
    })
  } catch (erro) {
    console.error('Erro ao carregar tatuadores:', erro)
  }
}

carregarClientes()
carregarTatuadores()

// ─── Carrega a lista de agendamentos ao abrir a página ───
async function listarAgendamentos() {
  try {
    const resposta = await fetch(`${API}/agendamentos`)
    const agendamentos = await resposta.json()

    const corpo = document.getElementById('corpo-tabela')
    corpo.innerHTML = '' // Limpa completamente o conteúdo anterior para evitar duplicações de renderização

    agendamentos.forEach(a => {
      // se existir um desenho salvo, monta uma miniatura; senão, mostra "-"
      const imagemHtml = a.desenhoaprovado
        ? `<img src="${API}/uploads/${a.desenhoaprovado}" style="max-width: 60px; max-height: 60px;">`
        : '-'

      const tr = document.createElement('tr')
      tr.innerHTML = `
        <td>${a.idagendamento}</td>
        <td>${a.cliente}</td>
        <td>${a.tatuador}</td>
        <td>${a.dataagendamento}</td>
        <td>${a.horaagendamento}</td>
        <td>${a.valortatuagem ? `R$ ${Number(a.valortatuagem).toFixed(2)}` : '-'}</td>
        <td>${a.status}</td>
        <td>${imagemHtml}</td>
        <td>
          <button class="btn btn-sm btn-warning me-2" onclick='preencherFormularioEdicao(${JSON.stringify(a)})'>Editar</button>
          <button class="btn btn-sm btn-danger" onclick="deletarAgendamento(${a.idagendamento})">Excluir</button>
        </td>`
      corpo.appendChild(tr)
    })
  } catch (erro) {
    console.error('Erro ao listar agendamentos:', erro)
  }
}

listarAgendamentos()

// ─── Cadastrar e atualizar agendamentos ───
formAgendamento.addEventListener('submit', async (e) => {
  e.preventDefault()

  const agendamento = {
    idcliente: Number(document.getElementById('idcliente').value),
    idtatuador: Number(document.getElementById('idtatuador').value),
    dataagendamento: document.getElementById('dataagendamento').value,
    horaagendamento: document.getElementById('horaagendamento').value,
    descricaotatuagem: document.getElementById('descricaotatuagem').value || null,
    valortatuagem: document.getElementById('valortatuagem').value
      ? Number(document.getElementById('valortatuagem').value)
      : null,
    status: document.getElementById('status').value
  }

  const idAgendamento = formAgendamento.dataset.idAgendamento
  let idParaUpload = idAgendamento   // qual id vamos usar pra anexar a imagem, se houver uma

  if (idAgendamento) {
    await fetch(`${API}/agendamentos/${idAgendamento}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(agendamento)
    })
  } else {
    const resposta = await fetch(`${API}/agendamentos`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(agendamento)
    })
    const dados = await resposta.json()
    idParaUpload = dados.idagendamento   // pega o id que acabou de ser criado
  }

  // ─── Se um arquivo foi escolhido, envia numa segunda chamada, separada ───
  const arquivo = document.getElementById('desenho').files[0]
  if (arquivo) {
    const formData = new FormData()   // FormData, não JSON — porque tem um arquivo dentro
    formData.append('arquivo', arquivo)   // "arquivo" precisa ser o mesmo nome do parâmetro no FastAPI

    await fetch(`${API}/agendamentos/${idParaUpload}/desenho`, {
      method: 'POST',
      body: formData
      // repare que aqui NÃO colocamos o header Content-Type — o navegador
      // define esse cabeçalho sozinho quando o corpo é um FormData
    })
  }

  limparFormulario()
  listarAgendamentos()
})

// ─── Abre os dados do agendamento no formulário para edição ───
function preencherFormularioEdicao(agendamento) {
  document.getElementById('idcliente').value = agendamento.idcliente
  document.getElementById('idtatuador').value = agendamento.idtatuador
  document.getElementById('dataagendamento').value = agendamento.dataagendamento
  document.getElementById('horaagendamento').value = agendamento.horaagendamento
  document.getElementById('descricaotatuagem').value = agendamento.descricaotatuagem || ''
  document.getElementById('valortatuagem').value = agendamento.valortatuagem || ''

  document.getElementById('status').value = agendamento.status
  blocoStatus.style.display = 'block'   // Exibe o campo de status apenas na edição

  formAgendamento.dataset.idAgendamento = agendamento.idagendamento

  botaoSubmit.textContent = 'Salvar alteração'
  botaoSubmit.classList.remove('btn-primary')
  botaoSubmit.classList.add('btn-success')
}

// ─── Exclui um agendamento ───
async function deletarAgendamento(id) {
  if (!confirm('Tem certeza que deseja excluir este agendamento?')) return

  try {
    await fetch(`${API}/agendamentos/${id}`, { method: 'DELETE' })
    await listarAgendamentos()
  } catch (erro) {
    console.error('Erro ao deletar agendamento:', erro)
  }
}