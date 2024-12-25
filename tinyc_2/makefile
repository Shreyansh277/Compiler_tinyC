LEX_FILE = tinyC2_22CS30010_22CS30030.l
C_FILE = tinyC2_22CS30010_22CS30030.c
BISON_FILE = tinyC2_22CS30010_22CS30030.y
BISON_OUTPUT = tinyC2_22CS30010_22CS30030.tab.c
BISON_HEADER = tinyC2_22CS30010_22CS30030.tab.h
LEX_OUTPUT = lex.yy.c
EXECUTABLE = a.out
INPUT_FILE = input_22CS30010_22CS30030.c
OUTPUT_FILE = output.txt

all:
	# Clean previous files
	rm -f $(LEX_OUTPUT) $(BISON_OUTPUT) $(BISON_HEADER) $(EXECUTABLE) $(OUTPUT_FILE)
	# Generate Bison files
	bison -d $(BISON_FILE)
	# Generate Lex files
	lex $(LEX_FILE)
	# Compile everything
	gcc $(C_FILE) $(BISON_OUTPUT) $(LEX_OUTPUT) -o $(EXECUTABLE)
	# Run the executable with input
	./$(EXECUTABLE) < $(INPUT_FILE) > $(OUTPUT_FILE)

clean:
	# Clean files
	rm -f $(LEX_OUTPUT) $(BISON_OUTPUT) $(BISON_HEADER) $(EXECUTABLE) $(OUTPUT_FILE)
