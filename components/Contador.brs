'***************************************************************
'* Inicializa a interface do componente Contador e o timer.
'***************************************************************
sub init()
  print "[init] Inicializando componente"
  observeFields()
  findNodes()
  initializeTimer()
  configureUI()
  m.botaoIndex = 0
  m.botoes = [
    m.playButton, m.pauseButton, m.umButton,
    m.cincoButton, m.dezButton, m.resetButton
  ]
  m.botoes[m.botaoIndex].setFocus(true)
  ' Configurar cores iniciais dos botões
  updateButtonColors()

  m.deviceInfo = CreateObject("roDeviceInfo")
  m.deviceInfo.SetMessagePort(m.port)
  m.deviceInfo.EnableLinkStatusEvent(true)
end sub

sub observeFields()
  print "[observeFields] Observando campos visuais"
  m.top.observeField("visible", "onVisibleChange")
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
  ' Mantém o cálculo original (80–160), sem alterar
  m.relogio.font.size = clamp(int(0.14 * altura), 80, 160)
  atualizaRelogio()
end sub

sub configureDate(largura as integer, altura as integer)
  m.data.width = 0.90 * largura
  m.data.height = 0.08 * altura
  m.data.horizAlign = "left"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, (0.28 * altura) + (0.004 * altura)]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  ' Aumentamos o multiplicador: antes era 0.045, agora 0.055 para ficar maior
  m.data.font.size = clamp(int(0.055 * altura), 28, 48)
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
  ' Aumentamos o multiplicador: antes era 0.052, agora 0.065 para ficar maior
  m.tituloSessao.font.size = clamp(int(0.059 * altura), 32, 56)
  m.tituloSessao.text = "CENTRO DE TREINAMENTO GFTEAM PRAÇA DAS NAÇÕES"
end sub

sub configureAllButtons(largura as float, altura as float)
  m.botoesGroup.layoutDirection = "horiz"
  m.botoesGroup.itemSpacings = [0.015 * largura]
  ' Posiciona os botões mais para baixo: 0.75 * altura (antes era 0.68)
  m.botoesGroup.translation = [0.05 * largura, 0.75 * altura]

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
  ' Aumentamos o multiplicador: antes 0.13, agora 0.20 (deixa muito maior, ajustável)
  m.cronometro.font.size = clamp(int(0.20 * altura), 100, 200)
  m.cronometro.text = "00:00"
end sub

sub initializeTimer()
  ' Criar nó de áudio e conteúdo corretamente
  m.audio = createObject("roSGNode", "Audio")
  audioContent = createObject("roSGNode", "ContentNode")
  audioContent.streamFormat = "mp3"
  audioContent.url = "pkg:/sounds/countdown-ten-seconds-76982.mp3"
  m.audio.content = audioContent
  m.top.appendChild(m.audio)

  ' Timer principal
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.observeField("fire", "atualizaCronometro")
  m.top.appendChild(m.timer)

  ' Timer de piscar
  m.blinkTimer = createObject("roSGNode", "Timer")
  m.blinkTimer.duration = 0.3
  m.blinkTimer.repeat = true
  m.blinkTimer.observeField("fire", "piscarCronometro")
  m.top.appendChild(m.blinkTimer)

  ' Timer para atualizar hora e data automaticamente
  m.clockTimer = createObject("roSGNode", "Timer")
  m.clockTimer.repeat = true
  m.clockTimer.observeField("fire", "atualizaHoraData")
  m.clockTimer.control = "start" ' Inicia automaticamente
  m.top.appendChild(m.clockTimer)

  ' Inicializa contador
  m.tempoRestante = 0
end sub

sub atualizaCronometro()
  if m.tempoRestante > 0
    m.tempoRestante = m.tempoRestante - 1
    minutos = m.tempoRestante \ 60
    segundos = m.tempoRestante mod 60
    m.cronometro.text = formatTempo(minutos, segundos)

    ' Toca o som quando faltarem 5 segundos
    if m.tempoRestante = 5
      print "⏰ Iniciando contagem regressiva final: tocando som..."
      tocarSomAbertura()
    end if

  else
    m.timer.control = "stop"
    m.blinkTimer.control = "stop"
    m.cronometro.visible = true
  end if
end sub

sub atualizaHoraData()
  ' Função chamada pelo timer para atualizar hora e data automaticamente
  atualizaRelogio()
  atualizaData()
end sub

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

sub onFocusChange()
  ' Esta função não é mais necessária - removemos a observação do focusedChild
end sub

sub updateButtonColors()
  ' Função para atualizar as cores dos botões baseado no foco atual
  for i = 0 to m.botoes.count() - 1
    if i = m.botaoIndex
      m.botoes[i].color = "0xF43F5EFF" ' Cor rosa/vermelha para botão focado (mesma cor do cronômetro)
    else
      m.botoes[i].color = "0x1E293BFF" ' Cor azul escura original para botões não focados
    end if
  end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false
  if key = "right"
    m.botaoIndex = (m.botaoIndex + 1) mod m.botoes.count()
    m.botoes[m.botaoIndex].setFocus(true)
    updateButtonColors()
    return true

  else if key = "left"
    m.botaoIndex = (m.botaoIndex - 1 + m.botoes.count()) mod m.botoes.count()
    m.botoes[m.botaoIndex].setFocus(true)
    updateButtonColors()
    return true

  else if key = "OK"
    botao = m.botoes[m.botaoIndex]

    if botao.isSameNode(m.playButton)
      print "Play pressionado"
      m.timer.control = "start"
    else if botao.isSameNode(m.pauseButton)
      print "Pause pressionado"
      m.timer.control = "stop"
    else if botao.isSameNode(m.umButton)
      print "+1 minuto"
      m.tempoRestante += 61
      atualizaCronometro()
    else if botao.isSameNode(m.cincoButton)
      print "+5 minutos"
      m.tempoRestante += 5 * 60 + 1
      atualizaCronometro()
    else if botao.isSameNode(m.dezButton)
      print "+10 minutos"
      m.tempoRestante += 10 * 60 + 1
      atualizaCronometro()
    else if botao.isSameNode(m.resetButton)
      print "Reset pressionado"
      m.timer.control = "stop"
      m.tempoRestante = 0
      m.cronometro.text = "00:00"
    end if

    return true
  end if

  return false
end function

function clamp(value as integer, min as integer, max as integer) as integer
  if value > max then return max
  if value < min then return min
  return value
end function

function formatTempo(minutos as integer, segundos as integer) as string
  minStr = minutos.toStr()
  if minStr.len() = 1 then minStr = "0" + minStr
  segStr = segundos.toStr()
  if segStr.len() = 1 then segStr = "0" + segStr
  return minStr + ":" + segStr
end function

sub piscarCronometro()
  m.cronometro.visible = not m.cronometro.visible
end sub

sub tocarSomAbertura()
  print "🔊 tentando tocar o som"
  audio = createObject("roSGNode", "Audio")
  content = createObject("roSGNode", "ContentNode")
  content.url = "pkg:/sounds/timer-alarm-detector-bleeping-beeping.wav"
  audio.content = content
  m.top.appendChild(audio)
  audio.control = "play"
end sub

function temConexaoInternet() as boolean
  deviceInfo = CreateObject("roDeviceInfo")
  return deviceInfo.GetLinkStatus()
end function