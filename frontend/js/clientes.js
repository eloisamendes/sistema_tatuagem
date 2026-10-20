const API = 'http://127.0.0.1:8000'
protegerPagina() // bloqueia a página se não tiver login

const formCliente = document.getElementById('form-cliente')
const botaoSubmit = document.getElementById('btn-submit-cliente')

function limparFormulario() {
  formCliente.reset()
  delete formCliente.dataset.idCliente
  botaoSubmit.textContent = 'Cadastrar'
  botaoSubmit.classList.remove('btn-success')
  botaoSubmit.classList.add('btn-primary')
}

async function listarClientes() {
  try {
    const resposta = await fetchAutenticado(`${API}/clientes`)
    const clientes = await resposta.json()

    const corpo = document.getElementById('corpo-tabela')
    corpo.innerHTML = ''

    clientes.forEach(c => {
      corpo.innerHTML += `
        <tr>
          <td>${c.idcliente}</td>
          <td>${c.nome}</td>
          <td>${c.cpf}</td>
          <td>${c.telefone ?? '-'}</td>
          <td>${c.cidade ?? '-'}</td>
          <td>${c.uf ?? '-'}</td>
          <td>
            <button class="btn btn-sm btn-warning me-2" onclick='preencherFormularioEdicao(${JSON.stringify(c)})'>Editar</button>
            <button class="btn btn-sm btn-danger" onclick="deletarCliente(${c.idcliente})">Excluir</button>
          </td>
        </tr>`
    })
  } catch (error) {
    console.error('Erro ao listar clientes:', error)
  }
}

listarClientes()

formCliente.addEventListener('submit', async (e) => {
  e.preventDefault()

  // Evita múltiplos cliques desativando o botão temporariamente
  botaoSubmit.disabled = true
  const textoOriginal = botaoSubmit.textContent
  botaoSubmit.textContent = 'Salvando...'

  const cliente = {
    nome: document.getElementById('nome').value.trim(),
    cpf: document.getElementById('cpf').value.trim(),
    telefone: document.getElementById('telefone').value.trim() || null,
    datacadastro: new Date().toISOString().split('T')[0],
    cidade: document.getElementById('cidade').value.trim() || null,
    uf: document.getElementById('uf').value.trim().toUpperCase() || null
  }

  const idCliente = formCliente.dataset.idCliente

  try {
    let resposta;
    if (idCliente) {
      resposta = await fetchAutenticado(`${API}/clientes/${idCliente}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(cliente)
      })
    } else {
      resposta = await fetchAutenticado(`${API}/clientes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(cliente)
      })
    }

    if (!resposta.ok) {
      const erroDados = await resposta.json()
      alert(erroDados.detail || 'Erro ao salvar cliente.')
      return
    }

    limparFormulario()
    await listarClientes()
  } catch (error) {
    console.error('Erro ao salvar cliente:', error)
    alert('Ocorreu um erro de conexão ao salvar o cliente.')
  } finally {
    botaoSubmit.disabled = false
    botaoSubmit.textContent = textoOriginal
  }
})

function preencherFormularioEdicao(cliente) {
  document.getElementById('nome').value = cliente.nome || ''
  document.getElementById('cpf').value = cliente.cpf || ''
  document.getElementById('telefone').value = cliente.telefone || ''
  document.getElementById('cidade').value = cliente.cidade || ''
  document.getElementById('uf').value = cliente.uf || ''

  formCliente.dataset.idCliente = cliente.idcliente
  botaoSubmit.textContent = 'Salvar alteração'
  botaoSubmit.classList.remove('btn-primary')
  botaoSubmit.classList.add('btn-success')
}

async function deletarCliente(id) {
  if (!confirm('Tem certeza que deseja excluir este cliente?')) return

  try {
    const resposta = await fetchAutenticado(`${API}/clientes/${id}`, { method: 'DELETE' })
    if (!resposta.ok) {
      const erroDados = await resposta.json()
      alert(erroDados.detail || 'Erro ao excluir.')
      return
    }
    listarClientes()
  } catch (error) {
    console.error('Erro ao deletar cliente:', error)
  }
}