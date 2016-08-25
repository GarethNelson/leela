#include <sys/stat.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/times.h>
#include <sys/errno.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
 
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

void* sbrk_ptr=NULL;
void* sbrk_base=NULL;
uint64_t sbrk_offs=0;
unsigned char sbrk_heap[65536];
caddr_t sbrk(int incr) { 
    if(sbrk_ptr==NULL) sbrk_ptr = sbrk_base = (void*)sbrk_heap;
    if((sbrk_offs+incr) > 65535) {
      errno = ENOMEM;
      return (caddr_t)-1;
    }
    caddr_t old_sbrk = (caddr_t)sbrk_ptr;
    sbrk_ptr += incr;
    sbrk_offs += incr;
    return old_sbrk;
//    errno = ENOSYS;
//    return (caddr_t)-1;
}

extern void* kalloc();
void* malloc(size_t size) {
      if(size <= 4096) return kalloc();
      errno = ENOMEM;
      return NULL;
}

extern void kfree(void* ptr);
void free(void* ptr) {
      kfree(ptr);
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

void cprintf(char* fmt, ...);
int printf(const char *format, ...) {
    va_list ap;
    va_start(ap, format);
     cprintf(format, ap);
    va_end(ap);
}

int write(int file, char *ptr, int len) {
    consolewrite(NULL,ptr,len);
    return len;
}
