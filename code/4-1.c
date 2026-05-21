#include <stdio.h>

#ifdef _WIN32
#include <windows.h>
#define sleep_sec(n) Sleep((n) * 1000)
#else
#include <unistd.h>
#define sleep_sec(n) sleep(n)
#endif

int main(void) {

    for (int i=0; i<10; i++)
        fputs("1111", stdout);
    sleep_sec(1);
    fputc('\n', stdout);

    for (int i=0; i<10; i++)
        fputs("2222", stdout);
    fflush(stdout);
    sleep_sec(1);
    fputc('\n', stdout);
    
    return 0;
}
