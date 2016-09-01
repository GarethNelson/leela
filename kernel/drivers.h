#ifndef DRIVERS_H
#define DRIVERS_H
#include <stdint.h>

#define DEV_TYPE_CHAR       1
#define DEV_TYPE_BLOCK      2
#define DEV_TYPE_FILESYSTEM 3

typedef struct driver_t driver_t;
typedef struct driver_t {
    driver_t* this;
    uint16_t major;
    uint16_t minor;
} driver_t;

#endif
