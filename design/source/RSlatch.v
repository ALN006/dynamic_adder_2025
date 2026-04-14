module rslatch(Rp, Sp, Q, Qp);
    
    input Rp, Sp;
    output Q, Qp; 

    nand #(1) n0 (Q, Sp, Qp);
    nand #(1) n1 (Qp, Rp, Q); 

endmodule
