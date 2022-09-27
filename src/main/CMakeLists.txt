set(main_target main)

add_executable(${main_target})

include(CompileOptions)

set_compile_options(${main_target})

target_sources(
  ${main_target}
  PRIVATE
    ${main_target}/${main_target}.cpp
)

target_link_libraries(
  ${main_target}
  PRIVATE
    LLVM
)

target_include_directories(
  ${main_target}
  PUBLIC
    ${LLVM_INCLUDE_DIRS}
)

set_target_properties(
  ${main_target}
  PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${root}/bin/
)