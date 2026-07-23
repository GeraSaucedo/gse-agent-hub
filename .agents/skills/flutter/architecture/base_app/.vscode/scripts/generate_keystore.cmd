@echo off
setlocal enabledelayedexpansion

set "KEYSTORE_PATH=android\app\upload-keystore.jks"
set "KEY_PROPS_PATH=android\key.properties"
set "KEY_ALIAS=upload"
set "DNAME=CN=GSE, OU=Dev, O=IENTC, L=City, ST=State, C=MX"

:: ===== Ask for password =====
set /p "STORE_PASS=Enter keystore password: "
if "!STORE_PASS!"=="" (
    echo ERROR: Password cannot be empty.
    exit /b 1
)

:: ===== Find keytool =====
set "KEYTOOL="

:: 1. JAVA_HOME
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\keytool.exe" (
        set "KEYTOOL=%JAVA_HOME%\bin\keytool.exe"
        echo Found keytool in JAVA_HOME: !KEYTOOL!
    )
)

:: 2. Android Studio bundled JBR
if not defined KEYTOOL (
    for %%D in (
        "%ProgramFiles%\Android\Android Studio\jbr\bin\keytool.exe"
        "%LOCALAPPDATA%\Android\Android Studio\jbr\bin\keytool.exe"
        "%ProgramFiles(x86)%\Android\Android Studio\jbr\bin\keytool.exe"
    ) do (
        if exist %%D (
            set "KEYTOOL=%%~D"
            echo Found keytool in Android Studio: !KEYTOOL!
            goto :found
        )
    )
)

:: 3. Program Files Java installations
if not defined KEYTOOL (
    for /d %%D in ("%ProgramFiles%\Java\jdk*") do (
        if exist "%%D\bin\keytool.exe" (
            set "KEYTOOL=%%D\bin\keytool.exe"
            echo Found keytool in Java installation: !KEYTOOL!
            goto :found
        )
    )
)

:: 4. System PATH
if not defined KEYTOOL (
    where keytool >nul 2>&1
    if !errorlevel! equ 0 (
        set "KEYTOOL=keytool"
        echo Found keytool in PATH.
    )
)

:found
if not defined KEYTOOL (
    echo ERROR: keytool not found.
    echo Install a JDK or set JAVA_HOME.
    exit /b 1
)

:: ===== Generate keystore =====
if exist "%KEYSTORE_PATH%" (
    echo Keystore already exists, skipping.
) else (
    echo Generating keystore...
    "!KEYTOOL!" -genkey -v -keystore "%KEYSTORE_PATH%" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias %KEY_ALIAS% -storepass "!STORE_PASS!" -keypass "!STORE_PASS!" -dname "%DNAME%"
    if !errorlevel! neq 0 (
        echo ERROR: Failed to generate keystore.
        exit /b 1
    )
    echo Keystore created successfully.
)

:: ===== Generate key.properties =====
if exist "%KEY_PROPS_PATH%" (
    echo key.properties already exists, skipping.
) else (
    echo Generating key.properties...
    (
        echo storePassword=!STORE_PASS!
        echo keyPassword=!STORE_PASS!
        echo keyAlias=%KEY_ALIAS%
        echo storeFile=../app/upload-keystore.jks
    ) > "%KEY_PROPS_PATH%"
    echo key.properties created successfully.
)

echo Done.
