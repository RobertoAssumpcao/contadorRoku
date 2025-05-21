sub init()
    m.top.setFocus(true)

    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.timeLabel = m.top.findNode("timeLabel")
    m.tituloAcademiaLabel.font.size = 40
    m.tituloAcademiaLabel.font.weight = "heavy"
    m.dayLabel.font.size = 35
    m.dayLabel.font.weight = "medium"
    m.timeLabel.font.size = 35
    m.timeLabel.font.weight = "regular"

    dayNames = ["Domingo","Segunda-feira","Terça-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sábado"]
    monthNames = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]
    dt = CreateObject("roDateTime")
    dow = dt.GetDayOfWeek()  ' 1 a 7
    day = dt.GetDayOfMonth()
    month = dt.GetMonth()    ' 1 a 12
    m.dayLabel.text = dayNames[dow - 1] + ", " + day.ToStr() + " de " + monthNames[month - 1]
    
    ' Pega hora, minuto e segundo
    dt.ToLocalTime()
    hora = dt.GetHours()
    minuto = dt.GetMinutes()
    segundo = dt.GetSeconds()
    ' Formata para HH:MM:SS
    m.timeLabel.text = hora.ToStr() + ":" + minuto.ToStr() + ":" + segundo.ToStr()
end sub
