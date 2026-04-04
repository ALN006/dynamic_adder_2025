//TODO: timing logic

module CRCA #(parameter N = 8, NAND_D = 1, XOR_D = 1) (S, P, Cout, A, B, Cin);
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1: 0] P, S;

    wire [N:0] RCA_out;

    RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.A(A), .B(B), .Cin(Cin), .Cout(RCA_out[N]), .P(P), .S(RCA_out[N-1:0]));

endmodule

module buffer #(parameter N = 9) (enable, in, out);
    input [N-1:0] in,
    input enable,
    output [N-1:0] out

    assign out = enable ? in : {N{1'bz}};
endmodule

module RCA #(parameter N = 8, NAND_D = 1, XOR_D = 1) (  //instantiates 16 bit slices which are connected ripple carry style
    input [N-1:0] A, B,
    input Cin,
    output Cout,
    output [N-1:0] P, sum);

    wire [$bits(sum) - 1:0]carry;

    FA #(.nand_d(NAND_D), .xor_d(XOR_D)) instance1 (A[0],B[0],Cin,carry[0],P[0],sum[0]);

    genvar i;
    generate
        for ( i = 1; i < $bits(sum); i = i + 1) begin : adder
            FA #(.nand_d(NAND_D), .xor_d(XOR_D)) u0 (A[i],B[i],carry[i-1],carry[i],P[i],sum[i]);
        end
    endgenerate

    assign Cout = carry[$bits(sum) - 1];

endmodule

module FA #(parameter nand_d = 1, xor_d = 1) ( // dynamic adder bitslice
    input a,b, Cin,
    output Cout, P, s);

    wire nab, naCin, nbCin, temp;
    xor #(xor_d) x0 (P, a, b);
    xor #(xor_d) x1 (s, P, Cin);
    nand #(nand_d) n0 (nbCin, b, Cin);
    nand #(nand_d) n1 (nab, a, b);
    nand #(nand_d) n2 (naCin, a, Cin);
    nand #(nand_d) n3 (Cout, nab, nbCin, naCin);

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
