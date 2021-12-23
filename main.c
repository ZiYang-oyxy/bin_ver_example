#include <stdio.h>
#include <string.h>

#ifndef BIN_VER
    #define BIN_VER "nil"
#endif
#define EXAMPLE_BIN_VER_STR "BIN_VER_TYPE example;"BIN_VER
const char *example_version = EXAMPLE_BIN_VER_STR;

int main(int argc, char *argv[])
{
    printf("%s\n", example_version);
    return 0;
}
