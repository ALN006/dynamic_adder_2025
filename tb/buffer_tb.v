`timescale 1ns/1ns

//imports
`include "buffer.v"

module buffer_tb;

    //setting parameters
    parameter N = 1;

    // I/O declaration
    reg [N-1:0] in = {N{1'b0}};
    reg control = 1'b0;
    wire [N-1:0] out;

    //no additional testing variables are needed

    //instantiating design under test
    buffer #(.N(N)) dut (.in(in), .out(out), .control(control));

    //there is nothing to measure/check in parallel
    
    //test case generation and output verification
    initial begin

        $dumpfile("buffer_tb.vcd"); //waveform dumpfile
        $dumpvars(0, buffer_tb);

        repeat (2*(2**N)) begin
            {control, in} += 1; 
            #1;
            if (out !== (control ? in : {N{1'bz}})) begin
                $display("ERROR: contol=%b in=%h out=%h", control, in, out);
            end
        end
        
        $display("Simulation done");
        $finish; //quit simulation
        
    end


endmodule
