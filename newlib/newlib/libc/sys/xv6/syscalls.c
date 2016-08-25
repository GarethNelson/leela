#include <sys/stat.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/times.h>
#include <sys/errno.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdint.h>
 
void _exit();
int close(int file) {}
char **environ; /* pointer to array of char * strings that define the current environment variables */
int execve(char *name, char **argv, char **env);
int fork();
int fstat(int file, struct stat *st) {
    if(file <= 2) {
       st->st_mode    = S_IFCHR;
       st->st_blksize = 0;
       return 0;
    }
    errno = EBADF;
    return -1;
}
int getpid();
int isatty(int file) {
    if(file <= 2) return 1;
    errno = EINVAL;
    return 0;
}
int kill(int pid, int sig);
int link(char *old, char *new);
int lseek(int file, int ptr, int dir) {}
int open(const char *name, int flags, ...);
int read(int file, char *ptr, int len) {}

void* kalloc();
caddr_t sbrk(int incr) {
    return (caddr_t)kalloc();
}
int stat(const char *file, struct stat *st) {
    if(file <= 2) {
       st->st_mode    = S_IFCHR;
       st->st_blksize = 0;
       return 0;
    }
    errno = EBADF;
    return -1;
}
clock_t times(struct tms *buf);
int unlink(char *name);
int wait(int *status);

int
consolewrite(void *ip, char *buf, int n);

int write(int file, char *ptr, int len) {
//    if(file != 1) return 0;
    consolewrite(NULL,ptr,len);
    return len;
}
