@ECHO OFF
CLS
COLOR 0a

REM ���ݱ�BAT�ļ�·��ȷ��gvim��ִ���ļ�·��
SET WORKING_DIR=%~dp0
SET GVIM_EXE_PATH=%WORKING_DIR%vim73\gvim.exe

ECHO.��Ϊ��:
ECHO        1.��װ�Ҽ��˵�
ECHO        2.�Ƴ��Ҽ��˵�
ECHO        3.�������Ϸ�һ����ݷ�ʽ
ECHO        4.����Ϊָ��Ŀ¼�еĴ�������HTML����
ECHO        5.������ӡָ��Ŀ¼�еĴ���
ECHO.
SET Choice=

:MAKECHOICE
SET /P Choice=����������ѡ��
IF '%Choice%'=='' GOTO MAKECHOICE

IF /I '%Choice%'=='1' GOTO INSTALL
IF /I '%Choice%'=='2' GOTO UNINSTALL
IF /I '%Choice%'=='3' GOTO SHORTCUT
IF /I '%Choice%'=='4' GOTO CONVERTHTML 
IF /I '%Choice%'=='5' GOTO BATCHPRINT
GOTO END

:INSTALL
reg add "HKCR\*\shell\ʹ��gVim��\command" /f /ve /d "\"%GVIM_EXE_PATH%\" \"%%1\""
GOTO END

:SHORTCUT
SET SHORTCUT_PATH="%USERPROFILE%\Desktop\gVim.url"
ECHO [InternetShortcut] >> %SHORTCUT_PATH%
ECHO URL="%GVIM_EXE_PATH%" >> %SHORTCUT_PATH%
ECHO IconIndex=0 >> %SHORTCUT_PATH%
ECHO IconFile="%GVIM_EXE_PATH%" >> %SHORTCUT_PATH%
GOTO END

:UNINSTALL
reg delete "HKCR\*\shell\ʹ��gVim��" /f
GOTO END

:CONVERTHTML
REM Ϊ���봴��HTML�汾
SET DELETE_ORIGINAL_FILE=false
SET CONVERTED_FILE_PREFIX=gvim_convert_

CLS
ECHO ************************************************************************
ECHO **	Ϊ���Ϲ���%FILE_PATTERN%���ļ�����html�ļ�����
ECHO **	�㻹����ͨ���޸�_vimrc_tohtml�ļ����ı�html�ļ���ʽ
ECHO ************************************************************************

:CONVERTHTML_ENTER_CONTENT_ROOT
REM ����·��
SET CONVERT_ROOT=
SET /P CONVERT_ROOT=������Ҫת����Ŀ¼·��:
IF '%CONVERT_ROOT%'=='' GOTO CONVERTHTML_ENTER_CONTENT_ROOT

:CONVERTHTML_ENTER_MATCH_PATTERN
REM ƥ�����
SET MATCH_PATTERN=
SET /P MATCH_PATTERN=�������ļ���ƥ�������*.php����������ÿո����:
IF '%MATCH_PATTERN%'=='' GOTO CONVERTHTML_ENTER_MATCH_PATTERN

FOR /R %CONVERT_ROOT% %%i in (%MATCH_PATTERN%) do (
	if EXIST %%~di%%~pi%CONVERTED_FILE_PREFIX%%%~ni.html. ( 
		ECHO ����%%~ni%%~xi
	) ELSE (
    	ECHO ����ת��%%~ni%%~xi
    	%GVIM_EXE_PATH% %%i -u %WORKING_DIR%/_vimrc_tohtml -c ":TOhtml" -c ":wq! %CONVERTED_FILE_PREFIX%%%~ni.html" -c ":q!" 
		IF '%DELETE_ORIGINAL_FILE%' == 'true' DEL /F /Q %%i
	)
)
GOTO END

:BATCHPRINT
REM ��ӡ����
REM ƥ����ļ�����,��ͬ����չ���ÿո����
SET FILE_PATTERN=*.php

CLS
ECHO ************************************************************************
ECHO **	��ӡ���Ϲ���%FILE_PATTERN%���ļ�
ECHO **	�㻹����ͨ���޸�_vimrc_print�ļ����ı��ӡ�������ʽ
ECHO ************************************************************************

:BATCHPRINT_ENTER_CONTENT_ROOT
SET CONVERT_ROOT=
SET /P CONVERT_ROOT=������Ҫ��ӡ��Ŀ¼·��:
IF '%CONVERT_ROOT%'=='' GOTO BATCHPRINT_ENTER_CONTENT_ROOT

:BATCHPRINT_ENTER_MATCH_PATTERN
REM ƥ�����
SET MATCH_PATTERN=
SET /P MATCH_PATTERN=�������ļ���ƥ�������*.php����������ÿո����:
IF '%MATCH_PATTERN%'=='' GOTO BATCHPRINT_ENTER_MATCH_PATTERN

FOR /R %CONVERT_ROOT% %%i in (%MATCH_PATTERN%) do (
	ECHO ���ڴ�ӡ%%~ni%%~xi
	%GVIM_EXE_PATH% %%i -u %WORKING_DIR%/_vimrc_print -c ":hardcopy!" -c ":q!"
)
GOTO END

:END
ECHO.
ECHO ��ѡ���������
PAUSE
