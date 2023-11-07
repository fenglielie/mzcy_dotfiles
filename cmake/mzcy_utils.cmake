# mzcy_utils.cmake

## marcos

macro(mzcy_usage)
    message(STATUS "\n"
        "    ###################################\n"
        "    #                                 #\n"
        "    #          MzcyUtils 1.0          #\n"
        "    #                                 #\n"
        "    ###################################\n")

    message(STATUS "macro usage:\n"
        "   - mzcy_init(): print usage, init the project (call after project)\n"
        "   - mzcy_init_quiet(): init the project  (call after project)\n"
        "   - mzcy_info(): show infomation\n"
        "   - mzcy_usage(): print this usage\n"
        "   - mzcy_use_bin_subdir(): use bin/debug as runtime output directory when Debug\n"
        "   - mzcy_add_my_rpath(): add environment variable ENV{MY_RPATH} to rpath\n"
        "   - mzcy_enable_qt(): enable CMAKE_AUTOMOC,CMAKE_AUTOUIC,CMAKE_AUTORCC\n"
        "   - mzcy_disable_qt(): disable CMAKE_AUTOMOC,CMAKE_AUTOUIC,CMAKE_AUTORCC\n")

    message(STATUS "function usage:\n"
        "   - mzcy_add_subdirs(src): go to src/CMakeLists.txt and src/*/CMakeLists.txt\n"
        "   - mzcy_add_subdirs_rec(src): go to src/CMakeLists.txt and src/*/*/CMakeLists.txt (recurse)\n"
        "   - mzcy_get_files(tmp test): search source files in test/ |-> tmp\n"
        "   - mzcy_get_files_rec(tmp test): search source files in test/ and test/*/ |-> tmp (recurse)\n")

    message(STATUS "target function usage:\n"
        "   - mzcy_target_preset_definitions(targetname): add some definitions\n"
        "     * MZCY_TARGET_NAME=targetname\n"
        "     * MZCY_PROJECT_SOURCE_DIR=PROJECT_SOURCE_DIR\n"
        "     * MZCY_CURRENT_SOURCE_DIR=CMAKE_CURRENT_SOURCE_DIR\n"
        "   - mzcy_target_use_postfix(targetname): add postfix _d when Debug (default in library)\n"
        "   - mzcy_target_reset_output(targetname RUNTIME path): change RUNTIME output to path (RUNTIME|ARCHIVE|LIBRARY)\n"
        "   - mzcy_target_info(targetname): show target properties\n")

endmacro()

macro(mzcy_init)
    mzcy_usage()
    mzcy_init_quiet()
endmacro()

macro(mzcy_init_quiet)
    message(STATUS ">> Init Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

    if(PROJECT_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
        message(FATAL_ERROR "The binary directory cannot be the same as source directory")
    endif()

    if(NOT CMAKE_BUILD_TYPE)
        message(STATUS ">> default CMAKE_BUILD_TYPE: \"Release\"")
        set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
    endif()

    # keep use folders in build/
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

    # create compile_commands.json in build/
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

    # c++ standard = C++20(required)
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)

    # libfunc
    # libfunc (release)
    set(CMAKE_DEBUG_POSTFIX "_d") # libfunc_d (debug)

    # ./bin
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

    # ./lib
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/lib")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})

    # ./lib
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/lib")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})


    # c/c++ compile flags
    if (("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU") OR ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang"))
        set(common_flags  "-fsanitize=address -fsanitize=undefined -fsanitize=memory -Wall -Wextra -Wfatal-errors -Wshadow -Wno-unused-parameter")
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        set(common_flags "/W3 /WX /MP")
    else()
        set(common_flags "")
    endif()

    # link rpath
    if (("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU") OR ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang"))
        if(DEFINED ENV{MY_RPATH})
            message("USE MY_RPATH")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath -Wl,$ENV{MY_RPATH}")
        endif()
    endif()

    # empty
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${common_flags}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${common_flags}")

    # debug default: -g
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${common_flags}")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${common_flags}")

    # release default: -O3 -DNDEBUG
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${common_flags}")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${common_flags}")



endmacro()

macro(mzcy_info)
    message(STATUS "---------- <Check Information Begin> ----------")
    message(STATUS ">> system = ${CMAKE_SYSTEM_NAME}")
    message(STATUS ">> generator = ${CMAKE_GENERATOR}")
    message(STATUS ">> build_type = ${CMAKE_BUILD_TYPE}")
    message(STATUS ">> cxx_compiler_id = ${CMAKE_CXX_COMPILER_ID}(${CMAKE_CXX_COMPILER_VERSION})")
    message(STATUS ">> cxx_compiler = ${CMAKE_CXX_COMPILER}")
    message(STATUS ">> cxx_flags = " ${CMAKE_CXX_FLAGS})
    message(STATUS ">> cxx_flags_debug = " ${CMAKE_CXX_FLAGS_DEBUG})
    message(STATUS ">> cxx_flags_release = " ${CMAKE_CXX_FLAGS_RELEASE})
    message(STATUS ">> linker = ${CMAKE_LINKER}")
    message(STATUS ">> exe_linker_flags = ${CMAKE_EXE_LINKER_FLAGS}")
    message(STATUS "-----------------------------------------------")
endmacro()


macro(mzcy_use_bin_subdir)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_SOURCE_DIR}/bin/debug")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_SOURCE_DIR}/bin")
endmacro()

macro(mzcy_add_my_rpath)
    if(CMAKE_SYSTEM_NAME MATCHES "Linux")
        if(DEFINED ENV{MY_RPATH})
            list(PREPEND CMAKE_BUILD_RPATH $ENV{MY_RPATH})
            list(PREPEND CMAKE_INSTALL_RPATH $ENV{MY_RPATH})
        endif()
    endif()
endmacro()

macro(mzcy_enable_qt)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTOUIC ON)
    set(CMAKE_AUTORCC ON)
endmacro()

macro(mzcy_disable_qt)
    set(CMAKE_AUTOMOC OFF)
    set(CMAKE_AUTOUIC OFF)
    set(CMAKE_AUTORCC OFF)
endmacro()

## functions

function(mzcy_get_files rst _sources)
    set(tmp_rst "")

    foreach(item ${_sources})
        if(IS_DIRECTORY ${item}) # item is dir
            file(GLOB itemSrcs CONFIGURE_DEPENDS
                ${item}/*.c ${item}/*.C ${item}/*.cc ${item}/*.cpp ${item}/*.cxx
                ${item}/*.h ${item}/*.hpp
                ${item}/*.f90
            )
            list(APPEND tmp_rst ${itemSrcs})
        else() # item is file
            # make sure using absolute filename
            if(NOT (IS_ABSOLUTE "${item}"))
                get_filename_component(item "${item}" ABSOLUTE)
            endif()

            list(APPEND tmp_rst ${item})
        endif()
    endforeach()

    set(${rst} ${tmp_rst} PARENT_SCOPE) # return
endfunction()

function(mzcy_get_files_rec rst _sources)
    set(tmp_rst "")

    foreach(item ${_sources})
        if(IS_DIRECTORY ${item}) # item is dir
            file(GLOB_RECURSE itemSrcs CONFIGURE_DEPENDS
                ${item}/*.c ${item}/*.C ${item}/*.cc ${item}/*.cpp ${item}/*.cxx
                ${item}/*.h ${item}/*.hpp
                ${item}/*.f90
            )
            list(APPEND tmp_rst ${itemSrcs})
        else() # item is file
            # make sure using absolute filename
            if(NOT (IS_ABSOLUTE "${item}"))
                get_filename_component(item "${item}" ABSOLUTE)
            endif()

            list(APPEND tmp_rst ${item})
        endif()
    endforeach()

    set(${rst} ${tmp_rst} PARENT_SCOPE) # return
endfunction()

# go to all relative subdirs which contains CMakeLists.txt from CMAKE_CURRENT_SOURCE_DIR.(not recurse)
# may not ordered as you want.
function(mzcy_add_subdirs _path)
	# search all subdirs
    file(GLOB children LIST_DIRECTORIES ON CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_path}/*)
	set(dirs "")
	list(PREPEND children "${CMAKE_CURRENT_SOURCE_DIR}/${_path}") # add first

    # append to dirs if contains CMakeLists.txt
    foreach(item ${children})
		if((IS_DIRECTORY ${item}) AND (EXISTS "${item}/CMakeLists.txt"))
			list(APPEND dirs ${item})
		endif()
	endforeach()

    # go to subdirs
    foreach(dir ${dirs})
        message(STATUS ">> Go to ${dir}")
		add_subdirectory(${dir})
	endforeach()

endfunction()


# go to all relative subdirs which contains CMakeLists.txt from CMAKE_CURRENT_SOURCE_DIR.(recurse)
# may not ordered as you want.
function(mzcy_add_subdirs_rec _path)
	# search all subdirs
	file(GLOB_RECURSE children LIST_DIRECTORIES ON CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_path}/*)
	set(dirs "")
	list(PREPEND children "${CMAKE_CURRENT_SOURCE_DIR}/${_path}") # add first

    # append to dirs if contains CMakeLists.txt
    foreach(item ${children})
		if((IS_DIRECTORY ${item}) AND (EXISTS "${item}/CMakeLists.txt"))
			list(APPEND dirs ${item})
		endif()
	endforeach()

    # go to subdirs
	foreach(dir ${dirs})
		message(STATUS ">> Go to ${dir}")
		add_subdirectory(${dir})
	endforeach()

endfunction()

## target functions

function(mzcy_inside_check_target _target)
    if(NOT TARGET "${_target}")
        message(FATAL_ERROR "${_target} is not a target")
    endif()
endfunction()

function(mzcy_target_preset_definitions _target)
    mzcy_inside_check_target(${_target})

    target_compile_definitions(${_target} PRIVATE
        "MZCY_TARGET_NAME=\"${_target}\""
        "MZCY_PROJECT_SOURCE_DIR=\"${PROJECT_SOURCE_DIR}\""
        "MZCY_CURRENT_SOURCE_DIR=\"${CMAKE_CURRENT_SOURCE_DIR}\""
    )
endfunction()

function(mzcy_target_use_postfix _target)
    mzcy_inside_check_target(${_target})

    set_target_properties(${_target}
        PROPERTIES
        DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
    )
endfunction()

function(mzcy_target_reset_output _target _type _path)
    mzcy_inside_check_target(${_target})

    string(TOUPPER "${_type}" _type)

    if(${_type} STREQUAL "RUNTIME")
        set_target_properties(${_target}
            PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${_path}"
            RUNTIME_OUTPUT_DIRECTORY_DEBUG "${_path}"
            RUNTIME_OUTPUT_DIRECTORY_RELEASE "${_path}"
        )
    elseif(${_type} STREQUAL "ARCHIVE")
        set_target_properties(${_target}
            PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${_path}"
            ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${_path}"
            ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${_path}"
        )
    elseif(${_type} STREQUAL "LIBRARY")
        set_target_properties(${_target}
            PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY "${_path}"
            LIBRARY_OUTPUT_DIRECTORY_DEBUG "${_path}"
            LIBRARY_OUTPUT_DIRECTORY_RELEASE "${_path}"
    )
    else()
        message(FATAL_ERROR "illegal type ${_type} (RUNTIME|ARCHIVE|LIBRARY)")
    endif()

endfunction()

function(mzcy_inside_list_print)
    # TITLE
    # PREFIX a
    # STRS a;b;c

    set(options "")
    set(oneValueArgs TITLE PREFIX)
    set(multiValueArgs STRS)
    cmake_parse_arguments("ARG" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # return if STRS is empty
    list(LENGTH ARG_STRS strsLength)
    if(NOT strsLength)
        return()
    endif()

    # print title
    if(NOT (${ARG_TITLE} STREQUAL ""))
        message(STATUS ${ARG_TITLE})
    endif()

    # print prefix+item in STRS
    foreach(str ${ARG_STRS})
        message(STATUS "${ARG_PREFIX}${str}")
    endforeach()

endfunction()

function(mzcy_inside_print_property _target _porperty)
    string(TOUPPER "${_porperty}" _porperty)

    get_target_property(tmp ${_target} ${_porperty})
    if(NOT (tmp STREQUAL "tmp-NOTFOUND"))
        string(TOLOWER "${_porperty}" porperty_lower)
        mzcy_inside_list_print(STRS "${tmp}" TITLE  "${porperty_lower}:" PREFIX "  * ")
    endif()

    get_target_property(tmp ${_target} INTERFACE_${_porperty})
    if(NOT (tmp STREQUAL "tmp-NOTFOUND"))
        string(TOLOWER "${_porperty}" porperty_lower)
        mzcy_inside_list_print(STRS "${tmp}" TITLE  "interface_${porperty_lower}:" PREFIX "  * ")
    endif()

endfunction()

function(mzcy_target_info _target)
    mzcy_inside_check_target(${_target})

    message(STATUS "---------- <Check Target Begin> ----------")
    message(STATUS "name: ${_target}")

    get_target_property(tmp ${_target} TYPE)
    string(TOLOWER "${tmp}" tmp)
    message(STATUS "type: ${tmp}")

    get_target_property(tmp ${_target} SOURCE_DIR)
    message(STATUS "location: ${tmp}")

    mzcy_inside_print_property(${_target} SOURCES)
    mzcy_inside_print_property(${_target} INCLUDE_DIRECTORIES)
    mzcy_inside_print_property(${_target} LINK_DIRECTORIES)
    mzcy_inside_print_property(${_target} LINK_LIBRARIES)
    mzcy_inside_print_property(${_target} LINK_OPTIONS)
    mzcy_inside_print_property(${_target} COMPILE_OPTIONS)
    mzcy_inside_print_property(${_target} COMPILE_DEFINITIONS)

    message(STATUS "------------------------------------------")
endfunction()
