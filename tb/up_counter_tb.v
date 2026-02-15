`timescale 1ns/1ns
`include "up_counter_synth.v"

module up_counter_tb;
    reg clk = 1;
    wire R;
    up_counter dut(clk, R);
    always #(1) clk = ~clk;

    initial begin   
        $dumpfile("up_counter_tb.vcd");
        $dumpvars(0, up_counter_tb);

        #(32);

        $display("simulation done");
        $finish;
    end
endmodule
