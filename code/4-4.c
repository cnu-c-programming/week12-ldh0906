#include <stdio.h>

int main(void) {
    FILE* fp1 = fopen("4-5-buf-1.txt", "w");
    FILE* fp2 = fopen("4-5-buf-2.txt", "w");
    char c;

    fprintf(stdout, "[stdout] message 1\n");
    fprintf(stderr, "[stderr] message 1\n");
    fprintf(fp1,    "[file1 ] message 1\n");
    fprintf(fp2,    "[file2 ] message 1\n");

    printf("Press Enter to fflush(NULL)...");
    c = getc(stdin);
    fflush(NULL);
    printf("fflush(NULL) done. '4-5-buf.txt' should now contain file messages.\n");

    fprintf(stdout, "[stdout] message 2\n");
    fprintf(stderr, "[stderr] message 2\n");
    fprintf(fp1,    "[file1 ] message 2\n");
    fprintf(fp2,    "[file2 ] message 2\n");

    printf("Press Enter to fflush(NULL)...");
    c = getc(stdin);
    fflush(NULL);
    printf("fflush(NULL) done. '4-5-buf.txt' should now contain file messages.\n");

    fclose(fp1);
    fclose(fp2);
    return 0;
}
