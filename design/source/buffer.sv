// TODO: ADD documentation in readme.md

//tristate buffer of width N
module buffer #(parameter N = 8, delay = 0) (enable, in, out);

    // I/O type specification
    input [N-1:0] in;
    input enable;
    output [N-1:0] out;

    //logic: out = in, if control = 1, else out = N'bz
    assign #(delay) out = enable ? in : {N{1'bz}};

endmodule

