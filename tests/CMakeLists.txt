add_executable(dark_tests
    main.c
    test_runner.c
)

target_include_directories(dark_tests PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(
    dark_tests
    PRIVATE dark_project_options dark_project_warnings
)

add_test(NAME dark_tests COMMAND dark_tests)
set_target_properties(dark_tests PROPERTIES FOLDER "tests")
dark_copy_msvc_asan_runtime(dark_tests)
