'***************************************************************
'* Inicializa a interface do componente Contador e o timer.
'***************************************************************
sub init()
  print "[init] Inicializando componente"
  observeFields()
  findNodes()
  initializeTimer()
  configureUI()
  m.playButton.setFocus(true)
end sub

sub observeFields()
  print "[observeFields] Observando campos visuais"
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "onFocusChange")
end sub

sub findNodes()
  print "[findNodes] Buscando nós de UI"
  m.fundo = m.top.findNode("fundo")
  m.relogio = m.top.findNode("relogio")
  m.tituloSessao = m.top.findNode("tituloSessao")
  m.data = m.top.findNode("data")
  m.cronometro = m.top.findNode("cronometro")
  m.playButton = m.top.findNode("playButton")
  m.playButtonLabel = m.top.findNode("playButtonLabel")
  m.pauseButton = m.top.findNode("pauseButton")
  m.pauseButtonLabel = m.top.findNode("pauseButtonLabel")
  m.umButton = m.top.findNode("umButton")
  m.umButtonLabel = m.top.findNode("umButtonLabel")
  m.cincoButton = m.top.findNode("cincoButton")
  m.cincoButtonLabel = m.top.findNode("cincoButtonLabel")
  m.dezButton = m.top.findNode("dezButton")
  m.dezButtonLabel = m.top.findNode("dezButtonLabel")
  m.resetButton = m.top.findNode("resetButton")
  m.resetButtonLabel = m.top.findNode("resetButtonLabel")
  m.botoesGroup = m.top.findNode("botoesGroup")
end sub

sub configureUI()
  print "[configureUI] Configurando interface"
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  configureBackground(largura, altura)
  configureClock(largura, altura)
  configureSessionTitle(largura, altura)
  configureDate(largura, altura)
  configureAllButtons(largura, altura)
  configureCronometer(largura, altura)
  print "[configureUI] Configuração concluída"
end sub

sub configureBackground(largura as integer, altura as integer)
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.translation = [0, 0]
  m.fundo.visible = true
end sub

sub configureClock(largura as integer, altura as integer)
  m.relogio.width = 0.90 * largura
  m.relogio.height = 0.18 * altura
  m.relogio.horizAlign = "left"
  m.relogio.translation = [0.05 * largura, 0.10 * altura]
  m.relogio.visible = true
  m.relogio.font = "font:ExtraLargeBoldSystemFont"
  m.relogio.font.size = clamp(int(0.14 * altura), 80, 160)
  atualizaRelogio()
end sub

sub configureDate(largura as integer, altura as integer)
  m.data.width = 0.90 * largura
  m.data.height = 0.08 * altura
  m.data.horizAlign = "left"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.28 * altura + 0.004 * altura]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = clamp(int(0.045 * altura), 24, 40)
  atualizaData()
end sub

sub configureSessionTitle(largura as integer, altura as integer)
  m.tituloSessao.width = 0.90 * largura
  m.tituloSessao.height = 0.10 * altura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  m.tituloSessao.translation = [0.05 * largura, 0.37 * altura]
  m.tituloSessao.visible = true
  m.tituloSessao.font = "font:LargeBoldSystemFont"
  m.tituloSessao.font.size = clamp(int(0.052 * altura), 28, 48)
  m.tituloSessao.text = "CENTRO DE TREINAMENTO GFTEAM PRAÇA DAS NAÇÕES"
end sub

function getButtonsStartX(btnWidth as float, spacing as float, qtdBotoes as integer, largura as float) as float
  totalWidth = (btnWidth * qtdBotoes) + (spacing * (qtdBotoes - 1))
  return (largura - totalWidth) / 2
end function

sub configureAllButtons(largura as float, altura as float)
  m.botoesGroup.layoutDirection = "horiz"
  m.botoesGroup.horizAlign = "center"
  m.botoesGroup.vertAlign = "top"
  m.botoesGroup.itemSpacings = [0.015 * largura]
  m.botoesGroup.translation = [100, 0.68 * altura]

  botoes = [
    { node: m.playButton, label: m.playButtonLabel },
    { node: m.pauseButton, label: m.pauseButtonLabel },
    { node: m.umButton, label: m.umButtonLabel },
    { node: m.cincoButton, label: m.cincoButtonLabel },
    { node: m.dezButton, label: m.dezButtonLabel },
    { node: m.resetButton, label: m.resetButtonLabel }
  ]

  btnWidth = 0.13 * largura
  btnHeight = 0.08 * altura

  for each b in botoes
    b.node.width = btnWidth
    b.node.height = btnHeight
    b.node.focusable = true
    b.label.width = btnWidth
    b.label.height = btnHeight
    b.label.horizAlign = "center"
    b.label.vertAlign = "center"
    b.label.font = "font:MediumBoldSystemFont"
    b.label.font.size = int(0.6 * btnHeight)
    b.label.visible = true
    b.node.observeField("buttonSelected", "onButtonPress")
  end for
end sub


sub configureCronometer(largura as integer, altura as integer)
  m.cronometro.width = largura
  m.cronometro.height = 0.20 * altura
  m.cronometro.horizAlign = "center"
  m.cronometro.vertAlign = "top"
  m.cronometro.translation = [0, 0.50 * altura]
  m.cronometro.visible = true
  m.cronometro.font = "font:ExtraLargeBoldSystemFont"
  m.cronometro.font.size = clamp(int(0.13 * altura), 70, 140)
  m.cronometro.text = "00:00"
end sub

sub initializeTimer()
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.observeField("fire", "atualizaCronometro")
  m.top.appendChild(m.timer)
  m.tempoRestante = 0
end sub

sub atualizaCronometro()
  if m.tempoRestante > 0
    m.tempoRestante = m.tempoRestante - 1
    minutos = m.tempoRestante \ 60
    segundos = m.tempoRestante mod 60
    m.cronometro.text = formatTempo(minutos, segundos)
  else
    m.timer.control = "stop"
  end if
end sub

function formatTempo(minutos as integer, segundos as integer) as string
  minStr = minutos.toStr()
  if minStr.len() = 1 then minStr = "0" + minStr
  segStr = segundos.toStr()
  if segStr.len() = 1 then segStr = "0" + segStr
  return minStr + ":" + segStr
end function

sub atualizaRelogio()
  agora = CreateObject("roDateTime")
  agora.ToLocalTime()
  hora = agora.GetHours().ToStr()
  if hora.len() = 1 then hora = "0" + hora
  minuto = agora.GetMinutes().ToStr()
  if minuto.len() = 1 then minuto = "0" + minuto
  m.relogio.text = hora + ":" + minuto
end sub

sub atualizaData()
  agora = CreateObject("roDateTime")
  agora.ToLocalTime()
  semana = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
  meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
  diaSemana = semana[agora.GetDayOfWeek()]
  dia = agora.GetDayOfMonth().ToStr()
  if dia.len() = 1 then dia = "0" + dia
  mes = meses[agora.GetMonth() - 1]
  m.data.text = diaSemana + ", " + dia + " de " + mes
end sub

sub onVisibleChange()
  if m.top.visible then
    configureUI()
  end if
end sub

sub onButtonPress()
  botao = m.top.focusedChild
  if botao = m.playButton
    m.timer.control = "start"
  else if botao = m.pauseButton
    m.timer.control = "stop"
  else if botao = m.umButton
    m.tempoRestante = m.tempoRestante + 60
    atualizaCronometro()
  else if botao = m.cincoButton
    m.tempoRestante = m.tempoRestante + (5 * 60)
    atualizaCronometro()
  else if botao = m.dezButton
    m.tempoRestante = m.tempoRestante + (10 * 60)
    atualizaCronometro()
  else if botao = m.resetButton
    m.timer.control = "stop"
    m.tempoRestante = 0
    m.cronometro.text = "00:00"
  end if
end sub

sub onFocusChange()
  botoes = [
    m.playButton, m.pauseButton, m.umButton,
    m.cincoButton, m.dezButton, m.resetButton
  ]
  for each botao in botoes
    if botao.hasFocus()
      botao.color = "0xE53E3EFF" ' vermelho
    else
      botao.color = "0x2D3748FF" ' cinza escuro
    end if
  end for
end sub

function clamp(value as integer, min as integer, max as integer) as integer
  if value > max then return max
  if value < min then return min
  return value
end function
