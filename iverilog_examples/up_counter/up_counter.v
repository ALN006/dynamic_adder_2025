module up_counter(clk, state, R):
    input clk;
    reg [3:0] state;
    output R;

    always @(posedge clk):
        state <= state + 8`d1;
        R = state[3] & state[2] & state[1] & state[0];
    end
endmodule
