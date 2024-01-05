CFLAGS  := -m64 -g
LDFLAGS := -m64 -g -L/usr/local/lib64 -Wl,-rpath,/usr/local/lib64

parser: parser.c

parser.c: parser.y
	bison -o $@ $<
