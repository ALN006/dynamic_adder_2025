`timescale 1ns/1ns

//imports
`include "source/RCA.v"
`include "source/FA.v"
`include "source/register.v"

module latency_RCA_tb;


    //setting tb variables
    integer seed = 42;
    integer tests = 100000;
    integer latency [1:32];
    integer csv_file; // file pointer?

    // instantiating and testing adders of many widths
    genvar w; 
    generate

        for (w = 1; w <= 32; w = w + 1) begin : WIDTH_TEST
            
            // I/O and testing var declarations
            reg  [w-1:0] A, B;
            reg          Cin;
            wire         Cout;
            wire [w-1:0] P, S;
            reg  [w:0]   expected_sum;

            //instantiating the design under test
            RCA #(.N(w)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));
            // no output reg, assuming the output regs clk is fast enough to effectively make it transparent

            // test case generation and latency measurement 
            initial begin 
                latency[w] = 0;

                repeat (tests) begin
                    A = $random(seed); B = $random(seed); Cin = $random(seed); //A, B, Cin
                    expected_sum = A + B + Cin;   

                    //measure runtime and wait for execution
                    while ({Cout, S} !== expected_sum) begin
                        latency[w] += 1;
                        #1;
                    end
                end

                if (w == 32) begin
                    $finish; // got to final block
                end    

            end
        end
    endgenerate


    // store results
    final begin

        $display("simulation done storing results");

        csv_file = $fopen("RCA_latency.csv", "w");
        if (csv_file == 0) begin
            $display("ERROR: could not open CSV file.");
            $finish;
        end

        // CSV header
        $fwrite(csv_file, "bit_width,total_latency_ns,tests\n");

        for (int i = 1; i <= 32; i++) begin
            $fwrite(csv_file, "%0d,%0d,%0d\n", i, latency[i],tests);
        end
        
        $fclose(csv_file);

        $display("results stored in RCA_latency.csv");

    end


endmodule                 