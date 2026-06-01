# Лабораторная работа №07

Студент: Щелоков Александр ИУ8-25

GitHub: shchelokov12

Gmail: aesch8877@gmail.com

## Ход работы
### 1. Подготовка окружения и клонирование
```
export GITHUB_USERNAME=shchelokov12
alias gsed=sed

cd ${GITHUB_USERNAME}/workspace
pushd .
source scripts/activate

git clone https://github.com{GITHUB_USERNAME}/lab06 projects/lab07
cd projects/lab07
git remote remove origin
git remote add origin https://github.com{GITHUB_USERNAME}/lab07
```

### 2. Скачивание специального CMake-модуля `HunterGate.cmake`, который отвечает за автоматическую инициализацию Hunter
```
mkdir -p cmake
wget https://githubusercontent.com -O cmake/HunterGate.cmake
git rm -rf third-party/gtest
```

Финальная рабочая конфигурация `CMakeLists.txt`:
```
cmake_minimum_required(VERSION 3.10)
include("cmake/HunterGate.cmake")
HunterGate(
    URL "https://github.com"
    SHA1 "5659b15dc0884d4b03dbd95710e6a1fa0fc3258d"
)
project(print)
set(PRINT_VERSION_MAJOR 0)
set(PRINT_VERSION_MINOR 1)
set(PRINT_VERSION_PATCH 0)
set(PRINT_VERSION "${PRINT_VERSION_MAJOR}.${PRINT_VERSION_MINOR}.${PRINT_VERSION_PATCH}")
set(PRINT_VERSION_STRING "v${PRINT_VERSION}")
hunter_add_package(GTest)
find_package(GTest REQUIRED)
add_library(print STATIC sources/print.cpp)
target_include_directories(print PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)
option(BUILD_TESTS "Build tests" OFF)
if(BUILD_TESTS)
  enable_testing()
  add_executable(test1 test.cpp)
  target_link_libraries(test1 print GTest::gtest_main)
  add_test(NAME test1 COMMAND test1)
endif()
```

### 3. Сборка с тестами
```
cmake -H. -B_builds -DBUILD_TESTS=ON
cmake --build _builds
cmake --build _builds --target test
```

### 4. Локальная копия Hunter
```
git clone https://github.com/cpp-pm/hunter $HOME/projects/hunter
export HUNTER_ROOT=$HOME/projects/hunter
rm -rf _builds
cmake -H. -B_builds -DBUILD_TESTS=ON
cmake --build _builds
cmake --build _builds --target test
```

### 5. Настройка конкретной версии GTest
Создан файл `cmake/Hunter/config.cmake`:
```
hunter_config(GTest VERSION 1.7.0~hunter-9)
```
В `HunterGate` добавлен параметр `LOCAL`

### 6.  Создание демонстрационного приложения `demo`
Файл `demo/main.cpp` – читает строки из stdin и записывает их в файл, указанный в `LOG_PATH`.
В CMakeLists.txt добавлено:
```
add_executable(demo ${CMAKE_CURRENT_SOURCE_DIR}/demo/main.cpp)
target_link_libraries(demo print)
install(TARGETS demo RUNTIME DESTINATION bin)
```

### 7. Использование polly для кроссплатформенной сборки
```
mkdir tools
git submodule add https://github.com/ruslo/polly tools/polly
tools/polly/bin/polly.py --test
tools/polly/bin/polly.py --install
tools/polly/bin/polly.py --toolchain clang-cxx14
```

### 8. Формирование отчета
```
popd
export LAB_NUMBER=07
git clone https://github.com/tp-labs/lab${LAB_NUMBER} tasks/lab${LAB_NUMBER}
mkdir reports/lab${LAB_NUMBER}
cp tasks/lab${LAB_NUMBER}/README.md reports/lab${LAB_NUMBER}/REPORT.md
cd reports/lab${LAB_NUMBER}
edit REPORT.md
gist REPORT.md
```

## Вывод
В ходе лабораторной работы изучены современные подходы к управлению C++ зависимостями (Hunter), настройка CMake для тестирования и кроссплатформенная сборка с помощью polly.
