echo off
cls


set DATABASENAME=shahcorp

:: filename format Name-Date (eg MyDatabase-mm.dd.yyyy.bak)
set DATESTAMP=%DATE:~4,2%.%DATE:~7,2%.%DATE:~-4%
set TIMESTAMP=%time:~0,2%.%time:~3,2%.%time:~6,2%
set BACKUPFILENAME=C:\Backups\DB_Backup\%DATABASENAME%-%DATESTAMP%-%TIMESTAMP%
set SERVERNAME=%COMPUTERNAME%\SQLEXPRESS2012

echo Backup on %DATESTAMP% at %TIMESTAMP%>"C:\Backups\DB_Backup\BackupLog-%DATESTAMP%_%TIMESTAMP%.txt"

sqlcmd -E -S %SERVERNAME% -d master -Q "BACKUP DATABASE [%DATABASENAME%] TO DISK = N'C:\Backups\DB_Backup\LatestBackup.bak' WITH INIT , NOUNLOAD , NAME = N'%DATABASENAME% backup', NOSKIP , NOFORMAT" 1>>"C:\Backups\DB_Backup\BackupLog-%DATESTAMP%_%TIMESTAMP%.txt" 2>&1


IF ERRORLEVEL 1 goto QUITSCRIPT


C:\Backups\7za.exe a "%BACKUPFILENAME%.7z" "C:\Backups\DB_Backup\LatestBackup.bak"


FORFILES /P C:\Backups\DB_Backup\ /S /M *.* /D -14 /C "cmd /c del @file /Q"

exit /b 0

:QUITSCRIPT
popd
REM Here the exit value 1 refers that an error encountered

exit /b 1