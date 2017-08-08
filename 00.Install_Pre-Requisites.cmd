@echo off
TITLE CAAP Installation script for Teamcenter
Mode 120,30
Color 5A

REM #===============================================================================
REM # Copyright 2017.
REM # CAAP, All Rights Reserved.
REM #===============================================================================
REM #
REM # Description : This script installs the Data Model for Teamcenter Quick Start.
REM # _____________________________________________________________________________
REM #
REM # Check and change the variables below.]
SET INSTALLDRIVE=C:
SET SOFTWARELOCATION=E:
SET dvddrive=D:
SET OSUSERNAME=%COMPUTERNAME%\\Administrator
SET OSPASSWORD=Admin
SET SQLADMINUSER=Administrator
SET SQLADMINPASSWORD=Welkom123
SET SAPASSWORD=Infodb@123
SET LICENSERVER=%COMPUTERNAME%
REM #===============================================================================
REM # DON'T CHANGE THE VARIABLES BELOW!!
REM #===============================================================================


REM #===============================================================================
Echo Unattended installation of all prerequisites for Teamcenter (1 / 4)
REM #===============================================================================
Echo:
Echo - Creating folderstructure
Echo - Installing Java software
Echo - Internet Information Services
Echo - Installing Microsoft SQL Server instance
Echo - Setting system environment variables for Java and license server
Echo:
Echo Are NOT configuring or installing
Echo - Installation of Teamcenter Corporate Server and 4-tier RAC
Echo - For demo or test environment, the servername and other Windows settings
Echo - Network Adapter settings (for finding the license server)
Echo - Firewall settings
Echo - User Account Controle settings
Echo:

Set /p continue=Should we continue with the installation? [ y / n ]?:
IF "%continue%"=="n" (
Echo Close this script
Goto Exit
)

cls
REM #===============================================================================
Echo Unattended installation of all prerequisites for Teamcenter (2 / 4)
REM #===============================================================================
Echo:
Echo The following software are required and expected on these location.
Echo If the location atre not correct, please change these location in this script.
Echo:
Echo - Microsoft Windows Server 2012 (R2) source dvd in drive %DVDDRIVE%
Echo - Microsoft SQL Server 2012 Express Edition - %SOFTWARELOCATION%\SQLEXPRWT_x64_ENU.exe
Echo - Java Development Kit 1.7 - %SOFTWARELOCATION%\jdk-7u79-windows-x64.exe
Echo - Java Runtime Environment 1.7 - %SOFTWARELOCATION%\jre-7u79-windows-x64.exe
Echo:
Echo The Teamcenter installation settings are:
Echo:
Echo - OS Username: %OSUSERNAME%
Echo - OS user password: %OSPASSWORD%
Echo - SQL admin user: %SQLADMINUSER%
Echo - SQL admin password: %SQLADMINPASSWORD%
Echo - SQL sa password: %SAPASSWORD%
Echo - License server: %LICENSERVER%
Echo:

set /p checked=Did you check these local variables in this batch file? [ y / n ]?:
IF "%checked%"=="n" (
Echo Please check the local variables in this file first.
goto Exit
)


cls
REM #===============================================================================
Echo Unattended installation of all prerequisites for Teamcenter (3 / 4)
REM #===============================================================================
Echo:
Echo This script will NOT install Microsoft SQL Server in a production
Echo environment. Please install the SQL Server after running this script. If this
Echo environment is for testing, SQL Server 2012 Express Edition will be
Echo installed. If you want to use a full version of SQL Server for testing,
Echo please choose Production, so no SQL Server will be installed.
Echo:

Echo:
set /p PRODUCTION=Is this a production server? [ y / n ]?:


cls
REM #===============================================================================
Echo Unattended installation of all prerequisites for Teamcenter (4 / 4)
REM #===============================================================================
set /p checked3=Did you check the servername, firewall, ip-address and UAC? [ y / n ]?:
IF "%checked3%"=="n" (
	Echo Please check these first.
	goto Exit
)
cls
REM #===============================================================================
Echo Unattended installation of all prerequisites for Teamcenter
REM #===============================================================================
Echo:
Echo Checking for the Windows server installation dvd in drive %dvddrive%
IF NOT EXIST %dvddrive%\sources\sxs goto NoSxsFolder

REM #===============================================================================
Echo Creating the folderstructure on drive %INSTALLDRIVE%
REM #===============================================================================
IF NOT EXIST %INSTALLDRIVE%\Teamcenter MD %INSTALLDRIVE%\Teamcenter
IF NOT EXIST %INSTALLDRIVE%\Teamcenter\SQLData MD %INSTALLDRIVE%\Teamcenter\SQLData
IF NOT EXIST %INSTALLDRIVE%\Teamcenter\Backup MD %INSTALLDRIVE%\Teamcenter\Backup
IF NOT EXIST %INSTALLDRIVE%\Teamcenter\AdministrationData MD %INSTALLDRIVE%\Teamcenter\AdministrationData
REM #===============================================================================
Echo Finished creating the folderstructure
Echo:
REM #===============================================================================


REM #===============================================================================
Echo Installing the JAVA software
REM #===============================================================================
IF NOT EXIST %SOFTWARELOCATION%\jre-7u79-windows-x64.exe GOTO NoJRE
IF NOT EXIST %SOFTWARELOCATION%\jdk-7u79-windows-x64.exe GOTO NoJDK

Echo Installing Java Runtimne Environment software
%SOFTWARELOCATION%\jre-7u79-windows-x64.exe /s

Echo Checking for installed Java Runtime Environment software
if Exist "C:\Program Files\Java\jre7\bin\java.exe" (
  echo Java Runtimne Environment correctly installed
) else ( 
  echo Java Runtimne Environment not correctly installed. Now exit the script.
  pause
  exit /b 1
)

Echo Setting the JRE64_HOME system environment variable
SETX JRE64_HOME "C:\Program Files\Java\jre7" /M
SET JRE64_HOME=C:\Program Files\Java\jre7
SETX JRE_HOME "C:\Program Files\Java\jre7" /M
SET JRE_HOME=C:\Program Files\Java\jre7

Echo Installing Java Development Kit software
%SOFTWARELOCATION%\jdk-7u79-windows-x64.exe /quiet

Echo Checking for installed Java Development Kit software
if Exist "C:\Program Files\Java\jdk1.7.0_79\bin\java.exe" (
  echo Java Development Kit correctly installed
) else ( 
  echo Java Development Kit not correctly installed. Now exit the script.
  pause
  exit /b 1
)

Echo Setting the JAVA_HOME system environment variable
SETX JAVA_HOME "C:\Program Files\Java\jdk1.7.0_79" /M 
REM #===============================================================================
Echo Finished installing Java software
Echo:
REM #===============================================================================

REM #===============================================================================
Echo Setting the license system variables
REM #===============================================================================
Echo Setting the environment variable for the license server
SETX UGS_LICENSE_SERVER "28000@192.168.200.1" /M
SET UGS_LICENSE_SERVER=28000@192.168.200.1
SETX TCVIS_LICENSE_FILE "28000@192.168.200.1" /M
SET TCVIS_LICENSE_FILE=28000@192.168.200.1
SETX SPLM_LICFENSE_SERVER "28000@192.168.200.1" /M
SET SPLM_LICFENSE_SERVER=28000@192.168.200.1
REM #===============================================================================
Echo Finished setting the license system variables
Echo:
REM #===============================================================================

REM Disabling the firewall for all profiles
REM NetSh Advfirewall set allprofiles state off

REM #===============================================================================
Echo Installation of Internet Information Services (IIS)
REM #===============================================================================
Echo Checking for the correct version of the Deployment Image Servicing and Management (DISM.exe)
if EXIST %WINDIR%\system32\dism.exe ( 
  set DISM=%WINDIR%\system32\dism.exe 
) 
if EXIST %WINDIR%\SysNative\dism.exe ( 
  set DISM=%WINDIR%\SysNative\dism.exe 
) 

Echo Installation of .NET Framework 3.5
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\sources\sxs
Echo Installation of Internet Information Services (IIS)
Echo   Add IIS Webserver Role
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-WebServerRole
Echo   Add IIS Common HTTP features
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-DefaultDocument /FeatureName:IIS-DirectoryBrowsing /FeatureName:IIS-HttpErrors /FeatureName:IIS-StaticContent /FeatureName:IIS-HttpRedirect
Echo   Add IIS Health and diagnostics features
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-HttpLogging /FeatureName:IIS-LoggingLibraries /FeatureName:IIS-RequestMonitor /FeatureName:IIS-HttpTracing
Echo   Add IIS Performance features
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-HttpCompressionDynamic /FeatureName:IIS-HttpCompressionStatic
Echo   Add IIS Security features
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-RequestFiltering /FeatureName:IIS-BasicAuthentication /FeatureName:IIS-ClientCertificateMappingAuthentication /FeatureName:IIS-DigestAuthentication /FeatureName:IIS-IISCertificateMappingAuthentication /FeatureName:IIS-IPSecurity /FeatureName:IIS-URLAuthorization /FeatureName:IIS-WindowsAuthentication
Echo   Add IIS Application Development features
START /WAIT %DISM% /Online /Enable-Feature /All /FeatureName:IIS-ApplicationDevelopment /FeatureName:IIS-ASPNET /FeatureName:IIS-ASPNET45 /FeatureName:IIS-ASP /FeatureName:IIS-NetFxExtensibility /FeatureName:IIS-NetFxExtensibility45 /FeatureName:IIS-CGI /FeatureName:IIS-ISAPIExtensions /FeatureName:IIS-ISAPIFilter /FeatureName:IIS-ServerSideIncludes 
Echo   Add IIS Management Tools features
START /WAIT %DISM%  /Online /Enable-Feature /FeatureName:IIS-ManagementConsole /FeatureName:IIS-IIS6ManagementCompatibility /FeatureName:IIS-LegacyScripts /FeatureName:IIS-LegacySnapIn /FeatureName:IIS-WMICompatibility
REM #===============================================================================
Echo Finished installing Internet Information Services (IIS)
Echo:
REM #===============================================================================


IF "%PRODUCTION%"=="n" (
	REM #===============================================================================
	Echo Installation of SQL Server Express and SQL Server Management Studio
	REM #===============================================================================
	Echo Checking for Microsoft SQL Server software
	IF NOT EXIST %SOFTWARELOCATION%\SQLEXPRWT_x64_ENU.exe goto NoSQLSoftware
	Echo Installation of SQL Server Express and SQL Server Management Studio
	%SOFTWARELOCATION%\SQLEXPRWT_x64_ENU.exe /ACTION=INSTALL /QS /IACCEPTSQLSERVERLICENSETERMS /FEATURES=SQLENGINE,SSMS /INSTANCENAME=TEAMCENTER /BROWSERSVCSTARTUPTYPE=Automatic /SAPWD=%SAPASSWORD% /SQLBACKUPDIR=%INSTALLDRIVE%\Teamcenter\Backup /SECURITYMODE=SQL /SQLSVCSTARTUPTYPE=Automatic /SQLSVCACCOUNT="NT AUTHORITY\NetworkService" /SQLTEMPDBDIR=%INSTALLDRIVE%\Teamcenter\SQLData /SQLTEMPDBLOGDIR=%INSTALLDRIVE%\Teamcenter\SQLData /SQLUSERDBDIR=%INSTALLDRIVE%\Teamcenter\SQLData /SQLUSERDBLOGDIR=%INSTALLDRIVE%\Teamcenter\SQLData /TCPENABLED=1
	REM We can add also the /INSTALLSQLDATADIR option, to specify the location of the root directory, sql data
	REM #===============================================================================
	Echo Finished installing SQL Server Express and SQL Server Management Studio
	Echo:
	REM #===============================================================================
)

PAUSE
cls
Echo:
Echo:
Echo Teamcenter 11.2 pre-requisites installed:
Echo   - Folder structure
Echo   - Internet Information Services
Echo   - Java Runtime Environment
Echo   - Jave Development Kit
IF "%PRODUCTION%"=="n" (
Echo   - Microsoft SQL Server Express Edition
)
Echo:
Echo Please check the installation before installing Teamcenter
PAUSE

GoTo Exit

:NoSxsFolder
Echo No sxs folder found on drive %dvddrive%
Echo Exit this batch file...
goto Exit

:NoJRE
Echo No Java Runtime Environment software found on drive %SOFTWARELOCATION%
Echo Looking for %SOFTWARELOCATION%\jre-7u79-windows-x64.exe
Echo Exit this batch file...
GoTo Exit

:NoJDK
Echo No Java Development Kit software found on drive %SOFTWARELOCATION%
Echo Looking for %SOFTWARELOCATION%\jdk-7u79-windows-x64.exe
Echo Exit this batch file...
GoTo Exit

:NoSQLSoftware
echo Cannot find the SQL Server software on drive %SOFTWARELOCATION%
Echo Looking for %SOFTWARELOCATION%\SQLEXPRWT_x64_ENU.exe
Echo Exit this batch file...
Goto Exit

:NoPrepareSoftware
Echo Cannot find the prepare config file software on drive %softwarelocation%\Scripts
Echo Looking for %softwarelocation%\Scripts\prepareInstallConfigFile.exe 
Echo Exit this batch file...
Goto Exit

:NoTEM
Echo Cannot find the tem on drive %TEMLOCATION%
Echo Looking for %TEMLOCATION%\tem.bat
Echo Exit this batch file...
Goto Exit

:Exit
pause
