sub init()
    m.top.setFocus(true)

    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.timeLabel = m.top.findNode("timeLabel")

    ' Set font sizes
    m.tituloAcademiaLabel.font.size = 43
    m.dayLabel.font.size = 41
    m.timeLabel.font.size = 40

    m.dayNames = ["Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"]
    m.monthNames = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]

    ' Create and configure the timer
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1 ' every 1 second
    m.timer.repeat = true
    m.timer.control = "start"
    m.timer.observeField("fire", "updateDateTime")

    m.top.appendChild(m.timer) ' VERY IMPORTANT

    updateDateTime() ' Update immediately on start
end sub

sub updateDateTime()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()

    dow = dt.GetDayOfWeek()
    day = dt.GetDayOfMonth()
    month = dt.GetMonth()

    m.dayLabel.text = m.dayNames[dow - 1] + ", " + day.ToStr() + " de " + m.monthNames[month - 1]

    hora = dt.GetHours()
    minuto = dt.GetMinutes()
    segundo = dt.GetSeconds()

    m.timeLabel.text = formatTime(hora) + ":" + formatTime(minuto) + ":" + formatTime(segundo)
end sub

function formatTime(value as integer) as string
    if value < 10
        return "0" + value.ToStr()
    else
        return value.ToStr()
    end if
end function
