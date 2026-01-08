module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
    reg [15:0] signal = 16'hECEB;
    reg enable = 1;
	initial begin
        #8 enable <= 0;
        #8 enable <= 1;
        #16 enable <= 0;
        #16 enable <= 1;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    buffer_16 inst1 ( .signal(signal), .enable(enable));   

endmodule


module buffer_16( //16bit tri-state buffer
    input [15:0] signal,
    input enable,
    output [15:0] out);

    assign out = enable ? signal : 16'bzzzzzzzzzzzzzzzz;

    `probe(signal);
    `probe(enable);
    `probe(out);

endmodule