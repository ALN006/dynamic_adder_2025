# Dynamic Adder Research Project

This is the Git repository for a research project on using Completion detection in variable latency adders. We design a completion detection peripheral for Ripple Carry Adders (RCAs) in particular that aims to make the Ripple Carry Adder suitable for high performance computing.

This repository contians many verilog source files, a couple of test benches and one analysis file. Note the following:
    1. adder_tb alon with the makfile of this REPO can be used to test all of the adders in this repo with parameters set as needed
    2. ./data contains csv files, graphs and one jupyter notebook where all our data analysis lives
    3. ./<ADDER> contains the source files and special test benches of a family of adders

# Naming Conventions in Source Files:
1. Delay Parameter: (GATE/MODULE) _ D
2. Module instance: (module name) _ (latency) _ (copy#)