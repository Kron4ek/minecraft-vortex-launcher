;                _ _         
;               | | |        
;   __ _  ___ __| | |____  __
;  / _` |/ __/ _` | '_ \ \/ /
; | (_| | (_| (_| | |_) >  < 
;  \__,_|\___\__,_|_.__/_/\_\
;
; Welcome to the translation (and labels) file for Acid Launcher!
; Here you will find every string that the launcher uses
; to provide with its minimalistic functionalities.
; 
; Strings are aligned from left to right, top to bottom,
; that way you can locate yourself easily as to where
; the strings you're changing are gonna be located.
;
; Comments may also be scattered around to specify special cases and things you
; should exclude from translating.
;
;
; How do i properly employ this file and make use of it?
; 
; It's simple, change __all__ the texts that are inside of the
; multiple double quotes you will find after scrolling down this, 
; And try your best To translate it to your language of choice.
; When you're finished with that, send that to my Discord DMs
; and I will implement your submitted language as soon as i can.
; 
;
; Information about this file
;
; You might notice some strings saying "strp1" or "desc"
; but you might wonder what they mean.
;
; "STRP#" (<--- The hashtag is for the part number)
; Basically indicates separation of a string, there is currently
; only a single case where it occurrs.
;
; "DESC"
; For those new to the stream, "DESC" is slang for description.
; This is for the tooltip that will be displayed when the user
; hovers on any applicable label.
;
; "#CRLF$"
; These characters indicate that a new-line is being specified,
; so something like "awesome string at the top" + #CRLF$ + "awesome string at the bottom"
; will turn into
;
; awesome string at the top
; awesome string at the bottom
;
;
; How categories are formatted
;
; You might also notice how some categories have square brackets around them,
; but also how some of them do not.
; 
; If a category has square brackets around the category name
; (square brackets are these ----> [])
; then it means that you've encountered a main category.
; 
; If it only has hyphens around the category name,
; then it means you've encountered a subcategory,
; a window designed to appear after interacting
; with a window created by interacting with the main launcher window.
; Below is a simplified diagram to help you visualize it.
; 
; Main launcher window
;   |          |
;   | Main     |
;   | Category |
; Button1   Button2   
;   |               Subcategory window
;   |_________________________________
;              |         |            |
;      SubButton1   SubCheck2     SubList3
;
; Thanks for your collaboration! Don't forget to include your socials 
; and specify what language you contributed to at the end of line 97.
; [   ------   Main Screen   -------  ]

Global.s stringUsername = "Nome de Usuario"
Global.s stringGameVersion = "Versão do Jogo"
Global.s stringRAM = "RAM"
Global.s stringRAMTooltip = "Quantidade de RAM para o jogo."
Global.s stringJavaRuntime = "Versão Java"

Global.s stringFindInstalledVersions = "Versões não encontradas"

;     ---- Main screen actions -----
; These are the big buttons you will see when starting the launcher, which when clicked on perform various administrative actions

Global.s stringGaming = "Começar Jogo"
Global.s stringDownload = "Baixar"
Global.s stringSettings = "Configurações"

Global.s stringCredits = "Creditos!"
Global.s stringCreditsList = "Repositório principal para o Lançador:" + #CRLF$ + "https://github.com/stuxvii/acid-launcher" + #CRLF$ + #CRLF$ + "Desenvolvedor principal: acidbox" + #CRLF$ + #CRLF$ + "Tradutor para Ingles e Espanhol: acidbox" + #CRLF$ + #CRLF$ + "Tradutor para PT-BR: shame, Discord: bozg." ; Change "LANGUAGE" by the language you're submitting and change "awesomeperson" with one of your socials (but you should probably keep "awesomeperson" as-is because that's referring to you xD )

; [   ------    Settings    ------    ]
; These are names for settings used in the launcher

Global.s stringSettingsWindowTitle = "Configurar o Lançador Acid."

Global.s stringKeepLauncherOpenGadget = "Deixar o lançador aberto depois do Jogo abrir."

Global.s stringLauncherLayoutChangeGadget = "Usar o lançador original."
Global.s descLauncherLayoutChangeGadget = "Alterne para o layout usado no projeto original."

Global.s stringSaveLaunchStringGadget = "Escrever parâmetros completos de inicialização em um arquivo."
Global.s descSaveLaunchStringGadget = "O comando de inicialização completo será salvo em launch_string.txt."

Global.s stringDownloadMissingLibrariesGadget = "Baixar componentes ausentes quando o jogo for iniciado."

Global.s stringAsyncDownloadGadget = "Quantidade de threads usadas para download."
Global.s stringDownloadThreadsGadget = "Mais threads podem tornar os downloads mais rápidos à custa dos recursos do sistema."

Global.s stringJavaPathGadget = "Localização binária Java usado para executar o jogo"

Global.s stringUseCustomParamsGadget = "Parâmetros personalizados"

Global.s stringUseCustomJava = "Definir um caminho personalizado para o Java Runtime"
Global.s descUseCustomJava = "Permitir a especificação de um caminho personalizado para o Java Runtime."

Global.s stringUseCustomParamsGadget = "Modificar os parâmetros de inicialização do jogo"
Global.s descArgsGadget = "Esses parâmetros de inicialização serão usados para iniciar o Game."

Global.s stringSaveSettingsButton = "Salvar e Sair"

; [   ------- Play Errors --------    ]
; These are errors that may occurr when trying to initialize the game
Global.s stringClientJarFileFail = "O arquivo client.jar não foi encontrado!"
Global.s stringJSONFileFail = "O arquivo client.json não foi encontrado!"

Global.s stringJavaNotFound = "Java não foi encontrado! Verifique se você tem o Java instalado," + #CRLF$ + "ou verifique se inseriu corretamente sua localização."
Global.s stringNoName = "Você deve inserir um Nome."
Global.s stringShortName = "Seu nome deve ser mais de 3 letras."

Global.s stringNoRam = "Coloque a Quantidade de RAM."
Global.s stringRAMAlert = "Quantidade de RAM atribuída é muito baixa." + #CRLF$ + "Ajustando para 512 MB para melhorar a estabilidade."

; [   ------- Download Box --------    ]
; Strings utilized for the download box

Global.s stringDownloadWindowTitle = "Baixador do Cliente"

Global.s stringVersionsTypeGadget = "Mostrar todas as Versões"
Global.s stringDownloadAllFilesGadget = "Re-baixar todos os Arquivos"

Global.s stringSetupMods = "Obter Fabric"

Global.s stringDownloadVersionButton = "Baixar"

;     ------ Download Process -----

Global.s stringDesperate = "Aguarde até que o download seja concluído!"
Global.s stringDesperateTitle = "Baixando"

; Errors

Global.s stringNoInternetTitle = "Erro no download"
Global.s stringNoInternet = "Parece que você não tem conexão com a Internet"

;     ------ Fabric Installer -----

Global.s stringInstallSuccess = "O Fabric foi instalado com sucesso! Por favor reinicie o lançador."

Global.s strp1CantRunInstaller = "Houve um erro ao executar o comando: "
Global.s strp2CantRunInstaller = "Isso provavelmente é um erro de sua parte. Entre em contato com o desenvolvedor para obter mais assistência."
Global.s stringCantDownloadFabric = "Falha no download do instalador Fabric. Verifique suas configurações de Internet ou firewall."
Global.s stringCantFindJSON = "O arquivo fabric.json não pôde ser encontrado." + #CRLF$ + "Verifique se ele está em %Temp% e/ou entre em contato com o desenvolvedor"
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 41
; FirstLine = 1
; EnableXP
; DPIAware
; DisableDebugger