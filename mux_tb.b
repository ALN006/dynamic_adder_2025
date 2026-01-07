module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
    reg [7:0] option = 8'h00;
    reg [2:0] select = 3'b000;
    reg F = 1;
	initial begin
        #8 F <= 0; option[0] <= 1;
        #2 option[0] <= 0;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    mux_3_8 inst1 ( .option(option), .select(select), .F(F));   

endmodule

module mux_3_8( // 3*8 mux that captures any selected signal in 3 gate delays so long as it was high for atleast 2 gate delays
    input [7:0] option,
    input [2:0] select,
    input F,
    output out
);
    parameter nand_d = 1, or_d = 1, and_d = 1;
    wire [7:0] high_option;
    wire low, high, capture;
    nand #(nand_d) n00 (high_option[0], option[0], ~select[2], ~select[1], ~select[0]);
    nand #(nand_d) n01 (high_option[1], option[1], ~select[2], ~select[1], select[0]);
    nand #(nand_d) n02 (high_option[2], option[2], ~select[2], select[1], ~select[0]);
    nand #(nand_d) n03 (high_option[3], option[3], ~select[2], select[1], select[0]);
    nand #(nand_d) n04 (high_option[4], option[4], select[2], ~select[1], ~select[0]);
    nand #(nand_d) n05 (high_option[5], option[5], select[2], ~select[1], select[0]);
    nand #(nand_d) n06 (high_option[6], option[6], select[2], select[1], ~select[0]);
    nand #(nand_d) n07 (high_option[7], option[7], select[2], select[1], select[0]);

    nand #(nand_d) n10 (low, high_option[3], high_option[2], high_option[1], high_option[0]);
    nand #(nand_d) n11 (high, high_option[7], high_option[6], high_option[5], high_option[4]);
    and #(and_d) a20 (capture, out, ~F);
    or #(or_d) o20 (out, high, low, capture);

    `probe(option);
    `probe(select);
    `probe(F);
    `probe(capture);
    `probe(out);
endmodule