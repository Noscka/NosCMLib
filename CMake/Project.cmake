function(Get_Git_Version)
	execute_process(COMMAND git describe --tags
					WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
					RESULT_VARIABLE GIT_RESULT
					OUTPUT_VARIABLE GIT_VERSION)

	if(NOT GIT_RESULT EQUAL 0)
		message(WARNING "Git describe failed, using v0.0.0 instead.")
		set(GIT_VERSION "v0.0.0")
	endif()

	string(REPLACE "\n" "" GIT_VERSION ${GIT_VERSION})
	string(REPLACE " " "" GIT_VERSION ${GIT_VERSION})

	if( GIT_VERSION MATCHES "^v(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)[.](0|[1-9][0-9]*)(.*)$" )
		set(version_major "${CMAKE_MATCH_1}")
		set(version_minor "${CMAKE_MATCH_2}")
		set(version_patch "${CMAKE_MATCH_3}")
	else()
		message(WARNING "Wrong Git Tag Format: [${GIT_VERSION}]")
	endif()

	message(STATUS "Git Tag: ${version_major}.${version_minor}.${version_patch}")

	set(GIT_VERSION "${version_major}.${version_minor}.${version_patch}" PARENT_SCOPE)
endfunction()

function(Get_Git_Branch)
	execute_process(COMMAND git rev-parse --abbrev-ref HEAD
					WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
					RESULT_VARIABLE GIT_RESULT
					OUTPUT_VARIABLE GIT_BRANCH)

	 if(NOT GIT_RESULT EQUAL 0)
		message(WARNING "Git rev-parse failed, using DEFAULT instead.")
		set(GIT_BRANCH "DEFAULT")
	endif()

	string(REPLACE "\n" "" GIT_BRANCH ${GIT_BRANCH})
	string(REPLACE " " "" GIT_BRANCH ${GIT_BRANCH})
	
	message(STATUS "Git Branch: ${GIT_BRANCH}")

	set(GIT_BRANCH "${GIT_BRANCH}" PARENT_SCOPE)
endfunction()

function(InstallProject TargetName)
	# 1) Derive key variables
	set(pkg_name	${TargetName})
	set(ns_prefix	"${pkg_name}::")
	set(version		${PROJECT_VERSION})
	set(inst_inc	${CMAKE_INSTALL_INCLUDEDIR})
	set(cm_subdir	${pkg_name})

	# 2) Map configurations
	set_target_properties(${pkg_name} PROPERTIES
		MAP_IMPORTED_CONFIG_DEBUG "Debug"
		MAP_IMPORTED_CONFIG_RELEASE "Release"
		MAP_IMPORTED_CONFIG_RELWITHDEBINFO "Release"
		MAP_IMPORTED_CONFIG_MINSIZEREL "Release"
	)

	if(WIN32 AND BUILD_SHARED_LIBS)
	  set_target_properties(${pkg_name} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
	endif()

	include(GNUInstallDirs)
	include(CMakePackageConfigHelpers)

	 # 3) Install the target + headers
	install(TARGETS ${pkg_name}
		EXPORT ${pkg_name}Targets
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/$<CONFIG>
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/$<CONFIG>
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/$<CONFIG>
		PUBLIC_HEADER DESTINATION ${inst_inc}
	)

	install(DIRECTORY ${inst_inc} DESTINATION ${inst_inc})

	# 4) Export targets file
	install(EXPORT ${pkg_name}Targets
		FILE ${pkg_name}Targets.cmake
		NAMESPACE ${ns_prefix}
		DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${cm_subdir}
	)

	# 5) Generate & install config files
	configure_package_config_file(
		"${CMAKE_CURRENT_SOURCE_DIR}/CMake/${pkg_name}Config.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/${pkg_name}Config.cmake"
		INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${cm_subdir}
		NO_SET_AND_CHECK_MACRO
		NO_CHECK_REQUIRED_COMPONENTS_MACRO
	)

	write_basic_package_version_file(
		"${CMAKE_CURRENT_BINARY_DIR}/${pkg_name}ConfigVersion.cmake"
		VERSION ${PROJECT_VERSION}
		COMPATIBILITY AnyNewerVersion
	)

	install(FILES
		"${CMAKE_CURRENT_BINARY_DIR}/${pkg_name}Config.cmake"
		"${CMAKE_CURRENT_BINARY_DIR}/${pkg_name}ConfigVersion.cmake"
		DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${pkg_name}
	)
endfunction()