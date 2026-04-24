// global time unit and precision declaration
`timescale 1ns/1ps
`include "adder_behavioural.sv"

module addition_tb #(parameter dump = 0, tests = 100_000, start = 8, stop = 33, step = 4);
    
    // 1. Calculate the exact number of steps
    localparam NUM_INSTANCES = (stop - start) / step + 1;

    // 2. Use unpacked arrays for the ports
    // We use [stop-1:0] to ensure the largest adder has enough width
    reg [stop-1:0] A [NUM_INSTANCES];
    reg [stop-1:0] B [NUM_INSTANCES];
    reg Cin [NUM_INSTANCES];
    reg first [NUM_INSTANCES];
    reg request [NUM_INSTANCES];
    
    wire [stop-1:0] S [NUM_INSTANCES]; 
    wire [stop-1:0] P [NUM_INSTANCES];
    wire ready_c [NUM_INSTANCES];
    wire Cout [NUM_INSTANCES];

    // Variables for timing measurement
    real start_time [NUM_INSTANCES];
    real latency [NUM_INSTANCES];
    int file;
    int current_n;

    generate
        for (genvar i = 0; i < NUM_INSTANCES; i = i + 1) begin : adders
            // Calculate N for this specific instance
            localparam CURRENT_N = start + (i * step);
            
            CRCA #(.N(CURRENT_N)) dut (
                .ready_c(ready_c[i]), 
                .S(S[i][CURRENT_N-1:0]), 
                .P(P[i][CURRENT_N-1:0]), 
                .Cout(Cout[i]), 
                .A(A[i][CURRENT_N-1:0]), 
                .B(B[i][CURRENT_N-1:0]), 
                .Cin(Cin[i]), 
                .first(first[i]), 
                .request(request[i])
            );
        end
    endgenerate

    initial begin 
        if (dump == 1) begin 
            $display("Waveform dumping enabled."); 
            $dumpfile("adder.vcd"); 
            $dumpvars(0, addition_tb); 
        end

        file = $fopen("results.csv", "w");
        $fwrite(file, "N,A,B,Cin,P_bits,Output,Expected,Latency\n"); 

        // 3. Main Test Loop
        for (int j = 0; j < NUM_INSTANCES; j++) begin
            current_n = start + (j * step);
            
            for (int k = 0; k < tests; k++) begin
                // Reset/Init for this test
                first[j] = 1; request[j] = 0;
                A[j] = $urandom();
                B[j] = $urandom();
                Cin[j] = $urandom_range(0, 1);
                
                #2; // Small delay to settle reset
                first[j] = 0;
                request[j] = 1;
                start_time[j] = $realtime;

                // 4. Wait for the CRCA to signal completion
                wait(ready_c[j] == 1);
                latency[j] = $realtime - start_time[j];

                // 5. Data Collection
                $fwrite(file, "%0d,%0d,%0d,%0d,%b,%0d,%0d,%0f\n", 
                        current_n, A[j], B[j], Cin[j], P[j], S[j], 
                        (A[j] + B[j] + Cin[j]), latency[j]);
                
                #5; // Cool down between tests
            end
        end 
        $fclose(file);
        $display("Simulation complete. Data written to results.csv");
        $finish;
    end
endmodule