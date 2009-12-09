main: start anic.exe
	
all: start cleanout test

start:
	@echo anic ANI Compiler Makefile
	
anic.exe: Makefile tmp/version.exe var/lexerStruct.h bld/hexTruncate.awk \
		src/mainDefs.h src/constantDefs.h src/globalVars.h \
		src/system.h src/customOperators.h src/lexer.h \
		src/core.cpp src/system.cpp src/customOperators.cpp src/lexer.cpp
	@echo Building main executable...
	@g++ src/core.cpp src/system.cpp src/customOperators.cpp src/lexer.cpp \
	-D BUILD_NUMBER_MAIN="\"`./tmp/version.exe`\"" \
	-D BUILD_NUMBER_SUB="\"` date | crypt password | awk -f bld/hexTruncate.awk `\"" \
	-o anic.exe \
	-O3 \
	-Wall
	@echo Done building main executable.
	
tmp/version.exe: bld/version.c src/mainDefs.h src/constantDefs.h
	@echo Building version controller...
	@mkdir -p var
	@mkdir -p tmp
	@gcc bld/version.c -o tmp/version.exe
	
var/lexerStruct.h: tmp/lexerStructGen.exe src/lexerTable.txt
	@echo Generating lexer structure...
	@mkdir -p var
	@./tmp/lexerStructGen.exe

tmp/lexerStructGen.exe: bld/lexerStructGen.c
	@echo Building lexer structure generator...
	@mkdir -p tmp
	@gcc bld/lexerStructGen.c -o tmp/lexerStructGen.exe
	
test: anic.exe
	@echo
	@echo ...Running default test cases...
	@echo
	./anic.exe -v ./tst/test.ani
	@echo Done running tests.

clean: cleanout
	@echo Cleaning temporary files...
	@rm -R -f var
	@rm -R -f tmp
	
cleanout:
	@echo Cleaning output...
	@rm -f anic.exe
	@rm -f tmp/version.exe
	@rm -f tmp/lexerStructGen.exe
