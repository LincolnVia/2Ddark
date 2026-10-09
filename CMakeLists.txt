cmake_minimum_required(VERSION 3.25)

project(
    2Ddark
    VERSION 0.1.0
    DESCRIPTION "A portable C17 dark-fantasy action game"
    LANGUAGES C
)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

option(DARK_ENABLE_SANITIZERS "Enable the sanitizers supported by this compiler" OFF)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(ProjectOptions)
include(FetchContent)

dark_configure_project_options()

set(SDL_SHARED OFF CACHE BOOL "Build SDL as a shared library" FORCE)
set(SDL_STATIC ON CACHE BOOL "Build SDL as a static library" FORCE)
set(SDL_TEST_LIBRARY OFF CACHE BOOL "Build SDL's test library" FORCE)
set(SDL_TESTS OFF CACHE BOOL "Build SDL's tests" FORCE)
set(SDL_EXAMPLES OFF CACHE BOOL "Build SDL's examples" FORCE)
set(SDL_DISABLE_INSTALL ON CACHE BOOL "Disable SDL install targets" FORCE)
set(SDL_DISABLE_INSTALL_DOCS ON CACHE BOOL "Disable SDL documentation installation" FORCE)

FetchContent_Declare(
    SDL3
    URL "https://github.com/libsdl-org/SDL/releases/download/release-3.4.16/SDL3-3.4.16.tar.gz"
    URL_HASH "SHA256=7322236cd12090c3eb40b9728be4d49c76f66ad17d04369584d4ecad5cf77c68"
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(SDL3)

enable_testing()

add_subdirectory(game)
add_subdirectory(tests)
