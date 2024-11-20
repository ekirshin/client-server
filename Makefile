# Makefile

CC = g++
CFLAGS = -Wall -g

all: generate_version server client

generate_version:
	./gen_version.sh

server: server.o
	$(CC) $(CFLAGS) -o server server.o

client: client.o 
	$(CC) $(CFLAGS) -o client client.o

server.o: server.cpp version.h
	$(CC) $(CFLAGS) -c server.cpp

client.o: client.cpp 
	$(CC) $(CFLAGS) -c client.cpp

clean:
	rm -f *.o server client version.h
