#!/bin/bash

CC=x10c++
EXEC=convert bisec test
all: $(EXEC)
test : src/Test.x10
	$(CC) -O -optimize -o bin/$@ $^
	mv *.h obj/
	mv *cc obj/
convert : src/Convert.x10
	$(CC) -O -optimize -o bin/$@ $^
	mv *.h obj/
	mv *cc obj/
bisec: src/BisecMain.x10
	$(CC) -O -optimize -o bin/$@ $^
	mv *.h obj/
	mv *cc obj/
install:all
	mv *.h obj/
	mv *cc obj/
##########################################
# Generic rules
##########################################

clean:
	rm -f *cc *h obj/*.cc *~ obj/*.h bin/$(EXEC)
