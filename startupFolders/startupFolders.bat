@echo off

for /f "usebackq eol=# delims=" %%i in ("C:\Users\Student\Documents\startupFolders\startupFolders.conf") do (
    echo "%%i"
    if exist "%%i" (
        echo FOUND
        start "" explorer.exe "%%i"
    ) else (
        echo NOT FOUND
    )
)
rem pause



rem bat‚È‚Ì‚ÅSJIS‚Å•Û‘¶‚µ‚Ä‚­‚¾‚³‚¢
rem startupFolders.conf‚àSJIS‚Å•Û‘¶‚µ‚Ä‚­‚¾‚³‚¢
rem ‚¹‚Á‚©‚­•Û‘¶‚µ‚Ä‚àchcp 65001 >nul‚Æ‚·‚é‚ÆUTF8ˆµ‚¢‚É‚È‚é‚Ì‚Å‹LÚ‚µ‚È‚¢‚Å‚­‚¾‚³‚¢
