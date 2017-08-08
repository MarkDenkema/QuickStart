@Echo off
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
REM # Check and change the variables below.
SET TC_USER_NAME=infodba
SET TC_USER_PASSWD=infodba
SET TC_ROOT=C:\PROGRA~1\Siemens\TEAMCE~1
SET TC_DATA=C:\Teamcenter\tcdata
SET VOLUME_ENG=C:\Teamcenter\Volumes\Volume_eng
REM #===============================================================================
REM # DON'T CHANGE THE VARIABLES BELOW!!
REM #===============================================================================
set CURRENTFOLDER=%~dp0
REM go 1 level and set QSROOT varaiable
for %%I in ("%CURRENTFOLDER%\..") do set "QSROOT=%%~fI
REM #===============================================================================
REM # First a couple of questions for the administrator before the configuration
REM #===============================================================================
Echo:
REM #===============================================================================
Echo Unattended configuration of Teamcenter with Quick Start (1 / 4)
REM #===============================================================================
Echo:
Echo Importing:
Echo - BMIDE project template
Echo - preferences
Echo - organization
Echo - workflows
Echo - acl's
Echo - values for the batch lovs
Echo:
Echo Are NOT configuring or installing
Echo - the client configuration:
Echo   - language pack files
Echo   - icons
Echo:

Set /p continue=Should we continue with the configuration? [ y / n ]?:
IF "%continue%"=="n" (
Echo Close this script
Goto Exit
)

cls
REM #===============================================================================
Echo Unattended configuration of Teamcenter with Quick Start (2 / 4)
REM #===============================================================================
Echo:
Echo The Teamcenter Quick Start configuration settings are:
Echo:
Echo - Teamcenter dba user: %TC_USER_NAME%
Echo - Teamcenter dba password: %TC_USER_PASSWD%
Echo - Teamcenter Root directory: %TC_ROOT%
Echo - Teamcenter Data directory: %TC_DATA%
Echo - Volume for Engineering: %VOLUME_ENG%
Echo:
Echo For your information only:
Echo - Current folder location: %CURRENTFOLDER%
Echo - QS Configuration root: %QSROOT%
Echo - TEM location: %TC_ROOT%\Install\tem.bat
Echo:
set /p checked=Did you check these local variables in this batch file? [ y / n ]?:
IF "%checked%"=="n" (
Echo Please check the local variables in this file first.
goto Exit
)

cls
REM #===============================================================================
Echo Unattended configuration of Teamcenter with Quick Start  (3 / 4)
REM #===============================================================================
Echo:
Echo Batch LOV's configuration
Echo:
set /p checked=Did you fill in the xml's for the batch lov's? [ y / n ]?:
IF "%checked%"=="n" (
Echo Please fill in these xml files.
goto Exit
)


cls
REM #===============================================================================
Echo Unattended configuration of Teamcenter with Quick Start  (4 / 4)
REM #===============================================================================
Echo:
Echo Ready to install the Quick Start configuration?
Echo:
set /p checked=Continue? [ y / n ]?:
IF "%checked%"=="n" (
Echo Please start over...
goto Exit
)

cls
REM #===============================================================================
REM #===============================================================================
Echo Configuration of Teamcenter Quick Start
REM #===============================================================================
REM #===============================================================================
REM # ..............................................................................
REM # SECTION: Utilites
REM # ..............................................................................
REM #    Use this section if your solution needs to install any workflow templates,
REM #    transfer modes, or any other data that must be installed before the BMIDE tools install 
REM #    Business Objects (Items, Datasets, Forms, Item Element, App Interface, IntDataCapture),
REM #    Business Rules, LOVs, Change Objects, Validation Data, Tools.
REM # ..............................................................................
REM #
REM <pre-non-schema-add>

REM #===============================================================================
Echo ===============================================================================
Echo Call the tc_profilevars.bat to create a Teamcenter command prompt
REM #===============================================================================
CALL %TC_DATA%\tc_profilevars
REM #===============================================================================
Echo Finished calling the tc_profilevars.bat
Echo:
REM #===============================================================================

REM TODO: Preferences
REM TODO: preferences_manager -mode=import -scope=SITE -file=%TC_INSTALL_DIR%/tcx/tcx_command_suppression_preferences.xml -action=OVERRIDE -u=infodba -p=%TC_USER_PASSWD% -g=dba
REM TODO: preferences_manager -mode=import -scope=SITE -file=%TC_INSTALL_DIR%/tcx/tcx_preferences_template.xml -action=OVERRIDE -u=infodba -p=%TC_USER_PASSWD% -g=dba


REM REM #===============================================================================
REM Echo ...Import the volumes
REM REM #===============================================================================
REM setlocal enableextensions disabledelayedexpansion
REM set "search=C:\Teamcenter\volume_eng"
REM set "textFile=%QSROOT%\002.Volumes\Volume_eng.xml"

REM for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    REM set "line=%%i"
    REM setlocal enabledelayedexpansion
    REM >>"%textFile%" echo(!line:%search%=%VOLUME_ENG%!
    REM endlocal
REM )
REM "%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\002.Volumes/Volume_eng.xml
REM REM #===============================================================================
REM Echo ...Finished importing the volume(s)
REM Echo:
REM REM #===============================================================================

REM #===============================================================================
Echo ===============================================================================
Echo ...Import BMIDE template
REM #===============================================================================
%TC_ROOT%\Install\tem.bat -install -features=qs4teamcenter -path=%QSROOT%/020.BMIDE/full_update/ -pass=%TC_USER_PASSWD%
REM #===============================================================================
Echo ...Finished importing tenplate
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import preferences
REM #===============================================================================
%TC_ROOT%\Bin\preferences_manager -mode=import  -file=%QSROOT%/090.Preferences/tcqs_preferences.xml -action=OVERRIDE -u=infodba -p=%TC_USER_PASSWD% -g=dba -scope=SITE
%TC_ROOT%\Bin\preferences_manager -mode=import  -file=%QSROOT%/090.Preferences/HidePerspectivesEngineering.xml -action=OVERRIDE -u=infodba -p=%TC_USER_PASSWD% -g=dba -scope=GROUP -target=Engineering
REM #===============================================================================
Echo Finished importing preferences
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import Organisation
REM #===============================================================================

%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\010.Organisation/RoleChangeAdministrator.xml -import_mode=overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/010.Organisation/RoleChecker.xml -import_mode=overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/010.Organisation/RoleManager.xml -import_mode=overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/010.Organisation/RoleViewer.xml -import_mode=overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/010.Organisation/GroupEngineering.xml -import_mode=overwrite
REM #===============================================================================
Echo Finished importing the oganisation
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import queries for the default workflows
REM #===============================================================================
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\060.Queries\__WF_CheckChildrenForNoStatus.txt
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\060.Queries\__WF_CheckChildrenForObsolete.txt
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\060.Queries\__WF_CheckForTargetsForApproved.txt
REM #===============================================================================
Echo Finished importing these queries
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the default Quick Start workflows
REM #===============================================================================
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/01CheckRelease.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/02CheckReleaseAll.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/03QuickRelease.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/04QuickReleaseAll.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/05QuickChange.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/06CheckObsolete.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/07CheckRemoveStatus.xml -transfermode=workflow_template_overwrite
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%/070.WorkflowTemplates/08EngineeringChangeOrder.xml -transfermode=workflow_template_overwrite
REM #===============================================================================
Echo Finished importing the workflows
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the style sheets
REM #===============================================================================
%TC_ROOT%/Bin/install_xml_stylesheet_datasets.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -input=%QSROOT%/080.StyleSheets/import_qs_stylesheets.txt -filepath=%QSROOT%/080.StyleSheets -replace
REM #===============================================================================
Echo Finished importing the style sheets
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the values for the batch lov's
REM #===============================================================================
CALL %TC_ROOT%\bin\bmide_manage_batch_lovs.bat -u=infodba -p=%TC_USER_PASSWD% -g=dba -option=update -file=%QSROOT%\021.LOVBatch\QS4ECOCategory\QS4ECOCategory.xml
CALL %TC_ROOT%\bin\bmide_manage_batch_lovs.bat -u=infodba -p=%TC_USER_PASSWD% -g=dba -option=update -file=%QSROOT%\021.LOVBatch\QS4Priority\QS4Priority.xml
CALL %TC_ROOT%\bin\bmide_manage_batch_lovs.bat -u=infodba -p=%TC_USER_PASSWD% -g=dba -option=update -file=%QSROOT%\021.LOVBatch\QS4Supplier\QS4Supplier.xml
REM #===============================================================================
Echo Finished importing the batch lovs
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the Solid Edge attribute mapping
REM #===============================================================================
%TC_ROOT%\bin\import_attr_mappings -u=infodba -p=%TC_USER_PASSWD% -g=dba -file=%QSROOT%\220.IntegrationSE\AttributeMapping.att
REM #===============================================================================
Echo Finished importing mapping
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the user queries
REM #===============================================================================
%TC_ROOT%\Bin\plmxml_import.exe -u=infodba -p=%TC_USER_PASSWD% -g=dba -xml_file=%QSROOT%\060.Queries\QS General....txt
REM #===============================================================================
Echo Finished importing the queries
Echo:
REM #===============================================================================


REM #===============================================================================
Echo ===============================================================================
Echo Import the command suppression
REM #===============================================================================

REM #===============================================================================
Echo Finished importing command suppression
Echo:
REM #===============================================================================

Goto Exit

:UnableToFindConfigurationFolder
Echo Cannot find the Quick Start configuratio files on location %QSROOT%
Echo Exit this batch file...
Goto Exit

:NoTEM
Echo Cannot find the tem on drive %TEMLOCATION%
Echo Looking for %TEMLOCATION%\tem.bat
Echo Exit this batch file...
Goto Exit

:Exit
REM #===============================================================================
Echo ===============================================================================
Echo Finished configuring Teamcenter Quick Start
Echo ===============================================================================
REM #===============================================================================
pause