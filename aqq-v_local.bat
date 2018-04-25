@ECHO off
REM This script has been created by Zarco Zwier, Aug 6th, 2017
REM This script can freely be re-used and distributed as long as this comment remains.
REM WARNING: THIS SCRIPT MESSES WITH YOUR SUBSTED OR NETWORK MAPPED DRIVES!
REM USE AT YOUR OWN RISK AND ONLY FOR BENIGN PURPOSES!

IF "%1"=="" goto Empty
ECHO:
ECHO ***************************************************************************
ECHO * WARNING: THIS SCRIPT MESSES WITH YOUR SUBSTED OR NETWORK MAPPED DRIVES! *
ECHO * USE AT YOUR OWN RISK AND ONLY FOR BENIGN PURPOSES!                      *
ECHO ***************************************************************************
ECHO:
CHOICE /M "Continue?"
IF ERRORLEVEL 2 GOTO Die


IF "%1"=="subst" (
  SET "EnableDrive=SUBST %%A: C:\"
  SET "DisableDrive=SUBST %%A: /D"
  GOTO Continue1
)

IF "%1"=="netuse" (
  SET "EnableDrive=NET USE %%A: \\localhost\C$"
  SET "DisableDrive=NET USE %%A: /DELETE"
  GOTO Continue1
)


GOTO Empty

:Continue1
FOR %%A IN (C D E F G H I J K L M N O P) DO (
  IF "%2"=="enable"  IF NOT EXIST %%A:\ %EnableDrive%>NUL 2>NUL
  IF "%2"=="disable" %DisableDrive%>NUL 2>NUL
)

SET force=
IF "%2"=="unhideq" (
  ECHO Removing NoDrives from registry, unhiding Q:
  ECHO:
  REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDrives /f 2>NUL
)

IF "%2"=="enable" (

  IF "%4"=="force" SET force=/f
  IF "%3"=="hideq" (
    ECHO Adding NoDrives to registry for hiding Q:
	REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDrives /t REG_DWORD /d 65536 %force%
	RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
  )
  
  ECHO:
  ECHO Drive through P: have been mapped using SUBST command
  ECHO:
  ECHO Now enter a removable drive or map a network drive using: NET USE \\SERVER\SHARE
  CHOICE /M "Remove SUBSTed drives through P: right now?"
  IF ERRORLEVEL 2 GOTO Die
  GOTO Disable
)

GOTO Die

:Empty
  ECHO:
  ECHO Use: %~n0%~x0 subst^|netuse enable [hideq [force]]
  ECHO Or:  %~n0%~x0 disable
  ECHO Or:  %~n0%~x0 unhideq
  ECHO - Subst/netuse:   Define whether to use SUBST OR NET USE .
  ECHO - Enable/disable: Hides Q: drive, user needs to logon again.
  ECHO - hideq:          Hides Q: drive, user needs to logon again.
  ECHO - unhideq:        Unhides Q: drive, user needs to logon again.
  ECHO - force:          Forces overwriting registry value.
  ECHO:
  PAUSE
  GOTO Die 

:Disable
  CALL %0 %1 disable  

:Die
