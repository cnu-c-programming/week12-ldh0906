#include <stdio.h>

int main(int argc, const char* argv[]) {
    if (argc < 3)
        return 0;

    FILE* fp_src = fopen(argv[1], "r");
    FILE* fp_dst = fopen(argv[2], "w");

    char line[128];
    while(fgets(line, sizeof line, fp_src)) 
        fputs(line, fp_dst);

    fclose(fp_src);
    fclose(fp_dst);
}

