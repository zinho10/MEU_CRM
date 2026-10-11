@echo off
title CONTROLE DE ESTOQUE - SERVIDOR LOCAL
cd /d "%~dp0"
echo.
echo ==========================================================
echo             CONTROLE DE ESTOQUE WEB
echo ==========================================================
echo.
echo Iniciando servidor local...
echo Banco de dados: %CD%\estoque.json
echo.
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%CD%\servidor.ps1"
timeout /t 2 /nobreak >nul
start "" "http://127.0.0.1:8765/"
echo.
echo Sistema aberto no navegador.
echo Mantenha a janela do PowerShell aberta enquanto utilizar.
echo.
pause
