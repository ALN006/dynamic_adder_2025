// example of multiple module use

module decoder1to2(A, D);
    input A;
    output [1:0] D; // both of these default to being wires

    assign D[0] = ~A;
    assign D[1] = A;
endmodule

module decoder2to4(A,D);
    input [1:0] A;
    output [3:0] D;

    wire [3:0] intermediate;

    decoder1to2 low(.A(A[0]), .D(intermediate[1:0]));
    decoder1to2 high(.A(A[1]), .D(intermediate[3:2]));

    assign D[0] = &{intermediate[0], intermediate[2]};
    assign D[1] = &{intermediate[1], intermediate[2]};
    assign D[2] = &{intermediate[0], intermediate[3]};
    assign D[3] = &{intermediate[1], intermediate[3]};
endmodule

