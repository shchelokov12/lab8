FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y gcc g++ cmake && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /print/
WORKDIR /print

# Исправлено: _build вместо _build (с подчеркиванием)
RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install && \
    cmake --build _build && \
    cmake --build _build --target install

ENV LOG_PATH=/home/logs/log.txt
VOLUME /home/logs

WORKDIR /print/install/bin

ENTRYPOINT ["./demo"]
