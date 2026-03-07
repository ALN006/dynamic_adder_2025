`timescale 1ns/1ns

// imports
`include "source/RCLA.v"
`include "source/cla4.v"

module verification_RCLA_tb;

    //setting parameters
    parameter N = 16;

    // I/O declaration
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //testing variables
    reg [N:0] expected_sum;
    integer seed = 42; // for reproducibility of random input cases

    //instantiating the design under test
    RCLA #(.N(N)) dut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));

    //test case generation and output verification
    initial begin 

        $dumpfile("./waveforms/verification_RCLA_tb.vcd");
        $dumpvars(0, verification_RCLA_tb);

        repeat (10000) begin
            A = $random(seed); B = $random(seed); Cin = $random(seed); //truncation of $random is intended
            expected_sum  = A + B + Cin;
            #(2*N + 2);
            if ({Cout, S} !== expected_sum) begin
                $display("ERROR: A=%h B=%h Cin=%b | Got=%h Expected=%h",
                         A, B, Cin, {Cout, S}, expected_sum);
                //$finish;
            end
        end

        $display("Simulation done");
        $finish;            //quit simulation

    end

endmodule