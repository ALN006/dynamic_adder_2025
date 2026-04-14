`timescale 1ns/1ns

//imports
`include "./source/sum_unit.v"

module sum_unit_tb;

    //setting parameters
    parameter N = 4;
    parameter D = 1;

    // I/O declaration
    reg [N-1:0] P = 0, C = 0;
    wire [N-1:0] S;

    //no additional testing variables are needed

    //intantiating the design under test
    sum_unit #(.N(N), .D(D)) dut (.P(P), .C(C), .S(S));_

    //test case generation and output verification 
    initial begin 

        $dumpfile("./waveforms/sum_unit_tb.vcd"); //waveform dumpfile
        $dumpvars(0, sum_unit_tb);

        repeat (2**(2*N)) begin
            #D;
            {P,C} += 1;
        end

        $display("Simulation Done");
        $finish;

    end

endmodule
