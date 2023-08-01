foo.o: foo.h foo.c
	gcc -c -fPIC -o foo.o foo.c

foo.so: foo.o
	gcc -shared -fPIC -Wl,-soname,foo.so -o foo.so foo.o

# bar.so: bar.h bar.c foo.so
# 	gcc -L ${PWD} -shared -fPIC -Wl,-soname,bar.so -o bar.so -c bar.c -l:foo.so

bar.o: bar.h bar.c
	gcc -c -fPIC -o bar.o bar.c

bar.so: bar.o
	gcc -L ${PWD} -shared -fPIC -Wl,-soname,bar.so -o bar.so bar.o -l:foo.so

baz: baz.c
	gcc -L ${PWD} -o baz baz.c -l:bar.so -l:bar.so -l:foo.so

.PHONY:execute
execute: baz
	LD_LIBRARY_PATH=$(shell pwd) ./baz

.PHONY: clean
clean:
	rm -f *.so *.o baz
