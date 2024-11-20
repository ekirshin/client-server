#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <cstdlib>
#include "version.h"

#define BUFFER_SIZE 256

void logErrorAndExit(const std::string &message, int errorCode) 
{
    std::cerr << message << std::endl;
    exit(errorCode);
}

int main(int argc, char *argv[]) 
{
    if (argc != 2) 
    {
        std::cerr << "Usage: " << argv[0] << " <socket_path>" << std::endl;
        return 1;
    }

    const char *socket_path = argv[1];
    int server_fd, client_fd;
    struct sockaddr_un server_addr;

    // Create socket
    server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_fd < 0) 
    {
        logErrorAndExit("Error creating socket", 2);
    }

    // Bind socket to address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, socket_path, sizeof(server_addr.sun_path) - 1);
    unlink(socket_path);

    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) 
    {
        logErrorAndExit("Error binding socket", 3);
    }

    // Listen for connections
    if (listen(server_fd, 5) < 0) 
    {
        logErrorAndExit("Error listening on socket", 4);
    }

    std::cout << "Server is listening on " << socket_path << std::endl;

    // Accept client connections
    while (true) 
    {
        client_fd = accept(server_fd, NULL, NULL);
        if (client_fd < 0) 
        {
            logErrorAndExit("Error accepting connection", 5);
        }

        char buffer[BUFFER_SIZE];
        ssize_t bytesRead = read(client_fd, buffer, sizeof(buffer));
        if (bytesRead > 0) 
        {
            buffer[bytesRead] = '\0';
            std::string command(buffer);

            if (command == "VERSION") 
            {
                std::string response = commit_hash;
                write(client_fd, response.c_str(), response.size());
            } 
            else 
            {
                std::string response = "REJECTED";
                write(client_fd, response.c_str(), response.size());
            }
        }

        close(client_fd);
    }

    close(server_fd);
    unlink(socket_path);
    return 0;
}
