sub init()
    m.top.setFocus(true)

    ' Labels
    m.timeLabel = m.top.findNode("timeLabel")
    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.cronometroLabel = m.top.findNode("cronometroLabel")

    ' Botões
    m.btnPlay   = m.top.findNode("btnPlay")
    m.btnPause  = m.top.findNode("btnPause")
    m.btnAdd3   = m.top.findNode("btnAdd3")
    m.btnAdd5   = m.top.findNode("btnAdd5")
    m.btnAdd10  = m.top.findNode("btnAdd10")
    m.btnReset  = m.top.findNode("btnReset")

    m.botaoLista = [m.btnPlay, m.btnPause, m.btnAdd3, m.btnAdd5, m.btnAdd10, m.btnReset]
    m.botaoIndiceAtual = 0
    m.botaoLista[m.botaoIndiceAtual].setFocus(true)
    atualizaEstiloBotoes()

    ' Timer de clique visual
    m.clickTimer = CreateObject("roSGNode", "Timer")
    m.clickTimer.duration = 0.2
    m.clickTimer.repeat = false
    m.clickTimer.observeField("fire", "onClickTimer")
    m.top.appendChild(m.clickTimer)

    ' Timer do relógio
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1
    m.timer.repeat = true
    m.timer.observeField("fire", "updateDateTime")
    m.timer.control = "start"
    m.top.appendChild(m.timer)

    ' Timer do cronômetro
    m.cronoTimer = CreateObject("roSGNode", "Timer")
    m.cronoTimer.duration = 1
    m.cronoTimer.repeat = true
    m.cronoTimer.observeField("fire", "updateCronometro")
    m.cronoTimer.control = "start"
    m.top.appendChild(m.cronoTimer)

    ' Som
    m.audio = CreateObject("roSGNode", "Audio")
    m.top.appendChild(m.audio)

    ' Datas
    m.dayNames = ["Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"]
    m.monthNames = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]

    ' Estados iniciais
    m.cronometroSegundos = 0
    m.cronometroAtivo = false

    updateDateTime()
    mostrarCronometro()
end sub

sub updateDateTime()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()
    m.dayLabel.text = m.dayNames[dt.GetDayOfWeek()-1] + ", " + dt.GetDayOfMonth().ToStr() + " de " + m.monthNames[dt.GetMonth()-1]
    m.timeLabel.text = formatTime(dt.GetHours()) + ":" + formatTime(dt.GetMinutes())
end sub

sub updateCronometro()
    if m.cronometroAtivo and m.cronometroSegundos > 0 then
        m.cronometroSegundos = m.cronometroSegundos - 1
        mostrarCronometro()

        if m.cronometroSegundos = 0 then
            m.cronometroAtivo = false
            tocarSom("pkg:/sounds/end.mp3")
        end if
    end if
end sub

sub mostrarCronometro()
    minutos = Int(m.cronometroSegundos / 60)
    segundos = m.cronometroSegundos mod 60
    m.cronometroLabel.text = formatTime(minutos) + ":" + formatTime(segundos)
end sub

function formatTime(value as integer) as string
    if value < 10 then
        return "0" + value.ToStr()
    else
        return value.ToStr()
    end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "right" and m.botaoIndiceAtual < m.botaoLista.count() - 1 then
        m.botaoIndiceAtual++
        m.botaoLista[m.botaoIndiceAtual].setFocus(true)
        atualizaEstiloBotoes()
        return true
    else if key = "left" and m.botaoIndiceAtual > 0 then
        m.botaoIndiceAtual--
        m.botaoLista[m.botaoIndiceAtual].setFocus(true)
        atualizaEstiloBotoes()
        return true
    else if key = "OK" then
        botao = m.botaoLista[m.botaoIndiceAtual]
        botao.color = "0xFF88FF88"
        m.clickTimer.control = "start"
        handleButtonAction(botao.id)
        atualizaEstiloBotoes()
        return true
    end if

    return false
end function

sub handleButtonAction(id as string)
    if id = "btnPlay" then
        if m.cronometroSegundos > 0 then
            m.cronometroAtivo = true
            tocarSom("pkg:/sounds/start.mp3")
        end if
    else if id = "btnPause" then
        m.cronometroAtivo = false
    else if id = "btnAdd3" then
        m.cronometroSegundos += 3
    else if id = "btnAdd5" then
        m.cronometroSegundos += 5
    else if id = "btnAdd10" then
        m.cronometroSegundos += 10
    else if id = "btnReset" then
        m.cronometroAtivo = false
        m.cronometroSegundos = 0
    end if
    mostrarCronometro()
end sub

sub onClickTimer()
    atualizaEstiloBotoes()
end sub

sub atualizaEstiloBotoes()
    for i = 0 to m.botaoLista.count() - 1
        botao = m.botaoLista[i]
        if i = m.botaoIndiceAtual then
            botao.color = "0xFFF99BFF"
            botao.scale = [1.15, 1.15]
        else
            botao.scale = [1.0, 1.0]
            if botao.id = "btnReset" then
                botao.color = "0xFFAAAAFF"
            else
                botao.color = "0xDDDDDDFF"
            end if
        end if
    end for
end sub

sub tocarSom(caminho as string)
    m.audio.uri = caminho
    m.audio.control = "play"
end sub
