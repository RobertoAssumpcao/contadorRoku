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
    m.playButton, m.pauseButton, m.dezSegundosButton,
    m.umButton, m.cincoButton, m.resetButton
  ]
  m.botoes[m.botaoIndex].setFocus(true)
  ' Configurar cores iniciais dos botões
  updateButtonColors()

  ' Inicializar timer de clima
  iniciarTimerClima()

  ' Criar porta de mensagens para eventos do dispositivo
  m.port = CreateObject("roMessagePort")
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
  m.dezSegundosButton = m.top.findNode("dezSegundosButton")
  m.dezSegundosButtonLabel = m.top.findNode("dezSegundosButtonLabel")
  m.umButton = m.top.findNode("umButton")
  m.umButtonLabel = m.top.findNode("umButtonLabel")
  m.cincoButton = m.top.findNode("cincoButton")
  m.cincoButtonLabel = m.top.findNode("cincoButtonLabel")
  m.resetButton = m.top.findNode("resetButton")
  m.resetButtonLabel = m.top.findNode("resetButtonLabel")
  m.botoesGroup = m.top.findNode("botoesGroup")
  m.temperatura = m.top.findNode("temperatura")
  m.cidade = m.top.findNode("cidade")
  m.coordenadas = m.top.findNode("coordenadas")
  m.alertaAcademia = m.top.findNode("alertaAcademia")
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
  configureClima(largura, altura)
  ' Inicializar busca de clima
  buscarClima()
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
    { node: m.dezSegundosButton, label: m.dezSegundosButtonLabel },
    { node: m.umButton, label: m.umButtonLabel },
    { node: m.cincoButton, label: m.cincoButtonLabel },
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

' Configurar elementos de clima no canto superior direito (responsivo)
sub configureClima(largura as integer, altura as integer)
  ' Calcular posições responsivas baseadas no tamanho da tela
  climaX = 0.72 * largura ' 72% da largura da tela
  baseY = 0.05 * altura ' 5% da altura da tela

  ' Configurar temperatura (maior e responsiva)
  m.temperatura.width = 0.25 * largura
  m.temperatura.height = 0.08 * altura
  m.temperatura.horizAlign = "right"
  m.temperatura.vertAlign = "top"
  m.temperatura.translation = [climaX, baseY]
  m.temperatura.visible = true
  m.temperatura.font = "font:LargeBoldSystemFont"
  m.temperatura.font.size = clamp(int(0.08 * altura), 40, 80) ' Tamanho ainda maior
  m.temperatura.text = "--°C"

  ' Configurar cidade (maior e responsiva)
  m.cidade.width = 0.25 * largura
  m.cidade.height = 0.06 * altura
  m.cidade.horizAlign = "right"
  m.cidade.vertAlign = "top"
  m.cidade.translation = [climaX, baseY + (0.08 * altura)] ' Abaixo da temperatura
  m.cidade.visible = true
  m.cidade.font = "font:MediumBoldSystemFont"
  m.cidade.font.size = clamp(int(0.045 * altura), 28, 45) ' Tamanho maior
  m.cidade.text = "Carregando..."

  ' Configurar coordenadas (responsiva)
  if m.coordenadas <> invalid
    m.coordenadas.width = 0.25 * largura
    m.coordenadas.height = 0.04 * altura
    m.coordenadas.horizAlign = "right"
    m.coordenadas.vertAlign = "top"
    m.coordenadas.translation = [climaX, baseY + (0.19 * altura)] ' Abaixo da estação
    m.coordenadas.visible = true
    m.coordenadas.font = "font:SmallSystemFont"
    m.coordenadas.font.size = clamp(int(0.025 * altura), 18, 28)
    m.coordenadas.text = "22.9°S, 43.2°W"
  else
    print "[configureClima] m.coordenadas é inválido"
  end if

  ' Configurar alerta da academia (maior, responsivo e com nova cor)
  m.alertaAcademia.width = 0.95 * largura
  m.alertaAcademia.height = 0.12 * altura
  m.alertaAcademia.horizAlign = "center"
  m.alertaAcademia.vertAlign = "center"
  m.alertaAcademia.translation = [0.025 * largura, 0.85 * altura] ' Parte inferior da tela
  m.alertaAcademia.visible = true
  m.alertaAcademia.font = "font:MediumBoldSystemFont"
  m.alertaAcademia.font.size = clamp(int(0.04 * altura), 24, 36)
  m.alertaAcademia.text = ""

  print "[configureClima] Clima configurado responsivamente para " + largura.toStr() + "x" + altura.toStr()
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

    if m.tempoRestante = 7
      print "⏰ Iniciando contagem regressiva final: tocando som..."
      tocarSomAbertura()
    end if

    ' Iniciar piscar quando restam 5 segundos ou menos
    if m.tempoRestante <= 5 and m.tempoRestante > 0
      if m.blinkTimer.control <> "start"
        print "⚠️ Iniciando piscar - restam " + m.tempoRestante.toStr() + " segundos"
        m.blinkTimer.control = "start"
      end if
    else
      ' Parar piscar se não estiver nos últimos 5 segundos
      if m.blinkTimer.control = "start"
        m.blinkTimer.control = "stop"
        m.cronometro.visible = true ' Garantir que está visível
      end if
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

' Buscar informações de clima REAIS da API OpenWeatherMap
sub buscarClima()
  print "[buscarClima] Iniciando busca de dados REAIS de clima..."

  if not temConexaoInternet()
    print "[buscarClima] Sem conexão com a internet"
    limparInformacoesClima()
    return
  end if

  ' Criar task para buscar dados reais em thread separada
  m.weatherTask = createObject("roSGNode", "WeatherTask")
  m.weatherTask.observeField("dadosClima", "onClimaRealRecebido")
  m.top.appendChild(m.weatherTask)
  m.weatherTask.control = "RUN"
end sub

sub limparInformacoesClima()
  if m.temperatura <> invalid then m.temperatura.text = ""
  if m.cidade <> invalid then m.cidade.text = ""
  if m.alertaAcademia <> invalid then m.alertaAcademia.text = ""
end sub

' Callback quando dados reais de clima são recebidos
sub onClimaRealRecebido()
  dadosClima = m.weatherTask.dadosClima

  if dadosClima <> invalid and dadosClima.sucesso = true
    ' Usar dados reais da API
    atualizarInterfaceComDadosReais(dadosClima)
  else
    print "[onClimaRealRecebido] Erro ou dados inválidos recebidos"
    limparInformacoesClima()
  end if
end sub

' Atualizar interface com dados reais da API
sub atualizarInterfaceComDadosReais(dadosClima as object)
  print "[atualizarInterfaceComDadosReais] Atualizando interface com dados reais..."

  ' Atualizar elementos da interface com dados reais
  temperaturaInteira = dadosClima.temperatura.split(".")[0] ' Pega apenas a parte inteira antes da vírgula
  m.temperatura.text = temperaturaInteira + " °C"
  m.cidade.text = dadosClima.cidade

  print "[atualizarInterfaceComDadosReais] Interface atualizada: " + temperaturaInteira + " C, " + dadosClima.condicao + " em " + dadosClima.cidade
end sub

' Usar dados de clima inteligentes baseados na hora e localização
' REMOVIDO: usarDadosClimaSmart() - substituído por dados reais da API OpenWeatherMap
' Agora o sistema usa buscarClima() para obter dados reais em tempo real

' REMOVIDO: verificarAlertasAcademia() - substituído por verificarAlertasAcademiaReais()
' Os novos alertas são baseados em dados meteorológicos reais

' Verificar alertas climáticos importantes para academia
' Timer para atualizar clima real periodicamente
sub iniciarTimerClima()
  m.climaTimer = createObject("roSGNode", "Timer")
  m.climaTimer.duration = 900 ' 15 minutos (mais frequente para dados reais)
  m.climaTimer.repeat = true
  m.climaTimer.observeField("fire", "buscarClima") ' Buscar dados reais periodicamente
  m.top.appendChild(m.climaTimer)
  m.climaTimer.control = "start"
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
    else if botao.isSameNode(m.dezSegundosButton)
      print "+ 0:10 minuto"
      m.tempoRestante += 11
      atualizaCronometro()
    else if botao.isSameNode(m.umButton)
      print "+ 3:00 minutos"
      m.tempoRestante += 60 + 1
      atualizaCronometro()
    else if botao.isSameNode(m.cincoButton)
      print "+ 5:00 minutos"
      m.tempoRestante += 5 * 60 + 1
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
  if minutos >= 60
    ' Quando tiver 60 minutos ou mais, exibir formato horas:minutos:segundos
    horas = minutos \ 60
    minutosRestantes = minutos mod 60
    
    horasStr = horas.toStr()
    if horasStr.len() = 1 then horasStr = "0" + horasStr
    
    minStr = minutosRestantes.toStr()
    if minStr.len() = 1 then minStr = "0" + minStr
    
    segStr = segundos.toStr()
    if segStr.len() = 1 then segStr = "0" + segStr
    
    return horasStr + ":" + minStr + ":" + segStr
  else
    ' Formato normal minutos:segundos
    minStr = minutos.toStr()
    if minStr.len() = 1 then minStr = "0" + minStr
    segStr = segundos.toStr()
    if segStr.len() = 1 then segStr = "0" + segStr
    return minStr + ":" + segStr
  end if
end function

sub piscarCronometro()
  m.cronometro.visible = not m.cronometro.visible
end sub

sub tocarSomAbertura()
  print "🔊 tentando tocar o som"
  audio = createObject("roSGNode", "Audio")
  content = createObject("roSGNode", "ContentNode")
  content.url = "pkg:/sounds/v.mp3"
  audio.content = content
  m.top.appendChild(audio)
  audio.control = "play"
end sub

sub tocarSomFinalizado()
  print "🔊 Tocando som de finalização do timer"
  audio = createObject("roSGNode", "Audio")
  content = createObject("roSGNode", "ContentNode")
  content.url = "pkg:/sounds/buzzer-15-187758.mp3"
  audio.content = content
  m.top.appendChild(audio)
  audio.control = "play"
end sub

function temConexaoInternet() as boolean
  deviceInfo = CreateObject("roDeviceInfo")
  return deviceInfo.GetLinkStatus()
end function
