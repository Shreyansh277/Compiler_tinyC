
all:
	bison -o y.tab.c -d expr.y
	flex expr.l
	gcc -c y.tab.c -o y.tab.o
	gcc -c lex.yy.c -o lex.yy.o
	gcc -c expr.c -o expr.o
	gcc -o a y.tab.o lex.yy.o expr.o 

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a expr.o lex.yy.o y.tab.o

run:
	./a < input.txt
