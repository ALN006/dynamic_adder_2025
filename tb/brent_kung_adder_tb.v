`timescale 1ns/1ns
`include "brent_kung_adder.v"

module brent_kung_adder_tb;

    parameter N = 8;

    reg [N-1:0] tb_A;
    reg [N-1:0] tb_B;
    reg tb_C_in;

    wire tb_C_out;
    wire [N-1:0] tb_S;

    wire [N:0] expected_result;
    assign expected_result = tb_A + tb_B + tb_C_in;

    brent_kung_adder #(.N(N)) dut (
        .A      (tb_A),
        .B      (tb_B),
        .C_in   (tb_C_in),
        .S      (tb_S),
        .C_out (tb_C_out)
    );

    initial begin
        $dumpfile("brent_kung_adder_waveform.vcd");
        $dumpvars(0, brent_kung_adder_tb);

        $display("Starting Brent-Kung Adder Test (N = %0d)", N);
        //$monitor("Time=%0t: A=%d B=%d Cin=%b | S=%d Cout=%b | Match=%b", 
                 //$time, tb_A, tb_B, tb_C_in, tb_S, tb_C_out, ({tb_C_out, tb_S} === expected_result));

        

        repeat (100) begin
            tb_A = $urandom_range(0, (2**N) - 1);
            tb_B = $urandom_range(0, (2**N) - 1);
            tb_C_in = $urandom % 2;
            #(2*N + 1);

            if ({tb_C_out, tb_S} !== expected_result) begin
            $display("Error: A=%d, B=%d, C_in=%d | Expected=%b, Got=%b",
                         tb_A, tb_B, tb_C_in, expected_result, {tb_C_out, tb_S});
                $display("G = %d, P = %d, C = %d %d", dut.G[dut.stages], dut.P[0], dut.C, dut.P[0] ^ dut.C[3:0]);
                $finish;
            end
            else begin
            $display("Success: A=%d, B=%d, C_in=%d | Expected=%d, Got=%d",
                         tb_A, tb_B, tb_C_in, expected_result, {tb_C_out, tb_S});
            end
        end

        $display("Simulation successful! Test simulation finished at time %0t", $time);
        $finish;

    end

endmodule