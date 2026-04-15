// TODO: add reset

// possitive edge triggered register
module register #(parameter N = 8, delay = 0) (D, clk, Q);
    
    //time definition
    timeunit 1ns;
    timeprecision 1ns;

    // I/O type specification
    input clk;
    input [N-1:0] D;
    output reg [N-1:0] Q;
    
    //logic
    always @(posedge clk) begin
        Q <= #(delay) D;
    end

endmodule
