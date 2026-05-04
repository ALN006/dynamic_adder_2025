SRC = adder_tb
test ?= 0
start ?= 2
stop ?= 8
step ?= 1
dump ?= 0
tests ?=  100
test ?=  1
seed ?= 42
NAND_D ?= 1
XOR_D ?= 1

all:
	iverilog -s $(SRC) \
	-g2012 -D$(ADDER) \
	-P$(SRC).test=$(test) \
	-P$(SRC).start=$(start) \
	-P$(SRC).stop=$(stop) \
	-P$(SRC).step=$(step) \
	-P$(SRC).dump=$(dump) \
	-P$(SRC).tests=$(tests) \
	-P$(SRC).test=$(test) \
	-P$(SRC).seed=$(seed) \
	-P$(SRC).NAND_D=$(NAND_D) \
	-P$(SRC).XOR_D=$(XOR_D) \
	-o $(ADDER).vvp $(SRC).sv design/RCA/RCA.sv design/RCA/FA.sv design/adder.v design/KSA/KSA.v
	vvp $(ADDER).vvp
	rm $(ADDER).vvp
clean:
	rm -f *.vvp *.vcd results.csv
wave:
	gtkwave adder.vcd
