#include <stdio.h>
#include <string.h>

typedef struct student {
    char name[64];
    int score;
} Student;

int main(int argc, const char* argv[]) {
    FILE* fp = fopen("student.txt", "r");
    int count = 0;
    Student students[64];



    int max = 0;
    float avg = 0;



    printf("max: %d\n", max);
    printf("avg: %.2f\n", avg);

    fclose(fp);

    return 0;
}

