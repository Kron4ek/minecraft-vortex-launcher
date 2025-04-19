EnableExplicit

Global.s workingDirectory = RTrim(GetPathPart(ProgramFilename()), "\")
Global.s tempDirectory = GetTemporaryDirectory()

Global Dim programFilesDir.s(1)
Global.i downloadOkButton
Global.i downloadThread
Global.i downloadThreadsAmount
Global.i asyncDownload
Global.i versionsGadget, playButton, javaListGadget, creditsButton, languageList
Global.i progressBar, filesLeft, progressWindow, downloadingClientTextGadget
Global.i versionsDownloadGadget, downloadVersionButton, setupMods, loaderList
Global.i forceDownloadMissingLibraries
Global.s versionsManifestString
Global.i a, loader
Define *FileBuffer
Define.i javaProgram
Define.i Event, font, ramGadget, nameGadget, javaPathGadget, argsGadget, downloadButton, settingsButton, launcherVersionGadget, launcherAuthorGadget
Define.i saveLaunchString, versionsTypeGadget, saveLaunchStringGadget, launchStringFile, inheritsJsonObject, jsonInheritsArgumentsModernMember
Define.i argsTextGadget, javaBinaryPathTextGadget, downloadThreadsTextGadget, downloadAllFilesGadget, javaPathGadget, language
Define.i gadgetsWidth, gadgetsHeight, gadgetsIndent, windowWidth, windowHeight
Define.i listOfFiles, jsonFile, jsonObject, jsonObjectObjects, fileSize, jsonJarMember, jsonArgumentsArray, jsonArrayElement, inheritsJson, clientSize
Define.i releaseTimeMember, releaseTime, jsonJvmArray, loggingMember, loggingClientMember, loggingFileMember, logConfSize

Define.s playerName, ramAmount, clientVersion, javaBinaryPath, fullLaunchString, assetsIndex, clientUrl, fileHash, versionToDownload
Define.s assetsIndex, clientMainClass, clientArguments, inheritsClientJar, customLaunchArguments, clientJarFile, nativesPath, librariesString
Define.s uuid, jvmArguments, logConfId, logConfUrl, logConfArgument

Define.i downloadMissingLibraries, jsonArgumentsMember, jsonArgumentsModernMember, jsonInheritsFromMember
Define.i downloadMissingLibrariesGadget, downloadThreadsGadget, asyncDownloadGadget, saveSettingsButton, useCustomJavaGadget, useCustomParamsGadget, keepLauncherOpenGadget, LauncherLayoutChangeGadget, LauncherLayoutChange
Define.i i

; Set some default variables for config, fields, etc

Define.s playerNameDefault = "chickenjockey", ramAmountDefault = "1024", javaBinaryPathDefault = "C:\jre8\bin\javaw.exe"
Define.s customLaunchArgumentsDefault = "-Xss1M -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M"
Define.s customOldLaunchArgumentsDefault = "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M"
Define.i downloadThreadsAmountDefault = 20
Define.i asyncDownloadDefault = 1
Define.i downloadMissingLibrariesDefault = 1
Define.i downloadAllFilesDefault = 0
Define.i versionsTypeDefault = 0
Define.i saveLaunchStringDefault = 0
Define.i useCustomParamsDefault = 0
Define.i keepLauncherOpenDefault = 0
Global.i useCustomJavaDefault = 0
Define.i LauncherLayoutChange = 0
Define.i language = 0

; Version and developer settings, probably should actually start updating it instead of just staying the same shit all the damn time
Define.s launcherVersion = "2.0"
Define.s launcherDeveloper = "acidbox's take"

Declare assetsToResources(assetsIndex.s)
Declare findJava()
Declare progressWindow(clientVersion.s)
Declare findInstalledVersions()
Declare downloadFiles(downloadAllFiles.i)
Declare CreateDirectoryRecursive(path.s)
Declare getFabric(clientVersion)

Declare.s parseVersionsManifest(versionType.i = 0, getClientJarUrl.i = 0, clientVersion.s = "")
Declare.s parseLibraries(clientVersion.s, prepareForDownload.i = 0, librariesString.s = "")
Declare.s fileRead(pathToFile.s)
Declare.s removeSpacesFromVersionName(clientVersion.s)

programFilesDir(0) = GetEnvironmentVariable("ProgramW6432") + "\"
programFilesDir(1) = GetEnvironmentVariable("PROGRAMFILES") + "\"

SetCurrentDirectory(workingDirectory)
OpenPreferences("acid_launcher.conf")

If ReadPreferenceInteger("Lang", language) = 0 ; Here we perform a check for changing the language, reading from acid_launcher.conf
  IncludeFile("lang_enus.pb")
ElseIf ReadPreferenceInteger("Lang", language) = 1
  IncludeFile("lang_ukr.pb")
ElseIf ReadPreferenceInteger("Lang", language) = 2
  IncludeFile("lang_ptbr.pb")
ElseIf ReadPreferenceInteger("Lang", language) = 3
  IncludeFile("lang_fr.pb")  
ElseIf ReadPreferenceInteger("Lang", language) = 4
  IncludeFile("lang_esar.pb")
EndIf
downloadThreadsAmount = ReadPreferenceInteger("DownloadThreads", downloadThreadsAmountDefault)
asyncDownload = ReadPreferenceInteger("AsyncDownload", asyncDownloadDefault)

DeleteFile(tempDirectory + "acid_download_list.txt")
ReadPreferenceInteger("LauncherLayoutChange", 0)
RemoveEnvironmentVariable("_JAVA_OPTIONS")

If ReadPreferenceInteger("LauncherLayoutChange", 0) ; Here we do a quick check, searching if the layout changing option is enabled, and performing necesary changes if so
  windowWidth = 200
  windowHeight = 280
Else
  windowWidth = 330
  windowHeight = 175
EndIf

If OpenWindow(0, #PB_Ignore, #PB_Ignore, windowWidth, windowHeight, "Acid Launcher") ;
  If ReadPreferenceInteger("LauncherLayoutChange", 0) = 1 ; Ditto
    gadgetsWidth = windowWidth - 10
    gadgetsHeight = 25
    gadgetsIndent = 5
  Else
    gadgetsWidth = 150
    gadgetsHeight = 35
  EndIf
  
  If ReadPreferenceInteger("LauncherLayoutChange", 0) = 1 ; Ditto
    nameGadget = StringGadget(#PB_Any, gadgetsIndent, 5, gadgetsWidth, gadgetsHeight, ReadPreferenceString("Name", playerNameDefault))
    SetGadgetAttribute(nameGadget, #PB_String_MaximumLength, 16)
    ramGadget = StringGadget(#PB_Any, gadgetsIndent, 35, gadgetsWidth, gadgetsHeight, ReadPreferenceString("Ram", ramAmountDefault), #PB_String_Numeric)
    GadgetToolTip(ramGadget, stringRAMTooltip)
    SetGadgetAttribute(ramGadget, #PB_String_MaximumLength, 6)
    versionsGadget = ComboBoxGadget(#PB_Any, gadgetsIndent, 65, gadgetsWidth, gadgetsHeight)
    javaListGadget = ComboBoxGadget(#PB_Any, gadgetsIndent, 95, gadgetsWidth, gadgetsHeight)
    playButton = ButtonGadget(#PB_Any, gadgetsIndent, 130, gadgetsWidth, gadgetsHeight + 5, stringGaming)
    downloadButton = ButtonGadget(#PB_Any, gadgetsIndent, 165, gadgetsWidth, gadgetsHeight + 5, stringDownload)
    settingsButton = ButtonGadget(#PB_Any, gadgetsIndent, 200, gadgetsWidth / 2, gadgetsHeight + 5, stringSettings)
    languageList = ComboBoxGadget(#PB_Any, gadgetsIndent * 20, 200, gadgetsWidth / 2, gadgetsHeight * 1.2)
    creditsButton = ButtonGadget(#PB_Any, gadgetsIndent, 235, gadgetsWidth, gadgetsHeight + 5, stringCredits)
  Else
    TextGadget(#PB_Any, 8, 5, 700, 20, stringUsername)
    nameGadget = StringGadget(#PB_Any, 5, 20, gadgetsWidth * 2.13, gadgetsHeight / 1.5, ReadPreferenceString("Name", playerNameDefault))
    TextGadget(#PB_Any, 8, 43, 140, 13, stringGameVersion)
    versionsGadget = ComboBoxGadget(#PB_Any, 5, 57, gadgetsWidth / 1.085, gadgetsHeight / 1.5)
    TextGadget(#PB_Any, 150, 43, 40, 13, stringRAM)
    ramGadget = StringGadget(#PB_Any, 148, 57, gadgetsWidth / 2.55, gadgetsHeight / 1.5, ReadPreferenceString("Ram", ramAmountDefault), #PB_String_Numeric)
    TextGadget(#PB_Any, 210, 43, 700, 13, stringJavaRuntime)
    javaListGadget = ComboBoxGadget(#PB_Any, 210, 57, gadgetsWidth / 1.3, gadgetsHeight / 1.5)
    playButton = ButtonGadget(#PB_Any, 5, 85, gadgetsWidth * 1.35, gadgetsHeight, stringGaming)
    languageList = ComboBoxGadget(#PB_Any, 195 / 1.88, 125, gadgetsWidth * 1.238 / 1.8, gadgetsHeight)
    downloadButton = ButtonGadget(#PB_Any, 210, 85, gadgetsWidth / 1.3, gadgetsHeight, stringDownload)
    settingsButton = ButtonGadget(#PB_Any, 5, 125, gadgetsWidth * 1.238 / 1.9, gadgetsHeight, stringSettings)
    creditsButton = ButtonGadget(#PB_Any, 210, 125, gadgetsWidth / 1.3, gadgetsHeight, stringCredits)
  EndIf
  If LoadFont(2, "Arial", 10)
    SetGadgetFont(playButton, FontID(2))
    SetGadgetFont(downloadButton, FontID(2))
    SetGadgetFont(settingsButton, FontID(2))
    SetGadgetFont(creditsButton, FontID(2))
    SetGadgetFont(nameGadget, FontID(2))
  EndIf
  
  AddGadgetItem(languageList, 0, "english(US)") ; Here we list available languages
  AddGadgetItem(languageList, 1, "українська(UKR)")
  AddGadgetItem(languageList, 2, "português(BR)")
  AddGadgetItem(languageList, 3, "français(FR)")
  AddGadgetItem(languageList, 4, "Español(AR)")
  SetGadgetState(languageList, ReadPreferenceInteger("Lang", language)) ; Here we set the language list display to match with the user's selection
  launcherAuthorGadget = TextGadget(#PB_Any, 2, windowHeight - 10, 700, 20, launcherDeveloper)
  launcherVersionGadget = TextGadget(#PB_Any, windowWidth - 20, windowHeight - 10, 50, 20, "v" + launcherVersion)
  If LoadFont(1, "Arial", 7)
    font = FontID(1) : SetGadgetFont(launcherAuthorGadget, font) : SetGadgetFont(launcherVersionGadget, font)
  EndIf
  SetGadgetAttribute(ramGadget, #PB_String_MaximumLength, 6)
  SetGadgetAttribute(nameGadget, #PB_String_MaximumLength, 16)
  findInstalledVersions()
  findJava()
  
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case playButton
          ramAmount = GetGadgetText(ramGadget)
          clientVersion = GetGadgetText(versionsGadget)
          playerName = GetGadgetText(nameGadget)
          javaBinaryPath = GetGadgetText(javaListGadget)
          downloadMissingLibraries = ReadPreferenceInteger("DownloadMissingLibs", downloadMissingLibrariesDefault)
          librariesString = ""
          clientArguments = ""
          jvmArguments = ""
          logConfArgument = ""
          
          If FindString(clientVersion, " ")
            clientVersion = removeSpacesFromVersionName(clientVersion)
          EndIf
          
          If forceDownloadMissingLibraries
            downloadMissingLibraries = 1
          EndIf
          
          If FindString(playerName, " ")
            playerName = ReplaceString(playerName, " ", "")
          EndIf
          
          If ramAmount And Len(playerName) >= 3
            If ReadPreferenceInteger("UseCustomJava", useCustomJavaDefault)
              javaBinaryPath = ReadPreferenceString("JavaPath", javaBinaryPathDefault)
            ElseIf Right(javaBinaryPath, 5) = "(x32)"
              javaBinaryPath = programFilesDir(1) + "Java\" + RemoveString(javaBinaryPath, " (x32)") + "\bin\javaw.exe"
            Else
              javaBinaryPath = programFilesDir(0) + "Java\" + javaBinaryPath + "\bin\javaw.exe"
            EndIf
            
            If Val(ramAmount) < 512
              ramAmount = "512"
              
              MessageRequester("Warning", stringRAMAlert)
            EndIf
            
            WritePreferenceString("Name", playerName)
            WritePreferenceString("Ram", ramAmount)
            WritePreferenceString("ChosenVer", clientVersion)
            
            If RunProgram(javaBinaryPath, "-version", workingDirectory)
              jsonFile = ParseJSON(#PB_Any, fileRead("versions\" + clientVersion + "\" + clientVersion + ".json"))
              
              If jsonFile
                clientJarFile = "versions\" + clientVersion + "\" + clientVersion + ".jar"
                nativesPath = "versions\" + clientVersion + "\natives"
                
                jsonObject = JSONValue(jsonFile)
                
                jsonJarMember = GetJSONMember(jsonObject, "jar")
                jsonInheritsFromMember = GetJSONMember(jsonObject, "inheritsFrom")
                
                If jsonInheritsFromMember Or jsonJarMember
                  If jsonInheritsFromMember
                    inheritsClientJar = GetJSONString(jsonInheritsFromMember)
                  Else
                    inheritsClientJar = GetJSONString(jsonJarMember)
                  EndIf
                  
                  If FileSize(clientJarFile) < 1 And FileSize("versions\" + inheritsClientJar + "\" + inheritsClientJar + ".jar") > 0
                    CopyFile("versions\" + inheritsClientJar + "\" + inheritsClientJar + ".jar", clientJarFile)
                  EndIf
                  
                  nativesPath = "versions\" + inheritsClientJar + "\natives"
                EndIf
                
                releaseTimeMember = GetJSONMember(jsonObject, "releaseTime")
                
                If releaseTimeMember
                  releaseTime = Val(StringField(GetJSONString(releaseTimeMember), 1, "-")) * 365 + Val(StringField(GetJSONString(releaseTimeMember), 2, "-")) * 30
                EndIf
                
                jsonArgumentsMember = GetJSONMember(jsonObject, "minecraftArguments")
                jsonArgumentsModernMember = GetJSONMember(jsonObject, "arguments")
                
                If jsonArgumentsMember
                  clientArguments = GetJSONString(jsonArgumentsMember)
                ElseIf jsonArgumentsModernMember
                  jsonArgumentsArray = GetJSONMember(jsonArgumentsModernMember, "game")
                  jsonJvmArray = GetJSONMember(jsonArgumentsModernMember, "jvm")
                  
                  For i = 0 To JSONArraySize(jsonArgumentsArray) - 1
                    jsonArrayElement = GetJSONElement(jsonArgumentsArray, i)
                    
                    If JSONType(jsonArrayElement) = #PB_JSON_String
                      clientArguments + " " + GetJSONString(jsonArrayElement) + " "
                    EndIf
                  Next
                  
                  If jsonJvmArray
                    For i = 0 To JSONArraySize(jsonJvmArray) - 1
                      jsonArrayElement = GetJSONElement(jsonJvmArray, i)
                      
                      If JSONType(jsonArrayElement) = #PB_JSON_String
                        jvmArguments + " " + Chr(34) + GetJSONString(jsonArrayElement) + Chr(34) + " "
                      EndIf
                    Next
                  EndIf
                EndIf
                
                If FileSize(clientJarFile) > 0
                  librariesString + parseLibraries(clientVersion, downloadMissingLibraries)
                  
                  If jsonInheritsFromMember
                    inheritsClientJar = GetJSONString(jsonInheritsFromMember)
                    
                    inheritsJson = ParseJSON(#PB_Any, fileRead("versions\" + inheritsClientJar + "\" + inheritsClientJar + ".json"))
                    
                    If inheritsJson
                      inheritsJsonObject = JSONValue(inheritsJson)
                      jsonInheritsArgumentsModernMember = GetJSONMember(inheritsJsonObject, "arguments")
                      
                      If jsonInheritsArgumentsModernMember
                        jsonArgumentsArray = GetJSONMember(jsonInheritsArgumentsModernMember, "game")
                        jsonJvmArray = GetJSONMember(jsonInheritsArgumentsModernMember, "jvm")
                        
                        For i = 0 To JSONArraySize(jsonArgumentsArray) - 1
                          jsonArrayElement = GetJSONElement(jsonArgumentsArray, i)
                          
                          If JSONType(jsonArrayElement) = #PB_JSON_String
                            clientArguments + " " + GetJSONString(jsonArrayElement) + " "
                          EndIf
                        Next
                        
                        If jsonJvmArray
                          For i = 0 To JSONArraySize(jsonJvmArray) - 1
                            jsonArrayElement = GetJSONElement(jsonJvmArray, i)
                            
                            If JSONType(jsonArrayElement) = #PB_JSON_String
                              jvmArguments + " " + Chr(34) + GetJSONString(jsonArrayElement) + Chr(34) + " "
                            EndIf
                          Next
                        EndIf
                      EndIf
                      
                      librariesString + parseLibraries(inheritsClientJar, downloadMissingLibraries, librariesString)
                      assetsIndex = GetJSONString(GetJSONMember(JSONValue(inheritsJson), "assets"))
                      
                      releaseTimeMember = GetJSONMember(inheritsJsonObject, "releaseTime")
                      
                      If releaseTimeMember
                        releaseTime = Val(StringField(GetJSONString(releaseTimeMember), 1, "-")) * 365 + Val(StringField(GetJSONString(releaseTimeMember), 2, "-")) * 30
                      EndIf
                    Else
                      MessageRequester("Error", inheritsClientJar + ".json file is missing!") : Break
                    EndIf
                  Else
                    If GetJSONMember(jsonObject, "assets")
                      assetsIndex = GetJSONString(GetJSONMember(jsonObject, "assets"))
                    ElseIf releaseTime > 0 And releaseTime < 734925
                      assetsIndex = "pre-1.6"
                    Else
                      assetsIndex = "legacy"
                    EndIf
                  EndIf
                  
                  If jsonInheritsFromMember And inheritsJson
                    loggingMember = GetJSONMember(inheritsJsonObject, "logging")
                  Else
                    loggingMember = GetJSONMember(jsonObject, "logging")
                  EndIf
                  
                  If loggingMember
                    loggingClientMember = GetJSONMember(loggingMember, "client")
                    
                    If loggingClientMember
                      loggingFileMember = GetJSONMember(loggingClientMember, "file")
                      
                      If loggingFileMember
                        logConfArgument = "-Dlog4j.configurationFile=assets\log_configs\" + GetJSONString(GetJSONMember(loggingFileMember, "id"))
                      EndIf
                    EndIf
                  EndIf
                  
                  If inheritsJson
                    FreeJSON(inheritsJson)
                  EndIf
                  
                  clientMainClass = GetJSONString(GetJSONMember(jsonObject, "mainClass"))
                  
                  UseMD5Fingerprint()
                  
                  uuid = StringFingerprint("OfflinePlayer:" + playerName, #PB_Cipher_MD5)
                  uuid = Left(uuid, 12) + LCase(Hex(Val("$" + Mid(uuid, 13, 2)) & $0f | $30)) + Mid(uuid, 15, 2) + LCase(Hex(Val("$" + Mid(uuid, 17, 2)) & $3f | $80)) + Right(uuid, 14)
                  
                  If assetsIndex = "pre-1.6" Or assetsIndex = "legacy"
                    assetsToResources(assetsIndex)
                  EndIf
                  
                  If downloadMissingLibraries
                    downloadFiles(0)
                  EndIf
                  
                  If jvmArguments = ""
                    jvmArguments = Chr(34) + "-Djava.library.path=" + nativesPath + Chr(34) + " -cp " + Chr(34) + librariesString + clientJarFile + Chr(34)
                  EndIf
                  
                  If releaseTime > 0 And releaseTime < 736780
                    customLaunchArguments = customOldLaunchArgumentsDefault
                  Else
                    customLaunchArguments = customLaunchArgumentsDefault
                  EndIf
                  
                  If ReadPreferenceInteger("UseCustomParameters", useCustomParamsDefault)
                    customLaunchArguments = ReadPreferenceString("LaunchArguments", customLaunchArgumentsDefault)
                  EndIf
                  
                  fullLaunchString = "-Xmx" + ramAmount + "M " + customLaunchArguments + " -Dlog4j2.formatMsgNoLookups=true " + logConfArgument + " " + jvmArguments + " " + clientMainClass + " " + clientArguments
                  
                  fullLaunchString = ReplaceString(fullLaunchString, "${auth_player_name}", playerName)
                  fullLaunchString = ReplaceString(fullLaunchString, "${version_name}", clientVersion)
                  fullLaunchString = ReplaceString(fullLaunchString, "${game_directory}", Chr(34) + workingDirectory + Chr(34))
                  fullLaunchString = ReplaceString(fullLaunchString, "${assets_root}", "assets")
                  fullLaunchString = ReplaceString(fullLaunchString, "${auth_uuid}", uuid)
                  fullLaunchString = ReplaceString(fullLaunchString, "${auth_access_token}", "00000000000000000000000000000000")
                  fullLaunchString = ReplaceString(fullLaunchString, "${clientid}", "0000")
                  fullLaunchString = ReplaceString(fullLaunchString, "${auth_xuid}", "0000")
                  fullLaunchString = ReplaceString(fullLaunchString, "${user_properties}", "{}")
                  fullLaunchString = ReplaceString(fullLaunchString, "${user_type}", "mojang")
                  fullLaunchString = ReplaceString(fullLaunchString, "${version_type}", "release")
                  fullLaunchString = ReplaceString(fullLaunchString, "${assets_index_name}", assetsIndex)
                  fullLaunchString = ReplaceString(fullLaunchString, "${auth_session}", "00000000000000000000000000000000")
                  fullLaunchString = ReplaceString(fullLaunchString, "${game_assets}", "resources")
                  fullLaunchString = ReplaceString(fullLaunchString, "${classpath}", librariesString + clientJarFile)
                  fullLaunchString = ReplaceString(fullLaunchString, "${library_directory}", "libraries")
                  fullLaunchString = ReplaceString(fullLaunchString, "${classpath_separator}", ";")
                  fullLaunchString = ReplaceString(fullLaunchString, "${natives_directory}", nativesPath)
                  fullLaunchString = ReplaceString(fullLaunchString, Chr(34) + "-Dminecraft.launcher.brand=${launcher_name}" + Chr(34), "")
                  fullLaunchString = ReplaceString(fullLaunchString, Chr(34) + "-Dminecraft.launcher.version=${launcher_version}" + Chr(34), "")
                  
                  RunProgram(javaBinaryPath, fullLaunchString, workingDirectory)
                  
                  saveLaunchString = ReadPreferenceInteger("SaveLaunchString", saveLaunchStringDefault)
                  If saveLaunchString
                    DeleteFile("launch_string.txt")
                    
                    launchStringFile = OpenFile(#PB_Any, "launch_string.txt")
                    fullLaunchString = ReplaceString(fullLaunchString, "  ", " ")
                    WriteString(launchStringFile, Chr(34) + javaBinaryPath + Chr(34) + " " + fullLaunchString)
                    CloseFile(launchStringFile)
                  EndIf
                  
                  If Not ReadPreferenceInteger("KeepLauncherOpen", keepLauncherOpenDefault)
                    Break
                  EndIf
                Else
                  MessageRequester("Error", stringClientJarFileFail)
                EndIf
                
                FreeJSON(jsonFile)
              Else
                MessageRequester("Error", stringJSONFileFail)
              EndIf
            Else
              MessageRequester("Error", stringJavaNotFound)
            EndIf
          Else
            If playerName = ""
              MessageRequester("Error", stringNoName)
            ElseIf ramAmount = ""
              MessageRequester("Error", stringNoRam)
            ElseIf Len(playerName) < 3
              MessageRequester("Error", stringShortName)
            EndIf
          EndIf
        Case downloadButton
          *FileBuffer = ReceiveHTTPMemory("https://launchermeta.mojang.com/mc/game/version_manifest.json")
          If *FileBuffer
            If OpenWindow(1, #PB_Ignore, #PB_Ignore, 250, 100, stringDownloadWindowTitle, #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
              DisableGadget(downloadButton, 1)
              
              ComboBoxGadget(325, 5, 10, 240, 25)
              versionsDownloadGadget = 325
              CheckBoxGadget(110, 5, 45, 155, 20, stringVersionsTypeGadget)
              versionsTypeGadget = 110
              SetGadgetState(versionsTypeGadget, ReadPreferenceInteger("ShowAllVersions", versionsTypeDefault))
              CheckBoxGadget(817, 5, 70, 155, 20, stringDownloadAllFilesGadget)
              downloadAllFilesGadget = 817
              SetGadgetState(downloadAllFilesGadget, ReadPreferenceInteger("RedownloadFiles", downloadAllFilesDefault))
              setupMods = ButtonGadget(#PB_Any, 160, 45, 85, 20, stringSetupMods)
              downloadVersionButton = ButtonGadget(#PB_Any, 160, 70, 85, 20, stringDownloadVersionButton)
              
              If IsThread(downloadThread) : DisableGadget(downloadVersionButton, 1) : EndIf
              
              versionsManifestString = PeekS(*FileBuffer, MemorySize(*FileBuffer), #PB_UTF8)
              FreeMemory(*FileBuffer)
              
              parseVersionsManifest(GetGadgetState(versionsTypeGadget))
            EndIf
          Else
            MessageRequester(stringNoInternetTitle, stringNoInternet)
          EndIf
        Case versionsTypeGadget
          ClearGadgetItems(versionsDownloadGadget)
          parseVersionsManifest(GetGadgetState(versionsTypeGadget))
        Case setupMods
          Define.s tempdir
          tempdir = GetTemporaryDirectory()
          Define.s savepath = tempdir + "fabric-installer-latest.jar"
          Define.s jsonsavepath = tempdir + "fabric.json"
          Define.s jsoncontent
          Define.s latestURL, l
          Define.s javaPath, outputs, launchdir
          Define.i progrun
          Define.i result
          result = ReceiveHTTPFile("https://meta.fabricmc.net/v2/versions/installer", jsonsavepath); listen. if you come at me, yelling because i didn't implement a system to check if it was all already downloaded. shut up. it's a 200kb file you're not on fucking dial-up
          progrun = RunProgram("cmd", "/c where java", "", #PB_Program_Open | #PB_Program_Read)
          outputs = ReadProgramString(progrun)
          javaPath = Trim(outputs)
          launchdir = GetPathPart(ProgramFilename())
          If PathFileExists_("versions/" + GetGadgetText(versionsDownloadGadget))
            If result
              If ReadFile(1, jsonsavepath)
                jsoncontent=ReadString(1, #PB_File_IgnoreEOL)
                Define.i urlStart
                Define.i urlEnd
                If jsoncontent
                  urlStart = FindString(jsoncontent, "https", 6)
                  latestURL = Mid(jsoncontent, urlStart)
                  urlEnd = FindString(latestUrl, Chr(34))
                  latestURL = Mid(jsoncontent, urlStart, urlEnd - 1)
                  If ReceiveHTTPFile(latestURL, savepath)
                    If RunProgram(Chr(34) + javaPath + Chr(34) + " -jar " + Chr(34) + savepath + Chr(34) + " client -dir " + launchdir + " -mcversion " + GetGadgetText(versionsDownloadGadget))
                      MessageRequester("Success!", stringInstallSuccess)
                      CloseFile(1)
                    Else
                      MessageRequester("Error", strp1CantRunInstaller + #CRLF$ + Chr(34) + javaPath + Chr(34) + " -jar " + Chr(34) + savepath + Chr(34) + " client -dir " + launchdir + " -mcversion " + GetGadgetText(versionsDownloadGadget) + strp2CantRunInstaller)
                      CloseFile(1)
                    EndIf
                  Else
                    MessageRequester("Error", stringCantDownloadFabric)
                  EndIf 
                EndIf
              Else
                MessageRequester("Error", "fabric.json file couldn't be found." + #CRLF$ + "Check if it is in %Temp% and/or contact the dev")
              EndIf
            Else
              MessageRequester("Error", "Couldn't fetch fabric.json. Check your internet?")
            EndIf
          Else
            MessageRequester("Error", "Select the version you wish to mod. (Must be downloaded already)")
          EndIf
        Case downloadVersionButton
          versionToDownload = GetGadgetText(versionsDownloadGadget)
          
          CreateDirectoryRecursive("versions\" + versionToDownload)
          
          If ReceiveHTTPFile(parseVersionsManifest(GetGadgetState(versionsDownloadGadget), 1, versionToDownload), "versions\" + versionToDownload + "\" + versionToDownload + ".json")
            DeleteFile(tempDirectory + "acid_download_list.txt")
            listOfFiles = OpenFile(#PB_Any, tempDirectory + "acid_download_list.txt")
            
            jsonFile = ParseJSON(#PB_Any, fileRead("versions\" + versionToDownload + "\" + versionToDownload + ".json"))
            
            If jsonFile
              jsonObject = JSONValue(jsonFile)
              
              assetsIndex = GetJSONString(GetJSONMember(jsonObject, "assets"))
              
              CreateDirectoryRecursive("assets\indexes")
              ReceiveHTTPFile(GetJSONString(GetJSONMember(GetJSONMember(jsonObject, "assetIndex"), "url")), "assets\indexes\" + assetsIndex + ".json")
              
              loggingMember = GetJSONMember(jsonObject, "logging")
              
              If loggingMember
                loggingClientMember = GetJSONMember(loggingMember, "client")
                
                If loggingClientMember
                  loggingFileMember = GetJSONMember(loggingClientMember, "file")
                  
                  If loggingFileMember
                    logConfId = GetJSONString(GetJSONMember(loggingFileMember, "id"))
                    logConfUrl = GetJSONString(GetJSONMember(loggingFileMember, "url"))
                    logConfSize = GetJSONInteger(GetJSONMember(loggingFileMember, "size"))
                    
                    WriteStringN(listOfFiles, logConfUrl + "::" + "assets\log_configs\" + logConfId + "::" + logConfSize)
                    
                    CreateDirectoryRecursive("assets\log_configs")
                  EndIf
                EndIf
              EndIf
              
              clientUrl = GetJSONString(GetJSONMember(GetJSONMember(GetJSONMember(jsonObject, "downloads"), "client"), "url"))
              clientSize = GetJSONInteger(GetJSONMember(GetJSONMember(GetJSONMember(jsonObject, "downloads"), "client"), "size"))
              
              WriteStringN(listOfFiles, clientUrl + "::" + "versions\" + versionToDownload + "\" + versionToDownload + ".jar" + "::" + clientSize)
              
              FreeJSON(jsonFile)
            EndIf
            
            jsonFile = ParseJSON(#PB_Any, fileRead("assets\indexes\" + assetsIndex + ".json"))
            
            If jsonFile
              jsonObject = JSONValue(jsonFile)
              jsonObjectObjects = GetJSONMember(jsonObject, "objects")
              
              If ExamineJSONMembers(jsonObjectObjects)
                While NextJSONMember(jsonObjectObjects)
                  fileHash = GetJSONString(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "hash"))
                  fileSize = GetJSONInteger(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "size"))
                  
                  WriteStringN(listOfFiles, "https://resources.download.minecraft.net/" + Left(fileHash, 2) + "/" + fileHash + "::" + "assets\objects\" + Left(fileHash, 2) + "\" + fileHash + "::" + fileSize)
                Wend
              EndIf
              
              FreeJSON(jsonFile)
            EndIf
            
            CloseFile(listOfFiles)
            
            parseLibraries(versionToDownload, 1)
            
            DisableGadget(playButton, 1)
            progressWindow(versionToDownload)
            
            downloadThread = CreateThread(@downloadFiles(), GetGadgetState(downloadAllFilesGadget))
          Else
            MessageRequester("Download Error", "Seems like you have no internet connection!")
          EndIf
        Case settingsButton
          DisableGadget(settingsButton, 1)
          
          If OpenWindow(3, #PB_Ignore, #PB_Ignore, 340, 235, stringSettingsWindowTitle)
            
            CheckBoxGadget(689, 5, 5, 340, 20, stringKeepLauncherOpenGadget)
            keepLauncherOpenGadget = 689
            SetGadgetState(keepLauncherOpenGadget, ReadPreferenceInteger("KeepLauncherOpen", keepLauncherOpenDefault))
            
            CheckBoxGadget(777, 5, 25, 320, 20, stringLauncherLayoutChangeGadget)
            LauncherLayoutChangeGadget = 777
            GadgetToolTip(LauncherLayoutChangeGadget, descLauncherLayoutChangeGadget)
            SetGadgetState(LauncherLayoutChangeGadget, ReadPreferenceInteger("LauncherLayoutChange", LauncherLayoutChange))
            
            saveLaunchStringGadget = CheckBoxGadget(#PB_Any, 5, 45, 340, 20, stringSaveLaunchStringGadget)
            GadgetToolTip(saveLaunchStringGadget, descSaveLaunchStringGadget)
            SetGadgetState(saveLaunchStringGadget, ReadPreferenceInteger("SaveLaunchString", saveLaunchStringDefault))
            
            downloadMissingLibrariesGadget = CheckBoxGadget(#PB_Any, 5, 65, 340, 20, stringDownloadMissingLibrariesGadget)
            SetGadgetState(downloadMissingLibrariesGadget, ReadPreferenceInteger("DownloadMissingLibs", downloadMissingLibrariesDefault))
            
            CheckBoxGadget(311, 5, 85, 320, 20, stringAsyncDownloadGadget)
            asyncDownloadGadget = 311
            SetGadgetState(asyncDownloadGadget, ReadPreferenceInteger("AsyncDownload", asyncDownloadDefault))
            
            downloadThreadsGadget = StringGadget(#PB_Any, 5, 105, 330, 20, ReadPreferenceString("DownloadThreads", Str(downloadThreadsAmountDefault)), #PB_String_Numeric)
            GadgetToolTip(downloadThreadsGadget, stringDownloadThreadsGadget)
            
            SetGadgetAttribute(downloadThreadsGadget, #PB_String_MaximumLength, 3)
            
            CheckBoxGadget(312, 5, 128, 270, 15, stringUseCustomJava)
            useCustomJavaGadget = 312
            GadgetToolTip(useCustomJavaGadget, descUseCustomJava)
            SetGadgetState(useCustomJavaGadget, ReadPreferenceInteger("UseCustomJava", useCustomJavaDefault))
            
            javaPathGadget = StringGadget(#PB_Any, 5, 145, 330, 20, ReadPreferenceString("JavaPath", javaBinaryPathDefault))
            GadgetToolTip(javaPathGadget, stringJavaPathGadget)
            
            CheckBoxGadget(313, 5, 168, 270, 15, stringUseCustomParamsGadget)
            useCustomParamsGadget = 313
            GadgetToolTip(useCustomParamsGadget, stringUseCustomParamsGadget)
            SetGadgetState(useCustomParamsGadget, ReadPreferenceInteger("UseCustomParameters", useCustomParamsDefault))
            
            argsGadget = StringGadget(#PB_Any, 5, 185, 330, 20, ReadPreferenceString("LaunchArguments", customLaunchArgumentsDefault))
            GadgetToolTip(argsGadget, descArgsGadget)
            
            saveSettingsButton = ButtonGadget(#PB_Any, 5, 210, 330, 20, stringSaveSettingsButton)
            
            DisableGadget(downloadThreadsGadget, Bool(Not GetGadgetState(asyncDownloadGadget)))
            DisableGadget(javaPathGadget, Bool(Not GetGadgetState(useCustomJavaGadget)))
            DisableGadget(argsGadget, Bool(Not GetGadgetState(useCustomParamsGadget)))
          EndIf
        Case useCustomParamsGadget
          DisableGadget(argsGadget, Bool(Not GetGadgetState(useCustomParamsGadget)))
        Case useCustomJavaGadget
          DisableGadget(javaPathGadget, Bool(Not GetGadgetState(useCustomJavaGadget)))
        Case asyncDownloadGadget
          DisableGadget(downloadThreadsGadget, Bool(Not GetGadgetState(asyncDownloadGadget)))
        Case saveSettingsButton
          If GetGadgetText(downloadThreadsGadget) = "0" : SetGadgetText(downloadThreadsGadget, "5") : EndIf
          
          WritePreferenceInteger("DownloadMissingLibs", GetGadgetState(downloadMissingLibrariesGadget))
          WritePreferenceInteger("AsyncDownload", GetGadgetState(asyncDownloadGadget))
          WritePreferenceInteger("SaveLaunchString", GetGadgetState(saveLaunchStringGadget))
          WritePreferenceInteger("UseCustomJava", GetGadgetState(useCustomJavaGadget))
          WritePreferenceInteger("UseCustomParameters", GetGadgetState(useCustomParamsGadget))
          WritePreferenceInteger("KeepLauncherOpen", GetGadgetState(keepLauncherOpenGadget))
          WritePreferenceInteger("LauncherLayoutChange", GetGadgetState(LauncherLayoutChangeGadget))
          
          If GetGadgetState(useCustomJavaGadget)
            WritePreferenceString("JavaPath", GetGadgetText(javaPathGadget))
          EndIf
          
          If GetGadgetState(asyncDownloadGadget)
            WritePreferenceString("DownloadThreads", GetGadgetText(downloadThreadsGadget))
          EndIf
          
          If GetGadgetState(useCustomParamsGadget)
            WritePreferenceString("LaunchArguments", GetGadgetText(argsGadget))
          EndIf
          
          findJava()
          
          downloadThreadsAmount = Val(GetGadgetText(downloadThreadsGadget))
          asyncDownload = GetGadgetState(asyncDownloadGadget)
          DisableGadget(settingsButton, 0)
          
          CloseWindow(3)
        Case downloadOkButton
          CloseWindow(progressWindow)
          
          If IsGadget(playButton) : DisableGadget(playButton, 0) : EndIf
          If IsGadget(downloadVersionButton) : DisableGadget(downloadVersionButton, 0) : EndIf
          
        Case creditsButton
          MessageRequester("Credits", stringCreditsList)
      EndSelect
    EndIf
    
    If #PB_Event_LeftClick
      WritePreferenceString("Name", GetGadgetText(nameGadget))
      WritePreferenceString("Ram", GetGadgetText(ramGadget))
      WritePreferenceString("ChosenVer", GetGadgetText(versionsGadget))
      WritePreferenceInteger("Lang", GetGadgetState(languageList))
    EndIf
    
    If Event = #PB_Event_CloseWindow
      If EventWindow() = 1
        WritePreferenceInteger("ShowAllVersions", GetGadgetState(versionsTypeGadget))
        WritePreferenceInteger("RedownloadFiles", GetGadgetState(downloadAllFilesGadget))
        
        CloseWindow(1)
        
        DisableGadget(downloadButton, 0)
      ElseIf EventWindow() = progressWindow
        If Not IsThread(downloadThread)
          CloseWindow(progressWindow)
          
          If IsGadget(playButton) : DisableGadget(playButton, 0) : EndIf
          If IsGadget(downloadVersionButton) : DisableGadget(downloadVersionButton, 0) : EndIf
        Else
          MessageRequester(stringDesperateTitle, stringDesperate)
        EndIf
      ElseIf EventWindow() = 3
        CloseWindow(3)
        
        DisableGadget(settingsButton, 0)
      EndIf
    EndIf
    
    
    
  Until Event = #PB_Event_CloseWindow And EventWindow() = 0
  
  DeleteFile(tempDirectory + "acid_download_list.txt")
EndIf


Procedure findInstalledVersions()
  Define.s dirName, chosenVer = ReadPreferenceString("ChosenVer", "")
  Define.i directory, chosenFound
  
  directory = ExamineDirectory(#PB_Any, "versions", "*")
  
  DisableGadget(playButton, 0)
  DisableGadget(versionsGadget, 0)
  
  If directory
    While NextDirectoryEntry(directory)
      If DirectoryEntryType(directory) = #PB_DirectoryEntry_Directory
        dirName = DirectoryEntryName(directory)
        
        If dirName <> ".." And dirName <> "."
          If FileSize("versions\" + dirName + "\" + dirName + ".json") > -1
            If Not chosenFound And dirName = chosenVer
              chosenFound = 1
            EndIf
            
            AddGadgetItem(versionsGadget, -1, dirName)
          EndIf
        EndIf
      EndIf
    Wend
    
    FinishDirectory(directory)
    
    If chosenFound
      SetGadgetText(versionsGadget, chosenVer)
    Else
      SetGadgetState(versionsGadget, 0)
    EndIf
  EndIf
  
  If Not CountGadgetItems(versionsGadget)
    
    DisableGadget(playButton, 1)
    DisableGadget(versionsGadget, 1) : AddGadgetItem(versionsGadget, 0, stringFindInstalledVersions) : SetGadgetState(versionsGadget, 0)
  EndIf
EndProcedure

Procedure.s parseVersionsManifest(versionType.i = 0, getClientJarUrl.i = 0, clientVersion.s = "")
  Protected.i jsonFile, jsonObject, jsonVersionsArray, jsonArrayElement, i
  Protected.s url
  
  jsonFile = ParseJSON(#PB_Any, versionsManifestString)
  
  If jsonFile
    jsonObject = JSONValue(jsonFile)
    
    jsonVersionsArray = GetJSONMember(jsonObject, "versions")
    
    For i = 0 To JSONArraySize(jsonVersionsArray) - 1
      jsonArrayElement = GetJSONElement(jsonVersionsArray, i)
      
      If getClientJarUrl = 0 And versionType = 0 And GetJSONString(GetJSONMember(jsonArrayElement, "type")) <> "release"
        Continue
      EndIf
      
      If getClientJarUrl = 0
        AddGadgetItem(versionsDownloadGadget, -1, GetJSONString(GetJSONMember(jsonArrayElement, "id")))
      Else
        If GetJSONString(GetJSONMember(jsonArrayElement, "id")) = clientVersion
          url = GetJSONString(GetJSONMember(jsonArrayElement, "url"))
          FreeJSON(jsonFile)
          
          ProcedureReturn url
        EndIf
      EndIf
    Next
    
    FreeJSON(jsonFile)
  Else
    AddGadgetItem(versionsDownloadGadget, -1, "Error")
    DisableGadget(downloadVersionButton, 1)
  EndIf
  
  SetGadgetState(versionsDownloadGadget, 0)
EndProcedure

Procedure.s parseLibraries(clientVersion.s, prepareForDownload.i = 0, librariesString.s = "")
  Protected.i jsonLibrariesArray, jsonArrayElement, jsonFile, fileSize, downloadListFile, zipFile
  Protected.i jsonArtifactsMember, jsonDownloadsMember, jsonUrlMember, jsonClassifiersMember, jsonNativesLinuxMember
  Protected.i jsonRulesMember, jsonRulesOsMember
  Protected.i i, k
  Protected.i allowLib, skipLib
  
  Protected.s libName, libNameBase, libsString, packFileName, url
  Protected.s jsonRulesOsName
  Protected Dim libSplit.s(4)
  
  If prepareForDownload = 1
    downloadListFile = OpenFile(#PB_Any, tempDirectory + "acid_download_list.txt")
    FileSeek(downloadListFile, Lof(downloadListFile), #PB_Relative)
  EndIf
  
  UseZipPacker()
  
  jsonFile = ParseJSON(#PB_Any, fileRead("versions\" + clientVersion + "\" + clientVersion + ".json"))
  
  If jsonFile
    jsonLibrariesArray = GetJSONMember(JSONValue(jsonFile), "libraries")
    
    For i = 0 To JSONArraySize(jsonLibrariesArray) - 1
      jsonArrayElement = GetJSONElement(jsonLibrariesArray, i)
      allowLib = 1
      jsonRulesOsName = "empty"
      skipLib = 0
      
      jsonRulesMember = GetJSONMember(jsonArrayElement, "rules")
      
      If jsonRulesMember
        For k = 0 To JSONArraySize(jsonRulesMember) - 1
          jsonRulesOsMember = GetJSONMember(GetJSONElement(jsonRulesMember, k), "os")
          
          If jsonRulesOsMember
            jsonRulesOsName = GetJSONString(GetJSONMember(jsonRulesOsMember, "name"))
          EndIf
          
          If GetJSONString(GetJSONMember(GetJSONElement(jsonRulesMember, k), "action")) = "allow"
            If jsonRulesOsName <> "empty" And jsonRulesOsName <> "windows"
              allowLib = 0
            EndIf
          Else
            If jsonRulesOsName = "windows"
              allowLib = 0
            EndIf
          EndIf
        Next
      EndIf
      
      If allowLib
        libName = GetJSONString(GetJSONMember(jsonArrayElement, "name"))
        
        libSplit(4) = ""
        For k = 1 To 4
          libSplit(k) = StringField(libName, k, ":")
        Next
        
        libNameBase = ReplaceString(libSplit(1), ".", "\") + "\" + libSplit(2)
        libName = libNameBase + "\" + libSplit(3) + "\" + libSplit(2) + "-" + libSplit(3)
        
        If librariesString <> ""
          If FindString(librariesString, libNameBase + "\")
            skipLib = 1
          EndIf
        EndIf
        
        If libSplit(4)
          libName + "-" + libSplit(4)
        EndIf
        
        If prepareForDownload = 1
          jsonDownloadsMember = GetJSONMember(jsonArrayElement, "downloads")
          
          If jsonDownloadsMember
            jsonArtifactsMember = GetJSONMember(jsonDownloadsMember, "artifact")
            jsonClassifiersMember = GetJSONMember(jsonDownloadsMember, "classifiers")
            
            If jsonClassifiersMember
              jsonNativesLinuxMember = GetJSONMember(jsonClassifiersMember, "natives-windows")
              
              If jsonNativesLinuxMember
                url = GetJSONString(GetJSONMember(jsonNativesLinuxMember, "url"))
                fileSize = GetJSONInteger(GetJSONMember(jsonNativesLinuxMember, "size"))
                
                libName + "-natives-windows"
              EndIf
            ElseIf jsonArtifactsMember
              url = GetJSONString(GetJSONMember(jsonArtifactsMember, "url"))
              fileSize = GetJSONInteger(GetJSONMember(jsonArtifactsMember, "size"))
            EndIf
          Else
            jsonUrlMember = GetJSONMember(jsonArrayElement, "url")
            
            If jsonUrlMember
              url = GetJSONString(jsonUrlMember) + ReplaceString(libName, "\", "/") + ".jar"
            Else
              url = "https://libraries.minecraft.net/" + ReplaceString(libName, "\", "/") + ".jar"
            EndIf
          EndIf
          
          WriteStringN(downloadListFile, url + "::" + "libraries\" + libName + ".jar" + "::" + fileSize)
        EndIf
        
        If Not GetJSONMember(jsonArrayElement, "natives")
          If skipLib = 0
            libsString + workingDirectory + "\libraries\" + libName + ".jar;"
          EndIf
        Else
          If Not Right(libName, 15) = "natives-windows"
            zipFile = OpenPack(#PB_Any, "libraries\" + libName + "-natives-windows.jar")
          Else
            zipFile = OpenPack(#PB_Any, "libraries\" + libName + ".jar")
          EndIf
          
          If zipFile
            CreateDirectoryRecursive("versions\" + clientVersion + "\natives")
            
            If ExaminePack(zipFile)
              While NextPackEntry(zipFile)
                If PackEntryType(zipFile) = #PB_Packer_File
                  packFileName = PackEntryName(zipFile)
                  
                  If FileSize("versions\" + clientVersion + "\natives\" + packFileName) < 1
                    UncompressPackFile(zipFile, "versions\" + clientVersion + "\natives\" + packFileName)
                  EndIf
                EndIf
              Wend
            EndIf
            
            ClosePack(zipFile)
          EndIf
        EndIf
      EndIf
    Next
  EndIf
  
  FreeJSON(jsonFile)
  FreeArray(libSplit())
  
  If prepareForDownload = 1 : CloseFile(downloadListFile) : EndIf
  
  ProcedureReturn libsString
EndProcedure

Procedure downloadFiles(downloadAllFiles.i)
  Protected Dim httpArray.i(downloadThreadsAmount)
  Protected Dim strings.s(downloadThreadsAmount)
  Protected Dim retries.i(downloadThreadsAmount)
  
  Protected.i failedDownloads, succeededDownloads, linesTotal, lines, allowedRetries = 5
  Protected.s string
  Protected.i file, fileSize, requiredSize, i
  Protected.i currentDownloads
  Protected.i retries
  
  file = ReadFile(#PB_Any, tempDirectory + "acid_download_list.txt")
  
  If file
    While Eof(file) = 0
      ReadString(file)
      lines + 1
    Wend
    
    linesTotal = lines
    
    FileSeek(file, 0)
    
    If IsGadget(downloadVersionButton) : DisableGadget(downloadVersionButton, 1) : EndIf
    If IsGadget(progressBar) : SetGadgetAttribute(progressBar, #PB_ProgressBar_Maximum, linesTotal) : EndIf
    
    If asyncDownload
      While (Eof(file) = 0 Or currentDownloads > 0) And failedDownloads <= 5
        For i = 0 To downloadThreadsAmount
          If httpArray(i) = 0
            string = ReadString(file)
            
            If string
              fileSize = FileSize(StringField(string, 2, "::"))
              requiredSize = Val(StringField(string, 3, "::"))
              
              If (downloadAllFiles = 0 And (fileSize = -1 Or (requiredSize <> 0 And fileSize <> requiredSize))) Or downloadAllFiles = 1
                CreateDirectoryRecursive(GetPathPart(StringField(string, 2, "::")))
                
                httpArray(i) = ReceiveHTTPFile(StringField(string, 1, "::"), StringField(string, 2, "::"), #PB_HTTP_Asynchronous)
                strings(i) = string
                retries(i) = 0
                
                currentDownloads + 1
              Else
                lines - 1
              EndIf
            EndIf
          ElseIf HTTPProgress(httpArray(i)) = #PB_HTTP_Success
            currentDownloads - 1
            lines - 1
            
            FinishHTTP(httpArray(i))
            httpArray(i) = 0
          ElseIf HTTPProgress(httpArray(i)) = #PB_HTTP_Failed
            FinishHTTP(httpArray(i))
            
            If retries(i) < allowedRetries
              httpArray(i) = ReceiveHTTPFile(StringField(strings(i), 1, "::"), StringField(strings(i), 2, "::"), #PB_HTTP_Asynchronous)
              retries(i) + 1
            Else
              retries(i) = 0
              httpArray(i) = 0
              
              failedDownloads + 1
              currentDownloads - 1
            EndIf
          EndIf
        Next
        
        If IsGadget(progressBar) : SetGadgetState(progressBar, linesTotal - lines) : EndIf
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Files remaining: " + lines): EndIf
        
        Delay(500)
      Wend
    Else
      While Eof(file) = 0
        string = ReadString(file)
        
        If string
          lines - 1
          
          fileSize = FileSize(StringField(string, 2, "::"))
          requiredSize = Val(StringField(string, 3, "::"))
          
          If (downloadAllFiles = 0 And (fileSize = -1 Or (requiredSize <> 0 And fileSize <> requiredSize))) Or downloadAllFiles = 1
            CreateDirectoryRecursive(GetPathPart(StringField(string, 2, "::")))
            
            If ReceiveHTTPFile(StringField(string, 1, "::"), StringField(string, 2, "::"))
              retries = 0
            Else
              If retries < allowedRetries
                retries + 1
                FileSeek(file, -1, #PB_Relative)
                
                Continue
              Else
                failedDownloads = 1
                
                Break
              EndIf
            EndIf
          EndIf
        EndIf
        
        If IsGadget(progressBar) : SetGadgetState(progressBar, linesTotal - lines) : EndIf
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Files remaining: " + lines) : EndIf
      Wend
    EndIf
    
    If failedDownloads
      If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download failed! " + lines + " files left.") : EndIf
    Else
      If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download complete!") : EndIf
    EndIf
    
    If IsGadget(progressBar) : HideGadget(progressBar, 1) : EndIf
    If IsGadget(downloadOkButton) : HideGadget(downloadOkButton, 0) : EndIf
    
    ClearGadgetItems(versionsGadget)
    findInstalledVersions()
    
    CloseFile(file)
  EndIf
  
  FreeArray(httpArray())
  FreeArray(strings())
  DeleteFile(tempDirectory + "acid_download_list.txt")
EndProcedure

Procedure progressWindow(clientVersion.s)
  progressWindow = OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, 230, 85, "Download in progress")
  
  If progressWindow
    downloadingClientTextGadget = TextGadget(#PB_Any, 5, 5, 220, 20, "Version: " + clientVersion)
    filesLeft = TextGadget(#PB_Any, 5, 25, 220, 20, "Files remaining: unknown")
    progressBar = ProgressBarGadget(#PB_Any, 5, 50, 220, 20, 0, 100, #PB_ProgressBar_Smooth)
    downloadOkButton = ButtonGadget(#PB_Any, 5, 50, 220, 30, "OK")
    
    HideGadget(downloadOkButton, 1)
  EndIf
EndProcedure

Procedure CreateDirectoryRecursive(path.s)
  Protected.s fullPath, pathElement
  Protected.i i = 1
  
  Repeat
    pathElement = StringField(path, i, "\")
    fullPath + pathElement + "\"
    
    CreateDirectory(fullPath)
    
    i + 1
  Until pathElement = ""
EndProcedure

Procedure.s fileRead(pathToFile.s)
  Protected.i file
  Protected.s fileContent
  
  file = ReadFile(#PB_Any, pathToFile)
  
  If file
    Repeat
      fileContent + ReadString(file) + #CRLF$
    Until Eof(file)
    
    CloseFile(file)
  EndIf
  
  ProcedureReturn fileContent
EndProcedure

Procedure findJava()
  Protected.s dirName, javaBinaryPath, customJavaPath
  Protected.i i, directory
  
  ClearGadgetItems(javaListGadget)
  DisableGadget(javaListGadget, 0)
  
  If GetGadgetText(versionsGadget) <> "Game not found!" And Not IsThread(downloadThread)
    DisableGadget(playButton, 0)
  EndIf
  
  If ReadPreferenceInteger("UseCustomJava", useCustomJavaDefault)
    AddGadgetItem(javaListGadget, -1, "Using custom Java version ")
    SetGadgetState(javaListGadget, 0)
    DisableGadget(javaListGadget, 1)
  Else
    For i = 0 To 1
      If programFilesDir(i) <> "\"
        directory = ExamineDirectory(#PB_Any, programFilesDir(i) + "Java", "*")
        
        If directory
          While NextDirectoryEntry(directory) And DirectoryEntryType(directory) = #PB_DirectoryEntry_Directory
            dirName = DirectoryEntryName(directory)
            
            If dirName <> ".." And dirName <> "." And FileSize(programFilesDir(i) + "Java\" + dirName + "\bin\javaw.exe") > 0
              If i
                dirName + " (x32)"
              EndIf
              
              AddGadgetItem(javaListGadget, -1, dirName)
              SetGadgetState(javaListGadget, 0)
            EndIf
          Wend
          
          FinishDirectory(directory)
        EndIf
      EndIf
    Next
    
    If Not CountGadgetItems(javaListGadget)
      AddGadgetItem(javaListGadget, -1, "Java not found")
      SetGadgetState(javaListGadget, 0)
      
      DisableGadget(javaListGadget, 1)
      DisableGadget(playButton, 1)
    EndIf
  EndIf
EndProcedure

Procedure assetsToResources(assetsIndex.s)
  Protected.i jsonFile, jsonObject, jsonObjectObjects, fileSize
  Protected.s fileHash, fileName
  
  jsonFile = ParseJSON(#PB_Any, fileRead("assets\indexes\" + assetsIndex + ".json"))
  
  If jsonFile
    jsonObject = JSONValue(jsonFile)
    jsonObjectObjects = GetJSONMember(jsonObject, "objects")
    
    If ExamineJSONMembers(jsonObjectObjects)
      While NextJSONMember(jsonObjectObjects)
        fileHash = GetJSONString(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "hash"))
        fileSize = GetJSONInteger(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "size"))
        fileName = JSONMemberKey(jsonObjectObjects)
        
        fileName = ReplaceString(fileName, "/", "\")
        
        If FileSize("resources\" + fileName) <> fileSize
          CreateDirectoryRecursive("resources\" + GetPathPart(fileName))
          
          CopyFile("assets\objects\" + Left(fileHash, 2) + "\" + fileHash, "resources\" + fileName)
        EndIf
      Wend
    EndIf
    
    FreeJSON(jsonFile)
  EndIf
EndProcedure

Procedure.s removeSpacesFromVersionName(clientVersion.s)
  Protected.s newVersionName = ReplaceString(clientVersion, " ", "-")
  
  RenameFile("versions\" + clientVersion + "\" + clientVersion + ".jar", "versions\" + clientVersion + "\" + newVersionName + ".jar")
  RenameFile("versions\" + clientVersion + "\" + clientVersion + ".json", "versions\" + clientVersion + "\" + newVersionName + ".json")
  RenameFile("versions\" + clientVersion, "versions\" + newVersionName)
  
  ProcedureReturn newVersionName
EndProcedure
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 149
; Folding = --
; Optimizer
; EnableXP
; SharedUCRT
; UseIcon = appicon.ico
; Executable = ..\..\home\liam\Downloads\dfsadsa\FirstRelease.exe
; Compiler = PureBasic 6.20 - C Backend (Windows - x64)
; Debugger = Standalone