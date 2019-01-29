; NSIS Installer File for Cmder
;   VERSION:        v0.1.0
;
;   Written by Mike Centola (http://github.com/mikecentola)
;
;   Intended for NSIS 3.0

; The MIT License (MIT)
;
; Copyright (c) 2019 Mike Centola
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

;--------------------------------
; Includes

    !include "MUI2.nsh"
    !include "FileFunc.nsh"
    !include "x64.nsh"
    !include "winmessages.nsh"


;--------------------------------
; Access Context

    ; Request application privileges
    RequestExecutionLevel admin
 

;--------------------------------
; General

    !define APP_NAME "Cmder"

    !ifndef INSTALLER_VERSION
      ; Not run with nodejs
      !define INSTALLER_VERSION "v0.1.0"
    !endif

    !ifndef CMDER_VERSION
        ; Not run with nodejs
        !define CMDER_VERSION "v1.3.11"
    !endif

    !ifndef FILE_VERSION
      !define FILE_VERSION "0.1.0.0"
    !endif

    !define CMDER_LATEST "https://api.github.com/repos/cmderdev/cmder/releases/latest"
    !define CMDER_URL "http://cmder.net"

    ; Temporary Files
    !define TMP_GHJSON "$PLUGINSDIR/${APP_NAME}_GitHub.json"
    !define TMP_CMDERPACKAGE "$PLUGINSDIR/${APP_NAME}.zip"


    !define APP_INSTALLER_TEXT "${APP_NAME} Installer ${INSTALLER_VERSION}"
    BrandingText "${APP_INSTALLER_TEXT}"

    ; Name / File
    Name "${APP_NAME}"
    OutFile "cmder_inst_${INSTALLER_VERSION}.exe"

    ; Default Installation Folder
    InstallDir $LOCALAPPDATA\Programs\${APP_NAME}

    ; Registry Set Up
    !define REGLOC "Software\${APP_NAME}"
    !define REGROOT "HKCU"
    InstallDirRegKey ${REGROOT} "${REGLOC}" "InstallPath"

    ; Uninstall Info
    !define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

    ; Additional Options
    ShowInstDetails show
    ShowUninstDetails show
    SpaceTexts none

    ; File Properties
    VIAddVersionKey "FileVersion" "${FILE_VERSION}"
    VIAddVersionKey "LegalCopyright" "Copyright (c) 2019 Mike Centola"
    VIAddVersionKey "CompanyName" "Applied Eng & Design"
    VIAddVersionKey "FileDescription" "${APP_NAME} Installer"
    VIAddVersionKey "ProductName" "${APP_NAME} Installer"
    VIAddVersionKey "ProductVersion" "${FILE_VERSION}"
    VIProductVersion "${FILE_VERSION}"

;--------------------------------
; Interface Configuration

    !define MUI_WELCOMEFINISHPAGE_BITMAP "img\cmder-side.bmp"
    !define MUI_UNWELCOMEFINISHPAGE_BITMAP "img\cmder-side.bmp"
    !define MUI_ICON "img\cmder.ico"
    !define MUI_UNICON "img\cmder.ico"

    !define MUI_WELCOMEPAGE_TITLE "Welcome to the ${APP_NAME} Installation Tool for Windows."
    !define MUI_WELCOMEPAGE_TITLE_3LINES
    !define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation the latest version of Cmder \
    for Windows.$\r$\n$\r$\nClick Next to continue."

    !define MUI_LICENSEPAGE_TEXT_TOP "Press Page Down to see the rest of the agreement"
    !define MUI_LICENSEPAGE_TEXT_BOTTOM "Cmder is released under the MIT license. The license is provided here for \
    information purposes only. Click Next to continue."

    !define MUI_COMPONENTSPAGE_NODESC

    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_TITLE "Congratulations! You have installed Cmder."
    !define MUI_FINISHPAGE_TITLE_3LINES
    !define MUI_FINISHPAGE_TEXT "You can now use Cmder. Start menu and/or desktop shortcuts have been created \
        if you chose to do so.$\r$\n$\r$\n"
    !define MUI_FINISHPAGE_RUN_TEXT "Run ${APP_NAME}"
    !define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_NAME}.exe"

    !define MUI_FINISHPAGE_NOREBOOTSUPPORT

    !define MUI_ABORTWARNING
    !define MUI_ABORTWARNING_TEXT "Are you sure you want to cancel the installation of ${APP_NAME}?"
    !define MUI_ABORTWARNING_CANCEL_DEFAULT

    !define MUI_UNCONFIRMPAGE_TEXT_TOP "This wizard will guide you through the uninstallation of ${APP_NAME} \
        .$\r$\n$\r$\nBefore starting the uninstallation, please make sure that ${APP_NAME} \
        is not running.$\r$\n$\r$\nClick Next to continue."
    !define MUI_UNFINISHPAGE_NOAUTOCLOSE

;--------------------------------
; Pages

    ; Installer Pages
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE LICENSE
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

    ; Uninstaller Pages
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES
    !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages

    !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; ZIP Handling
    !include "ZipDLL.nsh"

;--------------------------------
; Installer Sections

    Section "!Cmder" CmderInst
        SectionIn 1 RO

        ${If} ${RunningX64}
            DetailPrint "Installer running on 64-bit host"

            ; Disable registry redirection
            SetRegView 64

        ${EndIf}

        SetOutPath  "$INSTDIR"
        DetailPrint "Setting InstallDir: $INSTDIR"

        ; ADD FILES
        DetailPrint "Downloading latest Cmder (mini)..."
        Var /GLOBAL cmder_dl
        Var /GLOBAL cmder_version
        Call getLatestRelease
        DetailPrint "Attempting to fetch latest cmder installer..."
        inetc::get $cmder_dl ${TMP_CMDERPACKAGE}
        Pop $0
        StrCmp "$0" "OK" dlok
        DetailPrint "Download Failed $0"
        Abort

        dlok:
        DetailPrint "Download OK"
        !insertmacro ZIPDLL_EXTRACT "${TMP_CMDERPACKAGE}" "$INSTDIR" "<ALL>"
        Pop $0
        DetailPrint "Unzipping Files"
        StrCmp "$0" "success" unzipok
        DetailPrint "Failed to Unzip Cmder Files"
        Abort 
        

        unzipok:
        DetailPrint "Unzip OK"

        DetailPrint "Writing Registry Keys"
        ; Store Installation Folder
        WriteRegStr ${REGROOT} "${REGLOC}" "InstallPath" $INSTDIR
        WriteRegStr ${REGROOT} "${REGLOC}" "Version" $cmder_version

        ; Create Uninstaller
        DetailPrint "Creating Uninstaller"
        WriteUninstaller "$INSTDIR\Uninstall.exe"

        ; Write Uninstaller Registry Keys
        WriteRegStr ${REGROOT} "${ARP}" "DisplayName" "Cmder"
        WriteRegExpandStr ${REGROOT} "${ARP}" "UninstallString" "$INSTDIR\uninstall.exe"
        WriteRegExpandStr ${REGROOT} "${ARP}" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
        WriteRegExpandStr ${REGROOT} "${ARP}" "InstallLocation" "$INSTDIR"
        WriteRegStr ${REGROOT} "${ARP}" "DisplayIcon" "$INSTDIR\icons\${APP_NAME}.ico"
        WriteRegStr ${REGROOT} "${ARP}" "DisplayVersion" "$cmder_version"
        WriteRegStr ${REGROOT} "${ARP}" "URLInfoAbout" "${CMDER_URL}"
        WriteRegStr ${REGROOT} "${ARP}" "NoModify" 1
        WriteRegStr ${REGROOT} "${ARP}" "NoRepair" 1

        ; Get Size
        ${GetSize} "$INSTDIR" "/S=OK" $0 $1 $2
        IntFmt $0 "0x%08X" $0
        WriteRegDWORD ${REGROOT} "${ARP}" "EstimatedSize" "$0"

        ; Remove Temporary Files
        DetailPrint "Removing Temporary Files"
        Delete "${TMP_CMDERPACKAGE}"
        Delete "${TMP_GHJSON}"

    SectionEnd

    ; Shortcuts
    SectionGroup /e "Shortcuts"
        Section "Start Menu"
            DetailPrint "Writing StartMenu Shortcut"
            ; Start Menu item
            CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\icons\${APP_NAME}.ico" 0

        SectionEnd

        Section /o "Create Desktop Icon"
            ;Create Desktop Shortcut
            DetailPrint "Writing Desktop Shorcut"
            SetOutPath $INSTDIR
            SetOverwrite on
               CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\icons\${APP_NAME}.ico" 0
            SetOverwrite off
        SectionEnd
    SectionGroupEnd

    ; Windows Explorer Integration Section
    SectionGroup /e "Windows Explorer Integration"
        
        ; Open Cmder Here
        Section 'Add "Open Cmder Here"'
            DetailPrint "Adding Explorer Integrations"
            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "" "Open Cmder Here"
            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "Icon" "%CMDER_ROOT%\icons\cmder.ico"
            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}\command" "" '"%CMDER_ROOT%\${APP_NAME}.exe" "%v"'

            WriteRegStr HKCR "Directory\shell\${APP_NAME}" "" "Open Cmder Here"
            WriteRegStr HKCR "Directory\shell\${APP_NAME}" "Icon" "%CMDER_ROOT\icons\cmder.ico"
            WriteRegStr HKCR "Directory\shell\${APP_NAME}\command" "" '"%CMDER_ROOT%\${APP_NAME}.exe" "%1"'
        
        SectionEnd
    SectionGroupEnd

    ; Environment Variables
    SectionGroup /e "Environment Variables"
        Section "CMDER_ROOT"
            DetailPrint "Adding CMDER_ROOT Environment Variable"
            EnVar::SetHKCU
            EnVar::AddValue "CMDER_ROOT" "$INSTDIR"
            Pop $0
            ${Switch} $0
                ${Case} 0
                    DetailPrint "Success."
                    ${Break}
                ${Case} 4
                    DetailPrint "Error writing Environment Variable."
                    MessageBox MB_OK "Error writing Environment Variable, Please add manually after Install."
                    ${Break}
            ${EndSwitch}
        SectionEnd
    SectionGroupEnd


    


;--------------------------------
; Uninstaller Section


    Section "Uninstall"
        ; x64 Setup
        ${If} ${RunningX64}
            DetailPrint "Installer running on 64-bit host"

            ; Disable registry redirection
            SetRegView 64

        ${EndIf}
        
        ; Remove Start Menu Items
        DetailPrint "Removing StartMenu Item"
        Delete "$SMPROGRAMS\${APP_NAME}.lnk"
           
        ; Remove Desktop Link
        DetailPrint "Removing Desktop Shortcut"
        Delete "$DESKTOP\${APP_NAME}.lnk"

        ; Remove Files
        DetailPrint "Removing Files"
        rmDir /r "$INSTDIR\bin"
        rmDir /r "$INSTDIR\config"
        rmDir /r "$INSTDIR\icons"
        rmDir /r "$INSTDIR\vendor"
        Delete "$INSTDIR\*.*"
        Delete "$INSTDIR\Uninstall.exe"

        ; Try to Remove Install Dir
        DetailPrint "Removing Installation Folder"
        rmDir "$INSTDIR"

        ; Remove Registry Keys
        DetailPrint "Removing Registry Keys"
        DeleteRegKey ${REGROOT} "${REGLOC}"
        DeleteRegKey HKCR "Directory\Background\shell\${APP_NAME}"
        DeleteRegKey HKCR "Directory\shell\${APP_NAME}"
        DeleteRegKey ${REGROOT} "${ARP}" 

        ; Remove Environment Variables
        DetailPrint "Removing Environment Variables"
        EnVar::SetHKCU
        EnVar::Check "CMDER_ROOT" "NULL"
        Pop $0
        ${Switch} $0
            ${Case} 0
                DetailPrint "Found CMDER_ROOT... Removing..."
                EnVar::Delete "CMDER_ROOT"
                Pop $1
                ${Switch} $1
                    ${Case} 0
                        DetailPrint "Success."
                        ${Break}
                    ${Case} 4
                        DetailPrint "Could not remove Environment Variable"
                        ${Break}
                ${EndSwitch}
                ${Break}
            ${Case} 1
                DetailPrint "Could not read from the environment"
                ${Break}
            ${Case} 2
                DetailPrint "CMDER_ROOT variable does not exist... OK"
                ${Break}
        ${EndSwitch}


    SectionEnd


;--------------------------------
; Extra Functions

    ; Init Function
    Function .onInit
        InitPluginsDir
        File "/oname=$PLUGINSDIR\spltmp.bmp" "img\cmder-splash.bmp"

        advsplash::show 1000 600 400 -1 $PLUGINSDIR\spltmp

        Pop $0   

    FunctionEnd


    ; Get Latest Release using GitHub API
    Function getLatestRelease
        getjson:
        ClearErrors
        ; Get JSON from GH
        DetailPrint "Fetching Latest Release from GitHub (${CMDER_LATEST})"
        inetc::get ${CMDER_LATEST} ${TMP_GHJSON}
        IfErrors errors

        ; Parse JSON
        DetailPrint "Parsing JSON..."
        nsJSON::Set /file ${TMP_GHJSON}
        
        ; Get Version
        nsJSON::Get 'tag_name' /end
        Pop $cmder_version
        DetailPrint "Found version $cmder_version"

        ; Get Download URL
        nsJSON::Get /count 'assets' /end
        Pop $R0

        Var /GLOBAL i
        ${ForEach} $i 0 $R0 + 1
            nsJSON::Get 'assets' /index $i 'name' /end
            Pop $R1
            StrCmp $R1 "cmder_mini.zip" done 
        ${Next}

        done:
        nsJSON::Get 'assets' /index $i 'browser_download_url' /end
        DetailPrint "Got URL"
        Pop $cmder_dl
        Goto funcend

        errors:
            Pop $0
            DetailPrint $0
            MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "Could not retrieve JSON from GitHub" IDRETRY true IDCANCEL false
            true:
            Goto getjson  
            false:
            Abort "Installation Aborted."

        funcend:

    FunctionEnd



; END NSIS Script
