`timescale 1ns/1ns

//imports
`include "source/KSA.v"

module verification_KSA_tb;

    //setting tb variables
    integer seed = 42;
    integer tests = 100000;
    integer latency [1:64];
    integer csv_file; // file pointer?

    // instantiating and testing adders of many widths
    genvar w; 
    generate

        for (w = 1; w <= 64; w = w << 1) begin : WIDTH_TEST
            
            // I/O and testing var declarations
            reg  [w-1:0] A, B;
            reg          Cin;
            wire         Cout;
            wire [w-1:0] S;
            reg  [w:0]   expected_sum;

            //instantiating the design under test
            KSA #(.N(w)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S));

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

                if (w == 64) begin
                    $finish; // got to final block
                end    

            end
        end
    endgenerate


    // store results
    final begin

        $display("simulation done storing results");

        csv_file = $fopen("./data/KSA_latency.csv", "w");
        if (csv_file == 0) begin
            $display("ERROR: could not open CSV file.");
            $finish;
        end

        // CSV header
        $fwrite(csv_file, "bit_width,total_latency_ns,tests\n");

        for (int i = 1; i <= 64; i = i << 1) begin
            $fwrite(csv_file, "%0d,%0d,%0d\n", i, latency[i],tests);
        end
        
        $fclose(csv_file);

        $display("results stored in KSA_latency.csv");

    end


endmodule                 