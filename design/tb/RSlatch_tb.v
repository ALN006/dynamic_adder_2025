`timescale 1ns/1ns
`include "RSlatch.v"

module RSlatch_tb;
    reg Rp = 0, Sp = 0;
    wire Q, Qp;

    rslatch dut(.Rp(Rp), .Sp(Sp), .Q(Q), .Qp(Qp));

    initial begin
        $dumpfile("RSlatch_tb.vcd");
        $dumpvars(0, RSlatch_tb);
        repeat (4) begin 
            #10; {Rp, Sp} = {Rp, Sp} + 1;
        end
        $display("Success");
        $finish;
    end 

endmodule
