module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
    reg [15:0] A = 16'h0AAA, B = 16'h0555;
    reg Cin = 0;
    reg request = 1;
    reg F = 1;
	initial begin
        #8 F <= 0;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    adder_16 dut ( .A(A), .B(B), .Cin(Cin), .F(F), .request(request));   

endmodule


module adder_16( //the dynamic adder design 
    input F, Cin, request,
    input [15:0] A, B,
    output Cout,
    output [15:0] sum);

    wire [$bits(sum) - 1:0] P, temp_sum; // temp_sum holds sum till ready signal R is 1

    bitslices_16 add_logic (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .sum(temp_sum), .P(P));

    timing_circuit_16 timing_logic (.P(P), .sum(temp_sum), .F(F), .request(request), .sum_out(sum));

    `probe(F);
    `probe(Cin);
    `probe(request);
    `probe(A);
    `probe(B);
    `probe(Cout);
    `probe(sum);

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


module buffer_16( //16bit tri-state buffer
    input [15:0] signal,
    input enable,
    output [15:0] out);

    assign out = enable ? signal : 16'bzzzzzzzzzzzzzzzz;

endmodule


module timing_circuit_16(
    input [15:0] P, sum,
    input F,
    input request,
    output [15:0] sum_out
);
    parameter nand_d = 1, and_d = 1, nor_d = 1;
    wire s0, s1, s2;
    nand #(nand_d) n00 (s2, P[12], P[11]);
    nand #(nand_d) n01 (s1, P[8], P[7]);
    nand #(nand_d) n02 (s0, P[4], P[3]);
    wire c0, c1, c2;
    timer_3 stopwatch (.F(F), .c0(c0), .c1(c1), .c2(c2));
    wire a4fourths, a3fourths, a2fourths, a1fourths;
    and #(and_d) a10 (a4fourths, c2, c1);
    nor #(nor_d) no10 (a1fourths, c2, c1, c0);
    assign a3fourths = c2;
    assign a2fourths = c0;
    wire ready;
    mux_3_8 mux ( 
        .option({a1fourths, a2fourths, a2fourths, a3fourths, a2fourths, a2fourths, a3fourths, a4fourths}),
        .select({s2, s1, s0}),
        .F(F),
        .out(ready)
    );
    wire rlease;
    and #(and_d) (rlease, ready, request);
    buffer_16 sum_buffer (.signal(sum), .enable(rlease), .out(sum_out));

endmodule

module timer_3(
    input F, // the "first" signal
    output c0,c1,c2
);
    parameter and_d = 1, xor_d = 1; 
    wire xc0, xc1, xc2;
    wire xc0o, xc1o, xc2o;
    wire ac0, ac1, ac2;
    assign xc0o = 1'b1;
    and #(and_d) a001 (xc1o, 1'b1, c0);
    and #(and_d) a002 (xc2o, c0, c1);
    xor #(xor_d) x0 (xc0, ac0, xc0o);
    xor #(xor_d) x1 (xc1, ac1, xc1o);
    xor #(xor_d) x2 (xc2, ac2, xc2o);
    and #(and_d) a00 (c0, xc0, ~F);
    and #(and_d) a01 (c1, xc1, ~F);
    and #(and_d) a02 (c2, xc2, ~F);
    and #(and_d) a0 (ac0, c0, c0);
    and #(and_d) a1 (ac1, c1, c1);
    and #(and_d) a2 (ac2, c2, c2);
    
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

endmodule
