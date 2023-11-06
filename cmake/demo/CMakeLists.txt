cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


project(Demo)

if(PROJECT_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "The binary directory cannot be the same as source directory")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_SOURCE_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_SOURCE_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${PROJECT_SOURCE_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${PROJECT_SOURCE_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${PROJECT_SOURCE_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${PROJECT_SOURCE_DIR}/lib")

# c/c++ compile flags
if (("CMAKE_CXX_COMPILER_ID" STREQUAL "GNU") OR ("CMAKE_CXX_COMPILER_ID" STREQUAL "Clang"))
    set(common_flags  "-fsanitize=address -fsanitize=undefined -Wall -Wextra -Wfatal-errors -Wshadow -Wno-unused-parameter")
elseif("CMAKE_CXX_COMPILER_ID" STREQUAL "MSVC")
    set(common_flags "/W3 /WX /MP")
else()
    set(common_flags "")
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

# source files
file(GLOB_RECURSE SRCS CONFIGURE_DEPENDS src/*.cpp include/*.h)

# executable
add_executable(${PROJECT_NAME} ${SRCS})
