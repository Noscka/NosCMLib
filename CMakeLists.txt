cmake_minimum_required (VERSION 3.12)

include("${CMAKE_CURRENT_LIST_DIR}/CMake/Versioning.cmake")

Get_Git_Version()
Get_Git_Branch()

project ("NosCMLib" VERSION ${GIT_VERSION} LANGUAGES CXX)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
	"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake/${PROJECT_NAME}Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

file(GLOB_RECURSE CMakeFunctionFiles CONFIGURE_DEPENDS "CMake/*")

install(FILES
	"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
	"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	${CMakeFunctionFiles}
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/CMake/${PROJECT_NAME}
)