@echo on
setlocal enabledelayedexpansion

set PATH=%SRC_DIR%\build\bin;%PATH%
if %ERRORLEVEL% neq 0 exit /b 1

set EXTRA_CMAKE_ARGS=
if %ERRORLEVEL% neq 0 exit /b 1

if "%target_platform%"=="win-64" (
    set "EXTRA_CMAKE_ARGS=-DX86_ENABLED=ON"
) else if "%target_platform%"=="win-arm64" (
    set "EXTRA_CMAKE_ARGS=-DARM_ENABLED=ON"
)
if %ERRORLEVEL% neq 0 exit /b 1

cmake -S . -B build -G "NMake Makefiles JOM" ^
    %CMAKE_ARGS% ^
    -DCMAKE_BUILD_RPATH="%PREFIX%\lib" ^
    -DCMAKE_INSTALL_RPATH="%PREFIX%\lib" ^
    -DFILE_CHECK_EXECUTABLE=%LIBRARY_BIN%\FileCheck.exe ^
    -DISPC_NO_DUMPS=ON ^
    -DISPC_SLIM_BINARY=ON ^
    -DISPC_INCLUDE_TESTS=ON ^
    -DISPC_INCLUDE_EXAMPLES=OFF ^
    -DISPC_INCLUDE_RT=OFF ^
    -DISPC_INCLUDE_BENCHMARKS=OFF ^
    -DCMAKE_EXE_LINKER_FLAGS="%LIBRARY_LIB%\zstd_static.lib %LIBRARY_LIB%\zlibstatic.lib" ^
    %EXTRA_CMAKE_ARGS%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --build build --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --install build
if %ERRORLEVEL% neq 0 exit /b 1
