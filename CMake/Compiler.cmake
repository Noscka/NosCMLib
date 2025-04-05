function(Set_Harsh_Compiler_Flags TargetName)
    if(UNIX)
        target_compile_options(${TargetName} PRIVATE
          -Wall
          -Wextra
          -Wshadow
          -Wnon-virtual-dtor
          -Wcast-align -Wunused
          -Woverloaded-virtual
          -Wconversion
          -Wsign-conversion
          -Wduplicated-cond
          -Wnull-dereference
          -Wuseless-cast
          -Wdouble-promotion
          -Wformat=2
          -pedantic)
    elseif(WIN32)
        target_compile_options(${TargetName} PRIVATE
          /W4)
    endif()
endfunction()