// TODO: Multi_tb for pipelined adder

// test key:
//      0 -> single_test : 'tests' tests with random numbers, one number per test one at a time
//      1 -> async_test  : 'tests' tests with random numbers, First, request are set appropriately

// time definition
`timescale 1ns/1ps

// this is a test bench for all adders meant to be run with iverilog, it has a top module that handles csv logging and instantiating the appropriate test module
module adder_tb #(parameter test, dump, tests, start, stop, step, seed, NAND_D, XOR_D)();

    // local parameters
    localparam NUM_INSTANCES = (stop - start)/step;
    integer file;
    wire [NUM_INSTANCES-1: 0] done;

    initial begin  
        //waveform 
        if (dump == 1) begin $display("Waveform dumping enabled."); $dumpfile("adder.vcd"); $dumpvars(0); end
         
        //open csv file and write header
        file = $fopen("results.csv", "w");
        if (file == 0) begin $display("ERROR: Could not open file."); $finish; end
        $fwrite(file, "N,A,B,Cin,P,Output,Expected,Latency\n");
        wait(&done);
        $fclose(file);
        $finish; //exit the simulation
    end

    // instantiating test modules
    generate
        for (genvar i = start; i < stop; i = i + step) begin : adder_test
            // Local index calculation for readability
            localparam idx = (i - start) / step;
            if (test == 0) single_test #(.tests(tests), .N(i), .NAND_D(NAND_D), .XOR_D(XOR_D)) test_inst (.file(file), .done(done[idx]));
        end
    endgenerate
endmodule

// one random set of inuputs per test, with a timeout and latency measurement for each test
module single_test #(parameter tests = 100, timeout = 200, N = 8, NAND_D = 1, XOR_D = 1) (file, done);
    input integer file;
    output reg done;

    // I/O declaration
    reg F, request; 
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //adder selection
    `ifdef RCA
        RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));
        initial $display("RCA instantiated as design under test");
    `endif

    `ifdef KSA
        KSA #(.N(N)) adder (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S));
        initial $display("RCA instantiated as design under test");
    `endif

    //testing
    reg  [N:0] expected_sum;
    integer latency;

    initial begin
        done = 0;
        //stimulus   
        for (int i = 0; i < tests; i++) begin
            latency = 0;
            A = {N{1'bX}}; B = {N{1'bX}}; Cin = 1'bX;
            #(timeout);
            A = $urandom(); B = $urandom(); Cin = $urandom_range(0, 1);
            expected_sum = A + B + Cin; 
            #1;

            //measure runtime
            while (({Cout, S} !== expected_sum) && (latency < timeout)) begin latency += 1; #1; end
            if (latency == timeout) begin
                $display("ERROR: N = %0d, A = %0d, B = %0d, P = %0d, Cin = %0d, {Cout, S} = %0b, expected_sum = %0d, latency = %0d\n", N, A, B, P, Cin, {Cout, S}, expected_sum, latency);
            end

            $fwrite(file, "%0d,%b,%b,%0d,%b,%b,%b,%0d\n", N, A, B, Cin, P, {Cout, S}, expected_sum, latency);
        end
        done = 1;
    end

endmodule