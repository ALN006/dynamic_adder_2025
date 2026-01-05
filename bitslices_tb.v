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


module bitslices_32(  //instantiates 32 bit slices which are connected ripple carry style
    input [31:0] A, B,
    input Cin,
    output Cout,
    output [31:0] P, sum);

    wire [31:0]carry;

    FA instance1 (A[0],B[0],Cin,carry[0],P[0],sum[0]);

    genvar i;
    generate
        for ( i = 1; i < $bits(sum); i++) begin : adder
            FA u0 (A[i],B[i],carry[i-1],carry[i],P[i],sum[i]);
        end
    endgenerate

    assign Cout = carry[31];

    `probe(A);
    `probe(B);
    `probe(Cin);
    `probe(Cout);
    `probe(P);
    `probe(sum);

endmodule