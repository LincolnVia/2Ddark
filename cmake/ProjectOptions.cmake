function(dark_configure_project_options)
    add_library(dark_project_options INTERFACE)
    add_library(dark_project_warnings INTERFACE)

    target_compile_definitions(
        dark_project_options
        INTERFACE
            $<$<CONFIG:Debug>:DARK_DEBUG=1>
            $<$<CONFIG:Development>:DARK_DEVELOPMENT=1>
            $<$<CONFIG:Release>:DARK_RELEASE=1>
    )

    if(MSVC)
        target_compile_options(
            dark_project_warnings
            INTERFACE
                /W4
                /w14242
                /w14254
                /w14263
                /w14265
                /w14287
                /w14296
                /w14311
                /w14545
                /w14546
                /w14547
                /w14549
                /w14555
                /w14619
                /w14640
                /w14826
                /w14905
                /w14906
                /w14928
                /utf-8
                $<$<CONFIG:Debug>:/WX>
                $<$<CONFIG:Development>:/O2>
                $<$<CONFIG:Development>:/Zi>
        )
        target_link_options(
            dark_project_options
            INTERFACE
                $<$<CONFIG:Development>:/DEBUG>
        )
    elseif(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(
            dark_project_warnings
            INTERFACE
                -Wall
                -Wextra
                -Wpedantic
                -Wconversion
                -Wsign-conversion
                -Wshadow
                -Wstrict-prototypes
                -Wmissing-prototypes
                $<$<CONFIG:Debug>:-Werror>
                $<$<CONFIG:Development>:-O2>
                $<$<CONFIG:Development>:-g>
        )
    else()
        message(WARNING "No strict warning set is defined for ${CMAKE_C_COMPILER_ID}")
    endif()

    if(NOT DARK_ENABLE_SANITIZERS)
        return()
    endif()

    if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(
            dark_project_options
            INTERFACE
                $<$<CONFIG:Debug>:-fsanitize=address,undefined>
                $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
        )
        target_link_options(
            dark_project_options
            INTERFACE
                $<$<CONFIG:Debug>:-fsanitize=address,undefined>
        )
    elseif(MSVC)
        # MSVC AddressSanitizer is incompatible with the /RTC flags that CMake
        # supplies in Debug configurations.
        string(REGEX REPLACE "/RTC[1su]+" "" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE STRING "Debug C flags" FORCE)

        target_compile_options(
            dark_project_options
            INTERFACE
                $<$<CONFIG:Debug>:/fsanitize=address>
                $<$<CONFIG:Debug>:/Zi>
        )
        target_link_options(
            dark_project_options
            INTERFACE
                $<$<CONFIG:Debug>:/INCREMENTAL:NO>
        )
    else()
        message(WARNING "Sanitizers are not configured for ${CMAKE_C_COMPILER_ID}")
    endif()
endfunction()

function(dark_copy_msvc_asan_runtime target)
    if(NOT MSVC OR NOT DARK_ENABLE_SANITIZERS)
        return()
    endif()

    get_filename_component(dark_compiler_directory "${CMAKE_C_COMPILER}" DIRECTORY)
    find_file(
        dark_asan_runtime
        NAMES clang_rt.asan_dynamic-x86_64.dll
        PATHS "${dark_compiler_directory}"
        NO_DEFAULT_PATH
    )

    if(NOT dark_asan_runtime)
        message(WARNING "The MSVC AddressSanitizer runtime DLL was not found beside cl.exe")
        return()
    endif()

    add_custom_command(
        TARGET "${target}"
        POST_BUILD
        COMMAND
            "${CMAKE_COMMAND}" -E copy_if_different
            "${dark_asan_runtime}"
            "$<TARGET_FILE_DIR:${target}>"
        COMMENT "Copying the MSVC AddressSanitizer runtime for ${target}"
        VERBATIM
    )
endfunction()
