# use_mzcy_utils.cmake
# try include or download mzcy_utils.cmake
# fenglielie@qq.com

include(cmake/mzcy_utils.cmake OPTIONAL RESULT_VARIABLE RES)

if(${RES} STREQUAL "NOTFOUND")
    message("mzcy_utils.cmake was not found")
    message("download from https://fenglielie.top   -- start")

    file(DOWNLOAD "https://fenglielie.top/files/mzcy_utils-remote.cmake"
        ${PROJECT_SOURCE_DIR}/cmake/mzcy_utils-tmp.cmake
        HTTPHEADER "User-Agent: Mozilla/5.0"
        STATUS status LOG log)

    list(GET status 0 status_code)
    list(GET status 1 status_string)

    if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "download error
            status_code: ${status_code}
            status_string: ${status_string}
            log: ${log}")
    endif()
    message("download to cmake/mzcy_utils-tmp.cmake -- ok")

    include(cmake/mzcy_utils-tmp.cmake)
endif()
