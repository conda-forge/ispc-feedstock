#!/bin/bash
set -exo pipefail

if [[ "${target_platform}" == *"-64" ]]; then
  extra_cmake_args="-DX86_ENABLED=ON"
elif [[ "${target_platform}" == *"-aarch64" || "${target_platform}" == *"-arm64" ]]; then
  extra_cmake_args="-DARM_ENABLED=ON"
elif [[ "${target_platform}" == *"-ppc64le" ]]; then
  extra_cmake_args="-DPPC64_ENABLED=ON"
fi

cmake -S . -B build \
  ${CMAKE_ARGS} \
  -DFILE_CHECK_EXECUTABLE=${PREFIX}/libexec/llvm/FileCheck \
  -DARM_ENABLED=OFF \
  -DISPC_NO_DUMPS=ON \
  -DISPC_SLIM_BINARY=ON \
  -DISPC_LIBRARY=OFF \
  -DISPC_LIBRARY_JIT=OFF \
  -DISPC_INCLUDE_TESTS=ON \
  -DISPC_INCLUDE_EXAMPLES=OFF \
  -DISPC_INCLUDE_RT=OFF \
  -DISPC_INCLUDE_BENCHMARKS=OFF \
  ${extra_cmake_args}
cmake --build build --parallel ${CPU_COUNT}
cmake --install build

