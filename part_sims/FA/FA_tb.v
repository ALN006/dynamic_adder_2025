`timescale 1ns/1ns
//neccesary imports
`include "FA.v" 

module FA_tb;

	reg a = 0, b = 0, Cin = 0; //input declaration
	wire Cout, P, S; //output declaration

	wire [1:0] expected;
	assign expected = a + b + Cin;

	//design under test
	FA dut(.a(a), .b(b), .Cin(Cin), .Cout(Cout), .P(P), .S(S));

	initial begin

		$dumpfile("FA_tb.vcd"); //where to dump waveform
		$dumpvars(0, FA_tb);    

		repeat (8) begin 
			#3; 
			if ({Cout, S} != expected) begin //output testing
				$display("Error: a=%b b=%b Cin=%b | Expected=%b Got=%b", a, b, Cin, expected, {Cout,S});
			end
			{a, b, Cin} += 1; //input case generation
		end

		$display("Simulation Complete"); //just to check that the program counter gets to this
		$finish; //return control back to the OS ??? 

	end   

endmodule
