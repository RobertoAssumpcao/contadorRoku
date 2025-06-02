'***************************************************************
'* Inicializa a interface do componente Contador e o timer.
'***************************************************************
sub init()
  print "[init] Inicializando componente"
  observeFields()
  findNodes()
  configureUI()
  initializeTimer()
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
  print "[configureFundo] largura=" + largura.toStr() + ", altura=" + altura.toStr()
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.translation = [0, 0]
  m.fundo.visible = true
end sub

sub configureClock(largura as integer, altura as integer)
  print "[configureClock]"
  m.relogio.width = 0.90 * largura
  m.relogio.height = 0.18 * altura
  m.relogio.horizAlign = "left"
  m.relogio.translation = [0.05 * largura, 0.10 * altura]
  m.relogio.visible = true
  m.relogio.font = "font:ExtraLargeBoldSystemFont"
  relogioFontSize = clamp(int(0.14 * altura), 80, 160)
  print "[configureClock] relogioFontSize=" + relogioFontSize.toStr()
  m.relogio.font.size = relogioFontSize
  atualizaRelogio()
end sub

sub configureDate(largura as integer, altura as integer)
  print "[configureDate]"
  m.data.width = 0.90 * largura
  m.data.height = 0.08 * altura
  m.data.horizAlign = "left"
  m.data.vertAlign = "top"
  relogioY = 0.10 * altura
  relogioH = 0.18 * altura
  espacoEntre = 0.004 * altura
  m.data.translation = [0.05 * largura, relogioY + relogioH + espacoEntre]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = clamp(int(0.045 * altura), 24, 40)
  atualizaData()
end sub

sub configureSessionTitle(largura as integer, altura as integer)
  print "[configureSessionTitle]"
  m.tituloSessao.width = 0.90 * largura
  m.tituloSessao.height = 0.10 * altura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  relogioY = 0.10 * altura
  relogioH = 0.18 * altura
  dataH = 0.08 * altura
  espacoData = 0.008 * altura
  espacoTitulo = 0.012 * altura
  yData = relogioY + relogioH + espacoData
  m.tituloSessao.translation = [0.05 * largura, yData + dataH + espacoTitulo]
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
  print "[configureAllButtons]"
  btnWidth = 0.13 * largura
  btnHeight = 0.08 * altura
  spacing = 0.015 * largura
  yPos = 0.68 * altura
  total = 6
  xStart = getButtonsStartX(btnWidth, spacing, total, largura)

  buttons = [
    { node: m.playButton, label: m.playButtonLabel },
    { node: m.pauseButton, label: m.pauseButtonLabel },
    { node: m.umButton, label: m.umButtonLabel },
    { node: m.cincoButton, label: m.cincoButtonLabel },
    { node: m.dezButton, label: m.dezButtonLabel },
    { node: m.resetButton, label: m.resetButtonLabel }
  ]

  for i = 0 to total - 1
    xPos = xStart + i * (btnWidth + spacing)
    b = buttons[i]
    b.node.width = btnWidth
    b.node.height = btnHeight
    b.node.translation = [xPos, yPos]

    b.label.width = btnWidth
    b.label.height = btnHeight
    b.label.horizAlign = "center"
    b.label.vertAlign = "center"
    b.label.font = "font:MediumBoldSystemFont"
    b.label.font.size = int(0.6 * btnHeight)
    b.label.visible = true
  end for
end sub

sub configureCronometer(largura as integer, altura as integer)
  print "[configureCronometer]"
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
  print "[initializeTimer]"
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.observeField("fire", "atualizaRelogioECronometro")
  m.top.appendChild(m.timer)
  m.timer.control = "start"
end sub

function clamp(value as integer, min as integer, max as integer) as integer
  if value > max then return max
  if value < min then return min
  return value
end function

sub atualizaRelogio()
  agora = CreateObject("roDateTime")
  agora.ToLocalTime()
  hora = agora.GetHours().ToStr()
  if hora.len() = 1 then hora = "0" + hora
  minuto = agora.GetMinutes().ToStr()
  if minuto.len() = 1 then minuto = "0" + minuto
  m.relogio.text = hora + ":" + minuto
  print "[atualizaRelogio] " + m.relogio.text
end sub

sub atualizaData()
  print "[atualizaData]"
  agora = CreateObject("roDateTime")
  agora.ToLocalTime()
  semana = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
  meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
  diaSemana = semana[agora.GetDayOfWeek()]
  dia = agora.GetDayOfMonth().ToStr()
  if dia.len() = 1 then dia = "0" + dia
  mes = meses[agora.GetMonth() - 1]
  m.data.text = diaSemana + ", " + dia + " de " + mes
  print "[atualizaData] " + m.data.text
end sub

sub onVisibleChange()
  if m.top.visible then
    print "[onVisibleChange] Componente visível"
    configureUI()
  end if
end sub
