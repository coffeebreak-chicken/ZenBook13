@echo off
@REM 文字コード65001（UTF-8）
chcp 65001

rem 遅延環境変数の展開を有効化
setlocal ENABLEDELAYEDEXPANSION

set DROPFILE=%~1
rem set DROPFILE_NAME=%~nx1
set DROPFILE_NAME=%~n1
set DROPFILE_EXTENSION=%~x1

echo D^&Dされたファイル
echo %DROPFILE%
echo %DROPFILE_NAME%
echo %DROPFILE_EXTENSION%

rem D&Dではなく、そのまま実行された場合
IF [%DROPFILE%] == [] (
    echo 実行するjavaファイルが指定されていません.
    echo 所定の場所に格納されているjavaファイルを対象にします.
)

rem D&Dされたファイルがjavaファイルでない場合 %~x1
if not "%DROPFILE_EXTENSION%"==".java" (
    echo 指定されたファイルはJavaファイルではありません.
    pause
    exit /b
)

rem javaコンパイル
javac "%DROPFILE%"
if %ERRORLEVEL% neq 0 (
    echo コンパイルに失敗しました。
    pause
    exit /b
)

rem java実行
java %DROPFILE_NAME%


pause