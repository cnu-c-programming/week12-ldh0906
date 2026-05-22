#include <stdio.h>

int main(int argc, const char* argv[]) {
    const char* filename = "numbers.txt";

    FILE* fp = fopen(filename, "r");
    if (fp == NULL) {
        return 0;
    }

    int sum = 0;
    
    char ch[5];
    while (fgets(ch, sizeof ch, fp)) {
        int isdigit = 1;
        int num = 0;

        for (int i = 0; i < 5; i++) {
            if (ch[i] == '\n')
                break;

            if (ch[i] < '0' || ch[i] > '9') {
                fprintf("invalid input %s\n", ch);
                isdigit = 0;
                break;
            }

            num = num * 10 + ch[i] - '0';
        }

        if (isdigit)
            sum += num;
    }
    printf("sum: %d\n", sum);
    fclose(fp);
    return 0;
}
