/* 
    using the propagate signal P and the carry signal carry
    this module generates the sum signal Simulation
*/

module sum_unit #(parameter N = 8, D = 1) (P, C, S);

    // N is the bitwidth of our sum sum_unit
    // D is the delay of our sum_unit

    // I/O declaration 
    input [N-1:0] P, C;
    output [N-1:0] S;

    //not internal wiring at the level of abstraction in which this module is writen 

    // logic: S = P ^ C
    assign #(D) S = P ^ C;


endmodule
