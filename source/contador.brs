'**************************************************************
'  Contador / Cronômetro – versão sem ? perdido
'**************************************************************

sub init()
    m.top.setFocus(true)

    '--- Labels
    m.timeLabel = m.top.findNode("timeLabel")
    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.cronometroLabel = m.top.findNode("cronometroLabel")

    '--- Botões
    m.btnPlay = m.top.findNode("btnPlay")
    m.btnPause = m.top.findNode("btnPause")
    m.btnAdd1 = m.top.findNode("btnAdd1")
    m.btnAdd5 = m.top.findNode("btnAdd5")
    m.btnAdd10 = m.top.findNode("btnAdd10")
    m.btnReset = m.top.findNode("btnReset")

    m.botaoLista = [m.btnPlay, m.btnPause, m.btnAdd1, m.btnAdd5, m.btnAdd10, m.btnReset]
    m.botaoIndiceAtual = 0
    m.botaoLista[m.botaoIndiceAtual].setFocus(true)
    atualizaEstiloBotoes()

    '--- Timer de “clique” visual
    m.clickTimer = CreateObject("roSGNode", "Timer")
    m.clickTimer.duration = 0.2
    m.clickTimer.repeat = false
    m.clickTimer.observeField("fire", "onClickTimer")
    m.top.appendChild(m.clickTimer)

    '--- Timer de relógio
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1
    m.timer.repeat = true
    m.timer.observeField("fire", "updateDateTime")
    m.top.appendChild(m.timer)
    m.timer.control = "start"

    '--- Timer do cronômetro
    m.cronoTimer = CreateObject("roSGNode", "Timer")
    m.cronoTimer.duration = 1
    m.cronoTimer.repeat = true
    m.cronoTimer.observeField("fire", "updateCronometro")
    m.top.appendChild(m.cronoTimer)
    m.cronoTimer.control = "start"

    '--- Timer de piscar
    m.blinkTimer = CreateObject("roSGNode", "Timer")
    m.blinkTimer.duration = 0.2
    m.blinkTimer.repeat = true
    m.blinkTimer.observeField("fire", "onBlinkTimer")
    m.top.appendChild(m.blinkTimer)
    m.blinkCount = 0

    '--- Som
    m.audio = CreateObject("roSGNode", "Audio")
    m.top.appendChild(m.audio)

    '--- Dados estáticos
    m.dayNames = ["Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"]
    m.monthNames = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]

    '--- Estados iniciais
    m.cronometroSegundos = 0
    m.cronometroAtivo = false

    updateDateTime()
    mostrarCronometro()
end sub


'======================= Relógio ==============================
sub updateDateTime()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()

    diaSemana = dt.GetDayOfWeek() ' 0‒6
    mes = dt.GetMonth() ' 1‒12

    m.dayLabel.text = m.dayNames[diaSemana] + ", " + dt.GetDayOfMonth().ToStr() + " de " + m.monthNames[mes - 1]
    m.timeLabel.text = formatTime(dt.GetHours()) + ":" + formatTime(dt.GetMinutes())
end sub


'==================== Cronômetro ==============================
sub updateCronometro()
    if m.cronometroAtivo and m.cronometroSegundos > 0 then
        m.cronometroSegundos--
        mostrarCronometro()

        if m.cronometroSegundos = 0 then
            m.blinkCount = 6 ' 3 piscadas
            m.blinkTimer.control = "start"
        end if
    end if
end sub

sub mostrarCronometro()
    minutos = Int(m.cronometroSegundos / 60)
    segundos = m.cronometroSegundos mod 60
    m.cronometroLabel.text = formatTime(minutos) + ":" + formatTime(segundos)
end sub

function formatTime(v as integer) as string
    if v < 10 then
        return "0" + v.ToStr()
    else
        return v.ToStr()
    end if
end function


'==================== Navegação ===============================
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "right" and m.botaoIndiceAtual < m.botaoLista.count() - 1 then
        m.botaoIndiceAtual++
    else if key = "left" and m.botaoIndiceAtual > 0 then
        m.botaoIndiceAtual--
    else if key = "OK" then
        b = m.botaoLista[m.botaoIndiceAtual]
        b.color = "0xA5D6A7FF" ' Cor de feedback de clique
        m.clickTimer.control = "start"
        handleButtonAction(b.id)
        return true
    else
        return false
    end if

    m.botaoLista[m.botaoIndiceAtual].setFocus(true)
    atualizaEstiloBotoes()
    return true
end function


'================== Ações dos botões ==========================
sub handleButtonAction(id as string)
    if id = "btnPlay" then
        if m.cronometroSegundos > 0 then
            m.cronometroAtivo = true
            tocarSom("pkg:/sounds/start.mp3")
        end if
    else if id = "btnPause" then
        m.cronometroAtivo = false
    else if id = "btnAdd1" then
        m.cronometroSegundos += 60
    else if id = "btnAdd5" then
        m.cronometroSegundos += 300
    else if id = "btnAdd10" then
        m.cronometroSegundos += 600
    else if id = "btnReset" then
        m.cronometroAtivo = false
        m.cronometroSegundos = 0
    end if

    mostrarCronometro()
end sub


'==================== Timers auxiliares =======================
sub onClickTimer()
    atualizaEstiloBotoes()
end sub

sub onBlinkTimer()
    if m.blinkCount > 0 then
        m.cronometroLabel.visible = not m.cronometroLabel.visible
        m.blinkCount--
    else
        m.cronometroLabel.visible = true
        m.blinkTimer.control = "stop"
    end if
end sub


'================= Aparência dos botões =======================
sub atualizaEstiloBotoes()
    cNormalColor = "0xE0E0E0FF"
    cFocusedColor = "0x7986CBFF"
    cResetNormalColor = "0xFF8A80FF"
    cFocusedTextColor = "0xFFFFFFFF"
    cNormalTextColor = "0x000000FF"

    isClickRunning = (m.clickTimer <> invalid and m.clickTimer.control = "run")

    for i = 0 to m.botaoLista.count() - 1
        b = m.botaoLista[i]
        label = b.findNode("Label") ' Encontra a Label dentro do botão

        if i = m.botaoIndiceAtual then
            if (not isClickRunning) then
                b.color = cFocusedColor
                if label <> invalid then label.color = cFocusedTextColor
            end if
            b.scale = [1.15, 1.15]
        else
            b.scale = [1.0, 1.0]
            if b.id = "btnReset" then
                b.color = cResetNormalColor
            else
                b.color = cNormalColor
            end if
            if label <> invalid then label.color = cNormalTextColor
        end if
    end for
end sub


'====================== Áudio =================================
sub tocarSom(uri as string)
    m.audio.uri = uri
    m.audio.control = "play"
end sub