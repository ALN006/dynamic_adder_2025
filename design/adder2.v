//TODO: timing logic, include stopwatch and RCA 

module CRCA #(parameter N = 8, NAND_D = 1, XOR_D = 1) (S, P, Cout, A, B, Cin);
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1: 0] P, S;

    wire [N:0] RCA_out;

    RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.A(A), .B(B), .Cin(Cin), .Cout(RCA_out[N]), .P(P), .S(RCA_out[N-1:0]));


endmodule

module buffer #(parameter N = 9) (enable, in, out);
    input [N-1:0] in;
    input enable;
    output [N-1:0] out;

    assign out = enable ? in : {N{1'bz}};
endmodule

module timing_circuit #(parameter N = 8, AND_D = 1, XOR_D = 1, NAND_D = 1) (
    input [N-1:0] P, sum,
    input F,
    input request,
    output [N-1:0] sum_out
);
    integer stopwatch_len = $clog2(2*N);
    wire [stopwatch_len:0] stopwatch_out;
    stopwatch #(stopwatch_len, AND_D, XOR_D) watch (.F(F), .out(stopwatch_out));
    wire fourth, half, three_fourth, full; //how do you parameterize this??
    wire s2, s1, s0;
    nand #(NAND_D) nand0 (s0, P[N / 4], P[N / 4 - 1]);
    nand #(NAND_D) nand1 (s1, P[N / 2], P[N / 2 - 1]);
    nand #(NAND_D) nand2 (s2, P[3 * N / 4], P[(3 * N / 4) - 1]);
    wire ready;
    mux_3_8 mux(
        .option({fourth, half, half, three_fourth, half, half, three_fourth, full}),
        .select({s2, s1, s0}),
        .F(F),
        .out(ready)
    );
    wire rlease;
    and #(and_d) (rlease, ready, request);
    buffer #(N) buf2(.enable(rlease), .in(sum), .out(sum_out));
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
