all: libfloat128.so

float128.o: float128.c
	gcc  -O3 -fPIC -c -o float128.o float128.c 

set_float128.o: set_float128.c
	gcc -O3 -fpic -c -I/home/hofi/LibDownloads/mpfr-3.1.3/src -I/home/hofi/include -o set_float128.o -I/home/hofi/LibDownloads/mpfr-3.1.3/src/x86_64/core2  set_float128.c         

get_float128.o: get_float128.c
	gcc -O3 -fpic -c -I/home/hofi/LibDownloads/mpfr-3.1.3/src -I/home/hofi/include -o get_float128.o -I/home/hofi/LibDownloads/mpfr-3.1.3/src/x86_64/core2  get_float128.c         

libfloat128.so: float128.o set_float128.o get_float128.o
	gcc -shared -o libfloat128.so  float128.o  set_float128.o get_float128.o -lquadmath -L/usr/lib/sagemath/local/lib/ -lmpfr


        
