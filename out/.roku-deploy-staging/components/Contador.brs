'***************************************************************
'* Inicializa a interface do componente Contador e o timer.
'*
'* - Observa os campos "visible" e "focusedChild" para mudanças.
'* - Busca e configura os nós de UI: fundo, relogio e tituloSessao.
'* - Define dimensões, alinhamento, fonte e visibilidade de cada nó com base no retângulo delimitador do componente.
'* - Configura um timer repetitivo para atualizar o relógio a cada segundo.
'* - Inicializa o texto do título da sessão.
'*
'* Sem parâmetros.
'* Sem valor de retorno.
'***************************************************************
sub init()
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "onFocusChange")
  m.fundo = m.top.findNode("fundo")
  m.relogio = m.top.findNode("relogio")
  m.tituloSessao = m.top.findNode("tituloSessao")
  m.data = m.top.findNode("tituloSessao")
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.visible = true
  m.relogio.width = largura
  m.relogio.height = 0.15 * altura
  m.relogio.horizAlign = "center"
  m.relogio.vertAlign = "top"
  m.relogio.translation = [0, 0.10 * altura]
  m.relogio.visible = true
  m.relogio.font = "font:ExtraLargeBoldSystemFont"
  ' Responsividade: 120 px padrão, mas diminui proporcionalmente em telas pequenas, nunca menor que 60 px
  relogioFontSize = int(0.10 * altura)
  if relogioFontSize > 120 then
    relogioFontSize = 120
  else if relogioFontSize < 60 then
    relogioFontSize = 60
  end if
  m.relogio.font.size = relogioFontSize
  atualizaRelogio()
  ' Responsividade do título
  tituloLargura = 0.90 * largura
  tituloAltura = 0.15 * altura
  tituloFontSize = int(0.07 * altura)
  if tituloFontSize > 64 then
    tituloFontSize = 64
  else if tituloFontSize < 32 then
    tituloFontSize = 32
  end if
  m.tituloSessao.width = tituloLargura
  m.tituloSessao.height = tituloAltura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  m.tituloSessao.translation = [0.05 * largura, 0.27 * altura]
  m.tituloSessao.visible = true
  m.tituloSessao.font = "font:LargeBoldSystemFont"
  m.tituloSessao.font.size = tituloFontSize
  m.tituloSessao.text = "Centro de treinamento GfTeam praça das nações"
  ' Responsividade da data
  dataLargura = 0.90 * largura
  dataAltura = 0.10 * altura
  dataFontSize = int(0.045 * altura)
  if dataFontSize > 36 then
    dataFontSize = 36
  else if dataFontSize < 20 then
    dataFontSize = 20
  end if
  m.data.width = dataLargura
  m.data.height = dataAltura
  m.data.horizAlign = "center"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.40 * altura]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = dataFontSize
  m.data.text = "T de teste" ' Defina o texto da data conforme necessário
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.observeField("fire", "atualizaRelogio")
  m.top.appendChild(m.timer)
  m.timer.control = "start"
end sub

' Atualiza o texto do relógio na interface com a hora e minuto atuais do sistema.
' Obtém a data e hora atual, ajusta para o fuso horário local da TV,
' formata a hora e o minuto para sempre terem dois dígitos,
' e atualiza a propriedade 'text' do componente 'relogio' com o valor no formato "HH:MM".
' Não recebe parâmetros e não retorna valor.
sub atualizaRelogio()
  agora = CreateObject("roDateTime")
  agora.ToLocalTime() ' Ajusta para o fuso horário configurado na TV do usuário
  hora = agora.GetHours().ToStr()
  if hora.len() = 1 then hora = "0" + hora
  minuto = agora.GetMinutes().ToStr()
  if minuto.len() = 1 then minuto = "0" + minuto
  m.relogio.text = hora + ":" + minuto
end sub

'**************************************************************
'* onVisibleChange
'* 
'* Manipula o evento de mudança de visibilidade do componente.
'* Quando o componente se torna visível, esta sub-rotina:
'*   - Busca e atribui referências aos nós "fundo", "relogio" e "tituloSessao".
'*   - Define o foco para o componente principal.
'*   - Ajusta a largura e altura do fundo ("fundo") para coincidir com o retângulo delimitador do componente.
'*   - Configura o nó "relogio" (relógio) com tamanho, alinhamento, translação, visibilidade e fonte.
'*   - Chama atualizaRelogio() para atualizar o relógio.
'*   - Configura o nó "tituloSessao" (título da sessão) com tamanho, alinhamento, translação, visibilidade, fonte e texto.
'* 
'* Isso garante que os elementos da interface estejam corretamente dimensionados, posicionados e estilizados sempre que o componente se tornar visível.
'**************************************************************
sub onVisibleChange()
  if m.top.visible
    m.fundo = m.top.findNode("fundo")
    m.relogio = m.top.findNode("relogio")
    m.tituloSessao = m.top.findNode("tituloSessao")
    m.top.setFocus(true)
    largura = m.top.boundingRect().width
    altura = m.top.boundingRect().height
    m.fundo.width = largura
    m.fundo.height = altura
    m.fundo.visible = true
    m.relogio.width = largura
    m.relogio.height = 0.15 * altura
    m.relogio.horizAlign = "center"
    m.relogio.vertAlign = "top"
    m.relogio.translation = [0, 0.10 * altura]
    m.relogio.visible = true
    m.relogio.font = "font:ExtraLargeBoldSystemFont"
    ' Responsividade: 120 px padrão, mas diminui proporcionalmente em telas pequenas, nunca menor que 60 px
    relogioFontSize = int(0.10 * altura)
    if relogioFontSize > 120 then
      relogioFontSize = 120
    else if relogioFontSize < 60 then
      relogioFontSize = 60
    end if
    m.relogio.font.size = relogioFontSize
    atualizaRelogio()
    ' Responsividade do título
    tituloLargura = 0.90 * largura
    tituloAltura = 0.15 * altura
    tituloFontSize = int(0.07 * altura)
    if tituloFontSize > 64 then
      tituloFontSize = 64
    else if tituloFontSize < 32 then
      tituloFontSize = 32
    end if
    m.tituloSessao.width = tituloLargura
    m.tituloSessao.height = tituloAltura
    m.tituloSessao.horizAlign = "center"
    m.tituloSessao.vertAlign = "top"
    m.tituloSessao.translation = [0.05 * largura, 0.27 * altura]
    m.tituloSessao.visible = true
    m.tituloSessao.font = "font:LargeBoldSystemFont"
    m.tituloSessao.font.size = tituloFontSize
    m.tituloSessao.text = "Centro de treinamento GfTeam" + chr(10) + "praça das nações"
    ' Responsividade da data
    dataLargura = 0.90 * largura
    dataAltura = 0.10 * altura
    dataFontSize = int(0.045 * altura)
    if dataFontSize > 36 then
      dataFontSize = 36
    else if dataFontSize < 20 then
      dataFontSize = 20
    end if
    m.data.width = dataLargura
    m.data.height = dataAltura
    m.data.horizAlign = "center"
    m.data.vertAlign = "top"
    m.data.translation = [0.05 * largura, 0.40 * altura]
    m.data.visible = true
    m.data.font = "font:MediumBoldSystemFont"
    m.data.font.size = dataFontSize
    m.data.text = "" ' Defina o texto da data conforme necessário
  end if
end sub