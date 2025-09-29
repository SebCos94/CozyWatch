# #######################################################################################################################
# RA4M2 compiler configuration file
# #######################################################################################################################
# MCU sepcific flags
set(MCU_SPECIFIC "-mcpu=cortex-m33 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16")

#######################################################################################################################
# GCC ARM common compiler configuration
#######################################################################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED True)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(COMMON_FLAGS "${MCU_SPECIFIC} -fmessage-length=0 -fsigned-char -ffunction-sections \
-fdata-sections -Wunused -Wuninitialized -Wall -Wextra \
-Wmissing-declarations -Wconversion -Wpointer-arith -Wshadow -Wlogical-op \
-Waggregate-return -Wfloat-equal")

if(CMAKE_BUILD_TYPE MATCHES Release)
    set(COMMON_FLAGS "${COMMON_FLAGS} -Werror")
endif()

#######################################################################################################################
# C's flags
#######################################################################################################################
set(CMAKE_C_COMPILER "${ARMCompilerPath}/arm-none-eabi-gcc${EXECUTABLE_EXTENSION}"
    CACHE INTERNAL "C compiler")

set(CMAKE_C_FLAGS "${COMMON_FLAGS}" CACHE INTERNAL "C Compiler Flags")  

if(CMAKE_BUILD_TYPE MATCHES Debug)
    if(CMAKE_OPTIMISATION MATCHES "Size")
        message("Size optimisation enabled")
        set(CMAKE_C_FLAGS_DEBUG "-DDEBUG=1 -g3 -Os"
        CACHE INTERNAL "C Debug Compiler Flags")  
    else()
        message("Size optimisation disabled")
        set(CMAKE_C_FLAGS_DEBUG "-DDEBUG=1 -g3 -Og"
        CACHE INTERNAL "C Debug Compiler Flags")
    endif()
endif()

set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG -Os -g"
    CACHE INTERNAL "C Release Compiler Flags")

#######################################################################################################################
# C++'s flags
#######################################################################################################################
set(CMAKE_CXX_COMPILER "${ARMCompilerPath}/arm-none-eabi-g++${EXECUTABLE_EXTENSION}"
    CACHE INTERNAL "C++ compiler")

set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS}
    CACHE INTERNAL "C Compiler Flags")       

SET(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG}
    CACHE INTERNAL "C Debug Compiler Flags")

SET(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE}
    CACHE INTERNAL "C Release Compiler Flags")

#######################################################################################################################
# Assembler's flags
#######################################################################################################################
set(CMAKE_ASM_COMPILER "${ARMCompilerPath}/arm-none-eabi-gcc${EXECUTABLE_EXTENSION}"
    CACHE INTERNAL "ASM compiler")

set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} -x assembler-with-cpp"
    CACHE INTERNAL "ASM compiler flags")
