#!/bin/bash
# Fetch the latest commit hash
COMMIT_HASH=$(git rev-parse HEAD)

# Create the header file with the commit hash
echo "#ifndef VERSION_H" > version.h
echo "#define VERSION_H" >> version.h
echo "const char* commit_hash = \"${COMMIT_HASH}\";" >> version.h
echo "#endif" >> version.h
