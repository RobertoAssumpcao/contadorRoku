' main.brs
sub Main()
    screen = CreateObject("roSGScreen")
    port   = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    ' Cria e exibe a cena CounterScene
    scene = screen.CreateScene("CounterScene")
    screen.Show()

    ' Loop de eventos (aguarda fechar a tela)
    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed() then
            return
        end if
    end while
end sub
