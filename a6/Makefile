LEX_FILE = prog.l
C_FILE =codegen.c
BISON_FILE = prog.y
BISON_OUTPUT = prog.tab.c
BISON_HEADER = prog.tab.h
LEX_OUTPUT = lex.yy.c
EXE = ./a.out
INPUT = sample.txt
OUTPUT_FILE = output.txt

all: 
	rm -f $(LEX_OUTPUT) $(EXE) $(BISON_OUTPUT) $(OUTPUT_FILE) $(BISON_HEADER)
	bison -d $(BISON_FILE)
	flex $(LEX_FILE)
	gcc $(C_FILE) $(LEX_OUTPUT) $(BISON_OUTPUT)
	$(EXE) < $(INPUT) > $(OUTPUT_FILE)

post_clean:
	rm -f $(LEX_OUTPUT) $(EXE) $(BISON_OUTPUT) $(OUTPUT_FILE) $(BISON_HEADER)