@echo off
setlocal enabledelayedexpansion
chcp 1250 1> nul

:: �cie�ka do ImageMagick
set MAGICK_PATH="c:\Program Files\ImageMagick-6.8.9-Q16"

:: Utw�rz katalogi
mkdir ugotowane 2> nul
cd ugotowane 2> nul
mkdir BigPicon-transparent-32bit 2> nul
mkdir BigPicon-transparent-8bit 2> nul

echo ===================================
echo \\\ Gotuj� pikony prze�roczyste ///
echo ===================================

:: Przytnij, zmie� rozmiar i konwertuj do PNG
for %%i in (..\do_ugotowania\*.*) do (
	echo Gotuj� "%%~ni"...
	:: Dodaj prze�roczyst� ramk� na wypadek gdyby logo by�o by�o prostokatne i wype�ni�o ca�� powierzchni� robocz�...
	%MAGICK_PATH%\convert "%%i" -bordercolor none -compose Copy -border 10 "BigPicon-transparent-32bit\%%~ni.png"
	:: ...a teraz przytnij i zmie� rozmiar
	%MAGICK_PATH%\convert -background none "BigPicon-transparent-32bit\%%~ni.png" -trim +repage -resize 220x132^> -gravity center -extent 220x132 "BigPicon-transparent-32bit\%%~ni.png"
)
:: Wersja 8bit + optymalizacja pngquant
copy /Y BigPicon-transparent-32bit BigPicon-transparent-8bit 1> nul
for %%i in (BigPicon-transparent-8bit\*.png) do ("..\tools\pngquant2.exe" --force --ext .png 256 "%%i")

:: Ok, teraz wersja z t�em
:: Najpierw z cieniem...
for %%j in (..\tlo_dodaj_cien\*.png) do (
	echo.
	echo ========================================
	echo \\\ Gotuj� pikony z t�em "%%~nj.png" ///
	echo ========================================
	:: Utw�rz katalogi
	mkdir "BigPicon-%%~nj-32bit" 2> nul
	mkdir "BigPicon-%%~nj-8bit" 2> nul
	:: Skopiuj pikony utworzone wcze�niej do katralogu roboczego
	copy /Y BigPicon-transparent-32bit "BigPicon-%%~nj-32bit" 1> nul

	:: Zmniejsz logo, dodaj cie� i pod�� t�o
	for %%i in (BigPicon-transparent-32bit\*.*) do (
		echo Gotuj� "%%~ni" na tle "%%~nj.png"...
		%MAGICK_PATH%\convert "%%i" -resize 178x107 ^( +clone -background black -shadow 85x3+3+3 ^) +swap -background none -flatten "BigPicon-%%~nj-32bit\%%~ni.png"
		%MAGICK_PATH%\composite -gravity center "BigPicon-%%~nj-32bit\%%~ni.png" "..\tlo_dodaj_cien\%%~nj.png" "BigPicon-%%~nj-32bit\%%~ni.png"
	)
	:: Wersja 8bit + optymalizacja pngquant
	copy /Y BigPicon-%%~nj-32bit BigPicon-%%~nj-8bit 1> nul
	for %%i in (BigPicon-%%~nj-8bit\*.png) do ("..\tools\pngquant2.exe" --force --ext .png 256 "%%i")
)

:: i bez cienia...
for %%j in (..\tlo_bez_cienia\*.png) do (
	echo.
	echo ========================================
	echo \\\ Gotuj� pikony z t�em "%%~nj.png" ///
	echo ========================================
	:: Utw�rz katalogi
	mkdir "BigPicon-%%~nj-32bit" 2> nul
	mkdir "BigPicon-%%~nj-8bit" 2> nul
	:: Skopiuj pikony utworzone wcze�niej do katralogu roboczego
	copy /Y BigPicon-transparent-32bit "BigPicon-%%~nj-32bit" 1> nul

	:: Zmniejsz logo i pod�� t�o
	for %%i in (BigPicon-transparent-32bit\*.*) do (
		echo Gotuj� "%%~ni" na tle "%%~nj.png"...
		%MAGICK_PATH%\convert "%%i" -resize 190x114 -background none -flatten "BigPicon-%%~nj-32bit\%%~ni.png"
		%MAGICK_PATH%\composite -gravity center "BigPicon-%%~nj-32bit\%%~ni.png" "..\tlo_bez_cienia\%%~nj.png" "BigPicon-%%~nj-32bit\%%~ni.png"
	)
	:: Wersja 8bit + optymalizacja pngquant
	copy /Y BigPicon-%%~nj-32bit BigPicon-%%~nj-8bit 1> nul
	for %%i in (BigPicon-%%~nj-8bit\*.png) do ("..\tools\pngquant2.exe" --force --ext .png 256 "%%i")
)

:: Wr�c do katalogu ze skryptem
cd .. 2> nul

echo.
echo ========================
echo \\\ Pikony ugotowane ///
echo ========================

:: Zatrzymaj konsol�
pause