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
end sub

sub configureUI()
  print "[configureUI] Configurando interface"
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  configureBackground(largura, altura)
  configureClock(largura, altura)
  configureSessionTitle(largura, altura)
  configureDate(largura, altura)
  configurePlayButton(largura, altura)
  configureCronometer(largura, altura)
end sub

sub configureBackground(largura as Integer, altura as Integer)
  print "[configureBackground] largura=" + largura.toStr() + ", altura=" + altura.toStr()
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.visible = true
end sub

sub configureClock(largura as Integer, altura as Integer)
  print "[configureClock]"
  m.relogio.width = largura
  m.relogio.height = 0.18 * altura
  m.relogio.horizAlign = "center"
  m.relogio.vertAlign = "top"
  m.relogio.translation = [0, 0.10 * altura]
  m.relogio.visible = true
  m.relogio.font = "font:ExtraLargeBoldSystemFont"
  relogioFontSize = clamp(int(0.14 * altura), 80, 160)
  print "[configureClock] relogioFontSize=" + relogioFontSize.toStr()
  m.relogio.font.size = relogioFontSize
  atualizaRelogio()
end sub

sub configureSessionTitle(largura as Integer, altura as Integer)
  print "[configureSessionTitle]"
  m.tituloSessao.width = 0.90 * largura
  m.tituloSessao.height = 0.10 * altura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  m.tituloSessao.translation = [0.05 * largura, (0.10 * altura) + int(0.14 * altura) + (0.03 * altura)]
  m.tituloSessao.visible = true
  m.tituloSessao.font = "font:LargeBoldSystemFont"
  m.tituloSessao.font.size = clamp(int(0.06 * altura), 24, 48)
  m.tituloSessao.text = "Centro de treinamento GfTeam praça das nações"
end sub

sub configureDate(largura as Integer, altura as Integer)
  print "[configureDate]"
  m.data.width = 0.90 * largura
  m.data.height = 0.10 * altura
  m.data.horizAlign = "center"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.40 * altura]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = clamp(int(0.045 * altura), 20, 36)
  atualizaData()
end sub

sub configurePlayButton(largura as Integer, altura as Integer)
  print "[configurePlayButton]"
  m.playButton.width = 0.15 * largura
  m.playButton.height = 0.08 * altura
  m.playButton.horizAlign = "left"
  m.playButton.vertAlign = "top"
  m.playButton.translation = [0.50 * largura, 0.68 * altura]
  m.playButtonLabel.width = m.playButton.width
  m.playButtonLabel.height = m.playButton.height
  m.playButtonLabel.horizAlign = "center"
  m.playButtonLabel.vertAlign = "center"
  m.playButtonLabel.font = "font:MediumBoldSystemFont"
  m.playButtonLabel.font.size = int(0.6 * m.playButton.height)
  m.playButtonLabel.visible = true
end sub

sub configureCronometer(largura as Integer, altura as Integer)
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

function clamp(value as Integer, min as Integer, max as Integer) as Integer
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
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  dataLargura = 0.90 * largura
  dataAltura = 0.10 * altura
  dataFontSize = 36
  if int(0.045 * altura) < 20 then dataFontSize = 20
  m.data.width = dataLargura
  m.data.height = dataAltura
  m.data.horizAlign = "center"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.40 * altura]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = dataFontSize
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
