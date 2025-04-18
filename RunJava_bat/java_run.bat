@echo off
rem �����R�[�h65001�iUTF-8�j
rem chcp 65001
rem chcp 932

rem �x�����ϐ��̓W�J��L����
setlocal ENABLEDELAYEDEXPANSION

set DROPFILE=%~1
rem set DROPFILE_NAME=%~nx1
set DROPFILE_NAME=%~n1
set DROPFILE_EXTENSION=%~x1

echo D^&D���ꂽ�t�@�C��
echo %DROPFILE%
echo %DROPFILE_NAME%
echo %DROPFILE_EXTENSION%

rem ���s���̃o�b�`�t�@�C���̑��݂���p�X���擾
set SCRIPT_PATH=%~dp0

rem D&D�ł͂Ȃ��A���̂܂܎��s���ꂽ�ꍇ
IF [%DROPFILE%] == [] (
    echo ���s����java�t�@�C�����w�肳��Ă��܂���.
    echo ����̏ꏊ�Ɋi�[����Ă���java�t�@�C����Ώۂɂ��܂�.

    rem ���ʂ�\��
    echo ���s���̃o�b�`�t�@�C���̃p�X: %SCRIPT_PATH%

    rem Java�t�@�C���ꗗ���i�[���邽�߂̕ϐ���������
    set JAVA_FILES=
    
    rem �w�肵���p�X���̃t�@�C�������[�v�ŏ���
    for %%f in ("%SCRIPT_PATH%*.java") do (
        set JAVA_FILES=!JAVA_FILES! %%f
    )
    rem Java�t�@�C���ꗗ��\��
    if "!JAVA_FILES!"=="" (
        echo java�t�@�C���͑��݂��܂���.
        pause
        exit /b
    ) else (
        rem �t�@�C���ꗗ��1������
        for %%a in (!JAVA_FILES!) do (
            rem �R���p�C��
            javac -encoding UTF-8 "%%a"
            if %ERRORLEVEL% neq 0 (
                echo �R���p�C���Ɏ��s���܂���.
                echo �R���p�C���t�@�C��: "%%a"
                pause
                exit /b
            )
            
            rem ���s����Java�����擾�i�g���q�����������́j
            set CLASS_NAME=%%~na
            rem java���s
            echo ���s�N���X: !CLASS_NAME!
            java -Dfile.encoding=UTF-8 -cp %SCRIPT_PATH% !CLASS_NAME!
            pause
            exit /b
        ) 
    )
)

rem D&D���ꂽ�t�@�C����java�t�@�C���łȂ��ꍇ %~x1
if not "%DROPFILE_EXTENSION%"==".java" (
    echo �w�肳�ꂽ�t�@�C����Java�t�@�C���ł͂���܂���.
    pause
    exit /b
)

rem java�R���p�C��
javac -encoding UTF-8 "%DROPFILE%"
if %ERRORLEVEL% neq 0 (
    echo �R���p�C���Ɏ��s���܂���.
    pause
    exit /b
)

rem java���s
java -Dfile.encoding=UTF-8 %DROPFILE_NAME%
pause
exit /b

pause