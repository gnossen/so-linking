.SUFFIXES:

.PHONY: all
all: baz

foo.o: foo.h foo.c
	gcc -c -fPIC -o foo.o foo.c

foo.so: foo.o
	gcc -shared -fPIC -Wl,-soname,foo.so -o foo.so foo.o

bar.o: bar.h bar.c
	gcc -c -fPIC -o bar.o bar.c

bar.so: bar.o foo.so
	gcc -L ${PWD} -shared -fPIC -Wl,-soname,bar.so -o bar.so bar.o -l:foo.so

baz: baz.c bar.so foo.so
	gcc -L ${PWD} -o baz baz.c -l:bar.so -l:foo.so

.PHONY:execute
execute: baz
	LD_LIBRARY_PATH=$(shell pwd) ./baz

.PHONY: clean
clean:
	rm -f *.so *.o baz
