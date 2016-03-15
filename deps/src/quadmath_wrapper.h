#include <stdint.h>
#include <quadmath.h> 

typedef struct {
    uint32_t _d[4];
} myfloat128;

typedef struct {
    uint32_t _d[8];
} mycomplex128;

#define F(x) (*((__float128*)&(x)))
#define W(x) (*((myfloat128*)&(x)))
#define C(x) (*((__complex128*)&(x)))
#define Z(x) (*((mycomplex128*)&(x)))

