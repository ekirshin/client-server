# Stage 1: Build stage
FROM ubuntu:22.04 

# Set the maintainer
LABEL maintainer="ekirshin.pro@gmail.com"

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    git \
    wget \
    software-properties-common \
    && apt-get clean

# Download and install the latest aarch64 toolchain from Bootlin
RUN wget https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--glibc--stable-2024.05-1.tar.xz \
    && tar -xJf aarch64--glibc--stable-2024.05-1.tar.xz \
    && mv aarch64--glibc--stable-2024.05-1 /usr/local/aarch64-toolchain \
    && rm aarch64--glibc--stable-2024.05-1.tar.xz

# Add the toolchain to the PATH
ENV PATH="/usr/local/aarch64-toolchain/bin:$PATH"
ENV CROSS_COMPILE=/usr/local/aarch64-toolchain/bin/aarch64-buildroot-linux-gnu-

# Create a directory for the application
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy the source code into the container
COPY . /usr/src/app

# Generate the commit hash header file
#RUN ./generate_commit_hash.sh

# Cross-compile the server and client applications for aarch64
RUN make CC=${CROSS_COMPILE}gcc CXX=${CROSS_COMPILE}g++ LDFLAGS="-lstdc++" ARCH=aarch64 all

# Ensure the directory for compiled binaries exists
RUN mkdir -p /usr/src/app/output

# Copy compiled binaries to the output directory
RUN cp ./server ./client /usr/src/app/output/

# Define the output volume
VOLUME /usr/src/app/output

# Provide feedback when the container is run
#CMD ["sh", "-c", "echo 'Compiled binaries are available in /usr/src/app/output'", "bash"]
CMD ["bash"]
