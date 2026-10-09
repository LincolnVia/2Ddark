# 2Ddark

2Ddark is a fast-prototyping C17 project built directly on SDL3. The prototype intentionally has no
engine or platform abstraction: game code may call SDL anywhere it is useful. Architecture can be
extracted later, after the gameplay proves what boundaries are actually needed.

SDL 3.4.16 is downloaded and built automatically by CMake. It is the only runtime dependency.

## Project layout

| Path | Purpose |
| --- | --- |
| `game/main.c` | SDL startup, events, update logic, and rendering |
| `tests/` | Headless tests and the small custom C test runner |
| `assets/` | Source assets and attribution records |

Generated files are placed under `out/build/` and should not be committed.

## Prerequisites

- CMake 3.25 or newer
- Linux or WSL2: GCC and Make
- Windows: Visual Studio 2022 with the **Desktop development with C++** workload
- An internet connection during the first CMake configuration, to download pinned SDL3 source
- Optional: `clang-format` and `clangd`

## Build and run on Linux or WSL2

```sh
cmake --preset gcc-debug
cmake --build --preset gcc-debug --parallel
ctest --preset gcc-debug
./out/build/gcc-debug/game/dark_game
```

Use `gcc-development` or `gcc-release` in all four commands for an optimized configuration.

## Build and run on Windows

Open a Visual Studio 2022 Developer PowerShell in the repository root:

```powershell
cmake --preset msvc-debug
cmake --build --preset msvc-debug --parallel
ctest --preset msvc-debug
.\out\build\msvc-debug\game\Debug\dark_game.exe
```

Use `msvc-development` or `msvc-release` for an optimized configuration. The Debug preset enables
AddressSanitizer and copies its runtime beside the executable.

## Prototype workflow

Edit `game/main.c` directly. It uses SDL's callback entry points:

- `SDL_AppInit` initializes SDL and creates the window and renderer.
- `SDL_AppEvent` receives input and window events.
- `SDL_AppIterate` updates and draws one frame.
- `SDL_AppQuit` releases resources.

Use SDL APIs directly; there is no project-owned wrapper layer during the prototype. If the file
becomes uncomfortable to navigate, split code by gameplay concern under `game/` and add each new
`.c` file to `game/CMakeLists.txt`. Do not introduce interfaces solely to hide SDL.

## Add a test

Create a test function using the project assertion macro:

```c
#include "test_runner.h"

void dark_movement_stops_at_wall(void) {
    DARK_TEST_ASSERT(1 + 1 == 2);
}
```

Add its source file to `tests/CMakeLists.txt`, declare it in a header under `tests/`, and register it
in the test array in `tests/main.c`.

## Format source files

Linux or WSL2:

```sh
clang-format -i $(find game tests -type f \( -name '*.c' -o -name '*.h' \))
```

PowerShell:

```powershell
Get-ChildItem game,tests -Recurse -Include *.c,*.h |
    ForEach-Object { clang-format -i $_.FullName }
```

## clangd

Configure the Debug preset once so SDL headers and `compile_commands.json` exist:

```sh
cmake --preset gcc-debug
```

The committed fallback flags point at the downloaded SDL source. For the exact CMake flags, launch
clangd with `--compile-commands-dir=out/build/gcc-debug`, then restart clangd or reload the editor.

## Build configurations

| Configuration | Behavior |
| --- | --- |
| Debug | Debug symbols, warnings as errors, and supported sanitizers |
| Development | Optimization with debug symbols and strict warnings |
| Release | Optimized release build and strict warnings |

GitHub Actions builds and tests all three configurations with GCC on Linux and MSVC on Windows.
See [THIRD_PARTY.md](THIRD_PARTY.md) for SDL attribution.
