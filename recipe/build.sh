#!/bin/bash
set -exo pipefail

if [[ "${target_platform}" == *"-64" ]]; then
  target_arch="X86"
elif [[ "${target_platform}" == *"-aarch64" || "${target_platform}" == *"-arm64" ]]; then
  target_arch="ARM"
elif [[ "${target_platform}" == *"-ppc64le" ]]; then
  target_arch="GENERIC"
fi

cmake -S . -B build \
  ${CMAKE_ARGS} \
  -DFILE_CHECK_EXECUTABLE=${BUILD_PREFIX}/libexec/llvm/FileCheck \
  -DARM_ENABLED=OFF \
  -DISPC_NO_DUMPS=ON \
  -DISPC_SLIM_BINARY=ON \
  -DISPC_INCLUDE_TESTS=ON \
  -DISPC_INCLUDE_EXAMPLES=OFF \
  -DISPC_INCLUDE_RT=OFF \
  -DISPC_TARGETS="${target_arch}"
cmake --build build --parallel ${CPU_COUNT}
cmake --install build

