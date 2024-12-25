.SUFFIXES: .c .o

LEX_FILE = poly.l
C_FILE = polyutils.c
BISON_FILE = poly.y
BISON_OUTPUT = poly.tab.c
BISON_HEADER = poly.tab.h
LEX_OUTPUT = lex.yy.c
EXECUTABLE = a.out
INPUT_FILE = sample.txt
OUTPUT_FILE = output.txt

all:
	# Clean previous files
	rm -f $(LEX_OUTPUT) $(BISON_OUTPUT) $(BISON_HEADER) $(EXECUTABLE) $(OUTPUT_FILE)
	# Generate Bison files
	bison -d $(BISON_FILE)
	# Generate Lex files
	lex $(LEX_FILE)
	# Compile everything
	gcc -x c $(C_FILE) $(BISON_OUTPUT) $(LEX_OUTPUT) -lm -o $(EXECUTABLE)


run :
	# Run the executable with input
	./$(EXECUTABLE) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	# Clean files
	rm -f $(LEX_OUTPUT) $(BISON_OUTPUT) $(BISON_HEADER) $(EXECUTABLE) $(OUTPUT_FILE)