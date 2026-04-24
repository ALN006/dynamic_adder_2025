`timescale 1ns/1ps

module stopwatch_behavioural_tb #(parameter dump = 0, start = 1, stop = 9, step = 1);
    
    // 1. Calculate the exact number of steps
    localparam NUM_INSTANCES = (stop - start) / step + 1;

    // 2. Use unpacked arrays for the ports
    reg reset [NUM_INSTANCES];
    wire [stop-1:0] state [NUM_INSTANCES];

    generate
        for (genvar i = 0; i < NUM_INSTANCES; i = i + 1) begin : stopwatches
            // Calculate N for this specific instance
            localparam CURRENT_N = start + (i * step);
            
            stopwatch_behavioural #(.N(CURRENT_N)) dut (
                .reset(reset[i]), 
                .state(state[i][CURRENT_N-1:0])
            );
        end
    endgenerate

    initial begin 
        if (dump == 1) begin 
            $display("Waveform dumping enabled."); 
            $dumpfile("stopwatch_behavioural_tb.vcd"); 
            $dumpvars(0, stopwatch_behavioural_tb); 
        end

        // Assert reset at the beginning
        for (int j = 0; j < NUM_INSTANCES; j++) begin reset[j] = 1'b1; end
        #1.5; // Hold reset for 1.5 time units to ensure all stopwatches are reset
        for (int j = 0; j < NUM_INSTANCES; j++) begin reset[j] = 1'b0; end // Deassert reset to start counting

        // Wait long enough for all stopwatches to reach their expected counts
        #100;
        
        $finish; // End the simulation
    end
endmodule