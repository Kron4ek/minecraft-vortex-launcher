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
; It's simple, change __all__ the text that is inside of the
; double quotes you will find after scrolling down this, and
; try your best to translate it to your language of choice.
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

Global.s stringUsername = "Ім'я користувача"
Global.s stringGameVersion = "Версія гри"
Global.s stringRAM = "ОЗУ"
Global.s stringRAMTooltip = "Кількість ОЗУ для гри"
Global.s stringJavaRuntime = "версія Java"

Global.s stringFindInstalledVersions = "Версії не знайдено"

;     ---- Main screen actions -----
; These are the big buttons you will see when starting the launcher, which when clicked on perform various administrative actions

Global.s stringGaming = "Почати гру"
Global.s stringDownload = "Скачати"
Global.s stringSettings = "Налаштування"

Global.s stringCredits = "Титри!"
Global.s stringCreditsList = "Головна репозиторія лаунчеру:" + #CRLF$ + "https://github.com/stuxvii/acid-launcher" + #CRLF$ + #CRLF$ + "Головний розробник: acidbox" + #CRLF$ + #CRLF$ + "Перекладач на Англійську та Іспанську: acidbox" + #CRLF$ + #CRLF$ + "Перекладач на Українську: mewity" ; Change "LANGUAGE" by the language you're submitting and change "awesomeperson" with one of your socials (but you should probably keep "awesomeperson" as-is because that's referring to you xD )

; [   ------    Settings    ------    ]
; These are names for settings used in the launcher

Global.s stringSettingsWindowTitle = "Налаштування Acid Launcher"

Global.s stringKeepLauncherOpenGadget = "Залишати лаунчер відкритим після запуску гри"

Global.s stringLauncherLayoutChangeGadget = "Використовувати дизайн оригінального лаунчера"
Global.s descLauncherLayoutChangeGadget = "Переключитися на дизайн оригінального проекту."

Global.s stringSaveLaunchStringGadget = "Записувати параметри запуску в файл"
Global.s descSaveLaunchStringGadget = "Повна команда запуску буде збережено в launch_string.txt."

Global.s stringDownloadMissingLibrariesGadget = "Завантажити бібіліотеки, яких немає, коли гра запущена"

Global.s stringAsyncDownloadGadget = "Кількість потоків використаних при завантаженні"
Global.s stringDownloadThreadsGadget = "Більше потоків можуть пришвидшити завантаження, але використає більше системних ресурсів."

Global.s stringJavaPathGadget = "Локація бінарнику Java, використаного при запуску гри"

Global.s stringUseCustomParamsGadget = "Кастомні аргументи"

Global.s stringUseCustomJava = "Використати кастомний путь до Java Runtime"
Global.s descUseCustomJava = "Дозволити використовування кастомного путя до Java Runtime."

Global.s stringUseCustomParamsGadget = "Змінити аргументи запуску гри"
Global.s descArgsGadget = "Ці аргументи запуску будуть використані для запуску гри."

Global.s stringSaveSettingsButton = "Зберегти та вийти"

; [   ------- Play Errors --------    ]
; These are errors that may occurr when trying to initialize the game
Global.s stringClientJarFileFail = "client.jar не знайдено!"
Global.s stringJSONFileFail = "client.json не знайдено!"

Global.s stringJavaNotFound = "Java не знайдено! Перевірте, чи встановлена у вас на системі Java," + #CRLF$ + "чи перевірте правильність написання її локації."
Global.s stringNoName = "Спочатку введіть ім'я."
Global.s stringShortName = "Ваше ім'я повинно бути мінімально 3 букви."

Global.s stringNoRam = "Введіть кількість ОЗУ."
Global.s stringRAMAlert = "Замало ОЗУ для гри." + #CRLF$ + "Змінено на 512МБ для покращення стабільності."

; [   ------- Download Box --------    ]
; Strings utilized for the download box

Global.s stringDownloadWindowTitle = "Скачувальник Клієнтів"

Global.s stringVersionsTypeGadget = "Показати всі версії"
Global.s stringDownloadAllFilesGadget = "Перескачати всі файли"

Global.s stringSetupMods = "Скачати Fabric"

Global.s stringDownloadVersionButton = "Скачати"

;     ------ Download Process -----

Global.s stringDesperate = "Почекайте кінця завантаження!"
Global.s stringDesperateTitle = "Завантаження в прогрессі"

; Errors

Global.s stringNoInternetTitle = "Помилка Завантаження"
Global.s stringNoInternet = "Виглядає, ніби у вас немає інтернету."

;     ------ Fabric Installer -----

Global.s stringInstallSuccess = "Fabric встановлено успішно! Будь ласка, перезапустіть лаунчер."

Global.s strp1CantRunInstaller = "Помалка виконання команди: "
Global.s strp2CantRunInstaller = " Це, скоріш за все, ваша помилка. Контактуйте розробника для подальшої допомоги"
Global.s stringCantDownloadFabric = "Помилка завантаження Fabric. Перевірте налаштування інтернету та фаєрволу."
Global.s stringCantFindJSON = "fabric.json не знайдено." + #CRLF$ + "Перевірте, чи є він в %Temp% та/чи контактуйте розробника."
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 96
; FirstLine = 57
; EnableXP
; DPIAware
; DisableDebugger