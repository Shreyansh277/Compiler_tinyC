
LEX_FILE = ass3_22CS30010_22CS30030.l
C_FILE = ass3_22CS30010_22CS30030.c
LEX_OUTPUT = lex.yy.c
EXECUTABLE = a.out
INPUT_FILE = ass3_22CS30010_22CS30030_test.c
OUTPUT_FILE = output.txt


all: clean compile run post_clean

# Clean target: Remove old generated files
clean:
	rm -f $(LEX_OUTPUT) $(EXECUTABLE)

# Compile target: Generate lex.yy.c, compile lex.yy.c and c file
compile: $(LEX_FILE) $(C_FILE)
	flex $(LEX_FILE)
	gcc  $(C_FILE) 

# Run target: Execute the compiled program with the input file
run: $(EXECUTABLE)
	./$(EXECUTABLE) < $(INPUT_FILE) 

post_clean:
	rm -f $(LEX_OUTPUT) $(EXECUTABLE)


