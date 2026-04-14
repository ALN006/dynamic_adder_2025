`timescale 1ns/1ns

// imports
`include "source/RCLA.v"
`include "source/cla4.v"

module latency_RCLA_tb;

    ///setting tb variables
    integer seed = 42;
    integer tests = 100000;
    integer latency [1:32];
    integer csv_file;

    // instantiating and testing adders of many widths
    genvar w; 
    generate

        for (w = 4; w <= 32; w = w + 4) begin : WIDTH_TEST
            
            // I/O and testing var declarations
            reg  [w-1:0] A, B;
            reg          Cin;
            wire         Cout;
            wire [w-1:0] S, P;
            reg  [w:0]   expected_sum;

            //instantiating the design under test
            RCLA #(.N(w)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));

            // test case generation and latency measurement 
            initial begin 
                latency[w] = 0;

                repeat (tests) begin
                    A = {$random(seed),$random(seed)}; B = {$random(seed),$random(seed)}; Cin = $random(seed); //A, B, Cin
                    expected_sum = A + B + Cin;
                    #1;   

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

        csv_file = $fopen("./data/RCLA_latency.csv", "w");
        if (csv_file == 0) begin
            $display("ERROR: could not open CSV file.");
            $finish;
        end

        // CSV header
        $fwrite(csv_file, "bit_width,total_latency_ns,tests\n");

        for (int i = 4; i <= 32; i = i + 4) begin
            $fwrite(csv_file, "%0d,%0d,%0d\n", i, latency[i],tests);
        end
        
        $fclose(csv_file);

        $display("results stored in KSA_latency.csv");

    end

endmodule