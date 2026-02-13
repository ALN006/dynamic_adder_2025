`timescale 1ns/1ns

//imports
`include "RCA.v"
`include "FA.v" 

module random_RCA_tb;

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
    integer seed = 42; //for reproducibility of random input cases

    //instatiating the design under test
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

        $dumpfile("random_RCA_tb.vcd");
        $dumpvars(0, random_RCA_tb);

        repeat (100000) begin
            A = $random(seed); B = $random(seed); Cin = $random(seed); //truncation of random is intended
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
