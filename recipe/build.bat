@echo on
setlocal enabledelayedexpansion

set PATH=%LIBRARY_BIN%;%PATH%

set EXTRA_CMAKE_ARGS=
if "%target_platform%"=="win-64" (
    set EXTRA_CMAKE_ARGS=-DX86_ENABLED=ON
) else if "%target_platform%"=="win-arm64" (
    set EXTRA_CMAKE_ARGS=-DARM_ENABLED=ON
)

cmake -S . -B build -G "NMake Makefiles JOM" ^
    %CMAKE_ARGS% ^
    -DFILE_CHECK_EXECUTABLE=%PREFIX%/libexec/llvm/FileCheck ^
    -DISPC_NO_DUMPS=ON ^
    -DISPC_SLIM_BINARY=OFF ^
    -DISPC_INCLUDE_TESTS=ON ^
    -DISPC_INCLUDE_EXAMPLES=OFF ^
    -DISPC_INCLUDE_RT=OFF ^
    -DISPC_INCLUDE_BENCHMARKS=OFF ^
    -DCMAKE_EXE_LINKER_FLAGS="%LIBRARY_LIB%\zstd.lib %LIBRARY_LIB%\zlib.lib" ^
    %EXTRA_CMAKE_ARGS%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --build build --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit /b 1

cmake --install build
if %ERRORLEVEL% neq 0 exit /b 1
