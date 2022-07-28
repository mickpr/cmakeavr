del CMakeCache.txt 
del *.hex
del *.elf
del *.lst
del *.map
del Makefile
del cmake_install.cmake 
rm -r CMakeFiles

cmake -DCMAKE_TOOLCHAIN_FILE="avr-gcc.toolchain.cmake"  -G"MinGW Makefiles"
C:\Programs\bin\make.exe 

rm -r CMakeFiles
del CMakeCache.txt 
rem del *.hex
rem del *.elf
del *.lst
rem del *.map
del Makefile
del cmake_install.cmake 