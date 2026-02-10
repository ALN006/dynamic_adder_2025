`timescale 1ns/1ns

//imports
`include "RCA.v"
`include "FA.v" 

module RCA_tb;

    //setting parameter
    parameter N = 16;

    // I/O declaration
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //testing variables
    reg [N:0] expected_sum;
    integer run_time = 0; 

    //instatiating the design under test
    RCA #(.N(N)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));

    //mesuring runtime
    always begin 
        #1;
        if ({Cout,S} !== expected_sum) begin
            run_time += 1;
        end
    end

    //test case generation and output verification
    initial begin 

        $dumpfile("RCA_tb.vcd");
        $dumpvars(0, RCA_tb);

        repeat (10000) begin
            A = $random; B = $random; Cin = $random; //truncation of random is intended
            expected_sum = A + B + Cin;
            #(2*N + 1);
            if ({Cout, S} !== expected_sum) begin
                $display("ERROR: A=%h B=%h Cin=%b | Got=%h Expected=%h",
                         A, B, Cin, {Cout, S}, expected_sum);
                //$finish;
            end 
        end

        $display("Simulation done, runtime was %0d gate delays", run_time);
        $finish;            //quit simulation
    end


endmodule
