# Use the latest version of Ubuntu as the base image
FROM ubuntu:22.04

# Set the maintainer label
LABEL maintainer="email@mail.com"

# Update and install necessary packages 
RUN apt-get update && apt-get install -y \ 
    build-essential \ 
    g++ \ 
    git \ 
    wget \
    make \
    libc6-dev \
    software-properties-common \
    libstdc++6 \
    libglib2.0-0 \
    && apt-get clean

# Upgrade libstdc++ to ensure the correct version 
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y \ 
    && apt-get update \ 
    && apt-get install -y libstdc++6

# Create a directory for the application 
WORKDIR /usr/src/app

# Copy the source code into the container 
COPY . /usr/src/app

# Compile applications
RUN make all 

# Copy the start script into the container 
COPY start.sh /usr/src/app/start.sh 
RUN chmod +x /usr/src/app/start.sh 

# Set the entry point to run the start script 
ENTRYPOINT ["/usr/src/app/start.sh"]

# Set the entry point to run the server application 
#ENTRYPOINT ["./server", "/tmp/socket"]
