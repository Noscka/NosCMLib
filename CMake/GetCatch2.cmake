function(get_catch2)
    Include(FetchContent)

    FetchContent_Declare(
      Catch2
      GIT_REPOSITORY https://github.com/catchorg/Catch2.git
      GIT_TAG v3.8.1 # or a later release
    )

    FetchContent_MakeAvailable(Catch2)
endfunction()