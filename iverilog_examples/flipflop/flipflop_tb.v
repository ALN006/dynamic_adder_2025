`timescale 1ns/1ns
`include "flipflop.v"

module flipflop_tb;
    
    reg D = 0, clk = 0;
    wire Q;

    flipflop dut(D, clk, Q);

    always begin
        clk = ~clk;
        #10;
    end

    initial begin
        
        $dumpfile("flipflop_tb.vcd");
        $dumpvars(0, flipflop_tb);
        
        repeat (4) begin
            D = D + 1; #40;
        end
        $display("simulation done");
        $finish;
    end

endmodule
