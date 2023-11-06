cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(MzcyCMake VERSION 1.0)

# set(CMAKE_MODULE_PATH "$ENV{MY_CMAKE_MODULE_PATH}")
# include(mzcy_utils)

# include(cmake/use_mzcy_utils.cmake)
include(cmake/mzcy_utils-beta.cmake)

mzcy_init()
mzcy_info()

mzcy_add_subdirs_rec(source)
