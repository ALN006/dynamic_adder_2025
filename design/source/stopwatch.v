module stopwatch_3(
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