@echo off
SET THEFILE=c:\dev-pas\project\antrian.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  C:\Dev-Pas\project\rsrc.o -s   -b base.$$$ -o c:\dev-pas\project\antrian.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
