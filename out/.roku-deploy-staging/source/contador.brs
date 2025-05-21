'***************************************************************
'* Initializes the UI components and sets up date/time display.
'*
'* - Sets focus to the top component.
'* - Finds and assigns label nodes for title, day, and time.
'* - Sets font size for each label to 92.
'* - Retrieves current date and time using roDateTime.
'* - Formats and sets the day label with the day of the week,
'*   day of the month, and month name in Portuguese.
'* - Formats and sets the time label in HH:MM:SS format.
'***************************************************************
sub init()
    m.top.setFocus(true)

    m.tituloAcademiaLabel = m.top.findNode("tituloAcademiaLabel")
    m.dayLabel = m.top.findNode("dayLabel")
    m.timeLabel = m.top.findNode("timeLabel")

    m.tituloAcademiaLabel.font.size = 92
    m.dayLabel.font.size = 92
    m.timeLabel.font.size = 92

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
