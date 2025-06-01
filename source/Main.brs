'*************************************************************
'** App Principal - Roku SceneGraph
'*************************************************************

' Função principal que inicializa a aplicação
sub Main()
    print "[Main] Iniciando aplicação SceneGraph"

    ' Cria a tela principal do tipo roSGScreen
    screen = CreateObject("roSGScreen")
    print "[Main] Tela roSGScreen criada"

    ' Cria uma porta de mensagens para ouvir eventos da tela
    m.port = CreateObject("roMessagePort")
    print "[Main] Porta de mensagens criada"
    screen.setMessagePort(m.port)

    ' Cria e carrega a cena principal declarada em Contador.xml
    scene = screen.CreateScene("Contador")
    print "[Main] Cena 'Contador' criada"

    ' Exibe a tela na TV
    screen.show()
    print "[Main] Tela exibida"

    ' Garante que a cena receba foco inicial
    scene.setFocus(true)
    print "[Main] Cena recebeu foco"

    ' Loop para aguardar eventos do sistema (ex: fechar tela)
    while true
        msg = wait(0, m.port)
        print "[Main] Mensagem recebida: " + type(msg)
        msgType = type(msg)

        ' Fecha o app quando a tela for encerrada
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then
                print "[Main] Tela foi fechada, encerrando app"
                return
            end if
        end if
    end while
end sub
