SRC = adder_tb
start ?= 1
stop ?= 2
step ?= 1
dump ?= 0
tests ?=  100
seed ?= 42
NAND_D ?= 1
XOR_D ?= 1

all:
	iverilog -s $(SRC) \
	-g2012 -D$(ADDER) \
	-P$(SRC).start=$(start) \
	-P$(SRC).stop=$(stop) \
	-P$(SRC).step=$(step) \
	-P$(SRC).dump=$(dump) \
	-P$(SRC).tests=$(tests) \
	-P$(SRC).seed=$(seed) \
	-P$(SRC).NAND_D=$(NAND_D) \
	-P$(SRC).XOR_D=$(XOR_D) \
	-o $(ADDER).vvp $(SRC).v RCA/RCA.v RCA/FA.v new_adder/adder.v
	vvp $(ADDER).vvp
	rm $(ADDER).vvp
clean:
	rm -f *.vvp *.vcd results.csv