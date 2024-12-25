all:
	bison -dy tinyc3_22cs30010_22cs30030.y
	flex tinyc3_22cs30010_22cs30030.l
	g++ lex.yy.c y.tab.c tinyc3_22cs30010_22cs30030.cpp -o parser.out



clean:
	rm parser.out  lex.yy.* y.tab.* ./output/*.out

run: parser.out
	@echo "Running test cases\n"
	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test1.c > ./output/tinyc3_22cs30010_22cs30030_quads1.out
	
	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test2.c > ./output/tinyc3_22cs30010_22cs30030_quads2.out

	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test3.c > ./output/tinyc3_22cs30010_22cs30030_quads3.out
	
	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test4.c > ./output/tinyc3_22cs30010_22cs30030_quads4.out

	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test5.c > ./output/tinyc3_22cs30010_22cs30030_quads5.out
	
	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test6.c > ./output/tinyc3_22cs30010_22cs30030_quads6.out
	
	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test7.c > ./output/tinyc3_22cs30010_22cs30030_quads7.out

	./parser.out < ./test/tinyc3_22cs30010_22cs30030_test8.c > ./output/tinyc3_22cs30010_22cs30030_quads8.out
	@echo "Result of test cases generated in output directory\n"
	
