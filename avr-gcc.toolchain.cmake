#
# AVR GCC Toolchain file
#
# @author Natesh Narain
# @since Feb 06 2016

set(TRIPLE "avr")

# find the toolchain root directory

set(TOOLCHAIN_ROOT "C:/Programs/AVR/toolchain/bin")

set(CMAKE_MAKE_PROGRAM "C:/Programs/bin/make.exe")

# setup the AVR compiler variables

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_CROSS_COMPILING 1)

set(CMAKE_C_COMPILER   "${TOOLCHAIN_ROOT}/avr-gcc.exe"     CACHE PATH "gcc"     FORCE)
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_ROOT}/avr-g++.exe"     CACHE PATH "g++"     FORCE)
set(CMAKE_AR           "${TOOLCHAIN_ROOT}/avr-ar.exe"      CACHE PATH "ar"      FORCE)
set(CMAKE_LINKER       "${TOOLCHAIN_ROOT}/avr-ld.exe"      CACHE PATH "linker"  FORCE)
set(CMAKE_NM           "${TOOLCHAIN_ROOT}/avr-nm.exe"      CACHE PATH "nm"      FORCE)
set(CMAKE_OBJCOPY      "${TOOLCHAIN_ROOT}/avr-objcopy.exe" CACHE PATH "objcopy" FORCE)
set(CMAKE_OBJDUMP      "${TOOLCHAIN_ROOT}/avr-objdump.exe" CACHE PATH "objdump" FORCE)
set(CMAKE_STRIP        "${TOOLCHAIN_ROOT}/avr-strip.exe"   CACHE PATH "strip"   FORCE)
set(CMAKE_RANLIB       "${TOOLCHAIN_ROOT}/avr-ranlib.exe"  CACHE PATH "ranlib"  FORCE)
set(AVR_SIZE           "${TOOLCHAIN_ROOT}/avr-size.exe"    CACHE PATH "size"    FORCE)

#mickpr set(CMAKE_EXE_LINKER_FLAGS "-L /usr/lib/gcc/avr/4.8.2")
set(CMAKE_EXE_LINKER_FLAGS "-L'C:/Programs/AvrToolchain/lib/gcc/avr/5.4.0/'")

# avr uploader config
set(AVR_UPLOAD "C:/Programs/bin/avrdude.exe")

# setup the avr exectable macro

set(AVR_LINKER_LIBS "-lc -lm -lgcc")

macro(add_avr_executable target_name avr_mcu)

    set(elf_file ${target_name}-${avr_mcu}.elf)
    set(map_file ${target_name}-${avr_mcu}.map)
    set(hex_file ${target_name}-${avr_mcu}.hex)
    set(lst_file ${target_name}-${avr_mcu}.lst)

    # create elf file
    add_executable(${elf_file}
        ${ARGN}
    )

    set_target_properties(
        ${elf_file}

        PROPERTIES
            COMPILE_FLAGS "-mmcu=${avr_mcu} -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics"
            LINK_FLAGS    "-mmcu=${avr_mcu} -Wl,-Map,${map_file} ${AVR_LINKER_LIBS}"
    )

    # generate the lst file
    add_custom_command(
        OUTPUT ${lst_file}

        COMMAND
            ${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lst_file}

        DEPENDS ${elf_file}
    )

    # create hex file
    add_custom_command(
        OUTPUT ${hex_file}

        COMMAND
            ${CMAKE_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}

        DEPENDS ${elf_file}
    )

    add_custom_command(
        OUTPUT "print-size-${elf_file}"

        COMMAND
            ${AVR_SIZE} ${elf_file}

        DEPENDS ${elf_file}
    )

    # build the intel hex file for the device
    add_custom_target(
        ${target_name}
        ALL
        DEPENDS ${hex_file} ${lst_file} "print-size-${elf_file}"
    )

    set_target_properties(
        ${target_name}

        PROPERTIES
            OUTPUT_NAME ${elf_file}
    )
endmacro(add_avr_executable)
