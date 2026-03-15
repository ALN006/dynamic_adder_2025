SRC = adder_tb
N ?= 16
NAND_D ?= 1
XOR_D ?= 1

all:
	iverilog -g2012 -D$(ADDER) -P$(SRC).N=$(N) -P$(SRC).NAND_D=$(NAND_D) -P$(SRC).XOR_D=$(XOR_D) -o $(ADDER).vvp $(SRC).v 