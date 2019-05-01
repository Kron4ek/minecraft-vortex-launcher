EnableExplicit

Define.s workingDirectory = GetPathPart(ProgramFilename())

Global.i downloadThreadsAmount
Global.i asyncDownload
Global.i versionsGadget, playButton
Global.i progressBar, filesLeft, progressWindow, downloadingClientTextGadget
Global.i versionsDownloadGadget, downloadVersionButton

Define.i Event, font, ramGadget, nameGadget, javaPathGadget, argsGadget, downloadButton, settingsButton, launcherVersionGadget, launcherAuthorGadget
Define.i saveLaunchString, versionsTypeGadget, saveLaunchStringGadget, launchStringFile, inheritsJsonObject, jsonInheritsArgumentsModernMember
Define.i argsTextGadget, javaBinaryPathTextGadget, downloadThreadsTextGadget, downloadAllFilesGadget
Define.i gadgetsWidth, gadgetsHeight, gadgetsIndent, windowWidth, windowHeight
Define.i listOfFiles, jsonFile, jsonObject, jsonObjectObjects, fileSize, jsonJarMember, jsonArgumentsArray, jsonArrayElement, inheritsJson, clientSize

Define.s playerName, ramAmount, clientVersion, javaBinaryPath, fullLaunchString, assetsIndex, clientUrl, fileHash, versionToDownload
Define.s assetsIndex, clientMainClass, clientArguments, inheritsClientJar, customLaunchArguments, clientJarFile, nativesPath, librariesString

Define.i downloadThread, downloadMissingLibraries, jsonArgumentsMember, jsonArgumentsModernMember, jsonInheritsFromMember
Define.i downloadMissingLibrariesGadget, downloadThreadsGadget, asyncDownloadGadget, saveSettingsButton
Define.i i

Define.s playerNameDefault = "Name", ramAmountDefault = "1024", javaBinaryPathDefault = "/usr/bin/java"
Define.s customLaunchArgumentsDefault = "-Xss1M -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M"
Define.i downloadThreadsAmountDefault = 50
Define.i asyncDownloadDefault = 0
Define.i downloadMissingLibrariesDefault = 0
Define.i downloadAllFilesDefault = 0
Define.i versionsTypeDefault = 0
Define.i saveLaunchStringDefault = 0

Define.s launcherVersion = "1.1.0"
Define.s launcherDeveloper = "Kron(4ek)"

Declare progressWindow(clientVersion.s)
Declare findInstalledVersions()
Declare downloadFiles(downloadAllFiles.i)
Declare CreateDirectoryRecursive(path.s)
Declare generateProfileJson()

Declare.s generateGuid()
Declare.s parseVersionsManifest(versionType.i = 0, getClientJarUrl.i = 0, clientVersion.s = "")
Declare.s parseLibraries(clientVersion.s, prepareForDownload.i = 0)
Declare.s fileRead(pathToFile.s)

SetCurrentDirectory(workingDirectory)
OpenPreferences("vortex_launcher.conf")

downloadThreadsAmount = ReadPreferenceInteger("DownloadThreads", downloadThreadsAmountDefault)
asyncDownload = ReadPreferenceInteger("AsyncDownload", asyncDownloadDefault)

DeleteFile("version_manifest.json") : DeleteFile("download_list.txt")

windowWidth = 250
windowHeight = 250

If OpenWindow(0, #PB_Ignore, #PB_Ignore, windowWidth, windowHeight, "Vortex Minecraft Launcher")

  gadgetsWidth = windowWidth - 10
  gadgetsHeight = 30
  gadgetsIndent = 5

  nameGadget = StringGadget(#PB_Any, gadgetsIndent, 5, gadgetsWidth, gadgetsHeight, ReadPreferenceString("Name", playerNameDefault))
  SetGadgetAttribute(nameGadget, #PB_String_MaximumLength, 16)

  ramGadget = StringGadget(#PB_Any, gadgetsIndent, 40, gadgetsWidth, gadgetsHeight, ReadPreferenceString("Ram", ramAmountDefault), #PB_String_Numeric)
  GadgetToolTip(ramGadget, "Amount of RAM (in MB) to allocate for Minecraft")

  versionsGadget = ComboBoxGadget(#PB_Any, gadgetsIndent, 75, gadgetsWidth, gadgetsHeight)

  playButton = ButtonGadget(#PB_Any, gadgetsIndent, 120, gadgetsWidth, gadgetsHeight - 10, "Play")
  downloadButton = ButtonGadget(#PB_Any, gadgetsIndent, 160, gadgetsWidth, gadgetsHeight - 10, "Downloader")
  settingsButton = ButtonGadget(#PB_Any, gadgetsIndent, 200, gadgetsWidth, gadgetsHeight - 10, "Settings")

  If LoadFont(0, "Ariral", 10, #PB_Font_Bold)
    SetGadgetFont(playButton, FontID(0))
    SetGadgetFont(downloadButton, FontID(0))
  EndIf

  launcherAuthorGadget = TextGadget(#PB_Any, 2, windowHeight - 10, 70, 20, "by " + launcherDeveloper)
  launcherVersionGadget = TextGadget(#PB_Any, windowWidth - 35, windowHeight - 10, 50, 20, "v" + launcherVersion)
  If LoadFont(1, "Ariral", 7)
    font = FontID(1) : SetGadgetFont(launcherAuthorGadget, font) : SetGadgetFont(launcherVersionGadget, font)
  EndIf

  findInstalledVersions()
  generateProfileJson()

  Repeat
    Event = WaitWindowEvent(500)

    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case playButton
          ramAmount = GetGadgetText(ramGadget)
          clientVersion = GetGadgetText(versionsGadget)
          playerName = GetGadgetText(nameGadget)
          javaBinaryPath = ReadPreferenceString("JavaPath", javaBinaryPathDefault)
          customLaunchArguments = ReadPreferenceString("LaunchArguments", customLaunchArgumentsDefault)
          downloadMissingLibraries = ReadPreferenceInteger("DownloadMissingLibs", downloadMissingLibrariesDefault)

          If playerName And ramAmount And Len(playerName) >= 3
            If FileSize(javaBinaryPath) <> -1
              jsonFile = ParseJSON(#PB_Any, fileRead("versions/" + clientVersion + "/" + clientVersion + ".json"))

              If jsonFile
                jsonObject = JSONValue(jsonFile)

                jsonJarMember = GetJSONMember(jsonObject, "jar")
                jsonInheritsFromMember = GetJSONMember(jsonObject, "inheritsFrom")

                If jsonJarMember
                  clientJarFile = GetJSONString(jsonJarMember)
                  clientJarFile = "versions/" + clientJarFile + "/" + clientJarFile + ".jar"
                ElseIf jsonInheritsFromMember
                  inheritsClientJar = GetJSONString(jsonInheritsFromMember)

                  clientJarFile = "versions/" + inheritsClientJar + "/" + inheritsClientJar + ".jar"
                ElseIf FileSize("versions/" + clientVersion + "/" + clientVersion + ".jar") > 0
                  clientJarFile = "versions/" + clientVersion + "/" + clientVersion + ".jar"
                EndIf

                nativesPath = "versions/" + StringField(clientJarFile, 2, "/") + "/natives"

                If jsonInheritsFromMember
                  inheritsClientJar = GetJSONString(jsonInheritsFromMember)

                  inheritsJson = ParseJSON(#PB_Any, fileRead("versions/" + inheritsClientJar + "/" + inheritsClientJar + ".json"))

                  If inheritsJson
                    inheritsJsonObject = JSONValue(inheritsJson)
                    jsonInheritsArgumentsModernMember = GetJSONMember(inheritsJsonObject, "arguments")

                    librariesString + parseLibraries(inheritsClientJar, downloadMissingLibraries)
                    assetsIndex = GetJSONString(GetJSONMember(JSONValue(inheritsJson), "assets"))
                  Else
                    MessageRequester("Error", inheritsClientJar + ".json file is missing!") : Break
                  EndIf
                Else
                  assetsIndex = GetJSONString(GetJSONMember(jsonObject, "assets"))
                EndIf

                If FileSize(clientJarFile) > 0
                  librariesString + parseLibraries(clientVersion, downloadMissingLibraries)
                  clientMainClass = GetJSONString(GetJSONMember(jsonObject, "mainClass"))

                  jsonArgumentsMember = GetJSONMember(jsonObject, "minecraftArguments")
                  jsonArgumentsModernMember = GetJSONMember(jsonObject, "arguments")

                  If jsonArgumentsMember
                    clientArguments = GetJSONString(jsonArgumentsMember)
                  ElseIf jsonArgumentsModernMember
                    jsonArgumentsArray = GetJSONMember(jsonArgumentsModernMember, "game")

                    For i = 0 To JSONArraySize(jsonArgumentsArray) - 1
                      jsonArrayElement = GetJSONElement(jsonArgumentsArray, i)

                      If JSONType(jsonArrayElement) = #PB_JSON_String
                        clientArguments + " " + GetJSONString(jsonArrayElement) + " "
                      EndIf
                    Next
                  EndIf

                  If jsonInheritsArgumentsModernMember
                    jsonArgumentsArray = GetJSONMember(jsonInheritsArgumentsModernMember, "game")

                    For i = 0 To JSONArraySize(jsonArgumentsArray) - 1
                      jsonArrayElement = GetJSONElement(jsonArgumentsArray, i)

                      If JSONType(jsonArrayElement) = #PB_JSON_String
                        clientArguments + " " + GetJSONString(jsonArrayElement) + " "
                      EndIf
                    Next
                  EndIf

                  clientArguments = ReplaceString(clientArguments, "${auth_player_name}", playerName)
                  clientArguments = ReplaceString(clientArguments, "${version_name}", clientVersion)
                  clientArguments = ReplaceString(clientArguments, "${game_directory}", workingDirectory)
                  clientArguments = ReplaceString(clientArguments, "${assets_root}", "assets")
                  clientArguments = ReplaceString(clientArguments, "${auth_uuid}", generateGuid())
                  clientArguments = ReplaceString(clientArguments, "${auth_access_token}", generateGuid())
                  clientArguments = ReplaceString(clientArguments, "${user_properties}", "{}")
                  clientArguments = ReplaceString(clientArguments, "${user_type}", "mojang")
                  clientArguments = ReplaceString(clientArguments, "${version_type}", "client")
                  clientArguments = ReplaceString(clientArguments, "${assets_index_name}", assetsIndex)

                  WritePreferenceString("Name", playerName)
                  WritePreferenceString("Ram", ramAmount)
                  WritePreferenceString("ChosenVer", clientVersion)

                  If downloadMissingLibraries
                    downloadFiles(0)
                  EndIf

                  saveLaunchString = ReadPreferenceInteger("SaveLaunchString", saveLaunchStringDefault)

                  fullLaunchString = "-Xmx" + ramAmount + "M " + customLaunchArguments + " -Djava.library.path=" + nativesPath + " -cp " + librariesString + clientJarFile + " " + clientMainClass + " " + clientArguments
                  RunProgram(javaBinaryPath, fullLaunchString, workingDirectory)

                  If saveLaunchString
                    launchStringFile = OpenFile(#PB_Any, "launch_string.txt")

                    WriteString(launchStringFile, javaBinaryPath + " " + fullLaunchString)

                    CloseFile(launchStringFile)
                  EndIf

                  Break
                Else
                  MessageRequester("Error", "Client jar file is missing!")
                EndIf

                FreeJSON(inheritsJson)
                FreeJSON(jsonFile)
              Else
                MessageRequester("Error", "Client json file is missing!")
              EndIf
            Else
              MessageRequester("Error", "Java not found!" + #CRLF$ + #CRLF$ + "Check if path to Java binary is correct.")
            EndIf
          Else
            MessageRequester("Error", "Name or RAM amount is incorrect!")
          EndIf
        Case downloadButton
          InitNetwork()

          If ReceiveHTTPFile("https://launchermeta.mojang.com/mc/game/version_manifest.json", "version_manifest.json")
            If OpenWindow(1, #PB_Ignore, #PB_Ignore, 250, 140, "Client Downloader")
              DisableGadget(downloadButton, 1)

              versionsDownloadGadget = ComboBoxGadget(#PB_Any, 5, 5, 240, 30)
              CheckBoxGadget(110, 5, 45, 20, 20, "Show all versions")
              versionsTypeGadget = 110
              SetGadgetState(versionsTypeGadget, ReadPreferenceInteger("ShowAllVersions", versionsTypeDefault))
              downloadAllFilesGadget = CheckBoxGadget(#PB_Any, 5, 70, 20, 20, "Redownload existing files")
              SetGadgetState(downloadAllFilesGadget, ReadPreferenceInteger("RedownloadFiles", downloadAllFilesDefault))
              downloadVersionButton = ButtonGadget(#PB_Any, 5, 100, 240, 30, "Download")

              If IsThread(downloadThread) : DisableGadget(downloadVersionButton, 1) : EndIf

              parseVersionsManifest(GetGadgetState(versionsTypeGadget))
            EndIf
          Else
            MessageRequester("Download Error", "Seems like you have no internet connection")
          EndIf
        Case versionsTypeGadget
          ClearGadgetItems(versionsDownloadGadget)
          parseVersionsManifest(GetGadgetState(versionsTypeGadget))
        Case downloadVersionButton
          versionToDownload = GetGadgetText(versionsDownloadGadget)

          CreateDirectoryRecursive("versions/" + versionToDownload)

          If ReceiveHTTPFile(parseVersionsManifest(GetGadgetState(versionsDownloadGadget), 1, versionToDownload), "versions/" + versionToDownload + "/" + versionToDownload + ".json")
            DeleteFile("download_list.txt")
            listOfFiles = OpenFile(#PB_Any, "download_list.txt")

            jsonFile = ParseJSON(#PB_Any, fileRead("versions/" + versionToDownload + "/" + versionToDownload + ".json"))

            If jsonFile
              jsonObject = JSONValue(jsonFile)

              assetsIndex = GetJSONString(GetJSONMember(jsonObject, "assets"))

              CreateDirectoryRecursive("assets/indexes")
              ReceiveHTTPFile(GetJSONString(GetJSONMember(GetJSONMember(jsonObject, "assetIndex"), "url")), "assets/indexes/" + assetsIndex + ".json")

              clientUrl = GetJSONString(GetJSONMember(GetJSONMember(GetJSONMember(jsonObject, "downloads"), "client"), "url"))
              clientSize = GetJSONInteger(GetJSONMember(GetJSONMember(GetJSONMember(jsonObject, "downloads"), "client"), "size"))

              WriteStringN(listOfFiles, clientUrl + "::" + "versions/" + versionToDownload + "/" + versionToDownload + ".jar" + "::" + clientSize)

              FreeJSON(jsonFile)
            EndIf

            jsonFile = ParseJSON(#PB_Any, fileRead("assets/indexes/" + assetsIndex + ".json"))

            If jsonFile
              jsonObject = JSONValue(jsonFile)
              jsonObjectObjects = GetJSONMember(jsonObject, "objects")

              If ExamineJSONMembers(jsonObjectObjects)
                While NextJSONMember(jsonObjectObjects)
                  fileHash = GetJSONString(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "hash"))
                  fileSize = GetJSONInteger(GetJSONMember(GetJSONMember(jsonObjectObjects, JSONMemberKey(jsonObjectObjects)), "size"))

                  WriteStringN(listOfFiles, "http://resources.download.minecraft.net/" + Left(fileHash, 2) + "/" + fileHash + "::" + "assets/objects/" + Left(fileHash, 2) + "/" + fileHash + "::" + fileSize)
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

          If OpenWindow(3, #PB_Ignore, #PB_Ignore, 350, 240, "Vortex Launcher Settings")
              argsTextGadget = TextGadget(#PB_Any, 5, 5, 80, 20, "Launch arguments:")
              argsGadget = StringGadget(#PB_Any, 85, 5, 260, 30, ReadPreferenceString("LaunchArguments", customLaunchArgumentsDefault))
              GadgetToolTip(argsGadget, "These arguments will be used to launch Minecraft")

              javaBinaryPathTextGadget = TextGadget(#PB_Any, 5, 45, 80, 20, "Path to Java binary:")
              javaPathGadget = StringGadget(#PB_Any, 85, 45, 260, 30, ReadPreferenceString("JavaPath", javaBinaryPathDefault))
              GadgetToolTip(javaPathGadget, "Absolute path to Java binary")

              downloadThreadsTextGadget = TextGadget(#PB_Any, 5, 85, 80, 20, "Download threads:")
              downloadThreadsGadget = StringGadget(#PB_Any, 85, 85, 260, 30, ReadPreferenceString("DownloadThreads", Str(downloadThreadsAmountDefault)), #PB_String_Numeric)
              GadgetToolTip(downloadThreadsGadget, "Higher numbers may speedup downloads (works only with multi-threads downloads)")
              SetGadgetAttribute(downloadThreadsGadget, #PB_String_MaximumLength, 3)

              asyncDownloadGadget = CheckBoxGadget(#PB_Any, 5, 125, 70, 20, "Fast multi-thread downloads (experimental)")
              SetGadgetState(asyncDownloadGadget, ReadPreferenceInteger("AsyncDownload", asyncDownloadDefault))

              downloadMissingLibrariesGadget = CheckBoxGadget(#PB_Any, 5, 150, 70, 20, "Download missing libraries on game start")
              SetGadgetState(downloadMissingLibrariesGadget, ReadPreferenceInteger("DownloadMissingLibs", downloadMissingLibrariesDefault))

              saveLaunchStringGadget = CheckBoxGadget(#PB_Any, 5, 175, 70, 20, "Save launch string to file")
              GadgetToolTip(saveLaunchStringGadget, "Full launch string will be saved to launch_string.txt file")
              SetGadgetState(saveLaunchStringGadget, ReadPreferenceInteger("SaveLaunchString", saveLaunchStringDefault))

              saveSettingsButton = ButtonGadget(#PB_Any, 5, 200, 340, 20, "Save and apply")
          EndIf
        Case saveSettingsButton
          If GetGadgetText(downloadThreadsGadget) = "0" : SetGadgetText(downloadThreadsGadget, "1") : EndIf

          WritePreferenceString("LaunchArguments", GetGadgetText(argsGadget))
          WritePreferenceString("JavaPath", GetGadgetText(javaPathGadget))
          WritePreferenceString("DownloadThreads", GetGadgetText(downloadThreadsGadget))
          WritePreferenceInteger("DownloadMissingLibs", GetGadgetState(downloadMissingLibrariesGadget))
          WritePreferenceInteger("AsyncDownload", GetGadgetState(asyncDownloadGadget))
          WritePreferenceInteger("SaveLaunchString", GetGadgetState(saveLaunchStringGadget))

          downloadThreadsAmount = Val(GetGadgetText(downloadThreadsGadget))
          asyncDownload = GetGadgetState(asyncDownloadGadget)
      EndSelect
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
          MessageRequester("Download in progress", "Wait for download to complete!")
        EndIf
      ElseIf EventWindow() = 3
        CloseWindow(3)

        DisableGadget(settingsButton, 0)
      EndIf
    EndIf

  Until Event = #PB_Event_CloseWindow And EventWindow() = 0

  DeleteFile("version_manifest.json") : DeleteFile("download_list.txt")
EndIf

Procedure findInstalledVersions()
  Protected.s dirName, chosenVer = ReadPreferenceString("ChosenVer", "")
  Protected.i directory, chosenFound

  directory = ExamineDirectory(#PB_Any, "versions", "*")

  DisableGadget(playButton, 0)
  DisableGadget(versionsGadget, 0)

  If directory
    While NextDirectoryEntry(directory) And DirectoryEntryType(directory) = #PB_DirectoryEntry_Directory
      dirName = DirectoryEntryName(directory)

      If dirName <> ".." And dirName <> "."
        If FileSize("versions/" + dirName + "/" + dirName + ".json") > -1
          If Not chosenFound And dirName = chosenVer
            chosenFound = 1
          EndIf

          AddGadgetItem(versionsGadget, -1, dirName)
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
    DisableGadget(versionsGadget, 1) : AddGadgetItem(versionsGadget, 0, "Versions not found") : SetGadgetState(versionsGadget, 0)
  EndIf
EndProcedure

Procedure.s parseVersionsManifest(versionType.i = 0, getClientJarUrl.i = 0, clientVersion.s = "")
  Protected.i jsonFile, jsonObject, jsonVersionsArray, jsonArrayElement, i
  Protected.s url

  jsonFile = ParseJSON(#PB_Any, fileRead("version_manifest.json"))

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
  Else
    AddGadgetItem(versionsDownloadGadget, -1, "Error")
    DisableGadget(downloadVersionButton, 1)
  EndIf

  SetGadgetState(versionsDownloadGadget, 0)

  FreeJSON(jsonFile)
EndProcedure

Procedure.s parseLibraries(clientVersion.s, prepareForDownload.i = 0)
  Protected.i jsonLibrariesArray, jsonArrayElement, jsonFile, fileSize, downloadListFile, zipFile
  Protected.i jsonArtifactsMember, jsonDownloadsMember, jsonUrlMember, jsonClassifiersMember, jsonNativesLinuxMember
  Protected.i i, k

  Protected.s libName, libsString, packFileName, url
  Protected Dim libSplit.s(3)

  If prepareForDownload = 1
    downloadListFile = OpenFile(#PB_Any, "download_list.txt")
    FileSeek(downloadListFile, Lof(downloadListFile), #PB_Relative)
  EndIf

  UseZipPacker()

  jsonFile = ParseJSON(#PB_Any, fileRead("versions/" + clientVersion + "/" + clientVersion + ".json"))

  If jsonFile
    jsonLibrariesArray = GetJSONMember(JSONValue(jsonFile), "libraries")

    For i = 0 To JSONArraySize(jsonLibrariesArray) - 1
      jsonArrayElement = GetJSONElement(jsonLibrariesArray, i)
      libName = GetJSONString(GetJSONMember(jsonArrayElement, "name"))

      For k = 1 To 3
        libSplit(k) = StringField(libName, k, ":")
      Next

      libName = ReplaceString(libSplit(1), ".", "/") + "/" + libSplit(2) + "/" + libSplit(3) + "/" + libSplit(2) + "-" + libSplit(3)

      If prepareForDownload = 1
        jsonDownloadsMember = GetJSONMember(jsonArrayElement, "downloads")

        If jsonDownloadsMember
          jsonArtifactsMember = GetJSONMember(jsonDownloadsMember, "artifact")
          jsonClassifiersMember = GetJSONMember(jsonDownloadsMember, "classifiers")

          If jsonClassifiersMember
            jsonNativesLinuxMember = GetJSONMember(jsonClassifiersMember, "natives-linux")

            If jsonNativesLinuxMember
              url = GetJSONString(GetJSONMember(jsonNativesLinuxMember, "url"))
              fileSize = GetJSONInteger(GetJSONMember(jsonNativesLinuxMember, "size"))

              libName + "-natives-linux"
            EndIf
          ElseIf jsonArtifactsMember
            url = GetJSONString(GetJSONMember(jsonArtifactsMember, "url"))
            fileSize = GetJSONInteger(GetJSONMember(jsonArtifactsMember, "size"))
          EndIf
        Else
          jsonUrlMember = GetJSONMember(jsonArrayElement, "url")

          If jsonUrlMember
            url = GetJSONString(jsonUrlMember) + libName + ".jar"
          Else
            url = "https://libraries.minecraft.net/" + libName + ".jar"
          EndIf
        EndIf

        WriteStringN(downloadListFile, url + "::" + "libraries/" + libName + ".jar" + "::" + fileSize)
      EndIf

      If Not GetJSONMember(jsonArrayElement, "natives")
        libsString + "libraries/" + libName + ".jar:"
      Else
        If Not Right(libName, 13) = "natives-linux"
          zipFile = OpenPack(#PB_Any, "libraries/" + libName + "-natives-linux.jar")
        Else
          zipFile = OpenPack(#PB_Any, "libraries/" + libName + ".jar")
        EndIf

        If zipFile
          CreateDirectoryRecursive("versions/" + clientVersion + "/natives")
          If ExaminePack(zipFile)
            While NextPackEntry(zipFile)
              If PackEntryType(zipFile) = #PB_Packer_File
                packFileName = PackEntryName(zipFile)

                If packFileName <> "MANIFEST.MF" And FileSize("versions/" + clientVersion + "/natives/" + packFileName) <= 0
                UncompressPackFile(zipFile, "versions/" + clientVersion + "/natives/" + packFileName)
                EndIf
              EndIf
            Wend
          EndIf

          ClosePack(zipFile)
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

  file = ReadFile(#PB_Any, "download_list.txt")

  If file
    While Eof(file) = 0
      ReadString(file)
      lines + 1
    Wend

    linesTotal = lines

    FileSeek(file, 0)

    If IsGadget(downloadVersionButton) : DisableGadget(downloadVersionButton, 1) : EndIf
    If IsGadget(progressBar) : SetGadgetAttribute(progressBar, #PB_ProgressBar_Maximum, linesTotal) : EndIf

    InitNetwork()

    If asyncDownload
      While (Eof(file) = 0 Or currentDownloads > 0) And failedDownloads <= 5
        For i = 0 To downloadThreadsAmount
          If httpArray(i) = 0
            string = ReadString(file)

            If string
              lines - 1

              fileSize = FileSize(StringField(string, 2, "::"))
              requiredSize = Val(StringField(string, 3, "::"))

              If (downloadAllFiles = 0 And (fileSize = -1 Or (requiredSize <> 0 And fileSize <> requiredSize))) Or downloadAllFiles = 1
                CreateDirectoryRecursive(GetPathPart(StringField(string, 2, "::")))

                httpArray(i) = ReceiveHTTPFile(StringField(string, 1, "::"), StringField(string, 2, "::"), #PB_HTTP_Asynchronous)
                strings(i) = string

                currentDownloads + 1
              EndIf
            EndIf
          ElseIf HTTPProgress(httpArray(i)) = #PB_Http_Success
            currentDownloads - 1

            FinishHTTP(httpArray(i))
            httpArray(i) = 0
          ElseIf HTTPProgress(httpArray(i)) = #PB_Http_Failed
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

        If IsGadget(progressBar) : SetGadgetState(progressBar, lines) : EndIf
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Files left: " + lines): EndIf

        Delay(500)
      Wend

      If failedDownloads
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download failed! Files left: " + lines) : EndIf
      Else
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download completed!") : EndIf
      EndIf
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

        If IsGadget(progressBar) : SetGadgetState(progressBar, lines) : EndIf
        If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Files left: " + lines) : EndIf
      Wend
    EndIf

    If failedDownloads
      If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download failed! Files left: " + lines) : EndIf
    Else
      If IsGadget(filesLeft) : SetGadgetText(filesLeft, "Download completed!") : EndIf
    EndIf

    ClearGadgetItems(versionsGadget)
    findInstalledVersions()

    CloseFile(file)
  EndIf

  FreeArray(httpArray())
  FreeArray(strings())
EndProcedure

Procedure progressWindow(clientVersion.s)
  progressWindow = OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore, 230, 60, "Download progress")

  If progressWindow
    downloadingClientTextGadget = TextGadget(#PB_Any, 5, 5, 220, 20, "Downloading " + clientVersion)
    filesLeft = TextGadget(#PB_Any, 5, 25, 220, 20, "Files left: unknown")
    progressBar = ProgressBarGadget(#PB_Any, 5, 30, 220, 20, 0, 100, #PB_ProgressBar_Smooth)
  EndIf
EndProcedure

Procedure CreateDirectoryRecursive(path.s)
  Protected.s fullPath, pathElement
  Protected.i i = 1

  Repeat
    pathElement = StringField(path, i, "/")
    fullPath + pathElement + "/"

    CreateDirectory(fullPath)

    i + 1
  Until pathElement = ""
EndProcedure

Procedure generateProfileJson()
  Protected.i file

  If FileSize("launcher_profiles.json") <= 0
    DeleteFile("launcher_profile.json")
    file = OpenFile(#PB_Any, "launcher_profiles.json")

    If file
      WriteString(file, "{ " + Chr(34) + "profiles" + Chr(34) + ": { " + Chr(34) + "justProfile" + Chr(34) + ": { " + Chr(34) + "name" + Chr(34) + ": " + Chr(34) + "justProfile" + Chr(34) + ", ")
      WriteString(file, Chr(34) + "lastVersionId" + Chr(34) + ": " + Chr(34) + "1.12.2" + Chr(34) + " } } }" + #CRLF$)

      CloseFile(file)
    EndIf
  EndIf
EndProcedure

Procedure.s generateGuid()
  Protected.s guid
  Protected.i i

  For i = 0 To 32 - 1
    guid + Chr(Asc(Hex(Random(15))))

    If i = 7 Or i = 11 Or i = 15 Or i = 19
      guid + "-"
    EndIf
  Next

  ProcedureReturn LCase(guid)
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
