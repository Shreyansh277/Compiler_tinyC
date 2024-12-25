
all:
	bison -d expr.y
	flex expr.l
	gcc intcodegen.c 
	./a.out < sample.txt > output.c
	gcc output.c -o output
	./output > finaloutput

clean:
	rm lex.yy.c expr.tab.c expr.tab.h *.out output finaloutput output.c
