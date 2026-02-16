/* 
    using 2 binary number A and B as input
    this module generates the propagate signal P and the generate signal G as output
*/

module pg_unit #(parameter N = 8, xor_d = 1, and_d = 1) (A, B, P, G);

    // N is the bitwidth of our pg_unit
    // xor_d is the delay of our xor generates
    // and_d is the delay of our and gates

    // I/O declaration 
    input [N-1:0] A, B;
    output [N-1:0] P, G;

    //not internal wiring at the level of abstraction in which this module is writen 

    // logic
    assign #(xor_d) P = A ^ B;
    assign #(and_d) G = A & B;

endmodule
