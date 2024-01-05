# Makefile

CFLAGS  := -m64 -g
LDFLAGS := -m64 -g -L/usr/local/lib64 -Wl,-rpath,/usr/local/lib64

all: parser

clean:
	rm -f parser parser.c parser.h lexpars.c 2>/dev/null || true

parser: parser.c lexpars.c

%.c %.h: %.y
	bison -o $*.c -H$*.h $<

%.c: %.flex
	flex -o $@ $<
