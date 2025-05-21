sub init()
    m.top.setFocus(true)

    ' Labels do relógio e data
    m.timeLabel = m.top.findNode("timeLabel")
    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")

    ' Label do cronômetro
    m.cronometroLabel = m.top.findNode("cronometroLabel")

    ' Botões do cronômetro
    m.btnPlay   = m.top.findNode("btnPlay")
    m.btnPause  = m.top.findNode("btnPause")
    m.btnAdd3   = m.top.findNode("btnAdd3")
    m.btnAdd5   = m.top.findNode("btnAdd5")
    m.btnAdd10  = m.top.findNode("btnAdd10")
    m.btnReset  = m.top.findNode("btnReset")

    ' Lista ordenada dos botões para navegação
    m.botaoLista       = [m.btnPlay, m.btnPause, m.btnAdd3, m.btnAdd5, m.btnAdd10, m.btnReset]
    m.botaoIndiceAtual  = 0
    m.botaoLista[m.botaoIndiceAtual].setFocus(true)

    ' Observa foco para destaque visual
    for each botao in m.botaoLista
        botao.observeField("focusPercent", "onBotaoFocoMudou")
    end for

    ' Timer para "flash" de clique
    m.clickTimer = CreateObject("roSGNode", "Timer")
    m.clickTimer.duration = 0.2
    m.clickTimer.repeat = false
    m.clickTimer.observeField("fire", "onClickTimer")
    m.top.appendChild(m.clickTimer)

    ' Arrays de dias e meses
    m.dayNames   = ["Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"]
    m.monthNames = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]

    ' Timer do relógio
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1
    m.timer.repeat = true
    m.timer.observeField("fire", "updateDateTime")
    m.timer.control = "start"
    m.top.appendChild(m.timer)

    ' Timer do cronômetro decrescente
    m.cronoTimer = CreateObject("roSGNode", "Timer")
    m.cronoTimer.duration = 1
    m.cronoTimer.repeat = true
    m.cronoTimer.observeField("fire", "updateCronometro")
    m.cronoTimer.control = "start"
    m.top.appendChild(m.cronoTimer)

    ' Inicializa cronômetro decrescente
    m.cronometroSegundos = 0
    m.cronometroAtivo    = false

    ' Desenha pela primeira vez
    updateDateTime()
    mostrarCronometro()
end sub

'--------------------------------------------------
' Atualiza relógio (hh:mm:ss)
sub updateDateTime()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()
    dow    = dt.GetDayOfWeek()
    day    = dt.GetDayOfMonth()
    month  = dt.GetMonth()
    m.dayLabel.text  = m.dayNames[dow-1] + ", " + day.ToStr() + " de " + m.monthNames[month-1]

    hora   = dt.GetHours()
    minuto = dt.GetMinutes()
    segundo= dt.GetSeconds()
    m.timeLabel.text = formatTime(hora) + ":" + formatTime(minuto) + ":" + formatTime(segundo)
end sub

'--------------------------------------------------
' Atualiza cronômetro decrescente
sub updateCronometro()
    if m.cronometroAtivo and m.cronometroSegundos > 0 then
        m.cronometroSegundos = m.cronometroSegundos - 1
        mostrarCronometro()
        if m.cronometroSegundos = 0 then
            m.cronometroAtivo = false
        end if
    end if
end sub

'--------------------------------------------------
' Desenha cronômetro (MM:SS)
sub mostrarCronometro()
    minutos  = Int(m.cronometroSegundos / 60)
    segundos = m.cronometroSegundos mod 60
    m.cronometroLabel.text = formatTime(minutos) + ":" + formatTime(segundos)
end sub

'--------------------------------------------------
function formatTime(value as integer) as string
    if value < 10 then
        return "0" + value.ToStr()
    else
        return value.ToStr()
    end if
end function

'--------------------------------------------------
' Trata controle remoto
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then
        return false
    end if

    if key = "right" then
        if m.botaoIndiceAtual < m.botaoLista.count() - 1 then
            m.botaoIndiceAtual = m.botaoIndiceAtual + 1
            m.botaoLista[m.botaoIndiceAtual].setFocus(true)
        end if
        return true
    else if key = "left" then
        if m.botaoIndiceAtual > 0 then
            m.botaoIndiceAtual = m.botaoIndiceAtual - 1
            m.botaoLista[m.botaoIndiceAtual].setFocus(true)
        end if
        return true
    else if key = "OK" then
        bot = m.botaoLista[m.botaoIndiceAtual]
        bot.color = "0xFF88FF88"  ' verde claro flash
        m.clickTimer.control = "start"
        handleButtonAction(bot.id)
        return true
    end if

    return false
end function

'--------------------------------------------------
sub handleButtonAction(id as String)
    if id = "btnPlay" then
        if m.cronometroSegundos > 0 then
            m.cronometroAtivo = true
        end if
    else if id = "btnPause" then
        m.cronometroAtivo = false
    else if id = "btnAdd3" then
        m.cronometroSegundos = m.cronometroSegundos + 3
    else if id = "btnAdd5" then
        m.cronometroSegundos = m.cronometroSegundos + 5
    else if id = "btnAdd10" then
        m.cronometroSegundos = m.cronometroSegundos + 10
    else if id = "btnReset" then
        m.cronometroAtivo = false
        m.cronometroSegundos = 0
    end if
    mostrarCronometro()
end sub

'--------------------------------------------------
sub onClickTimer()
    onBotaoFocoMudou()
end sub

'--------------------------------------------------
sub onBotaoFocoMudou()
    for each bot in m.botaoLista
        if bot.focusPercent = 1.0 then
            bot.color = "0xFFF99BFF"  ' amarelo
            bot.scale = [1.15, 1.15]
        else
            bot.scale = [1.0, 1.0]
            if bot.id = "btnReset" then
                bot.color = "0xFFAAAAFF"
            else
                bot.color = "0xDDDDDDFF"
            end if
        end if
    end for
end sub
