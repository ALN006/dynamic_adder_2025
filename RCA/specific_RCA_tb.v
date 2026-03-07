`timescale 1ns/1ns

//imports
`include "RCA.v"
`include "FA.v"

module specific_RCA_tb;

    //setting parameters
    parameter N = 16;

    // I/O declaration
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //testing variables
    reg [N:0] expected_sum;
    integer run_time = 0;
    
    //instantiating the design under test
    RCA #(.N(N)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));

    //measuring runtime
    always begin
        #1;
        if ({Cout,S} !== expected_sum) begin
            run_time += 1;
        end
    end

    //test case generation and output verification
    initial begin

        $dumpfile("specific_RCA_tb.vcd");
        $dumpvars(0, specific_RCA_tb);

        A= 16'h9C94; B = 16'h636A; Cin = 1'b1; expected_sum = A + B + Cin; #33; //width mismatch for expected sum assignment is ok

        $display("Simulation done, runtime was %0d gate delays", run_time);
        $finish;    //quit simulation
    
    end


endmodule
