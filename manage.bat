:: this batch script helps you deploy and build your application
@echo off
:: setting default variables
set USAGE=[ERROR]        Usage: manage.bat [build/deploy/commit]
set CSS_PATH=src/resources/dist
set SCSS_PATH=src/resources/main.scss

:: if usages is manage.bat commit
if "%1"=="commit" (
    echo [WARN]        deploying code
    git add .
    call :assert "stagging succeeded", "stagging failed" || goto :eof
    set /p commit_message=commit message:
    git commit -m"%commit_message%"
    call :assert "commit succeeded", "commit failed" || goto :eof
    git push origin master
    call :assert "push succeeded", "push failed" || goto :eof
    echo [WARN]        btw it's simple.. u just do
    echo [WARN]        "git add ." to add everysthing to staging
    echo [WARN]        "git commit -m'commit description'" to commit all staged items
    echo [WARN]        "git push origin master" to push commits to orign remote on the master branch
    goto :eof
)

:: if usages is manage.bat deploy
if "%1"=="deploy" (
    echo [WARN]        deploying code
    git subtree push --prefix src origin gh-pages
    call :assert "routing github pages succeeded", "routing github pages failed" || goto :eof
    echo [WARN]        this is hard to memorize bs u can by time
    echo [WARN]        "git subtree push --prefix src origin gh-pages" this creates a new branch called gh-pages out of the src folder
    goto :eof
)
:: if usages is manage.bat build
if "%1"=="build" (
    choice /m "Watch file changes"
    echo ___                  __     ___
    echo/\  \                /\ \   /\  \
    echo\ \  \               \ \ \  \ \  \
    echo \ \  \___  __   __  _\ \ \  \_\  \  __  ______  ______
    echo  \ \  __ \/\ \  \ \/\ \ \ \/\  __ \/\ \/\  __ \/\  __ \
    echo   \ \ \_\ \ \ \__\ \ \ \ \ \ \ \_\ \ \ \ \ \ \ \ \ \_\ \
    echo    \ \_____\ \______\ \_\ \_\ \_____\ \_\ \_\ \_\ \___  \
    echo     \/_____/\/______/\/_/\/_/\/_____/\/_/\/_/\/_/\/___/\ \
    echo ______________________________________________________\_\ \
    echo/\__________________________________________________________\
    echo\/__________________________________________________________/

    echo [WARN]	building css in %CSS_PATH% from %SCSS_PATH%
    if "%errorlevel%" == "1" (
        sass --watch %SCSS_PATH% %CSS_PATH%
        goto :eof
    )
    sass %SCSS_PATH% %CSS_PATH%
    goto :eof

)


:: if usages is manage.bat
echo %USAGE%
goto :eof

:: a function that asserts if the operation is a success or failer
:: and prints to the command line the result
:assert
    if "%errorlevel%" == "0" (
        echo OK->	%~1
        exit /b 0
    )
    echo [ERROR]        %~2 - exit code: %ERRORLEVEL%
    exit /b 1
