@echo off
set lang=EN
set PATH=%dosdir%\bin
set NLSPATH=%dosdir%\NLS
set HELPPATH=%dosdir%\HELP
set temp=%dosdir%\temp
set tmp=%dosdir%\temp
SET BLASTER=A220 I5 D1 H5 P330
set DIRCMD=/P /OGN
if "%config%"=="4" goto end
lh doslfn
SHSUCDX /QQ /D3
IF EXIST BOOT\FD11SRC.ISO LH SHSUCDHD /Q /F:BOOT\FD11SRC.ISO
LH FDAPM APMDOS
if "%config%"=="2" LH SHARE
REM LH DISPLAY CON=(EGA,,1)
REM NLSFUNC C:\FDOS\BIN\COUNTRY.SYS
REM MODE CON CP PREP=((858) A:\cpi\EGA.CPX)
REM MODE CON CP SEL=858
REM CHCP 858
REM LH KEYB US,,C:\FDOS\bin\KEY\US.KL
CTMOUSE
DEVLOAD /H /Q %dosdir%\bin\uide.sys /D:FDCD0001 /S5
ShsuCDX /QQ /~ /D:?SHSU-CDH /D:?FDCD0001 /D:?FDCD0002 /D:?FDCD0003
mem /c /n
shsucdx /D
goto end
:end
SET AUTOFILE=C:\autoexec.bat
SET CFGFILE=C:\fdconfig.sys
alias reboot=fdapm warmboot
alias halt=fdapm poweroff
echo type HELP to get support on commands and navigation
echo.
echo Welcome to FreeDOS 1.1
echo.
