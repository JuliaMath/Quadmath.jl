all: libfloat128.so

INCMPFR =  $(HOME)/LibDownloads/mpfr-3.1.3/src
INCMPARAM =  $(HOME)/LibDownloads/mpfr-3.1.3/src/x86_64/core2
INCGMP = $(HOME)/LibDownloads/gmp-6.1.0/

LIBQUADMATH = /usr/lib/x86_64-linux-gnu/libquadmath.so.0
LIBMPFR =  /usr/lib/x86_64-linux-gnu/libmpfr.so.4

float128.o: float128.c
	gcc  -O3 -fPIC -c -o float128.o float128.c 

set_float128.o: set_float128.c
	gcc -O3 -fpic -c -o set_float128.o  \
            -I$(INCGMP) -I$(INCMPFR) -I$(INCGMP) \
            set_float128.c         

get_float128.o: get_float128.c
	gcc -O3 -fpic -c -o get_float128.o  \
            -I$(INCGMP) -I$(INCMPFR) -I$(INCGMP) \
            get_float128.c         

libfloat128.so: float128.o set_float128.o get_float128.o
	gcc -shared -o libfloat128.so  float128.o  set_float128.o get_float128.o \
                       $(LIBMPFR) $(LIBQUADMATH)  


        
