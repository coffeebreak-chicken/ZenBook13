@echo off

rem current:カレントディレクトリ
set current=%~dp0
echo %current%

rem カレントディレクトリ上でclassファイル作成（コンパイル）
cd %current%
javac -encoding utf-8 StringToFile.java

rem java実行
java StringToFile

pause