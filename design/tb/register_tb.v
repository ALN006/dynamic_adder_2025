`timescale 1ns/1ns

//imports
`include "register.v"

module register_tb;

    //setting parameters
    parameter N = 16;

    // I/O declaration
    reg [N-1:0] in;
    reg clk = 1;
    wire [N-1:0] out;
    always #(N + 1) clk = ~clk; // setup clock signal of period 2N + 2

    //no extra testing variables required

    //instantiating the desiign under test
    register #(.N(N)) dut (.clk(clk), .in(in), .out(out));

    //test case generation and output verification
    initial begin

        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);

        repeat (10000) begin 
            in = $random; // truncation of $random is expected and intended
            #(N/2);
        end

        $display("Simulation done");
        $finish;
    
    end


endmodule 
