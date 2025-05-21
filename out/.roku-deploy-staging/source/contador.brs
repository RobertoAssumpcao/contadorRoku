sub init()
    m.top.setFocus(true)

    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.tituloAcademiaLabel.font.size = 40
    m.dayLabel.font.size = 35
    m.timeLabel.font.size = 35

    m.dayNames = ["Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"]
    m.monthNames = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]

    ' Cria e configura o timer
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1 ' a cada 1 segundo
    m.timer.repeat = true
    m.timer.control = "start"
    m.timer.observeField("fire", "updateDateTime")

    m.top.appendChild(m.timer) ' MUITO IMPORTANTE

    updateDateTime() ' Atualiza imediatamente ao iniciar
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

function formatTime(value as Integer) as String
    if value < 10
        return "0" + value.ToStr()
    else
        return value.ToStr()
    end if
end function
