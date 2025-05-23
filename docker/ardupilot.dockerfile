# sourced from https://github.com/ArduPilot/ardupilot_dev_docker/blob/master/docker/Dockerfile_dev-base
# and https://github.com/unl-nimbus-lab/SwarmPlanner/blob/demo_do_not_change/uav_simulator/ardupilot_docker/Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    lsb-release \
    sudo \
    wget \
    software-properties-common \
    astyle \
    build-essential  \
    ccache \
    g++ \
    gdb \
    gawk \
    git \
    make \
    cmake \
    ninja-build \
    libtool \
    libxml2-dev \
    libxml2-utils \
    libxslt1-dev \
    python3-numpy \
    python3-pyparsing \
    python3-serial \
    python-is-python3 \
    libpython3-stdlib \
    libtool-bin \
    zip \
    iputils-ping \
    netcat \
    && apt-get clean \
    && apt-get -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TAKEN from https://github.com/docker-library/python/blob/a58630aef106c8efd710011c6a2a0a1d551319a0/3.11/bullseye/Dockerfile
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 23.1.2
# https://github.com/docker-library/python/issues/365
ENV PYTHON_SETUPTOOLS_VERSION 65.5.1
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/9af82b715db434abb94a0a6f3569f43e72157346/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 45a2bb8bf2bb5eff16fdd00faef6f29731831c7c59bd9fc2bf1f3bed511ff1fe

RUN set -eux; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
	\
	export PYTHONDONTWRITEBYTECODE=1; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		--no-compile \
		"pip==$PYTHON_PIP_VERSION" \
		"setuptools==$PYTHON_SETUPTOOLS_VERSION" \
	; \
	rm -f get-pip.py; \
	\
	pip --version

RUN python -m pip install --no-cache-dir -U future lxml pexpect flake8 pycodestyle empy==3.3.4 pyelftools tabulate pre-commit junitparser

RUN mkdir -p /__w/ardupilot/ardupilot && git config --global --add safe.directory /__w/ardupilot/ardupilot && git config --system --add safe.directory /__w/ardupilot/ardupilot

# Set ccache to the PATH
ENV PATH="/usr/lib/ccache:$PATH"

# Gain some time by disabling mavnative
ENV DISABLE_MAVNATIVE=True

# Set the buildlogs directory into /tmp as other directory aren't accessible
ENV BUILDLOGS=/tmp/buildlogs

ENV TZ=UTC

WORKDIR /home
RUN git clone https://github.com/ingmarfjolla/ardupilot.git
WORKDIR /home/ardupilot
# RUN git checkout master
RUN pip install MAVproxy
RUN git submodule update --init --recursive

RUN ./waf configure --board sitl
RUN ./waf copter

EXPOSE 5760
EXPOSE 5763
EXPOSE 14550/udp