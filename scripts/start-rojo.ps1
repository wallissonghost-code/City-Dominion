$ErrorActionPreference = "Stop"

Write-Host "City Dominion - Rojo" -ForegroundColor Cyan
Write-Host "1) Instalando ferramentas do projeto via Rokit..."
rokit install

Write-Host "2) Instalando/atualizando plugin do Roblox Studio..."
rojo plugin install

Write-Host "3) Iniciando live sync em http://localhost:34872" -ForegroundColor Green
rojo serve default.project.json
