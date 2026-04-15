// TODO: ADD documentation in readme.md

// this is a 1 bit Full Adder with parameterized gate delays
module FA #(parameter NAND_D = 1, XOR_D = 1) (S, P, Cout, a, b, Cin);
    input a, b, Cin;
    output Cout, P, S;

    // carry unit
    wire nab, naCin, nbCin;
    nand #(NAND_D) nand_1_0 (nab, a, b);
    nand #(NAND_D) nand_1_1 (naCin, a, Cin);
    nand #(NAND_D) nand_1_2 (nbCin, b, Cin);
    nand #(NAND_D) nand_2_0 (Cout, nab, naCin, nbCin);

    // sum unit
    xor #(XOR_D) x0 (P, a, b);
    xor #(XOR_D) x1 (S, P, Cin);

endmodule