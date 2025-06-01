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
  m.data = m.top.findNode("data")
  m.cronometro = m.top.findNode("cronometro")
  m.playButton = m.top.findNode("playButton")
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  ' Configuração inicial do cronômetro
  m.cronometro.width = largura
  m.cronometro.height = 0.20 * altura ' aumentado de 0.15 para 0.20
  m.cronometro.horizAlign = "center"
  m.cronometro.vertAlign = "top"
  m.cronometro.translation = [0, 0.50 * altura] ' ajustado de 0.55 para 0.50
  m.cronometro.visible = true
  m.cronometro.font = "font:ExtraLargeBoldSystemFont"
  cronometroFontSize = int(0.13 * altura) ' aumentado de 0.10 para 0.13
  if cronometroFontSize > 140 then
    cronometroFontSize = 140 ' aumentado de 120 para 140
  else if cronometroFontSize < 70 then
    cronometroFontSize = 70 ' aumentado de 60 para 70
  end if
  m.cronometro.font.size = cronometroFontSize
  m.cronometro.text = "00:00"
  m.fundo.width = largura
  m.fundo.height = altura
  m.fundo.visible = true
  m.relogio.width = largura
  ' Aumenta mais o tamanho da hora de forma responsiva
  m.relogio.height = 0.18 * altura
  m.relogio.horizAlign = "center"
  m.relogio.vertAlign = "top"
  m.relogio.translation = [0, 0.10 * altura]
  m.relogio.visible = true
  m.relogio.font = "font:ExtraLargeBoldSystemFont"
  relogioFontSize = int(0.14 * altura)
  if relogioFontSize > 160 then
    relogioFontSize = 160
  else if relogioFontSize < 80 then
    relogioFontSize = 80
  end if
  m.relogio.font.size = relogioFontSize
  atualizaRelogio()
  ' Responsividade do título
  tituloLargura = 0.90 * largura
  ' Diminui a altura do título para ficar mais próximo do relógio, mantendo responsividade
  tituloAltura = 0.10 * altura
  tituloFontSize = int(0.06 * altura)
  if tituloFontSize > 48 then
    tituloFontSize = 48
  else if tituloFontSize < 24 then
    tituloFontSize = 24
  end if
  m.tituloSessao.width = tituloLargura
  m.tituloSessao.height = tituloAltura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  m.tituloSessao.translation = [0.05 * largura, (0.10 * altura) + relogioFontSize + (0.03 * altura)]
  m.tituloSessao.visible = true
  m.tituloSessao.font = "font:LargeBoldSystemFont"
  m.tituloSessao.font.size = tituloFontSize
  m.tituloSessao.text = "Centro de treinamento GfTeam praça das nações"
  ' Atualiza a data ao iniciar
  atualizaData()
  m.timer = createObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.observeField("fire", "atualizaRelogioECronometro")
  m.top.appendChild(m.timer)
  m.timer.control = "start"
  ' Configuração do botão playButton
  m.playButton.width = 0.25 * largura
  m.playButton.height = 0.08 * altura
  m.playButton.horizAlign = "center"
  m.playButton.vertAlign = "top"
  m.playButton.translation = [0, 0.60 * altura]

  ' Configuração do cronômetro
  m.cronometro.width = largura
  m.cronometro.height = 0.20 * altura
  m.cronometro.horizAlign = "center"
  m.cronometro.vertAlign = "top"
  m.cronometro.translation = [0, 0.50 * altura]

  ' Configuração do relógio
  m.relogio.width = largura
  m.relogio.height = 0.18 * altura
  m.relogio.horizAlign = "center"
  m.relogio.vertAlign = "top"
  m.relogio.translation = [0, 0.10 * altura]

  ' Configuração do título da sessão
  m.tituloSessao.width = 0.90 * largura
  m.tituloSessao.height = 0.10 * altura
  m.tituloSessao.horizAlign = "center"
  m.tituloSessao.vertAlign = "top"
  m.tituloSessao.translation = [0.05 * largura, (0.10 * altura) + relogioFontSize + (0.03 * altura)]

  ' Configuração da data
  m.data.width = 0.90 * largura
  m.data.height = 0.10 * altura
  m.data.horizAlign = "center"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.40 * altura]
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

' Atualiza o texto da data na interface com o dia da semana, dia e mês atuais.
sub atualizaData()
  largura = m.top.boundingRect().width
  altura = m.top.boundingRect().height
  dataLargura = 0.90 * largura
  dataAltura = 0.10 * altura
  ' Sempre 36px, mas nunca menor que 20px em telas pequenas
  dataFontSize = 36
  if int(0.045 * altura) < 20 then
    dataFontSize = 20
  end if
  m.data = m.top.findNode("data")
  m.data.width = dataLargura
  m.data.height = dataAltura
  m.data.horizAlign = "center"
  m.data.vertAlign = "top"
  m.data.translation = [0.05 * largura, 0.40 * altura]
  m.data.visible = true
  m.data.font = "font:MediumBoldSystemFont"
  m.data.font.size = dataFontSize
  ' Monta a data: semana, dia e mês
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
    m.data = m.top.findNode("data")
    m.cronometro = m.top.findNode("cronometro")
    m.playButton = m.top.findNode("playButton")
    largura = m.top.boundingRect().width
    altura = m.top.boundingRect().height
    ' Configuração inicial do cronômetro
    m.cronometro.width = largura
    m.cronometro.height = 0.20 * altura ' aumentado de 0.15 para 0.20
    m.cronometro.horizAlign = "center"
    m.cronometro.vertAlign = "top"
    m.cronometro.translation = [0, 0.50 * altura] ' ajustado de 0.55 para 0.50
    m.cronometro.visible = true
    m.cronometro.font = "font:ExtraLargeBoldSystemFont"
    cronometroFontSize = int(0.13 * altura) ' aumentado de 0.10 para 0.13
    if cronometroFontSize > 140 then
      cronometroFontSize = 140 ' aumentado de 120 para 140
    else if cronometroFontSize < 70 then
      cronometroFontSize = 70 ' aumentado de 60 para 70
    end if
    m.cronometro.font.size = cronometroFontSize
    if m.cronometroTempo = invalid then
      m.cronometro.text = "00:00"
    else
      minutos = int(m.cronometroTempo / 60)
      segundos = m.cronometroTempo mod 60
      minStr = minutos.ToStr()
      if minStr.len() = 1 then minStr = "0" + minStr
      segStr = segundos.ToStr()
      if segStr.len() = 1 then segStr = "0" + segStr
      m.cronometro.text = minStr + ":" + segStr
    end if
    m.top.setFocus(true)
    largura = m.top.boundingRect().width
    altura = m.top.boundingRect().height
    m.fundo.width = largura
    m.fundo.height = altura
    m.fundo.visible = true
    m.relogio.width = largura
    ' Aumenta mais o tamanho da hora de forma responsiva
    m.relogio.height = 0.18 * altura
    m.relogio.horizAlign = "center"
    m.relogio.vertAlign = "top"
    m.relogio.translation = [0, 0.10 * altura]
    m.relogio.visible = true
    m.relogio.font = "font:ExtraLargeBoldSystemFont"
    relogioFontSize = int(0.14 * altura)
    if relogioFontSize > 160 then
      relogioFontSize = 160
    else if relogioFontSize < 80 then
      relogioFontSize = 80
    end if
    m.relogio.font.size = relogioFontSize
    atualizaRelogio()
    ' Responsividade do título
    tituloLargura = 0.90 * largura
    ' Diminui a altura do título para ficar mais próximo do relógio, mantendo responsividade
    tituloAltura = 0.10 * altura
    tituloFontSize = int(0.06 * altura)
    if tituloFontSize > 48 then
      tituloFontSize = 48
    else if tituloFontSize < 24 then
      tituloFontSize = 24
    end if
    m.tituloSessao.width = tituloLargura
    m.tituloSessao.height = tituloAltura
    m.tituloSessao.horizAlign = "center"
    m.tituloSessao.vertAlign = "top"
    m.tituloSessao.translation = [0.05 * largura, (0.10 * altura) + relogioFontSize + (0.03 * altura)]
    m.tituloSessao.visible = true
    m.tituloSessao.font = "font:LargeBoldSystemFont"
    m.tituloSessao.font.size = tituloFontSize
    m.tituloSessao.text = "Centro de treinamento GfTeam" + chr(10) + "praça das nações"
    ' Atualiza a data ao ficar visível
    atualizaData()

    m.playButton.width = 0.25 * largura
    m.playButton.height = 0.08 * altura
    m.playButton.horizAlign = "center"
    m.playButton.vertAlign = "top"
    m.playButton.translation = [0, 0.60 * altura]

    ' Configuração do cronômetro
    m.cronometro.width = largura
    m.cronometro.height = 0.20 * altura
    m.cronometro.horizAlign = "center"
    m.cronometro.vertAlign = "top"
    m.cronometro.translation = [0, 0.50 * altura]

    ' Configuração do relógio
    m.relogio.width = largura
    m.relogio.height = 0.18 * altura
    m.relogio.horizAlign = "center"
    m.relogio.vertAlign = "top"
    m.relogio.translation = [0, 0.10 * altura]

    ' Configuração do título da sessão
    m.tituloSessao.width = 0.90 * largura
    m.tituloSessao.height = 0.10 * altura
    m.tituloSessao.horizAlign = "center"
    m.tituloSessao.vertAlign = "top"
    m.tituloSessao.translation = [0.05 * largura, (0.10 * altura) + relogioFontSize + (0.03 * altura)]

    ' Configuração da data
    m.data.width = 0.90 * largura
    m.data.height = 0.10 * altura
    m.data.horizAlign = "center"
    m.data.vertAlign = "top"
    m.data.translation = [0.05 * largura, 0.40 * altura]
  end if
end sub