
CC = gcc
CFLAGS = -pthread -D KXVER=3
OBJECTS = main.o c.o

all: clean $(OBJECTS)
	$(CC) -o feed $(CFLAGS) $(OBJECTS)

make.o: make.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf make.o feed *~
