#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct config {
    char InputFileName[64];
    int Options;
    char SectionName[64];
    unsigned long long Address;
} Config;

void config_parser(Config* config_ptr) {

}

int main(int argc, const char* argv[]) {
    Config config;
    config_parser(&config);

    printf("config: %s %d %s %llu\n", 
        config.InputFileName, 
        config.Options,
        config.SectionName,
        config.Address);
    return 0;
}

