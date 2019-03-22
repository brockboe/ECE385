
default: aes

aes.o: main.c aes.h crypto.h
	gcc -c -g main.c -o aes.o

crypto.o: crypto.c aes.h crypto.h
	gcc -c -g crypto.c -o crypto.o

aes: aes.o crypto.o
	gcc aes.o crypto.o -o aes

clean:
	-rm -f aes.o
