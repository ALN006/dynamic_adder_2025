module adder_32( //the dynamic adder design 
    input F, Cin, request,
    input [31:0] A, B,
    output Cout,
    output [31:0] sum);

    wire [31:0] P, temp_sum; // temp_sum holds sum till ready signal R is 1
    wire R;

    bitslices_32 add_logic (.a(A), .b(B), .cin(Cin), .cout(Cout), .sum(temp_sum), .p(P));

    timer timing_logic (.clk(adder_clk),.middle_p(p[17:14]), .F(F), .R(R));

    buffer_32 output_buffer (.signal(temp_sum), .enable(R), .out(sum));

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

endmodule


module buffer_32( //32bit tri-state buffer
    input [31:0] signal,
    input enable,
    output [31:0] out);

    assign out = control ? signal : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; 

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

module timing_circuit_16(
    input [15:0] P, sum,
    input F,
    input request,
    output sum_out
);
    parameter nand_d = 1, and_d = 1, nor_d = 1; 
    wire m0, m1, m2;
    wire c0, c1, c2;
    wire 4fourths, 3fourths, 2fourths, 1fourths;
    wire ready, cready, realease;
    assign 3fourths = c2;
    assign 2fourths = c0;
    and #(and_d) (4fourths, c2, c1);
    nor #(nor_d) (1fourths, c1, c0);
    nand #(nand_d) (m0, P[12], P[11]);
    nand #(nand_d) (m1, P[8], P[7]);
    nand #(nand_d) (m2, P[4], P[3]);
    always @(*) begin
        #2
        case ({m0,m1,m2})
            3'b000: ready = 4fourths;
            3'b001: ready = 3fourths;
            3'b010: ready = 2fourths;
            3'b011: ready = 2fourths;
            3'b100: ready = 3fourths;
            3'b101: ready = 2fourths;
            3'b110: ready = 2fourths;
            3'b111: ready = 1fourths;
            defalut: ready = 4fourths;
        endcase
    end
    #2 assign cready = &{cready,~F}|ready;
    assign release = request&cready;
    timer_3 inst1 (.F(F), .c0(c0), .c1(c1), .c2(c2));
    buffer_32 inst1 (sum, release, sum_out);
    
endmodule   