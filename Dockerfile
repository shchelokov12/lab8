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

# Создаем wrapper-скрипт, который гарантированно создает лог
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'LOG_PATH="${LOG_PATH:-/home/logs/log.txt}"' >> /entrypoint.sh && \
    echo 'mkdir -p "$(dirname "$LOG_PATH")"' >> /entrypoint.sh && \
    echo 'echo "=== Starting logger ==="' >> /entrypoint.sh && \
    echo 'while IFS= read -r line; do' >> /entrypoint.sh && \
    echo '    echo "$line" | tee -a "$LOG_PATH"' >> /entrypoint.sh && \
    echo 'done' >> /entrypoint.sh && \
    echo 'echo "=== Log saved to: $LOG_PATH ==="' >> /entrypoint.sh && \
    echo 'echo "=== Content of log file ==="' >> /entrypoint.sh && \
    echo 'cat "$LOG_PATH"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

ENTRYPOINT ["/entrypoint.sh"]
