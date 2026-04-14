`timescale 1ns/1ns
`include "source/up_counter.v"

module up_counter_tb;
    reg clk = 1;
    wire R;
    reg [3:0] val;
    reg load;
    up_counter dut(clk, val, load, R);
    always #(1) clk = ~clk;

    initial begin   
        $dumpfile("up_counter_tb.vcd");
        $dumpvars(0, up_counter_tb);

        #(32);
        val = 4'd6;
        load = 1;
        #(2)
        load = 0;
        #(14);

        $display("simulation done");
        $finish;
    end
endmodule
