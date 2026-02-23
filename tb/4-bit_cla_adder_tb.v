`timescale 1ns/1ns
`include "4-bit_cla_adder.v"

module carry_lookahead_adder_4_bit_tb;

    reg [3:0] tb_A;
    reg [3:0] tb_B;
    reg tb_C_in;

    wire tb_C_out;
    wire [3:0] tb_S;

    carry_lookahead_adder_4_bit dut (
        .A      (tb_A),
        .B      (tb_B),
        .C_in   (tb_C_in),
        .S      (tb_S),
        .C_out (tb_C_out)
    );

    initial begin
        $dumpfile("4_bit_cla_adder_waveform.vcd");
        $dumpvars(0, carry_lookahead_adder_4_bit_tb);

        tb_A = 4'd5;
        tb_B = 4'd10;
        tb_C_in = 1'b0;
        #10;

        tb_A = 4'd9;
        tb_B = 4'd15;
        tb_C_in = 1'b1;
        #10;

        tb_A = 4'd0;
        tb_B = 4'd0;
        tb_C_in = 1'b0;
        #10;

        tb_A = 4'd3;
        tb_B = 4'd2;
        tb_C_in = 1'b1;
        #10;
        
        tb_A = 4'd8;
        tb_B = 4'd8;
        tb_C_in = 1'b0;
        #10;

        $display("Test simulation finished at time %0t", $time);
        $finish;

    end

endmodule