`timescale 1ns/1ns

// imports
`include "source/RCLA.v"
`include "source/cla4.v"

module latency_RCLA_tb;

    ///setting tb variables
    integer seed = 42;
    integer tests = 100000;
    integer latency;
    integer csv_file;
            
    // I/O and testing var declarations
    reg  [32-1:0] A, B;
    reg          Cin;
    wire         Cout;
    wire [32-1:0] S;
    wire [3:1]   G;

    //instantiating the design under test
    RCLA #(.N(32)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .G(G), .S(S));

    // test case generation and latency measurement 
    initial begin 
        latency = 0;

        repeat (tests) begin
            A = {$random(seed),$random(seed)}; B = {$random(seed),$random(seed)}; Cin = $random(seed); //A, B, Cin
            #26;   

            //measure runtime and wait for execution
            case(G[3:1])
                3'b000: latency += 25;
                3'b001: latency += 22;
                3'b010: latency += 16;
                3'b011: latency += 16;
                3'b100: latency += 19;
                3'b101: latency += 16;
                3'b110: latency += 13;
                3'b111: latency += 10;
            endcase
        end

        $finish; // got to final block

    end

    // store results
    final begin

        $display("simulation done storing results");

        csv_file = $fopen("./data/v2_latency.csv", "w");
        if (csv_file == 0) begin
            $display("ERROR: could not open CSV file.");
            $finish;
        end

        // CSV header
        $fwrite(csv_file, "bit_width,total_latency_ns,tests\n");

        $fwrite(csv_file, "%0d,%0d,%0d\n", 32, latency,tests);
        
        $fclose(csv_file);

        $display("results stored in KSA_latency.csv");

    end

endmodule