FROM alpine:3.14

LABEL maintainer="PythonMove <pythonmove@gmail.com>"

ENV BAZEL_VERSION="3.7.2" \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

RUN apk add --no-cache --update python3 py3-pip libstdc++ libexecinfo-dev bash openjdk11 build-base gcc g++ linux-headers zip unzip \
    && rm -rf /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install -U --user --no-cache-dir pip setuptools wheel \
    && cd /tmp \
    && wget -q https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip \
    && mkdir bazel-${BAZEL_VERSION} \
    && unzip -qd bazel-${BAZEL_VERSION} bazel-${BAZEL_VERSION}-dist.zip \
    && cd bazel-${BAZEL_VERSION} \
    && wget -q https://github.com/PythonMove/alpine-python3-tensorflow/raw/main/bazel_src/linux-sandbox-pid1.cc -O src/main/tools/linux-sandbox-pid1.cc \
    && env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh \
    && cp -p output/bazel /usr/bin/ \
    && rm -rf /tmp/* /root/.cache/*
