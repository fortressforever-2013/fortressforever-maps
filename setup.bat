@echo off
setlocal enabledelayedexpansion
FOR /f "tokens=1,2*" %%E in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam"') DO (
	IF "%%E"=="SteamPath" (
		set SteamPath=%%G
	)
)
IF "%SteamPath%"=="" (
	echo Not able to determine Steam install path. Make sure you have Steam installed
	pause
	exit /B
)

for /F "usebackq tokens=*" %%L in ("%SteamPath%\steamapps\libraryfolders.vdf") do (
    for /F "tokens=1*" %%A in ("%%L") do (
        if "%%B" NEQ "" (
            if "%%~A" EQU "path" (
                set "CurPath=%%~B"
                set "CurPath=!CurPath:\\=\!"
            )
            :: 253530 is the FF appid
            if "%%~A" EQU "253530" (
                set "GameDir=!CurPath!/steamapps/common/Fortress Forever/sdk2013"
            )
        )
    )
)

IF "%GameDir%"=="" (
	echo "%SteamPath%\steamapps\libraryfolders.vdf" does not contain FF's appid. Make sure Fortress Forever is installed
	pause
	exit /B
)

set ModDir=%GameDir%/fortressforever

IF NOT EXIST "%GameDir%" (
	echo "%GameDir%" does not exist. Make sure Fortress Forever is installed
	pause
	exit /B
)

IF NOT EXIST "%ModDir%" (
	echo "%ModDir%" does not exist. Make sure Fortress Forever is installed properly
	pause
	exit /B
)

set BinDir=%GameDir%\bin\
set ConfigFile=%BinDir%\GameConfig.txt
set SchemeDir=%BinDir%\resource
set SchemeFile=%SchemeDir%\SourceScheme.res
set GameInfoFile=%ModDir%/gameinfo.txt

IF NOT EXIST "%GameInfoFile%" (
	echo "%GameInfoFile%" does not exist. Make sure Fortress Forever is installed properly
	pause
	exit /B
)

echo(
echo Writing "%ConfigFile%"...
(
echo "Configs"
echo {
echo 	"SDKVersion"		"5"
echo 	"Games"
echo 	{
echo 		"Fortress Forever"
echo 		{
echo 			"GameDir"		"%ModDir%"
echo 			"hammer"
echo 			{
echo 				"GameData0"		"%ModDir%/fortressforever.fgd"
echo 				"TextureFormat"		"5"
echo 				"MapFormat"		"4"
echo 				"DefaultTextureScale"		"0.250000"
echo 				"DefaultLightmapScale"		"16"
echo 				"GameExe"		"%GameDir%/hl2.exe"
echo 				"DefaultSolidEntity"		"func_detail"
echo 				"DefaultPointEntity"		"info_ff_script"
echo 				"BSP"		"%BinDir%\vbsp.exe"
echo 				"Vis"		"%BinDir%\vvis.exe"
echo 				"Light"		"%BinDir%\vrad.exe"
echo 				"GameExeDir"		"%GameDir%"
echo 				"MapDir"		"%ModDir%/mapsrc"
echo 				"BSPDir"		"%ModDir%/maps"
echo 				"CordonTexture"		"tools\toolsskybox"
echo 				"MaterialExcludeCount"		"0"
echo 			}
echo 		}
echo 	}
echo }
) >"%ConfigFile%"
echo  -^> Done

echo(
echo Fortress Forever Hammer setup completed successfully.
echo(

pause
