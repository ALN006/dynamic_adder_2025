// this is an unrealistic flip flop
module flipflop(D, clk, Q);
    
    input D, clk;
    output reg Q;
    
    always @(posedge clk) begin
        Q = D;
    end

endmodule
