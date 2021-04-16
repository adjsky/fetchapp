cmake_minimum_required(VERSION 3.0)

project(fetchapp LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package(...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick Widgets LinguistTools REQUIRED)
find_package(fmt)

file(GLOB TRANSLATION_FILES ${CMAKE_CURRENT_SOURCE_DIR}/qml/translations/*.ts)

qt5_add_translation(TRANSLATION_QM ${TRANSLATION_FILES})
add_custom_target(translations ALL DEPENDS ${TRANSLATION_QM})

set(PROJECT_SOURCES
        qml/qml.qrc
        cpp/main.cpp
        cpp/UserManager/UserManager.cpp
        cpp/UserManager/UserManager.hpp
        cpp/NetworkManager/NetworkManager.hpp
        cpp/NetworkManager/NetworkManager.cpp
        cpp/Language/Language.cpp
        cpp/Language/Language.hpp
        cpp/Config/Config.cpp
        cpp/Config/Config.hpp
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(fetchapp
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(fetchapp SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(fetchapp
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(fetchapp
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(fetchapp
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Widgets fmt::fmt)
target_compile_options(fetchapp PRIVATE -Wall -Wextra -pedantic-errors)
