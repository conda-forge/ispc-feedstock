@echo on
setlocal enabledelayedexpansion

set PATH=%SRC_DIR%\build\bin;%LIBRARY_BIN%;%PATH%
if %ERRORLEVEL% neq 0 exit /b 1

set EXTRA_CMAKE_ARGS=
if %ERRORLEVEL% neq 0 exit /b 1
if "%target_platform%"=="win-64" (
    set "EXTRA_CMAKE_ARGS=-DX86_ENABLED=ON -DARM_ENABLED=OFF"
) else if "%target_platform%"=="win-arm64" (
    set "EXTRA_CMAKE_ARGS=-DARM_ENABLED=ON -DX86_ENABLED=OFF"
)
if %ERRORLEVEL% neq 0 exit /b 1

cmake -S . -B build -G "NMake Makefiles JOM" ^
    %CMAKE_ARGS% ^
    -DFILE_CHECK_EXECUTABLE=%PREFIX%/libexec/llvm/FileCheck ^
    -DISPC_NO_DUMPS=ON ^
    -DISPC_SLIM_BINARY=ON ^
    -DISPC_LIBRARY=OFF ^
    -DISPC_LIBRARY_JIT=OFF ^
    -DISPC_INCLUDE_TESTS=ON ^
    -DISPC_INCLUDE_EXAMPLES=OFF ^
    -DISPC_INCLUDE_RT=OFF ^
    -DISPC_INCLUDE_BENCHMARKS=OFF ^
    -DCMAKE_EXE_LINKER_FLAGS="%LIBRARY_LIB%\zstd.lib %LIBRARY_LIB%\zlib.lib" ^
    %EXTRA_CMAKE_ARGS%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --build build --parallel %CPU_COUNT%

echo === DLL dependency check ===
dumpbin /dependents %SRC_DIR%\build\bin\ispc.exe
echo === End check ===

echo === Testing ispc.exe ===
%SRC_DIR%\build\bin\ispc.exe --version
echo Exit code: %ERRORLEVEL%
echo === End ===

cmake --install build
if %ERRORLEVEL% neq 0 exit /b 1
