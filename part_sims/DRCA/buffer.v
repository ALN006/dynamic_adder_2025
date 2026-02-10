// no imports needed for workinng

//this is a collection of N tristate buffers
module buffer #(parameter N = 8) (in, out, control);

    //N is the bitwidth of the buffer

    // I/O declaration
    input [N-1:0] in;
    input control;
    output [N-1:0] out;

    //no internal wiring at the level of abstraction in which this file is written

    //logic: out = in, if control = 1, else out = N'bz
    assign out = control ? in : {N{1'bz}};

endmodule

