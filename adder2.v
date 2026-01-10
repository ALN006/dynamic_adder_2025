module cla_4( // carry_delay = 3; sum_delay = 4
    input [3:0] A, B,
    input Cin,
    output p0, p3, Cout,
    output [3:0] sum
);
    parameter not_delay = 1;
    wire nCin;
    not #(not_delay) n00 (nCin, Cin);
    wire x0, x1, x2, x3; 
endmodule