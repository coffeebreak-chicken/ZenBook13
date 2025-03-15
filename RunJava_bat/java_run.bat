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

rem 実行中のバッチファイルの存在するパスを取得
set SCRIPT_PATH=%~dp0

rem D&Dではなく、そのまま実行された場合
IF [%DROPFILE%] == [] (
    echo 実行するjavaファイルが指定されていません.
    echo 所定の場所に格納されているjavaファイルを対象にします.

    rem 結果を表示
    echo 実行中のバッチファイルのパス: %SCRIPT_PATH%

    rem Javaファイル一覧を格納するための変数を初期化
    set JAVA_FILES=
    
    rem 指定したパス内のファイルをループで処理
    for %%f in ("%SCRIPT_PATH%*.java") do (
        set JAVA_FILES=!JAVA_FILES! %%f
    )
    rem Javaファイル一覧を表示
    if "!JAVA_FILES!"=="" (
        echo javaファイルは存在しません.
        pause
        exit /b
    ) else (
        rem ファイル一覧を1つずつ処理
        for %%a in (!JAVA_FILES!) do (
            rem コンパイル
            javac "%%a"
            if %ERRORLEVEL% neq 0 (
                echo コンパイルに失敗しました.
                echo コンパイルファイル: "%%a"
                pause
                exit /b
            )
            
            rem 実行するJava名を取得（拡張子を除いたもの）
            set CLASS_NAME=%%~na
            rem java実行
            echo 実行クラス: !CLASS_NAME!
            java -cp %SCRIPT_PATH% !CLASS_NAME!
            pause
            exit /b
        ) 
    )
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
    echo コンパイルに失敗しました.
    pause
    exit /b
)

rem java実行
java %DROPFILE_NAME%
pause
exit /b

pause