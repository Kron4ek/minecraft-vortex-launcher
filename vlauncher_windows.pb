EnableExplicit

Global.s java, usrJava
Global Dim programFilesDir.s(1) : programFilesDir(0) = GetEnvironmentVariable("ProgramW6432") + "\" : programFilesDir(1) = GetEnvironmentVariable("PROGRAMFILES") + "\"
Define Directory.s = GetCurrentDirectory()
Define.i Event, font, jsonObj, inheritsM, jarM
Define.s name, ram, version, mainClass, assets, params, libs, inherits, natives, jar

Declare setVerList()
Declare setJavaPath()
Declare.s getLibsString(obj.i, ver.s)
Declare.s fileRead(path.s)

If OpenWindow(0, #PB_Ignore, #PB_Ignore, 200, 173, "Vortex Launcher")
  
  SetCurrentDirectory(Directory)
  OpenPreferences(GetHomeDirectory() + ".vortex_launcher.conf")
  
  StringGadget(1, 5, 5, 190, 22, ReadPreferenceString("Name", "Имя"))
  SetGadgetAttribute(1, #PB_String_MaximumLength, 16)
  
  StringGadget(2, 5, 32, 190, 22, ReadPreferenceString("Ram", "512"), #PB_String_Numeric)
  SetGadgetAttribute(2, #PB_String_MaximumLength, 4)
  GadgetToolTip(2, "Выделяемая память")
  
  ComboBoxGadget(3, 5, 59, 190, 22)
  
  ComboBoxGadget(4, 5, 86, 190, 22)
  
  ButtonGadget(6, 5, 115, 190, 45, "Играть")
  If LoadFont(0, "Ariral", 16, #PB_Font_Bold)
    SetGadgetFont(6, FontID(0))
  EndIf
  
  TextGadget(7, 0, 163, 50, 20, "by Kron")
  TextGadget(8, 173, 163, 50, 20, "v1.0.1")
  If LoadFont(1, "Ariral", 7)
    font = FontID(1) : SetGadgetFont(7, font) : SetGadgetFont(8, font)
  EndIf
  
  setVerList()
  setJavaPath()
  
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
        Select EventGadget()
          Case 5
            usrJava = OpenFileRequester("Выберите файл javaw.exe", "", "JRE|javaw.exe", 0)
            
            If usrJava
              FreeGadget(4) : FreeGadget(5)
              ComboBoxGadget(4, 5, 86, 190, 22)
              AddGadgetItem(4, 0, "User-selected Java") : SetGadgetState(4, 0)
              WritePreferenceString("Java", usrJava)
            EndIf
          Case 6
            ram = GetGadgetText(2)
            version = GetGadgetText(3)
            java = GetGadgetText(4)
            name = GetGadgetText(1)
            If FindString(name, " ") : name = RemoveString(name, " ") : EndIf
          
            If name And ram And version <> "Нет версий"
              If java <> "Java не найдена"
                If ParseJSON(0, fileRead("versions\" + version + "\" + version + ".json"))
                  jsonObj = JSONValue(0)
                
                  jarM = GetJSONMember(jsonObj, "jar")
                  If jarM
                    jar = GetJSONString(jarM) : jar = "versions\" + jar + "\" + jar + ".jar"
                  Else
                    jar = "versions\" + version + "\" + version + ".jar"
                  EndIf
                
                  If FileSize(jar) <> -1
                    natives = "versions\" + version + "\natives"
                    libs = getLibsString(jsonObj, version)
                    mainClass = GetJSONString(GetJSONMember(jsonObj, "mainClass"))
                    assets = GetJSONString(GetJSONMember(jsonObj, "assets"))
                
                    params = GetJSONString(GetJSONMember(jsonObj, "minecraftArguments"))
                    params = ReplaceString(params, "${auth_player_name}", name)
                    params = ReplaceString(params, "${version_name}", version)
                    params = ReplaceString(params, "${game_directory}", Directory)
                    params = ReplaceString(params, "${assets_root}", "assets")
                    params = ReplaceString(params, "${assets_index_name}", assets)
                    params = ReplaceString(params, "${auth_uuid}", "00000000-0000-0000-0000-000000000000")
                    params = ReplaceString(params, "${auth_access_token}", "00000000-0000-0000-0000-000000000000")
                    params = ReplaceString(params, "${user_properties}", "{}")
                    params = ReplaceString(params, "${user_type}", "mojang")
                  
                    inheritsM = GetJSONMember(jsonObj, "inheritsFrom")
                    If inheritsM
                      inherits = GetJSONString(inheritsM)
                      
                      If ParseJSON(1, fileRead("versions\" + inherits + "\" + inherits + ".json"))
                        libs + getLibsString(JSONValue(1), inherits)
                        natives = "versions\" + inherits + "\natives"
                      Else
                        MessageRequester("Error", "Отсутствует файл " + inherits + ".json") : End
                      EndIf
                    EndIf
                    
                    If Val(ram) < 250 : ram = "250" : EndIf
                    WritePreferenceString("Name", name) : WritePreferenceString("Ram", ram)
                    WritePreferenceString("ChosenVer", version) : ClosePreferences()
                
                    If java = "User-selected Java"
                      java = usrJava
                    ElseIf FindString(java, " (x32)")
                      java = programFilesDir(1) + "Java\" + RemoveString(java, " (x32)") + "\bin\javaw.exe"
                    Else
                      java = programFilesDir(0) + "Java\" + java + "\bin\javaw.exe"
                    EndIf : FreeArray(programFilesDir())
                    
                    RunProgram(java, "-Xmx" + ram + "M -Xms" + ram + "M -Djava.library.path=" + natives + " -cp " + libs + jar + " " + mainClass + " " + params, Directory)
                    End
                  Else
                    MessageRequester("Error", "Отсутствует jar файл")
                  EndIf
                  
                  FreeJSON(#PB_All)
                Else
                  MessageRequester("Error", "Отсутствует файл " + version + ".json")
                EndIf
              Else
                MessageRequester("Error", "В системе не найдена Java!" + #CRLF$ + #CRLF$ + "Установите ее или выберите вручную," + #CRLF$ + "если она уже установлена!")
              EndIf
            Else
              MessageRequester("Error", "Введите имя\память и выберите версию")
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
        If FileSize("versions\" + dirName + "\" + dirName + ".json") <> -1
          If FindString(dirName, " ")
            fixedDirName = ReplaceString(dirName, " ", "_")
            If FileSize("versions\" + dirName + "\" + dirName + ".jar") <> -1
              RenameFile("versions\" + dirName + "\" + dirName + ".jar", "versions\" + dirName + "\" + fixedDirName + ".jar")
            EndIf
            RenameFile("versions\" + dirName + "\" + dirName + ".json", "versions\" + dirName + "\" + fixedDirName + ".json")
            RenameFile("versions\" + dirName, "versions\" + fixedDirName)
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
    DisableGadget(3, 1) : AddGadgetItem(3, 0, "Нет версий") : SetGadgetState(3, 0)
  EndIf
EndProcedure

Procedure setJavaPath()
  Protected dirName.s
  Protected count.i
  
  usrJava = ReadPreferenceString("Java", "")
  If usrJava
    If FileSize(usrJava) <> -1
      AddGadgetItem(4, 0, "User-selected Java") : SetGadgetState(4, 0)
    Else
      RemovePreferenceKey("Java")
    EndIf
  EndIf
  
  For count = 0 To 1
    If programFilesDir(count) <> "\"
      If ExamineDirectory(0, programFilesDir(count) + "Java", "*")
        While NextDirectoryEntry(0) And DirectoryEntryType(0) = #PB_DirectoryEntry_Directory
          dirName = DirectoryEntryName(0)
  
          If dirName <> ".." And dirName <> "." And FileSize(programFilesDir(count) + "Java\" + dirName + "\bin\javaw.exe") <> -1
            If count : dirName + " (x32)" : EndIf
            AddGadgetItem(4, -1, dirName) : SetGadgetState(4, 0)
          EndIf
        Wend
  
        FinishDirectory(0)
      EndIf
    EndIf
  Next
  
  If Not CountGadgetItems(4)
    FreeGadget(4)
    StringGadget(4, 5, 86, 130, 22, "Java не найдена", #PB_String_ReadOnly)
    ButtonGadget(5, 140, 86, 55, 22, "Выбрать")
  EndIf
EndProcedure

Procedure.s getLibsString(obj.i, ver.s)
  Protected.i jsonLibsArray, jsonElement, i, k
  Protected.s libName, libsString, packFileName
  Protected Dim libSplit.s(3)
  
  UseZipPacker()
  
  If FileSize("versions\" + ver + "\natives") <> -2
    CreateDirectory("versions\" + ver + "\natives")
  EndIf
  
  jsonLibsArray = GetJSONMember(obj, "libraries")
  
  For i = 0 To JSONArraySize(jsonLibsArray) - 1
    jsonElement = GetJSONElement(jsonLibsArray, i)
    libName = GetJSONString(GetJSONMember(jsonElement, "name"))
                    
    For k = 1 To 3
      libSplit(k) = StringField(libName, k, ":")
    Next

    libName = ReplaceString(libSplit(1), ".", "\") + "\" + libSplit(2) + "\" + libSplit(3) + "\" + libSplit(2) + "-" + libSplit(3)
                    
    If Not GetJSONMember(jsonElement, "natives")
      libsString + "libraries\" + libName + ".jar;"
    ElseIf OpenPack(0, "libraries\" + libName + "-natives-windows.jar")
      If ExaminePack(0)
        While NextPackEntry(0)
          If PackEntryType(0) = #PB_Packer_File
            packFileName = PackEntryName(0)
            
            If packFileName <> "MANIFEST.MF" And FileSize("versions\" + ver + "\natives\" + packFileName) = -1
              UncompressPackFile(0, "versions\" + ver + "\natives\" + packFileName)
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
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 161
; FirstLine = 137
; Folding = -
; EnableUnicode
; EnableXP
; UseIcon = icon.ico
; Executable = VLauncher.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1.0.0.0
; VersionField1 = 1.0.1
; VersionField3 = Vortex Launcher
; VersionField4 = 1.0.1
; VersionField6 = Fast minecraft launcher
; VersionField9 = Kron