module top_module ();
    
	initial `probe_start;   // Start the timing diagram

	// A testbench
    reg [15:0] P = 16'hAAAA, sum = 16'h5555;
    reg Cin = 0;
    reg request = 1;
    reg F = 1;
	initial begin
        #8 F <= 0;
		$display ("Hello world! The current time is (%0d ps)", $time);
		#100 $finish;            // Quit the simulation
	end

    timing_ inst1 ( .P(P), .sum(sum), .F(F), .request(request));   

endmodule

module timing_circuit_16(
    input [15:0] P, sum,
    input F,
    input request,
    output [15:0] sum_out
);
    parameter nand_d = 1, and_d = 1, nor_d = 1; 
    wire m0, m1, m2;
    wire c0, c1, c2;
    wire a4fourths, a3fourths, a2fourths, a1fourths;
    reg ready, cready, release;
    assign a3fourths = c2;
    assign a2fourths = c0;
    and #(and_d) (a4fourths, c2, c1);
    nor #(nor_d) (a1fourths, c1, c0);
    nand #(nand_d) (m0, P[12], P[11]);
    nand #(nand_d) (m1, P[8], P[7]);
    nand #(nand_d) (m2, P[4], P[3]);
    always @(*) begin
        #2
        case ({m0,m1,m2})
            3'b000: ready = a4fourths;
            3'b001: ready = a3fourths;
            3'b010: ready = a2fourths;
            3'b011: ready = a2fourths;
            3'b100: ready = a3fourths;
            3'b101: ready = a2fourths;
            3'b110: ready = a2fourths;
            3'b111: ready = a1fourths;
            default: ready = a4fourths;
        endcase
    end
    #2 assign cready = &{cready,~F}|ready;
    assign release = request&cready;
    timer_3 inst1 (.F(F), .c0(c0), .c1(c1), .c2(c2));
    buffer_16 inst1 (sum, release, sum_out);
    `probe(P);
    `probe(sum);
    `probe(F);
    `probe(request);
    `probe(sum_out);    
endmodule

module stopwatch_3(
    input F, // the "first" signal which is high for the first clock cycle of adder opperation
    output s0,s1,s2 //state of our stopwatch
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
