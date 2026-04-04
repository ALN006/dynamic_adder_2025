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