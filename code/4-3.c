#include <stdio.h>

int main(void) {
    FILE* fp = fopen("4-4-buf.txt", "w");
    if (fp == NULL) {
        return 0;
    }

    int count = 1;
    while (1) {
        for (int i = 1; i <= 20; i++) {
            fprintf(fp, "%5dbyte%21s\n", count++ * 32, " ");
        }
        printf("Press Enter to continue...");
        char c = getc(stdin);
        if (c != '\n')
            break;
    }
    fclose(fp);
    return 0;
}
