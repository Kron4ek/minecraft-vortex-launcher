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

Global.s stringUsername = "Username"
Global.s stringGameVersion = "Game version"
Global.s stringRAM = "RAM"
Global.s stringRAMTooltip = "RAM amount for Game."
Global.s stringJavaRuntime = "Java version"

Global.s stringFindInstalledVersions = "Versions not found"

;     ---- Main screen actions -----
; These are the big buttons you will see when starting the launcher, which when clicked on perform various administrative actions

Global.s stringGaming = "Start Game"
Global.s stringDownload = "Download"
Global.s stringSettings = "Settings"

Global.s stringCredits = "Credits!"
Global.s stringCreditsList = "Main repo for the launcher:" + #CRLF$ + "https://github.com/stuxvii/acid-launcher" + #CRLF$ + #CRLF$ + "Main developer: acidbox" + #CRLF$ + #CRLF$ + "Translator for English and Spanish: acidbox" + #CRLF$ + #CRLF$ + "Translator for Ukranian: mewity" + #CRLF$ + #CRLF$ + "Translator for Portuguese: bozg" + #CRLF$ + #CRLF$ + "Translator for French & Romanian: skvlk78" ; Change "LANGUAGE" by the language you're submitting and change "awesomeperson" with one of your socials (but you should probably keep "awesomeperson" as-is because that's referring to you xD )

; [   ------    Settings    ------    ]
; These are names for settings used in the launcher

Global.s stringSettingsWindowTitle = "Set-up Acid Launcher"

Global.s stringKeepLauncherOpenGadget = "Keep launcher open after Game is opened"

Global.s stringLauncherLayoutChangeGadget = "Use original launcher design"
Global.s descLauncherLayoutChangeGadget = "Toggle to the layout used in the original project."

Global.s stringSaveLaunchStringGadget = "Write full launch parameters to a file"
Global.s descSaveLaunchStringGadget = "The entire launch command will be saved to launch_string.txt."

Global.s stringDownloadMissingLibrariesGadget = "Download missing libraries when Game is launched"

Global.s stringAsyncDownloadGadget = "Amount of threads used for downloading"
Global.s stringDownloadThreadsGadget = "More threads can make downloads faster at the expense of system resources."

Global.s stringJavaPathGadget = "Location of Java binary used to run Game"

Global.s stringUseCustomParamsGadget = "Custom arguments"

Global.s stringUseCustomJava = "Set a custom path for the Java Runtime"
Global.s descUseCustomJava = "Allow specifing a custom path for the Java Runtime."

Global.s stringUseCustomParamsGadget = "Modify game launch arguments"
Global.s descArgsGadget = "These launch arguments will be used to launch Game."

Global.s stringSaveSettingsButton = "Save and close"

; [   ------- Play Errors --------    ]
; These are errors that may occurr when trying to initialize the game
Global.s stringClientJarFileFail = "The client.jar file wasn't found!"
Global.s stringJSONFileFail = "The client.json file wasn't found!"

Global.s stringJavaNotFound = "Java not found! Check if you have Java installed," + #CRLF$ + "or check if you have correctly entered its location."
Global.s stringNoName = "You must enter a name."
Global.s stringShortName = "Your name must be at least 3 characters long."

Global.s stringNoRam = "Enter RAM amount."
Global.s stringRAMAlert = "Assigned amount of RAM for game is too low." + #CRLF$ + "Setting to 512MB to improve stabilty."

; [   ------- Download Box --------    ]
; Strings utilized for the download box

Global.s stringDownloadWindowTitle = "Client Downloader"

Global.s stringVersionsTypeGadget = "Show all versions"
Global.s stringDownloadAllFilesGadget = "Redownload all files"

Global.s stringSetupMods = "Get Fabric"

Global.s stringDownloadVersionButton = "Download"

;     ------ Download Process -----

Global.s stringDesperate = "Wait for download to complete!"
Global.s stringDesperateTitle = "Download in progress"

; Errors

Global.s stringNoInternetTitle = "Download Error"
Global.s stringNoInternet = "Seems like you have no internet connection"

;     ------ Fabric Installer -----

Global.s stringInstallSuccess = "Fabric has been successfully installed! Please relaunch the launcher."

Global.s strp1CantRunInstaller = "There was an error running the command: "
Global.s strp2CantRunInstaller = " This is probably an error on your end. Contact the developer for further asistance"
Global.s stringCantDownloadFabric = "Failed to download Fabric installer. Check your internet or firewall settings."
Global.s stringCantFindJSON = "fabric.json file couldn't be found." + #CRLF$ + "Check if it is in %Temp% and/or contact the dev"
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 96
; FirstLine = 71
; EnableXP
; DPIAware
; DisableDebugger