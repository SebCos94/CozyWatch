#######################################################################################################################
# MSVC compiler configuration
#######################################################################################################################
if(WIN32)
    set(CMAKE_SYSTEM_NAME Windows)
    set(CMAKE_SYSTEM_PROCESSOR x86_64)
elseif(UNIX)
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR x86_64) 
else()
    message(FATAL_ERROR "Unsupported system")
endif()
 
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED True)
 
#######################################################################################################################
# C's flags
#######################################################################################################################
set(CMAKE_C_COMPILER "${HostCompilerPath}/gcc${EXECUTABLE_EXTENSION}"
    CACHE INTERNAL "C compiler")

set(COMMON_FLAGS "-fprofile-arcs -ftest-coverage -Og -g3")

set(CMAKE_C_FLAGS "${COMMON_FLAGS}" CACHE INTERNAL "C Compiler Flags")  

#######################################################################################################################
# C++'s flags
#######################################################################################################################
set(CMAKE_CXX_COMPILER "${HostCompilerPath}/g++${EXECUTABLE_EXTENSION}"
    CACHE INTERNAL "C++ compiler")
