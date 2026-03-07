module FA( // adder bitslice
    input a,b, Cin,
    output Cout, P, S);
    parameter nand_d = 1, xor_d = 1; 

    wire nab, naCin, nbCin;
    xor #(xor_d) x0 (P, a, b);
    xor #(xor_d) x1 (S, P, Cin);
    nand #(nand_d) n1 (nab, a, b);
    nand #(nand_d) n2 (naCin, a, Cin);
    nand #(nand_d) n3 (nbCin, b, Cin);
    nand #(nand_d) n4 (Cout, nab, naCin, nbCin);

endmodule