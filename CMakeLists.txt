cmake_minimum_required(VERSION 3.10.0)

# ######################################################################################################################
# Macro and Functions
# ######################################################################################################################

include(${CMAKE_SOURCE_DIR}/tools/cmake_scripts/cmake_macros.cmake)

# ######################################################################################################################
# Configure scripts environment
# ######################################################################################################################
set(EXECUTABLE_EXTENSION "")

# ######################################################################################################################
# Configure Target
# ######################################################################################################################
set(TARGET          "CozyWatch")
set(TARGET_HOST     ${TARGET}-Host)

if(CMAKE_BUILD_ARCH STREQUAL "ARM")
    set(TARGET_MCU "EKRA4M2")
else()
    message(FATAL_ERROR "Unkown architecture")
endif()

if(CMAKE_BUILD_ARCH STREQUAL "ARM")

    find_path(ARMCompilerPath "arm-none-eabi-gcc${EXECUTABLE_EXTENSION}" REQUIRED NO_DEFAULT_PATH NO_SYSTEM_ENVIRONMENT_PATH PATHS
        "/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin"
    )

    # Toolchain file for GCC-ARM compiler - adjust to your MCU, used in project
    include(${CMAKE_SOURCE_DIR}/tools/cmake_scripts/cmake_ra4m2_arm_gcc_cfg.cmake)

else()
    find_path(HostCompilerPath "gcc${EXECUTABLE_EXTENSION}" REQUIRED NO_DEFAULT_PATH NO_SYSTEM_ENVIRONMENT_PATH PATHS
        "/usr/bin"
    )

    # Toolchain file for Host compiler
    include(${CMAKE_SOURCE_DIR}/tools/cmake_scripts/cmake_host_cfg.cmake)
endif()

# ######################################################################################################################
# Project setup and compiler check
# ######################################################################################################################
project(CozyWatch
    LANGUAGES CXX C ASM
    DESCRIPTION "CozyWatch Project"
)

# ######################################################################################################################
# Configure Project
# ######################################################################################################################
if(CMAKE_BUILD_ARCH STREQUAL "ARM")

    set(REQUIRED_ARM_GCC_VERSION 14.2.1)

    if(NOT CMAKE_C_COMPILER_VERSION VERSION_EQUAL REQUIRED_ARM_GCC_VERSION)
        message(FATAL_ERROR "ARM GCC version must be equal to: ${REQUIRED_ARM_GCC_VERSION}!\n \
                Current ARM GCC version: ${CMAKE_C_COMPILER_VERSION}")
    endif()

    # Path to linker script
    set(LINKER_SCRIPT_DIR ${CMAKE_SOURCE_DIR}/fw/ld)
    set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/fw/ld/fsp.ld)

    message(${LINKER_SCRIPT_DIR})

    # Link libraries to target
    set(ARCH_LIBS ${TARGET_MCU} gcc c_nano)

    # Path to GCC size tool (prints on console size of elf file). Natively cmake don't store this path.
    string(REPLACE "g++" "size" CMAKE_OBJSIZE ${CMAKE_CXX_COMPILER})

    add_subdirectory(fw/src)

    file(GLOB_RECURSE SOURCE_LIST
        "${CMAKE_CURRENT_SOURCE_DIR}/fw/src/prj/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/fw/src/prj/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/fw/src/prj/*.h"
    )

    add_executable(${TARGET} ${SOURCE_LIST})

    target_link_libraries(${TARGET} PUBLIC ${ARCH_LIBS})

    set_target_properties(${TARGET} PROPERTIES SUFFIX ".elf")
    
    target_link_options(${TARGET} PUBLIC
        -Xlinker --gc-sections
        -Wl,--no-warn-rwx-segments
        -Wl,--print-memory-usage
        -Wl,-Map=${TARGET}.map
        --specs=nano.specs
        --specs=nosys.specs
        -T ${LINKER_SCRIPT}
        -L ${LINKER_SCRIPT_DIR}
        -u _printf_float
        -nodefaultlibs  # Exclude default libraries
        -nostdlib       # Exclude standard libraries
    )

    mcu_post_build(${TARGET})
    
endif()