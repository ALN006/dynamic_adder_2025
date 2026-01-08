module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
    reg [15:0] A = 16'hAAAA, B = 16'h5555;
    reg Cin = 0;
	initial begin
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    bitslices_16 inst1 ( .A(A), .B(B), .Cin(Cin));   

endmodule


module bitslices_16(  //instantiates 16 bit slices which are connected ripple carry style
    input [15:0] A, B,
    input Cin,
    output Cout,
    output [15:0] P, sum);

    wire [$bits(sum) - 1:0]carry;

    FA instance1 (A[0],B[0],Cin,carry[0],P[0],sum[0]);

    genvar i;
    generate
        for ( i = 1; i < $bits(sum); i++) begin : adder
            FA u0 (A[i],B[i],carry[i-1],carry[i],P[i],sum[i]);
        end
    endgenerate

    assign Cout = carry[$bits(sum) - 1];

    `probe(A);
    `probe(B);
    `probe(Cin);
    `probe(carry);
    `probe(P);
    `probe(sum);

endmodule

module FA( // dynamic adder bitslice
    input a,b, Cin,
    output Cout, P, s);
    parameter nand_d = 1, xor_d = 1; 

    wire nab, naCin, nbCin, temp;
    xor #(xor_d) x0 (P, a, b);
    xor #(xor_d) x1 (s, P, Cin);
    nand #(nand_d) n0 (nbCin, b, Cin);
    nand #(nand_d) n1 (nab, a, b);
    nand #(nand_d) n2 (naCin, a, Cin);
    nand #(nand_d) n3 (Cout, nab, nbCin, naCin);

endmodule
