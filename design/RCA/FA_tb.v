`timescale 1ns/1ns
//neccesary imports
`include "FA.v" 

module FA_tb;

	// I/O declaration
	reg a = 0, b = 0, Cin = 0; 
	wire Cout, P, S;

	wire [1:0] expected;
	assign expected = a + b + Cin;

	//design under test
	FA #(1,1) FA_2_1 (.a(a), .b(b), .Cin(Cin), .Cout(Cout), .P(P), .S(S));
	reg [1023:0] vcd_file;

	initial begin

		if ($test$plusargs("DUMP_ON")) begin

            $display("Waveform dumping enabled.");
			$value$plusargs("VCD_NAME=%s", vcd_file);
            $dumpfile(vcd_file); 
            $dumpvars(0, FA_tb);    
        end else begin
            $display("Note: Waveform dumping disabled.");
        end   

		repeat (8) begin 
			#3; 
			if ({Cout, S} !== expected) begin //output testing
				$display("Error: a=%b b=%b Cin=%b | Expected=%b Got=%b\n", a, b, Cin, expected, {Cout,S});
			end
			{a, b, Cin} += 1; //input case generation
		end

		$display("Simulation Complete"); //just to check that the program counter gets to this
		$finish; //return control back to the OS 

	end   

endmodule
