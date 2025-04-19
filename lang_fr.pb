;                _ _         
;               | | |        
;   __ _  ___ __| | |____  __
;  / _` |/ __/ _` | '_ \ \/ /
; | (_| | (_| (_| | |_) >  < 
;  \__,_|\___\__,_|_.__/_/\_\
;
; [   ------   Main Screen   -------  ]

Global.s stringUsername = "Pseudonyme"
Global.s stringGameVersion = "Version de jeux"
Global.s stringRAM = "RAM"
Global.s stringRAMTooltip = "Quantité de RAM pour le jeux."
Global.s stringJavaRuntime = "Version java"

Global.s stringFindInstalledVersions = "Versions pas trouves"

;     ---- Main screen actions -----

Global.s stringGaming = "Commencer jeux"
Global.s stringDownload = "Instaler"
Global.s stringSettings = "Parametres"

Global.s stringCredits = "Credits!"
Global.s stringCreditsList = "Le repo principale pour le launcheur:" + #CRLF$ + "https://github.com/stuxvii/acid-launcher" + #CRLF$ + #CRLF$ + "développeuse principal: acidbox" + #CRLF$ + #CRLF$ + "Traductrice pour l'Anglais et l'Espagnol: acidbox" + #CRLF$ + #CRLF$ + "Traductrice pour le Français et le Roumain: skvlk78" + #CRLF$ + #CRLF$ + "Traductrice pour le Ukrainien: mewity"  + #CRLF$ + #CRLF$ + "Traductrice pour le Portugais bozg"

Global.s stringSettingsWindowTitle = "Instalation de Acid Launcher"

Global.s stringKeepLauncherOpenGadget = "Garder le launcher ouvert meme après le jeux est ouvert"

Global.s stringLauncherLayoutChangeGadget = "Utiliser le design de launcher originel"
Global.s descLauncherLayoutChangeGadget = "Basculer le mise en page utilise dans le projet originel."

Global.s stringSaveLaunchStringGadget = "Ecrit toutes les paramètres de lancement dans un fichier"
Global.s descSaveLaunchStringGadget = "Toute la commande de lancement dans launch_string.txt."

Global.s stringDownloadMissingLibrariesGadget = "Tele-charger les libraries manquants quand le jeux est lance"

Global.s stringAsyncDownloadGadget = "Quantité de threads utilises pour le téléchargement"
Global.s stringDownloadThreadsGadget = "Plus de threads peut faire le téléchargement plus rapide a l'expense de resources ."

Global.s stringJavaPathGadget = "Location de Binaire Java utilise pour lancer le jeux"

Global.s stringUseCustomParamsGadget = "Arguments personnalisés"

Global.s stringUseCustomJava = "Choisir un chemin personalise pour le Java Runtime"
Global.s descUseCustomJava = "Permette de specifier un un chemin personalise pour le Java Runtime."

Global.s stringUseCustomParamsGadget = "Modifier les arguments de lancement du Jeu"
Global.s descArgsGadget = "Cette arguments de lancement vont être utilises pour lancer le Jeux."

Global.s stringSaveSettingsButton = "Sauvegarder et fermez"

; [   ------- Play Errors --------    ]

Global.s stringClientJarFileFail = "Le fichier client.jar n'a été pas trouve!"
Global.s stringJSONFileFail = "Le fichier client.json n'a été pas trouve!"

Global.s stringJavaNotFound = "Java pas trouve! Verifier si vous avez Java instalè," + #CRLF$ + "Ou verifier si vous avez correctement introduit sa location."
Global.s stringNoName = "Vous devait introduire un pseudonyme."
Global.s stringShortName = "Votre nome devait être un minimum de 3 characteres."

Global.s stringNoRam = "Indiquer la quantité de RAM."
Global.s stringRAMAlert = "Quantité de RAM indique es trop bas pour le Jeux ." + #CRLF$ + "Setting to 512MB to improve stabilty."

; [   ------- Download Box --------    ]

Global.s stringDownloadWindowTitle = "Telechargeur de client "

Global.s stringVersionsTypeGadget = "Voire touts les versions"
Global.s stringDownloadAllFilesGadget = "ReInstaler toutes les fichiers"

Global.s stringSetupMods = "Obtenir Fabric"

Global.s stringDownloadVersionButton = "Telecharger"

;     ------ Download Process -----

Global.s stringDesperate = "Attendre que le téléchargement pour être complet!"
Global.s stringDesperateTitle = "Téléchargement en progress"

; Errors

Global.s stringNoInternetTitle = "Téléchargement"
Global.s stringNoInternet = "Ça ressemble que tu n'a pas une conection d'internet "

;     ------ Fabric Installer -----

Global.s stringInstallSuccess = "Fabric a été installé avec succés! S'il te plaît relancer le launcher."

Global.s strp1CantRunInstaller = "Il a été une erreur pour lancer la commande : "
Global.s strp2CantRunInstaller = " C'es probablement une erreure de vote part. Contacter la développeuse "
Global.s stringCantDownloadFabric = "Echoue de télécharger Fabric installer. Verifier votre connection d'internet ou votre parametrés de pare-feu."
Global.s stringCantFindJSON = "Le fichier fabric.json. ne pouvait pas être trouve" + #CRLF$ + " Verifier si c'est dans %Temp% et/ou contactez la développeuse"
