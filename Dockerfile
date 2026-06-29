FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y gcc g++ cmake && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /print/
WORKDIR /print

RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install && \
    cmake --build _build && \
    cmake --build _build --target install

WORKDIR /print/install/bin

# Скрипт для сохранения ввода в файл
RUN echo '#!/bin/bash' > /entry.sh && \
    echo 'mkdir -p /logs' >> /entry.sh && \
    echo 'while IFS= read -r line; do' >> /entry.sh && \
    echo '    echo "$line" | tee -a /logs/log.txt' >> /entry.sh && \
    echo 'done' >> /entry.sh && \
    chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]
