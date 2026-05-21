#include <stdio.h>

int main(int argc, const char* argv[]) {
    const char* filename = "numbers.txt";

    FILE* fp = fopen(filename, "r");
    if (fp == NULL) {
        return 0;
    }


    int sum = 0;


    printf("sum: %d\n", sum);
    fclose(fp);
    return 0;
}
