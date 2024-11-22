# client-server
Client-server application example with Dockerfile to build the client and server applications inside the container for aarch64 platform.
The container will install the toolchain and build the applications with the binaries placed in the /output folder.

# Build container
$ docker build -t test-socket-app .

# Run container
$ docker run --rm -v $(pwd)/output:/usr/src/app/output test-socket-app

# Run in interative mode
$ docker run -it --rm -v $(pwd)/output:/usr/src/app/output test-socket-app

# Useful Docker commands
List current Docker containers:
$ docker ps -a
Stop Docker container:
# docker stop <container ID>  

