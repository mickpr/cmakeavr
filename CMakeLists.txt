cmake_minimum_required(VERSION 3.10)

set(CMAKE_TOOLCHAIN_FILE "avr-gcc.toolchain.cmake")

project(myproject C CXX ASM)

include_directories(
    C:/Programs/AvrToolchain/avr/include/
)

add_definitions(-DF_CPU=16000000)
add_avr_executable(${PROJECT_NAME} "atmega32"
    main.cpp
)
