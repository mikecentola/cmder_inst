; NSIS Installer File for Cmder
;   Written by Mike Centola (http://github.com/mikecentola)
;
;   Intended for NSIS 3.0

; The MIT License (MIT)
;
; Copyright (c) 2016 Mike Centola
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

;--------------------------------
; General

    !define INSTALLER_VERSION "0.0.1"
    !define CMDER_VERSION "1.3.0"
    !define APP_NAME "Cmder"
    !define CMDER_DLURL "http://github.com/cmderdev/cmder/releases/download/v${CMDER_VERSION}/cmder_mini.zip"
    !define CMDER_URL "http://cmder.net"

    !define APP_INSTALLER_TEXT "${APP_NAME} Installer Ver. ${INSTALLER_VERSION}"
    BrandingText "${APP_INSTALLER_TEXT}"

    ; Name / File
    Name "${APP_NAME} v${CMDER_VERSION} Installer"
    OutFile "cmder_inst_${INSTALLER_VERSION}.exe"

    ; Default Installation Folder
    InstallDir $PROGRAMFILES\Cmder

    ; Registry Key to check for directory
    !define REGLOC "Software\${APP_NAME}"
    InstallDirRegKey HKLM "${REGLOC}" "InstallPath"

    ; Request application privileges for Windows Vista
    RequestExecutionLevel admin

    ; Uninstall Info
    !define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

    ; Additional Options
    ShowInstDetails show
    ShowUninstDetails show
    SpaceTexts none

;--------------------------------
; Variables

    Var STARTMENUFOLDER

;--------------------------------
; Interface Configuration

    !define MUI_WELCOMEFINISHPAGE_BITMAP "img\cmder-side.bmp"
    !define MUI_ABORTWARNING
    !define MUI_ICON "img\cmder.ico"
    !define MUI_UNICON "img\cmder.ico"

    !define MUI_WELCOMEPAGE_TITLE "Welcome to the Cmder set up for Windows."
    !define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation the latest version of Cmder \
    for Windows.$\r$\n$\r$\nClick Next to continue."

    !define MUI_LICENSEPAGE_TEXT_TOP "Press Page Down to see the rest of the agreement"
    !define MUI_LICENSEPAGE_TEXT_BOTTOM "Cmder is released under the MIT license. The license is provided here for \
    information purposes only. Click Next to continue."

    !define MUI_COMPONENTSPAGE_NODESC

    !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP_NAME}"

    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_TITLE "Congratulations! You have installed Cmder."
    !define MUI_FINISHPAGE_TEXT "You can now use Cmder. Start menu and/or desktop shortcuts have been created if you chose to do so."
    !define MUI_FINISHPAGE_RUN_TEXT "Run ${APP_NAME} v${CMDER_VERSION}"
    !define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_NAME}.exe"
    !define MUI_FINISHPAGE_RUN_NOTCHECKED

    !define MUI_STARTMENUPAGE_REGISTRY_ROOT

    !define MUI_UNCONFIRMPAGE_TEXT_TOP "All files will be removed from the install directory."

;--------------------------------
; Pages

    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE LICENSE
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_STARTMENU Application $STARTMENUFOLDER
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
; Languages

    !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; ZIP Handling
    !include "ZipDLL.nsh"

;--------------------------------
; Installer Sections

    Section "!Cmder ${CMDER_VERSION}" CmderInst
        SectionIn 1 RO
        SetOutPath  "$INSTDIR"

        ; ADD FILES
        DetailPrint "Downloading latest Cmder (mini) from ${CMDER_DLURL}"
        inetc::get ${CMDER_DLURL} $TEMP/cmder_mini.zip
        Pop $0
        StrCmp "$0" "OK" dlok
        DetailPrint "Download Failed $0"
        Abort

        dlok:
        !insertmacro ZIPDLL_EXTRACT "$TEMP/cmder_mini.zip" "$INSTDIR" "<ALL>"
        Pop $0
        StrCmp "$0" "success" unzipok
        DetailPrint "Failed to Unzip Cmder Files"
        Abort 
        

        unzipok:

        ; Store Installation Folder
        WriteRegStr HKLM "${REGLOC}" "InstallPath" $INSTDIR
        WriteRegStr HKLM "${REGLOC}" "Version" ${CMDER_VERSION}

        ; Start Menu items
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
            CreateDirectory "$SMPROGRAMS\$STARTMENUFOLDER"
            CreateShortCut "$SMPROGRAMS\$STARTMENUFOLDER\${APP_NAME}" "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\icons\cmder.ico"
            CreateShortCut "$SMPROGRAMS\$STARTMENUFOLDER\Uninstall.lnk" "$INSTDIR\uninstall.exe"
        !insertmacro MUI_STARTMENU_WRITE_END

        ; Write Uninstaller Registry Keys
        WriteRegStr HKLM "${ARP}" "DisplayName" "Cmder"
        WriteRegExpandStr HKLM "${ARP}" "UninstallString" "$INSTDIR\uninstall.exe"
        WriteRegExpandStr HKLM "${ARP}" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
        WriteRegExpandStr HKLM "${ARP}" "InstallLocation" "$INSTDIR"
        WriteRegStr HKLM "${ARP}" "DisplayIcon" "$INSTDIR\icons\cmder.ico"
        WriteRegStr HKLM "${ARP}" "DisplayVersion" "${CMDER_VERSION}"
        WriteRegStr HKLM "${ARP}" "URLInfoAbout" "${CMDER_URL}"
        WriteRegStr HKLM "${ARP}" "NoModify" 1
        WriteRegStr HKLM "${ARP}" "NoRepair" 1

        ; Get Size
        ${GetSize} "$INSTDIR" "/S=OK" $0 $1 $2
        IntFmt $0 "0x$08X" $0
        WriteRegDWORD HKLM "${ARP}" "EstimatedSize" "$0"

        ; Create Uninstaller
        WriteUninstaller "$INSTDIR\Uninstall.exe"

    SectionEnd

    ; Shortcuts
    SectionGroup /e "Shortcuts"
        Section "Start Menu"
            ; Start Menu items
            !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
                CreateDirectory "$SMPROGRAMS\$STARTMENUFOLDER"
                CreateShortCut "$SMPROGRAMS\$STARTMENUFOLDER\${APP_NAME}.lnk" "$INSTDIR\${APP_NAME}.exe" "" "$INSTDIR\icons\cmder.ico"
                CreateShortCut "$SMPROGRAMS\$STARTMENUFOLDER\Uninstall.lnk" "$INSTDIR\uninstall.exe"
            !insertmacro MUI_STARTMENU_WRITE_END
        SectionEnd

        Section /o "Create Desktop Icon"
            ;Create Desktop Shortcut
            CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_NAME}.exe" ""
        SectionEnd
    SectionGroupEnd

    ; Windows Explorer Integration Section
    SectionGroup /e "Windows Explorer Integration"
        
        ; Open Cmder Here
        Section 'Add "Open Cmder Here"'

            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "" "Open Cmder Here"
            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}" "Icon" "$INSTDIR\icons\cmder.ico"
            WriteRegStr HKCR "Directory\Background\shell\${APP_NAME}\command" "" '"$INSTDIR\${APP_NAME}.exe" "%V"'

            WriteRegStr HKCR "Directory\shell\${APP_NAME}" "" "Open Cmder Here"
            WriteRegStr HkCR "Directory\shell\${APP_NAME}" "Icon" "$INSTDIR\icons\cmder.ico"
            WriteRegStr HKCR "Directory\shell\${APP_NAME}\command" "" '"$INSTDIR\${APP_NAME}.exe" "%1"'
        
        SectionEnd
    SectionGroupEnd

    


;--------------------------------
; Uninstaller Section

    Section "Uninstall"
    
        ; Remove Start Menu Item
        delete "$SMPROGRAMS\$STARTMENUFOLDER\${APP_NAME}.lnk"
        delete "$SMPROGRAMS\$STARTMENUFOLDER\Uninstall.lnk"
        rmDir "$SMPROGRAMS\$STARTMENUFOLDER"

        ; Remove Desktop Link
        delete $DESKTOP\${APP_NAME}.lnk

        ; Remove Files
        rmDir /r "$INSTDIR\bin"
        rmDir /r "$INSTDIR\config"
        rmDir /r "$INSTDIR\icons"
        rmDir /r "$INSTDIR\vendor"
        delete "$INSTDIR\${APP_NAME}.exe"
        delete "$INSTDIR\CHANGELOG.md"
        delete "$INSTDIR\CONTRIBUTING.md"
        delete "$INSTDIR\README.md"
        delete "$INSTDIR\Version v${CMDER_VERSION}"
        delete "$INSTDIR\Uninstall.exe"

        ; Try to Remove Install Dir
        rmDir $INSTDIR

        ; Remove Registry Keys
        DeleteRegKey HKLM "${REGLOC}"
        DeleteRegKey HKCR "Directory\Background\shell\${APP_NAME}"
        DeleteRegKey HKCR "Directory\shell\${APP_NAME}"
        DeleteRegKey HKLM "${ARP}" 

    SectionEnd


;--------------------------------
; Extra Functions
    Function .onInit
        InitPluginsDir
        File "/oname=$PluginsDir\spltmp.bmp" "img\cmder-splash.bmp"

        advsplash::show 1000 600 400 -1 $PluginsDir\spltmp

        Pop $0

        

    FunctionEnd

; END NSIS Script
