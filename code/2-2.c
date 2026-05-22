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

    while(feof(fp) == 0) {
        fscanf(fp, "%s %d", students[count].name, &students[count].score);
        count++;
    }



    int max = 0;
    float avg = 0;

    int result = 0;
    for(int i = 0; i < count - 1; i++) {
        result += students[i].score;
        if(students[i].score > max) max = students[i].score;
    }
    avg = result/count;



    printf("max: %d\n", max);
    printf("avg: %.2f\n", avg);

    fclose(fp);

    return 0;
}

