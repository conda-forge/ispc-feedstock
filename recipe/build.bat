@echo on
setlocal enabledelayedexpansion

set PATH=%SRC_DIR%\build\bin;%SRC_DIR%\build\Release\bin;%BUILD_PREFIX%\Library\bin;%BUILD_PREFIX%\bin;%PREFIX%\Library\bin;%PREFIX%\bin;%PATH%
if %ERRORLEVEL% neq 0 exit /b 1

set EXTRA_CMAKE_ARGS=
if %ERRORLEVEL% neq 0 exit /b 1
if "%target_platform%"=="win-64" (
    set "EXTRA_CMAKE_ARGS=-DX86_ENABLED=ON"
) else if "%target_platform%"=="win-arm64" (
    set "EXTRA_CMAKE_ARGS=-DARM_ENABLED=ON"
)
if %ERRORLEVEL% neq 0 exit /b 1

cmake -S . -B build ^
    %CMAKE_ARGS% ^
    -DFILE_CHECK_EXECUTABLE=%LIBRARY_BIN%\FileCheck.exe ^
    -DISPC_NO_DUMPS=ON ^
    -DISPC_SLIM_BINARY=ON ^
    -DISPC_INCLUDE_TESTS=ON ^
    -DISPC_INCLUDE_EXAMPLES=OFF ^
    -DISPC_INCLUDE_RT=OFF ^
    -DISPC_INCLUDE_BENCHMARKS=OFF ^
    -DCMAKE_EXE_LINKER_FLAGS="%LIBRARY_LIB%\zstd.lib %LIBRARY_LIB%\zlib.lib" ^
    %EXTRA_CMAKE_ARGS%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --build build --config Release --parallel 1

echo === PATH check ===
where zstd.dll
where zlib.dll
where VCRUNTIME140.dll
echo === imports check ===
dumpbin /imports %SRC_DIR%\build\bin\Release\ispc.exe
echo === End ===

cmake --install build --config Release
if %ERRORLEVEL% neq 0 exit /b 1
