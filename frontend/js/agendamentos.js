const API = 'http://127.0.0.1:8000'
protegerPagina()   // bloqueia a página se não tiver login

const formAgendamento = document.getElementById('form-agendamento')
const botaoSubmit = document.getElementById('btn-submit-agendamento')
const blocoStatus = document.getElementById('bloco-status')

function limparFormulario() {
  formAgendamento.reset()
  delete formAgendamento.dataset.idAgendamento
  botaoSubmit.textContent = 'Cadastrar'
  botaoSubmit.classList.remove('btn-success')
  botaoSubmit.classList.add('btn-primary')
  blocoStatus.style.display = 'none'
}

async function carregarClientes() {
  try {
    const resposta = await fetchAutenticado(`${API}/clientes`)
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

async function carregarTatuadores() {
  try {
    const resposta = await fetchAutenticado(`${API}/tatuadores`)
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

async function listarAgendamentos() {
  try {
    const resposta = await fetchAutenticado(`${API}/agendamentos`)
    const agendamentos = await resposta.json()

    const corpo = document.getElementById('corpo-tabela')
    corpo.innerHTML = ''

    agendamentos.forEach(a => {
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
        <td>${a.status ?? '-'}</td>
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

formAgendamento.addEventListener('submit', async (e) => {
  e.preventDefault()

  // Trava o botão para evitar cliques duplos que duplicam o cadastro
  botaoSubmit.disabled = true
  const textoOriginal = botaoSubmit.textContent
  botaoSubmit.textContent = 'Salvando...'

  const agendamento = {
    idcliente: Number(document.getElementById('idcliente').value),
    idtatuador: Number(document.getElementById('idtatuador').value),
    dataagendamento: document.getElementById('dataagendamento').value,
    horaagendamento: document.getElementById('horaagendamento').value,
    descricaotatuagem: document.getElementById('descricaotatuagem').value.trim() || null,
    valortatuagem: document.getElementById('valortatuagem').value
      ? Number(document.getElementById('valortatuagem').value)
      : null,
    status: document.getElementById('status').value || null
  }

  const idAgendamento = formAgendamento.dataset.idAgendamento
  let idParaUpload = idAgendamento

  try {
    if (idAgendamento) {
      await fetchAutenticado(`${API}/agendamentos/${idAgendamento}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(agendamento)
      })
    } else {
      const resposta = await fetchAutenticado(`${API}/agendamentos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(agendamento)
      })
      const dados = await resposta.json()
      idParaUpload = dados.idagendamento
    }

    const arquivo = document.getElementById('desenho').files[0]
    if (arquivo && idParaUpload) {
      const formData = new FormData()
      formData.append('arquivo', arquivo)

      await fetchAutenticado(`${API}/agendamentos/${idParaUpload}/desenho`, {
        method: 'POST',
        body: formData
      })
    }

    limparFormulario()
    await listarAgendamentos()
  } catch (erro) {
    console.error('Erro ao salvar agendamento:', erro)
    alert('Ocorreu um erro ao salvar o agendamento.')
  } finally {
    // Reativa o botão no final de tudo (com sucesso ou erro)
    botaoSubmit.disabled = false
    botaoSubmit.textContent = textoOriginal
  }
})

function preencherFormularioEdicao(agendamento) {
  document.getElementById('idcliente').value = agendamento.idcliente
  document.getElementById('idtatuador').value = agendamento.idtatuador
  document.getElementById('dataagendamento').value = agendamento.dataagendamento
  document.getElementById('horaagendamento').value = agendamento.horaagendamento
  document.getElementById('descricaotatuagem').value = agendamento.descricaotatuagem || ''
  document.getElementById('valortatuagem').value = agendamento.valortatuagem || ''
  document.getElementById('status').value = agendamento.status || 'Pendente'

  blocoStatus.style.display = 'block'
  formAgendamento.dataset.idAgendamento = agendamento.idagendamento

  botaoSubmit.textContent = 'Salvar alteração'
  botaoSubmit.classList.remove('btn-primary')
  botaoSubmit.classList.add('btn-success')
}

async function deletarAgendamento(id) {
  if (!confirm('Tem certeza que deseja excluir este agendamento?')) return

  try {
    await fetchAutenticado(`${API}/agendamentos/${id}`, { method: 'DELETE' })
    await listarAgendamentos()
  } catch (erro) {
    console.error('Erro ao deletar agendamento:', erro)
  }
}