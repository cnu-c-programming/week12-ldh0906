#include <stdio.h>

int main(int argc, const char* argv[], const char* envp[]) {
    const char** env = envp;

    while(*env != NULL) {
        printf("%s\n", *env);
        **env++;
    }

    return 0;
}