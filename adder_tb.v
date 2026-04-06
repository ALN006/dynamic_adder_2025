// this is a test_bench for adders meant to be run with iverilog
//TODO: core functionality appears complete, test it

`timescale 1ns/1ns 

module adder_tb #(parameter dump, tests, start, stop, step, seed, NAND_D, XOR_D);

    //csv
    integer file;
    wire [(stop - start - step)/step : 0] done;
    initial begin
        file = $fopen("results.csv", "w");
        if (file == 0) begin
            $display("ERROR: Could not open file.");
            $finish;
        end

        $fwrite(file, "N,A,B,Cin,P,Output,Expected,Latency\n");
        wait(&done);
        $fclose(file);
        $finish; //exit the simulation
    end

    //instantiating adders under test
    genvar i;
    generate
        for (i = start; i < stop; i = i + step) begin : adder
            single_test #(.dump(dump), .tests(tests), .N(i), .seed(seed), .NAND_D(NAND_D), .XOR_D(XOR_D)) test_inst (.file(file), .done(done[(i-start)/step]));
        end
    endgenerate
endmodule



module single_test #(parameter dump, tests, N, seed, NAND_D, XOR_D) (input integer file, output reg done);

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

    `ifdef V1
        adder_16 adder (.F(F), .request(request), .A(A), .B(B), .Cin(Cin), .Cout(Cout), .sum(S));
        initial $display("adder instantiated as design under test");
    `endif

    //testing
    reg  [N:0] expected_sum;
    integer latency;
    integer s = seed;

    initial begin
        
        done = 0;

        //waveform  
        if (dump == 1)  begin
            $display("Waveform dumping enabled.");
            $dumpfile("adder.vcd"); 
            $dumpvars(0);    
        end 

        //stimulus   
        repeat (tests) begin
            latency = 0;
            A = {N{1'bX}}; B = {N{1'bX}}; Cin = 1'bX;
            request = 0;
            #100;
            A = $random(s); B = $random(s); Cin = $random(s);
            request = 1;
            expected_sum = A + B + Cin;
            F = 1;   
            #1;

            //measure runtime and wait for execution
            while (({Cout, S} !== expected_sum) && (latency < 100)) begin
                latency += 1;
                if (latency == 8) F = 0;
                #1;
            end

            if (latency == 100) begin
                $display("ERROR: N, A, B, Cin, {Cout, S}, expected_sum, latency = %0d,%0d,%0d,%0d,%0d,%0d,%0d\n", N, A, B, Cin, {Cout, S}, expected_sum, latency);
            end 
            // Write to CSV
            $fwrite(file, "%0d,%0b,%0b,%0b,%0b,%0b,%0b,%0d\n", N, A, B, Cin, P, {Cout, S}, expected_sum, latency);
        end

        done = 1;
        
    end

endmodule