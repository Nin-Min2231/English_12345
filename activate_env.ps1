# Nạp Flutter SDK / JDK 17 / Android SDK vào PATH cho session PowerShell hiện tại.
# Dùng: dot-source (dấu ". " ở đầu là bắt buộc, nếu không PATH sẽ không áp dụng ra ngoài):
#   . .\activate_env.ps1
# Toolchain được cài 2026-07-23, KHÔNG nằm trong PATH hệ thống của máy này.

$env:JAVA_HOME = "D:\jdk17_extract\jdk-17.0.19+10"
$env:ANDROID_SDK_ROOT = "$env:USERPROFILE\AppData\Local\Android\Sdk"
$env:ANDROID_HOME = $env:ANDROID_SDK_ROOT
$env:PATH = "D:\flutter\bin;$env:JAVA_HOME\bin;" + $env:PATH

Write-Host "Da nap: Flutter D:\flutter | JDK 17 $env:JAVA_HOME | Android SDK $env:ANDROID_SDK_ROOT"
Write-Host "Kiem tra: flutter --version"
