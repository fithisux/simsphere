# cmake version, project name, language
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(simsphere)
enable_language(Fortran)

# set output paths for modules, archives, and executables
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/include)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# if build type not specified, default to release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "release")
endif()

# compiler flags for gfortran
if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -std=f2008 -Wall -Wintrinsic-shadow -Wextra -pedantic -ggdb3 -fbacktrace -ffpe-trap=zero,overflow,underflow -fprofile-arcs -ftest-coverage")
  set(CMAKE_Fortran_FLAGS_RELEASE "-std=f2008 -fprofile-arcs -ftest-coverage")
endif()

# compiler flags for ifort
if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -assume realloc_lhs -heap-arrays")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -C -traceback")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
endif()

# libcompare is provided via git submodule from git://github.com/tcanich/compare
add_subdirectory(externals/compare)

# libjson is provided by external script, built in /tmp/json-build for Travis
find_package(jsonfortran NAMES jsonfortran-gnu HINTS /tmp/json-build REQUIRED)
#add_library(jsonfortran SHARED IMPORTED)
#set_target_properties(jsonfortran PROPERTIES IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/lib/libjsonfortran.so)

# library to archive (libsimsphere)
add_library(simsphere_mod SHARED src/simsphere_mod.f90 src/config_mod.f90 src/constants_mod.f90 src/snding_mod.f90 src/stomata_mod.f90 src/transm_mod.f90 src/vel_mod.f90 src/globals.f90)
add_dependencies(simsphere_mod compare)
target_link_libraries(simsphere_mod compare jsonfortran)
set_target_properties(simsphere_mod PROPERTIES INTERFACE_POSITION_INDEPENDENT_CODE ON)

# Testing library (mod_testing)
add_library(mod_testing SHARED tests/mod_testing.f90)
set_target_properties(mod_testing PROPERTIES INTERFACE_POSITION_INDEPENDENT_CODE ON)


# tests
enable_testing()
add_executable(simsphere src/air.f90 src/albedo.f90 src/ball.f90 src/below.f90 src/bri.f90 src/calc.f90 src/canres.f90 src/capac.f90 src/daykm.f90 src/fine.f90 src/flux.f90 src/gettbl.f90 src/gtemp.f90 src/hot.f90 src/input.f90 src/intpol.f90 src/main.f90 src/momday.f90 src/mom.f90 src/netrad.f90 src/prfile.f90 src/pslcal.f90 src/psoil.f90 src/slope.f90 src/snding.f90 src/start.f90 src/vegflx.f90 src/vegrad.f90 src/vegvel.f90 src/vel.f90 src/water.f90)
add_executable(config src/config_gen.f90)
add_executable(loadjson src/loadjson.f90)
add_executable(simsphere_test src/fine.f90 src/prfile.f90 src/intpol.f90 src/albedo.f90 src/hot.f90 src/snding.f90 src/start.f90 src/vegflx.f90 tests/tests.f90)
add_executable(test_air src/air.f90 tests/test_air.f90)
add_executable(test_albedo src/albedo.f90 tests/test_albedo.f90)
add_executable(test_average tests/test_average.f90)
add_executable(test_ball src/ball.f90 tests/test_ball.f90)
add_executable(test_below src/below.f90 src/water.f90  tests/test_below.f90)
add_executable(test_bri src/mom.f90 src/bri.f90 tests/test_bri.f90)
add_executable(test_calc src/calc.f90  tests/test_calc.f90)
add_executable(test_canres src/canres.f90  tests/test_canres.f90)
add_executable(test_capac src/capac.f90  tests/test_capac.f90)
add_executable(test_co2flx src/co2flx.f90 tests/test_co2flx.f90)
add_executable(test_daykm src/daykm.f90  tests/test_daykm.f90)
add_executable(test_fine src/fine.f90  tests/test_fine.f90)
add_executable(test_flux src/flux.f90 src/vegflx.f90 src/gtemp.f90 tests/test_flux.f90)
add_executable(test_gtemp src/gtemp.f90  tests/test_gtemp.f90)
add_executable(test_hot src/hot.f90 tests/test_hot.f90)
add_executable(test_intpol src/intpol.f90  tests/test_intpol.f90)
add_executable(test_load_data  tests/test_load_data.f90)
add_executable(test_mom src/mom.f90  tests/test_mom.f90)
add_executable(test_momday src/momday.f90 src/fine.f90  tests/test_momday.f90)
add_executable(test_netrad src/slope.f90 src/input.f90 src/vegrad.f90 src/albedo.f90 src/netrad.f90  tests/test_netrad.f90)
add_executable(test_ozone tests/test_ozone.f90)
add_executable(test_output  tests/test_output.f90)
add_executable(test_prfile src/fine.f90 src/prfile.f90 src/intpol.f90  tests/test_prfile.f90)
add_executable(test_pslcal src/capac.f90 src/pslcal.f90  tests/test_pslcal.f90)
add_executable(test_psoil src/psoil.f90  tests/test_psoil.f90)
add_executable(test_slope src/slope.f90 src/albedo.f90  tests/test_slope.f90)
add_executable(test_snding src/snding.f90 src/start.f90  tests/test_snding.f90)
add_executable(test_veghot tests/test_veghot.f90)
add_executable(test_vegrad src/vegrad.f90  tests/test_vegrad.f90)
add_executable(test_vegvel src/vegvel.f90 src/ball.f90 src/pslcal.f90 src/capac.f90  tests/test_vegvel.f90)
add_executable(test_water src/water.f90  tests/test_water.f90)

target_link_libraries(simsphere simsphere_mod compare)
target_link_libraries(config jsonfortran)
target_link_libraries(loadjson simsphere_mod)
target_link_libraries(simsphere_test simsphere_mod mod_testing)
target_link_libraries(test_air simsphere_mod mod_testing)
target_link_libraries(test_albedo simsphere_mod mod_testing)
target_link_libraries(test_average simsphere_mod mod_testing)
target_link_libraries(test_ball simsphere_mod mod_testing)
target_link_libraries(test_below simsphere_mod mod_testing)
target_link_libraries(test_bri simsphere_mod mod_testing)
target_link_libraries(test_calc simsphere_mod mod_testing)
target_link_libraries(test_canres simsphere_mod mod_testing)
target_link_libraries(test_capac simsphere_mod mod_testing)
target_link_libraries(test_co2flx simsphere_mod mod_testing)
target_link_libraries(test_daykm simsphere_mod mod_testing)
target_link_libraries(test_fine simsphere_mod mod_testing)
target_link_libraries(test_flux simsphere_mod mod_testing)
target_link_libraries(test_gtemp simsphere_mod mod_testing)
target_link_libraries(test_hot simsphere_mod mod_testing)
target_link_libraries(test_intpol simsphere_mod mod_testing)
target_link_libraries(test_load_data simsphere_mod mod_testing)
target_link_libraries(test_mom simsphere_mod mod_testing)
target_link_libraries(test_momday simsphere_mod mod_testing)
target_link_libraries(test_netrad simsphere_mod mod_testing)
target_link_libraries(test_ozone simsphere_mod mod_testing)
target_link_libraries(test_output simsphere_mod mod_testing)
target_link_libraries(test_prfile simsphere_mod mod_testing)
target_link_libraries(test_pslcal simsphere_mod mod_testing)
target_link_libraries(test_psoil simsphere_mod mod_testing)
target_link_libraries(test_slope simsphere_mod mod_testing)
target_link_libraries(test_snding simsphere_mod mod_testing)
target_link_libraries(test_veghot simsphere_mod mod_testing)
target_link_libraries(test_vegrad simsphere_mod mod_testing)
target_link_libraries(test_vegvel simsphere_mod mod_testing)
target_link_libraries(test_water simsphere_mod mod_testing)

target_include_directories(simsphere_mod PRIVATE ${compare_BINARY_DIR}/include PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(simsphere PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(config PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(loadjson PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(simsphere_test PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(test_snding PRIVATE ${jsonfortran_INCLUDE_DIRS})
target_include_directories(test_load_data PRIVATE ${jsonfortran_INCLUDE_DIRS})


add_test(simsphere_test ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/simsphere_test)
add_test(test_air ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_air)
add_test(test_albedo ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_albedo)
add_test(test_average ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_average)
add_test(test_ball ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_ball)
add_test(test_below ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_below)
add_test(test_bri ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_bri)
add_test(test_calc ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_calc)
add_test(test_canres ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_canres)
add_test(test_capac ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_capac)
add_test(test_daykm ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_daykm)
add_test(test_fine ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_fine)
add_test(test_flux ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_flux)
add_test(test_gtemp ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_gtemp)
add_test(test_intpol ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_intpol)
add_test(test_load_data ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_load_data)
add_test(test_mom ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_mom)
add_test(test_momday ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_momday)
add_test(test_prfile ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_prfile)
add_test(test_pslcal ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_pslcal)
add_test(test_psoil ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_psoil)
add_test(test_netrad ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_netrad)
add_test(test_ozone ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_ozone)
add_test(test_output ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_output)
add_test(test_slope ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_slope)
add_test(test_snding ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_snding)
add_test(test_vegrad ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_vegrad)
add_test(test_vegvel ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_vegvel)
add_test(test_water ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test_water)
