# Makefile

#CC = g++
CFLAGS = -Wall -g
LDFLAGS = -lstdc++

all: generate_version server client

generate_version:
	./gen_version.sh

server: server.o
	$(CXX) $(CFLAGS) -o server server.o $(LDFLAGS)

client: client.o 
	$(CXX) $(CFLAGS) -o client client.o $(LDFLAGS)

server.o: server.cpp version.h
	$(CXX) $(CFLAGS) -c server.cpp

client.o: client.cpp 
	$(CXX) $(CFLAGS) -c client.cpp

clean:
	rm -f *.o server client version.h
