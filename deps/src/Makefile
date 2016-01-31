all: shared_lib

ifeq (exists, $(shell [ -e Make.user ] && echo exists ))
include Make.user 
endif


#location of mpfr.h:
INCMPFR =  $(HOME)/LibDownloads/mpfr-3.1.3/src

#location of mparam.h:
INCMPARAM =  $(HOME)/LibDownloads/mpfr-3.1.3/src/x86_64/core2

#location of gmp.h:
INCGMP = $(HOME)/LibDownloads/gmp-6.1.0/

#path to shared quadmath library:
LIBQUADMATH = /usr/lib/x86_64-linux-gnu/libquadmath.so.0

#path to shared mpfr library used by Julia:
LIBMPFR =  /usr/lib/x86_64-linux-gnu/libmpfr.so.4


OBJS = quadmath_wrapper.o get_float128.o  set_float128.o
#LIBS += -lquadmath -L/usr/lib/x86_64-linux-gnu -lmpfr -lgmp -lm
#LIBS += -lquadmath -lm

# Figure out OS and architecture
OS = $(shell uname)
ifeq ($(OS), MINGW32_NT-6.1)
  OS=WINNT
endif

# file extensions
ifeq ($(OS), WINNT)
  SHLIB_EXT = dll 
else ifeq ($(OS), Darwin)
  SHLIB_EXT = dylib
else
  SHLIB_EXT = so
endif


shared_lib: libquadmath_wrapper.$(SHLIB_EXT)

%.c.o: %.c %.h
	$(CC) $< -fPIC -c -o $@ $(INC) $(CFLAGS) $(FLAGS)

quadmath_wrapper.o: quadmath_wrapper.c quadmath_wrapper.h
	gcc  -O3 -g -fPIC -c -o quadmath_wrapper.o quadmath_wrapper.c 

set_float128.o: set_float128.c quadmath_wrapper.h
	gcc -O3 -fpic -c -o set_float128.o  \
            -I$(INCGMP) -I$(INCMPFR) -I$(INCMPARAM) \
            set_float128.c         

get_float128.o: get_float128.c quadmath_wrapper.h
	gcc -O3 -fpic -c -o get_float128.o  \
            -I$(INCGMP) -I$(INCMPFR) -I$(INCMPARAM) \
            get_float128.c         
        

libquadmath_wrapper.$(SHLIB_EXT): $(OBJS)
	$(CC) $(OBJS) -rdynamic -shared -o $@ $(LDFLAGS) $(LIBS)

clean:
	rm -f *.o *.$(SHLIB_EXT)
