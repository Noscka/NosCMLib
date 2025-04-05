cmake_minimum_required (VERSION 3.12)

include("${CMAKE_CURRENT_LIST_DIR}/CMake/Versioning.cmake")

Get_Git_Version()
Get_Git_Branch()

project ("NosCMLib" VERSION ${GIT_VERSION} LANGUAGES CXX)

configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake/NosCMLibConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/NosCMLibConfig.cmake"
  @ONLY
)

install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/NosCMLibConfig.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/CMake/NosCMLibConfig.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/CMake/${PROJECT_NAME}
)