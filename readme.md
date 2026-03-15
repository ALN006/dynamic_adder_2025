# Dynamic Adder Research Project

This is the Git repository for a research project on using Completion detection in variable latency adders. it contians a couple of verilog source files, a couple of test benches and some analysis file. the most important file is adder_tb which currently lives in ./RCA and is meant to be a proper test bench for all adder designs in this repo. use -Padder_tb.< param > = param with iverilog to set params and use +< adder option > with vvp to specify adders options at run time. 

# Naming Conventions in Source Files:
1. Delay Parameter: (GATE/MODULE) _ D
2. Module instance: (module name) _ (latency) _ (copy#)