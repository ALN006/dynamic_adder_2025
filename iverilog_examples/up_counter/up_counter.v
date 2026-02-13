module up_counter(clk, R);
    input clk;
    reg [3:0] state = 8'd0;
    output R;

    always @(posedge clk) begin
        state <= state + 8'd1;
    end

    assign R = state[3] & state[2] & state[1] & state[0];
endmodule