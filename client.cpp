#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <cstdlib>

void logErrorAndExit(const std::string &message, int errorCode) 
{
    std::cerr << message << std::endl;
    exit(errorCode);
}

int main(int argc, char *argv[]) 
{
    if (argc != 3) 
    {
        std::cerr << "Usage: " << argv[0] << " <socket_path> <command>" << std::endl;
        return 1;
    }

    const char *socket_path = argv[1];
    const char *command = argv[2];
    int client_fd;
    struct sockaddr_un server_addr;

    // Create socket
    client_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (client_fd < 0) {
        logErrorAndExit("Error creating socket", 2);
    }

    // Connect to server
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, socket_path, sizeof(server_addr.sun_path) - 1);

    if (connect(client_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) 
    {
        logErrorAndExit("Error connecting to socket", 3);
    }

    // Send command
    if (write(client_fd, command, strlen(command)) < 0) 
    {
        logErrorAndExit("Error sending command", 4);
    }

    // Read response
    char buffer[256];
    ssize_t bytesRead = read(client_fd, buffer, sizeof(buffer) - 1);
    if (bytesRead < 0) 
    {
        logErrorAndExit("Error reading response", 5);
    }
    buffer[bytesRead] = '\0';
    std::cout << buffer << std::endl;

    close(client_fd);
    return 0;
}
