@echo off
setlocal

:: 设置固定的搜索目录
set SEARCH_DIR=E:\RIPPER\261\ExportedProject\Assets\MonoBehaviour

:: 检查是否提供了搜索内容
if "%~1"=="" (
    echo 请输入要搜索的内容。
    exit /b 1
)

:: 搜索指定内容
findstr /S /I /M "%~1" "%SEARCH_DIR%\*"

endlocal