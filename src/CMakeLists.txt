cmake_minimum_required(VERSION 3.10)

project(native_opencv LANGUAGES C CXX)

include_directories(include)
add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/../android/src/main/jniLibs/${ANDROID_ABI}/libopencv_java4.so)

add_library(
    native_opencv
    SHARED
    ../src/native_opencv.cpp
)

set (BUILD_WRITERS ON)


find_library(log-lib log)
target_link_libraries(native_opencv lib_opencv ${log-lib})