dump ?= 0
tests ?= 100_000
start ?= 8
stop ?= 33
step ?= 4

behavioural: 
	iverilog -s behavioural_adder_tb \
	-g2012 \
	-Pbehavioural_adder_tb.dump=$(dump) \
	-Pbehavioural_adder_tb.tests=$(tests) \
	-Pbehavioural_adder_tb.start=$(start) \
	-Pbehavioural_adder_tb.stop=$(stop) \
	-Pbehavioural_adder_tb.step=$(step) \
	-o behavioural_adder.vvp behavioural_adder_tb.sv adder_behavioural.sv
	vvp behavioural_adder.vvp
	rm behavioural_adder.vvp