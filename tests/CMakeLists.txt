cmake_minimum_required(VERSION 3.19)

project(fetchapp_tests LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick REQUIRED)

add_executable(fetchapp_tests
    main.cpp
    catch.hpp
    ../cpp/UserManager/UserManager.cpp
    usermanager_test.cpp
)

target_link_libraries(fetchapp_tests
  PRIVATE Qt${QT_VERSION_MAJOR}::Core)
