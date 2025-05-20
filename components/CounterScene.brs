' CounterScene.brs
sub init()
    ' Referências aos nodes
    m.dateLabel    = m.top.findNode("dateLabel")
    m.timerLabel   = m.top.findNode("timerLabel")
    m.playBtn      = m.top.findNode("playBtn")
    m.resetBtn     = m.top.findNode("resetBtn")
    m.btn3min      = m.top.findNode("btn3min")
    m.btn10s       = m.top.findNode("btn10s")
    m.btn1min      = m.top.findNode("btn1min")
    m.refreshTimer = m.top.findNode("refreshTimer")

    ' Estado inicial
    m.duration  = 180
    m.remaining = m.duration
    m.isRunning = false

    ' Observers
    m.playBtn.ObserveField("buttonSelected", "onPlay")
    m.resetBtn.ObserveField("buttonSelected", "onReset")
    m.btn3min.ObserveField("buttonSelected", "onSelect3")
    m.btn10s.ObserveField("buttonSelected", "onSelect10")
    m.btn1min.ObserveField("buttonSelected", "onSelect60")
    m.refreshTimer.ObserveField("fire", "onTick")

    ' Primeira renderização
    updateDisplay()
end sub

sub onTick()
    ' Atualiza data/hora
    now = CreateObject("roDateTime")
    m.dateLabel.text = now.AsDateTimeString()

    ' Decrementa contador se ativo
    if m.isRunning and m.remaining > 0 then
        m.remaining = m.remaining - 1
        if m.remaining = 0 then m.isRunning = false
    end if

    updateDisplay()
end sub

sub updateDisplay()
    mins   = int(m.remaining / 60)
    secs   = m.remaining mod 60
    minStr = right("0" + str(mins), 2)
    secStr = right("0" + str(secs), 2)
    m.timerLabel.text = minStr + ":" + secStr
end sub

sub onPlay()
    m.isRunning = not m.isRunning
    m.playBtn.labelText = m.isRunning ? "Pause" : "Play"
end sub

sub onReset()
    m.remaining = m.duration
    updateDisplay()
end sub

sub onSelect3()
    m.duration  = 180
    m.remaining = m.duration
    updateDisplay()
end sub

sub onSelect10()
    m.duration  = 10
    m.remaining = m.duration
    updateDisplay()
end sub

sub onSelect60()
    m.duration  = 60
    m.remaining = m.duration
    updateDisplay()
end sub
