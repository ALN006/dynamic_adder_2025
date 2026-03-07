`timescale 1ns/1ns

//imports
`include "RCA.v"
`include "FA.v" // the one in this folder is modified to make a gate delay = 2 time units
`include "register.v" 

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
    reg clk = 1;
    wire [N:0] out;
    always #(1) clk = ~clk; 
    integer run_time_ideal = 0; 
    integer run_time_actual = 0; 
    integer seed = 42; //for reproducibility of random input cases

    //instatiating the design under test
    RCA #(.N(N)) adder (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));
    register #(.N(N+1)) output_register (.clk(clk), .in({Cout, S}), .out(out));

    //measuring runtime
    always begin 
        #1;
        if ({Cout, S} !== expected_sum) begin
            run_time_ideal += 1;
        end
        if (out !== expected_sum) begin
            run_time_actual += 1;
        end
    end

    //test case generation and output verification
    initial begin 

        $dumpfile("random_RCA_tb.vcd");
        $dumpvars(0, random_RCA_tb);

        repeat (10000) begin
            A = $random(seed); B = $random(seed); Cin = $random(seed); //truncation of random is intended
            expected_sum = A + B + Cin;
            #(2*N + 1);
            if ({Cout, S} !== expected_sum) begin
                $display("ERROR: A=%h B=%h Cin=%b | Got=%h Expected=%h",
                         A, B, Cin, {Cout, S}, expected_sum);
                //$finish;
            end 
        end

        $display("Simulation done, ideal runtime was %0d gate delays", run_time_ideal);
        $display("Simulation done, runtime with our clock speed was %0d gate delays", run_time_actual);
        $finish;            //quit simulation
    end


endmodule
