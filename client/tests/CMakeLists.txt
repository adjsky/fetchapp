cmake_minimum_required(VERSION 3.14)

project(fetchapp_tests LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

add_executable(fetchapp_tests main.cpp catch.hpp)
