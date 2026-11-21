@echo off

for /f "usebackq eol=# delims=" %%i in (`findstr /v /r /c:"^//" /c:"^rem " "C:\Users\F23199\Documents\startupFolders.conf"`) do (

    rem 空行は無視
    if not "%%i"=="" (

        rem '#' コメント行を無視
        rem if not "%%i:~0,1%"=="#" (

            rem '//' コメント行を無視
            rem if not "%%i:~0,2%"=="//" (

                echo "%%i"

                if exist "%%i" (
                    echo FOUND
                    start "" explorer.exe "%%i"
                ) else (
                    echo NOT FOUND
                )

            rem )
        rem )
    )
)
rem pause



rem batなのでSJISで保存してください
rem startupFolders.confもSJISで保存してください
rem せっかく保存してもchcp 65001 >nulとするとUTF8扱いになるので記載しないでください


