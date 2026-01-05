module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
	reg a = 0, b = 0, Cin = 0;
	initial begin
		
        #8 a <= 0 ; b <= 1 ; Cin <= 1;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    FA inst1 ( .a(a), .b(b), .Cin(Cin));   

endmodule

module FA( // dynamic adder bitslice
    input a,b, Cin,
    output Cout, P, s);
    parameter nand_d = 1, xor_d = 1; 

    wire nab, nPCin;
    xor #(xor_d) x0 (P, a, b);
    xor #(xor_d) x1 (s, P, Cin);
    nand #(nand_d) n1 (nab, a, b);
    nand #(nand_d) n2 (nPCin, P, Cin);
    nand #(nand_d) n3 (Cout, nab, nPCin);
    `probe(a);
    `probe(b);
    `probe(Cin);
    `probe(Cout);
    `probe(P);
    `probe(s);

endmodule