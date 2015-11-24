all: libfloat128.so

float128.o: float128.c
	gcc  -O3 -fPIC -c -o float128.o float128.c 

libfloat128.so: float128.o
	gcc -shared -o libfloat128.so  float128.o -lquadmath

