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

Global.s stringUsername = "Nombre de usuario"
Global.s stringGameVersion = "Version del juego"
Global.s stringRAM = "RAM"
Global.s stringRAMTooltip = "Cantidad de RAM para el juego"
Global.s stringJavaRuntime = "Version de Java"

Global.s stringFindInstalledVersions = "No hay versiones"

;     ---- Main screen actions -----
; These are the big buttons you will see when starting the launcher, which when clicked on perform various administrative actions

Global.s stringGaming = "Iniciar juego"
Global.s stringDownload = "Descargar"
Global.s stringSettings = "Configuracion"

Global.s stringCredits = "Creditos!"
Global.s stringCreditsList = "Repo principal del proyecto:" + #CRLF$ + "https://github.com/stuxvii/acid-launcher" + #CRLF$ + #CRLF$ + "Desarrolladora principal: acidbox" + #CRLF$ + #CRLF$ + "Traductora para los idiomas Ingles y Español: acidbox" + #CRLF$ + #CRLF$ + "Traductora para el idioma Ukraniano: mewity" + #CRLF$ + #CRLF$ + "Traductor para el idioma Portugues: bozg" + #CRLF$ + #CRLF$ + "Traductora para los idiomas Frances y Rumano: skvlk78" ; Change "LANGUAGE" by the language you're submitting and change "awesomeperson" with one of your socials (but you should probably keep "awesomeperson" as-is because that's referring to you xD )

; [   ------    Settings    ------    ]
; These are names for settings used in the launcher

Global.s stringSettingsWindowTitle = "Configurar Acid Launcher"

Global.s stringKeepLauncherOpenGadget = "Mantener el launcher abierto despues de iniciar el Juego"

Global.s stringLauncherLayoutChangeGadget = "Usar diseño original del launcher"
Global.s descLauncherLayoutChangeGadget = "Volver al diseño que se utiliza en el proyecto original."

Global.s stringSaveLaunchStringGadget = "Escribir el comando de ejecucion a un archivo"
Global.s descSaveLaunchStringGadget = "El comando usado para ejecutar el juego sera guardado en launch_string.txt."

Global.s stringDownloadMissingLibrariesGadget = "Descargar todas las librerias faltantes al iniciar el juego"

Global.s stringAsyncDownloadGadget = "Cantidad de hilos para las descargas"
Global.s stringDownloadThreadsGadget = "Una mayor cantidad de hilos pueden hacer las descargas mas rapidas, pero utilizaran mas recursos del sistema."

Global.s stringJavaPathGadget = "Ubicacion del Runtime de Java"

Global.s stringUseCustomParamsGadget = "Parametros personalizados"

Global.s stringUseCustomJava = "Configurar una ruta personalizada para el Runtime de Java"
Global.s descUseCustomJava = "Permite especificar una ruta personalizada en donde se buscara el Runtime de Java"

Global.s stringUseCustomParamsGadget = "Modificar parametros de lanzamiento"
Global.s descArgsGadget = "Estos parametros de lanzamiento se usaran para ejecutar el juego."

Global.s stringSaveSettingsButton = "Guardar y cerrar"

; [   ------- Play Errors --------    ]
; These are errors that may occurr when trying to initialize the game
Global.s stringClientJarFileFail = "El archivo client.jar no fue encontrado!"
Global.s stringJSONFileFail = "El archivo client.json no fue encontrado!"

Global.s stringJavaNotFound = "Java no encontrado! Revisa si tienes Java instalado," + #CRLF$ + "o revisa si has ingresado su ubicacion correctamente."
Global.s stringNoName = "Necesitas ingresar un nombre."
Global.s stringShortName = "Tu nombre tiene que tener una longitud de 3 caracteres como minimo."

Global.s stringNoRam = "Necesitas especificar una cantidad de RAM."
Global.s stringRAMAlert = "La cantidad especificada de RAM es muy baja." + #CRLF$ + "Ajustando a 512MB para mejorar la estabilidad."

; [   ------- Download Box --------    ]
; Strings utilized for the download box

Global.s stringDownloadWindowTitle = "Descargar Cliente"

Global.s stringVersionsTypeGadget = "Mostrar todas las versiones"
Global.s stringDownloadAllFilesGadget = "Re-descargar los archivos"

Global.s stringSetupMods = "Obtener Fabric"

Global.s stringDownloadVersionButton = "Descargar"

;     ------ Download Process -----

Global.s stringDesperate = "Espera a que termine la descarga!"
Global.s stringDesperateTitle = "Descarga en progreso"

; Errors

Global.s stringNoInternetTitle = "Error de descarga"
Global.s stringNoInternet = "Parece que no tienes conexion a Internet!"

;     ------ Fabric Installer -----

Global.s stringInstallSuccess = "Fabric ha sido instalado con exito! Por favor vuelve a abrir el launcher."

Global.s strp1CantRunInstaller = "Hubo un error ejecutando el comando: "
Global.s strp2CantRunInstaller = " Este es probablemente un error de tu parte. Contacta con la desarrolladora para mas informacion."
Global.s stringCantDownloadFabric = "Descarga de Fabric fallida. Revisa tu internet o configuraciones del cortafuegos."
Global.s stringCantFindJSON = "El archivo fabric.json no se pudo abrir." + #CRLF$ + "Revisa si esta ubicado en %Temp% o contacta la desarrolladora"
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 169
; FirstLine = 114
; EnableXP
; DPIAware
; DisableDebugger