#include <stdio.h>
#include <stdlib.h>

int main(int argc, const char* argv[]) {
    int mode = (argc >= 2) ? atoi(argv[1]) : 0;

    FILE* fp = fopen("4-2-log.txt", "w");
    if (fp == NULL) {
        return 0;
    }

    fprintf(fp, "mode %d\n", mode);

    if (mode == 1) {
        fclose(fp);
    } else if (mode == 2) {
        _Exit(0);
    }

    return 0;
}
