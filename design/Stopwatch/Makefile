SRC = stopwatch_behavioural_tb
dump ?= 1
start ?= 1
stop ?= 9
step ?= 1

test_behavioural_stopwatch:
	iverilog -s $(SRC) \
	-g2012 \
	-P$(SRC).dump=$(dump) \
	-P$(SRC).start=$(start) \
	-P$(SRC).stop=$(stop) \
	-P$(SRC).step=$(step) \
	-o $(SRC).vvp $(SRC).sv stopwatch_behavioural.sv
	vvp $(SRC).vvp
	rm $(SRC).vvp

view:
	gtkwave stopwatch_behavioural_tb.vcd