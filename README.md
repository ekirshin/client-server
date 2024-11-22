# client-server
Client-server application example with Dockerfile to build the client and server applications and execute inside the container for testing.
Additional gen_version.sh script will insert the full hash of the latest commit the application was compiled against. 
The container will execute the client application twice to test the "VERSION" and "TEST" commands. The results are output to the console.


# Build container
$ docker build -t test-socket-app .

# Run container
$ docker run --rm test-socket-app

# Useful Docker commands
List current Docker containers:
$ docker ps -a
Stop Docker container:
$ docker stop <container ID> 
