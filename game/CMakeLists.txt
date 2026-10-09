add_executable(dark_game
    main.c
)

target_link_libraries(
    dark_game
    PRIVATE SDL3::SDL3 dark_project_options dark_project_warnings
)

set_target_properties(dark_game PROPERTIES FOLDER "game")
dark_copy_msvc_asan_runtime(dark_game)
