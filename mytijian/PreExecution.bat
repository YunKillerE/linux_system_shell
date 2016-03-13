@echo off
CD /D %~dp0

for /f "tokens=1 delims= " %%i in (MYTIJIAN_RELOAD.ini) do (
	echo "download upgrade.zip"
	wget.exe %%i
)

echo "begin unzip file....."
md upgrade
cd upgrade
..\WinRAR\WinRAR.exe x ..\upgrade.zip
cd ..

echo "begin cp file....."
md backup
for /f "tokens=1,2 delims= " %%i in (upgrade\mediator-agent\winabc.txt) do (
	rem echo file %%i %%j
	echo "backup %%j........."
	copy /y %%j .\backup
	echo "copy %%i........."
	copy /y .\upgrade\mediator-agent\%%i .\%%j
)
for /f "tokens=1,2 delims= " %%i in (upgrade\control\winabc.txt) do (
	rem echo file %%i %%j
	echo "backup %%j........."
	copy /y %%j .\backup
	echo "copy %%i........."
	copy /y .\upgrade\control\%%i .\%%j
)

echo "delete unused file"
for /f "tokens=1 delims= " %%i in (upgrade\mediator-agent\del_winabc.txt) do (
	rem echo file %%i %%j
	echo "del %%i........."
	del /Q .\%%i
)
for /f "tokens=1 delims= " %%i in (upgrade\control\del_winabc.txt) do (
	rem echo file %%i %%j
	echo "del %%i........."
	del /Q .\%%i
)


rem copy /y upgrade\winabc.txt backup
del /Q .\upgrade\control\*
del /Q .\upgrade\mediator-agent\*
rd .\upgrade\control
rd .\upgrade\mediator-agent
rd .\upgrade

move upgrade.zip backup
pause
