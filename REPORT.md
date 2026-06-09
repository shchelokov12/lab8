# Лабораторная работа №08

Студент: Щелоков Александр ИУ8-25

GitHub: shchelokov12

Gmail: aesch8877@gmail.com

## Ход работы
### 1. Подготовка репозитория
```
export GITHUB_USERNAME=shchelokov12

cd ${GITHUB_USERNAME}/workspace
pushd .
source scripts/activate

git clone https://github.com/${GITHUB_USERNAME}/lab07_lab08
cd lab08
git submodule update --init
git remote remove origin
git remote add origin https://github.com/${GITHUB_USERNAME}/lab08
```

### 2. Создание Dockerfile
Dockerfile создавался поэтапно: базовый образ, установка компиляторов и CMake, копирование исходного кода, сборка проекта, переменная окружения для логов, том для хранения логов, Рабочая директория и точка входа:
```
FROM ubuntu:18.04
RUN apt update
RUN apt install -yy gcc g++ cmake
COPY . print/
WORKDIR print
RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install
RUN cmake --build _build
RUN cmake --build _build --target install
ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs
WORKDIR _install/bin
ENTRYPOINT ./demo
```

### 3. Сборка образа
```
docker build -t logger .
docker images
```

### 4. Запуск контейнера
```
mkdir logs
docker run -it -v "$(pwd)/logs/:/home/logs/" logger
```
Ввод данных:
```
text1
text2
text3
<Ctrl-D>
```
Проверка результата:
```
docker inspect logger
cat logs/log.txt
```

### 5. Настройка GitHub Actions
Изменение ссылок в README.md:
`sed -i 's/lab07/lab08/g' README.md`

Создание директории для workflow: 
`mkdir -p .github/workflows`

Создание файла `.github/workflows/docker-build.yml`:

```
name: Docker Build

on:
  push:
    branches: [ master, main ]
  pull_request:
    branches: [ master, main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Build Docker image
      run: docker build -t logger .
    
    - name: Test Docker container
      run: |
        mkdir logs
        echo -e "test1\ntest2\ntest3" | docker run -i -v "$(pwd)/logs/:/home/logs/" logger
        cat logs/log.txt
```

Добавление файлов в Git и push:
```
git add Dockerfile .github/workflows/docker-build.yml
git commit -m "add Dockerfile and GitHub Actions workflow"
git push origin master
```


### 6. Подготовка отчета:
```
popd
export LAB_NUMBER=08
git clone https://github.com/tp-labs/lab${LAB_NUMBER} tasks/lab${LAB_NUMBER}
mkdir reports/lab${LAB_NUMBER}
cp tasks/lab${LAB_NUMBER}/README.md reports/lab${LAB_NUMBER}/REPORT.md
cd reports/lab${LAB_NUMBER}
edit REPORT.md   # замена содержимого на данный отчёт
gist REPORT.md
```

## Вывод
В ходе работы освоены базовые команды Docker: написание Dockerfile, сборка образов, запуск контейнеров с пробросом томов, просмотр информации об образе. Также приобретены навыки интеграции Docker с CI-системой на примере GitHub Actions — современного встроенного инструмента автоматизации GitHub.
