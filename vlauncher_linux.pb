EnableExplicit

Define Directory.s = GetCurrentDirectory()
Define.i Event, font, jsonObj, inheritsM, jarM
Define.s name, ram, version, java, mainClass, assets, params, libs, inherits, natives, jar

Declare setVerList()
Declare.s getLibsString(obj.i, ver.s)
Declare.s fileRead(path.s)

If OpenWindow(0, #PB_Ignore, #PB_Ignore, 250, 210, "Vortex Launcher")

  SetCurrentDirectory(Directory)
  OpenPreferences(GetHomeDirectory() + ".vortex_launcher.conf")

  StringGadget(1, 5, 5, 240, 30, ReadPreferenceString("Name", "Имя"))
  SetGadgetAttribute(1, #PB_String_MaximumLength, 16)

  StringGadget(2, 5, 40, 240, 30, ReadPreferenceString("Ram", "512"), #PB_String_Numeric)
  SetGadgetAttribute(2, #PB_String_MaximumLength, 4)
  GadgetToolTip(2, "Выделяемая память")

  ComboBoxGadget(3, 5, 75, 240, 30)

  StringGadget(4, 5, 112, 240, 30, ReadPreferenceString("Java", "/usr/bin/java"))
  GadgetToolTip(4, "Путь к Java")

  ButtonGadget(5, 5, 150, 240, 45, "Играть")
  If LoadFont(0, "Ariral", 16, #PB_Font_Bold)
    SetGadgetFont(5, FontID(0))
  EndIf

  TextGadget(6, 0, 198, 50, 20, "by Kron")
  TextGadget(7, 220, 198, 50, 20, "v1.0.2")
  If LoadFont(1, "Ariral", 7)
    font = FontID(1) : SetGadgetFont(6, font) : SetGadgetFont(7, font)
  EndIf

  setVerList()

  Repeat
    Event = WaitWindowEvent()

    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case 5
          ram = GetGadgetText(2)
          version = GetGadgetText(3)
          java = GetGadgetText(4)
          name = GetGadgetText(1)
          If FindString(name, " ") : name = RemoveString(name, " ") : EndIf

          If name And ram And version <> "Версии не найдены"
            If FileSize(java) <> -1
              If ParseJSON(0, fileRead("versions/" + version + "/" + version + ".json"))
                jsonObj = JSONValue(0)

                jarM = GetJSONMember(jsonObj, "jar")
                If jarM
                  jar = GetJSONString(jarM) : jar = "versions/" + jar + "/" + jar + ".jar"
                Else
                  jar = "versions/" + version + "/" + version + ".jar"
                EndIf

                If FileSize(jar) <> -1
                  natives = "versions/" + version + "/natives"
                  libs = getLibsString(jsonObj, version)
                  mainClass = GetJSONString(GetJSONMember(jsonObj, "mainClass"))

                  params = GetJSONString(GetJSONMember(jsonObj, "minecraftArguments"))
                  params = ReplaceString(params, "${auth_player_name}", name)
                  params = ReplaceString(params, "${version_name}", version)
                  params = ReplaceString(params, "${game_directory}", Directory)
                  params = ReplaceString(params, "${assets_root}", "assets")
                  params = ReplaceString(params, "${auth_uuid}", "00000000-0000-0000-0000-000000000000")
                  params = ReplaceString(params, "${auth_access_token}", "00000000-0000-0000-0000-000000000000")
                  params = ReplaceString(params, "${user_properties}", "{}")
                  params = ReplaceString(params, "${user_type}", "mojang")
                  params = ReplaceString(params, "${version_type}", "plain")

                  inheritsM = GetJSONMember(jsonObj, "inheritsFrom")
                  If inheritsM
                    inherits = GetJSONString(inheritsM)

                    If ParseJSON(1, fileRead("versions/" + inherits + "/" + inherits + ".json"))
                      libs + getLibsString(JSONValue(1), inherits)
                      natives = "versions/" + inherits + "/natives"
                      assets = GetJSONString(GetJSONMember(JSONValue(1), "assets"))
                    Else
                      MessageRequester("Error", "Отсутствует файл " + inherits + ".json!") : End
                    EndIf
                  Else
                    assets = GetJSONString(GetJSONMember(jsonObj, "assets"))
                  EndIf

                  params = ReplaceString(params, "${assets_index_name}", assets)

                  If Val(ram) < 250 : ram = "250" : EndIf
                  WritePreferenceString("Name", name) : WritePreferenceString("Ram", ram)
                  WritePreferenceString("Java", java) : WritePreferenceString("ChosenVer", version) : ClosePreferences()

                  RunProgram(java, "-Xmx" + ram + "M -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M -Djava.library.path=" + natives + " -cp " + libs + jar + " " + mainClass + " " + params, Directory)
                  End
                Else
                  MessageRequester("Error", "Отсутствует jar файл")
                EndIf

                FreeJSON(#PB_All)
              Else
                MessageRequester("Error", "Отсутствует json файл!")
              EndIf
            Else
              MessageRequester("Error", "В системе не найдена Java!" + #CRLF$ + #CRLF$ + "Установите ее или введи путь к ней," + #CRLF$ + "если она уже установлена!")
            EndIf
          Else
            MessageRequester("Error", "Введите имя/память и выберите версию")
          EndIf
      EndSelect
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

Procedure setVerList()
  Protected.s dirName, fixedDirName, chosenVer = ReadPreferenceString("ChosenVer", "")
  Protected.i chosenFound

  If ExamineDirectory(0, "versions", "*")
    While NextDirectoryEntry(0) And DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
      dirName = DirectoryEntryName(0)

      If dirName <> ".." And dirName <> "."
        If FileSize("versions/" + dirName + "/" + dirName + ".json") <> -1
          If FindString(dirName, " ")
            fixedDirName = ReplaceString(dirName, " ", "_")
            If FileSize("versions/" + dirName + "/" + dirName + ".jar") <> -1
              RenameFile("versions/" + dirName + "/" + dirName + ".jar", "versions/" + dirName + "/" + fixedDirName + ".jar")
            EndIf
            RenameFile("versions/" + dirName + "/" + dirName + ".json", "versions/" + dirName + "/" + fixedDirName + ".json")
            RenameFile("versions/" + dirName, "versions/" + fixedDirName)
            dirName = fixedDirName
          EndIf

          If Not chosenFound And dirName = chosenVer : chosenFound = 1 : EndIf

          AddGadgetItem(3, -1, dirName)
        EndIf
      EndIf
    Wend

    FinishDirectory(0)

    If chosenFound
      SetGadgetText(3, chosenVer)
    Else
      SetGadgetState(3, 0)
    EndIf
  EndIf

  If Not CountGadgetItems(3)
    DisableGadget(3, 1) : AddGadgetItem(3, 0, "Версии не найдены") : SetGadgetState(3, 0)
  EndIf
EndProcedure

Procedure.s getLibsString(obj.i, ver.s)
  Protected.i jsonLibsArray, jsonElement, i, k
  Protected.s libName, libsString, packFileName
  Protected Dim libSplit.s(3)

  UseZipPacker()

  If FileSize("versions/" + ver + "/natives") <> -2
    CreateDirectory("versions/" + ver + "/natives")
  EndIf

  jsonLibsArray = GetJSONMember(obj, "libraries")

  For i = 0 To JSONArraySize(jsonLibsArray) - 1
    jsonElement = GetJSONElement(jsonLibsArray, i)
    libName = GetJSONString(GetJSONMember(jsonElement, "name"))

    For k = 1 To 3
      libSplit(k) = StringField(libName, k, ":")
    Next

    libName = ReplaceString(libSplit(1), ".", "/") + "/" + libSplit(2) + "/" + libSplit(3) + "/" + libSplit(2) + "-" + libSplit(3)

    If Not GetJSONMember(jsonElement, "natives")
      libsString + "libraries/" + libName + ".jar:"
    ElseIf OpenPack(0, "libraries/" + libName + "-natives-linux.jar")
      If ExaminePack(0)
        While NextPackEntry(0)
          If PackEntryType(0) = #PB_Packer_File
            packFileName = PackEntryName(0)

            If packFileName <> "MANIFEST.MF" And FileSize("versions/" + ver + "/natives/" + packFileName) = -1
              UncompressPackFile(0, "versions/" + ver + "/natives/" + packFileName)
            EndIf
          EndIf
        Wend
      EndIf

      ClosePack(0)
    EndIf
  Next

  FreeArray(libSplit())
  ProcedureReturn libsString
EndProcedure

Procedure.s fileRead(path.s)
  Protected file.s

  If ReadFile(0, path)
    Repeat
      file + ReadString(0) + #CRLF$
    Until Eof(0)

    CloseFile(0)
  EndIf

  ProcedureReturn file
EndProcedure
