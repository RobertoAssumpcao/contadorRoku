sub init()
    print "[WeatherTask] Inicializando task de clima real"
    m.top.functionName = "buscarClimaReal"
end sub

sub buscarClimaReal()
    print "[WeatherTask] Iniciando busca de dados reais de clima..."
    
    ' Configuração da API OpenWeatherMap
    apiKey = "1ec1dd72a3ce9b6fd0a870284b467472"  ' Obtenha em: https://openweathermap.org/api
    
    ' Coordenadas do Rio de Janeiro (Praça das Nações)
    lat = "-22.9068"  ' Latitude
    lon = "-43.1729"  ' Longitude
    
    ' URL da API com dados atuais
    urlAtual = "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=" + apiKey + "&units=metric&lang=pt_br"
    
    ' Criar requisição HTTP
    request = CreateObject("roUrlTransfer")
    print "[WeatherTask] URL configurada: " + urlAtual
    request.SetUrl(urlAtual)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt") ' Configurar caminho do arquivo de certificados SSL para teste
    request.SetMessagePort(CreateObject("roMessagePort"))
    print "[WeatherTask] Objeto roUrlTransfer configurado com sucesso"
    
    print "[WeatherTask] Fazendo requisição para OpenWeatherMap..."
    
    ' Fazer requisição
    if request.AsyncGetToString()
        msg = wait(20000, request.GetMessagePort()) ' Timeout 20 segundos
        
        if type(msg) = "roUrlEvent"
            responseCode = msg.GetResponseCode()
            
            if responseCode = 200
                responseString = msg.GetString()
                print "[WeatherTask] Resposta recebida da API"
                
                ' Parse do JSON
                climaData = ParseJson(responseString)
                
                if climaData <> invalid
                    ' Processar dados reais
                    processarDadosReais(climaData)
                else
                    print "[WeatherTask] Erro ao fazer parse do JSON"
                    m.top.dadosClima = {
                        erro: "Erro ao processar dados da API"
                        sucesso: false
                    }
                end if
            else
                print "[WeatherTask] Erro HTTP: " + responseCode.toStr()
                m.top.dadosClima = {
                    erro: "Erro de conexão com API: " + responseCode.toStr()
                    sucesso: false
                }
            end if
        else
            print "[WeatherTask] Timeout na requisição"
            m.top.dadosClima = {
                erro: "Timeout na conexão com API"
                sucesso: false
            }
        end if
    else
        print "[WeatherTask] Falha ao iniciar requisição"
        m.top.dadosClima = {
            erro: "Falha ao conectar com API"
            sucesso: false
        }
    end if
end sub

sub processarDadosReais(climaData as Object)
    print "[WeatherTask] Processando dados reais da API..."

    ' Inicializar m.top.dadosClima como objeto vazio se estiver inválido
    if m.top.dadosClima = invalid
        m.top.dadosClima = {}
    end if

    try
        ' Extrair dados principais
        temperatura = climaData.main.temp
        sensacao = climaData.main.feels_like
        umidade = climaData.main.humidity
        pressao = climaData.main.pressure
        visibilidade = climaData.visibility / 1000 ' Converter para km

        ' Informações de chuva/neve
        chuva = 0
        if climaData.rain <> invalid and climaData.rain["1h"] <> invalid
            chuva = climaData.rain["1h"]
        end if

        neve = 0
        if climaData.snow <> invalid and climaData.snow["1h"] <> invalid
            neve = climaData.snow["1h"]
        end if

        ' Vento
        ventoVelocidade = climaData.wind.speed * 3.6 ' Converter m/s para km/h
        ventoGraus = climaData.wind.deg

        ' Condição climática
        condicao = climaData.weather[0].description

        ' Informações de localização
        cidade = climaData.name

        ' Determinar estação baseada na data
        agora = CreateObject("roDateTime")
        agora.ToLocalTime()
        mes = agora.GetMonth()

        estacao = ""
        if mes >= 12 or mes <= 3
            estacao = "Verão"
        else if mes >= 6 and mes <= 9
            estacao = "Inverno"
        else if mes >= 9 and mes <= 11
            estacao = "Primavera"
        else
            estacao = "Outono"
        end if

        ' Montar objeto com todos os dados reais
        m.top.dadosClima = {
            temperatura: temperatura.toStr(),
            sensacao: sensacao.toStr(),
            umidade: umidade.toStr(),
            pressao: pressao.toStr(),
            visibilidade: visibilidade.toStr(),
            chuva: chuva.toStr(),
            neve: neve.toStr(),
            ventoVelocidade: ventoVelocidade.toStr(),
            ventoGraus: ventoGraus.toStr(),
            condicao: condicao,
            cidade: cidade,
            estacao: estacao,
            coordenadas: climaData.coord.lat.toStr() + "°S, " + climaData.coord.lon.toStr() + "°W",
            timestamp: agora.AsDateString() + " " + agora.AsTimeString(),
            sucesso: true
        }

        print "[WeatherTask] Dados reais processados com sucesso: " + temperatura.toStr() + "°C, " + condicao
    catch e
        print "[WeatherTask] Erro ao processar dados reais: " + e.getMessage()
        m.top.dadosClima = invalid ' Não exibir nada na interface
    end try
end sub
