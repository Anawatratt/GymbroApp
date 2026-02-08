# GymBro APK Builder - Workaround for AGP 2026 date bug
# Run as Administrator: Right-click -> Run with PowerShell (as Admin)

Write-Host "=== GymBro APK Builder ===" -ForegroundColor Cyan
Write-Host ""

# Save current date
$currentDate = Get-Date
Write-Host "Current date: $currentDate" -ForegroundColor Yellow

# Change to 2025
Write-Host "Changing date to Jan 15, 2025..." -ForegroundColor Yellow
Set-Date -Date "2025-01-15"

# Build APK
Write-Host ""
Write-Host "Building APK..." -ForegroundColor Green
Set-Location "C:\Users\ASUS\Desktop\Storage\Code\gymbro\gymbro_app"
& "C:\Users\ASUS\develop\flutter\bin\flutter" build apk --debug

# Restore date
Write-Host ""
Write-Host "Restoring date to $currentDate..." -ForegroundColor Yellow
Set-Date -Date $currentDate

Write-Host ""
if (Test-Path "build\app\outputs\flutter-apk\app-debug.apk") {
    $apk = Get-Item "build\app\outputs\flutter-apk\app-debug.apk"
    Write-Host "BUILD SUCCESS!" -ForegroundColor Green
    Write-Host "APK: $($apk.FullName)" -ForegroundColor Cyan
    Write-Host "Size: $([math]::Round($apk.Length / 1MB, 2)) MB" -ForegroundColor Cyan
} else {
    Write-Host "BUILD FAILED" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
