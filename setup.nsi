!include WinVer.nsh

!define NAME "EdgeDeflectorSlim"
!define PUBLISHER "osyu"
!define URL "https://github.com/osyu/EdgeDeflectorSlim"
!define VERSION "1.0.1"
!define VERSION4 "1.0.1.0"

SetCompressor lzma

Name "${NAME}"
OutFile "${NAME}_${VERSION}_setup.exe"

VIAddVersionKey "FileDescription" "${NAME} Setup"
VIAddVersionKey "FileVersion" "${VERSION4}"
VIAddVersionKey "ProductName" "${NAME}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIProductVersion "${VERSION4}"

LicenseData "licdata.txt"
LicenseForceSelection checkbox

InstallDir "$PROGRAMFILES32\${NAME}"

Page license
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

Section
  SetAutoClose true
  SetOutPath $INSTDIR

  File "${NAME}.exe"
  File /oname=license.txt "LICENSE"
  WriteUninstaller "uninst.exe"

  WriteRegStr HKLM "SOFTWARE\Classes\${NAME}\Application" "ApplicationName" "${NAME}"
  WriteRegStr HKLM "SOFTWARE\Classes\${NAME}\Capabilities\UrlAssociations" "microsoft-edge" "${NAME}"
  WriteRegStr HKLM "SOFTWARE\Classes\${NAME}\shell\open\command" "" '"$INSTDIR\${NAME}.exe" "%1"'
  WriteRegStr HKLM "SOFTWARE\RegisteredApplications" "${NAME}" "Software\Classes\${NAME}\Capabilities"

  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayName" "${NAME}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "Publisher" "${PUBLISHER}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "URLInfoAbout" "${URL}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoModify" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoRepair" 1
  SectionGetSize 0 $0
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "EstimatedSize" $0
SectionEnd

Section "Uninstall"
  SetAutoClose true

  DeleteRegKey HKLM "SOFTWARE\Classes\${NAME}"
  DeleteRegValue HKLM "SOFTWARE\RegisteredApplications" "${NAME}"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"

  Delete "$INSTDIR\${NAME}.exe"
  Delete "$INSTDIR\uninst.exe"
  RMDir "$INSTDIR"
SectionEnd

Function .onInit
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "This application only supports Windows 10 and above."
    Quit
  ${EndIf}
FunctionEnd

Function .onInstSuccess
  HideWindow
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\Shell\Associations\UrlAssociations\microsoft-edge\UserChoice" "ProgId"

  ${If} $0 != "${NAME}"
    ExecShell "open" "ms-settings:defaultapps"
    MessageBox MB_ICONINFORMATION "${NAME} has been installed successfully.$\n$\n\
    However, you still need to manually associate it with the microsoft-edge protocol, in order to intercept calls to Edge.$\n$\n\
    This can be set in Windows settings:$\nApps > Default apps > Choose default apps by protocol."
  ${Else}
    MessageBox MB_ICONINFORMATION "${NAME} has been installed successfully."
  ${EndIf}
FunctionEnd
