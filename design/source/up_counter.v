module up_counter(input clk, input [3:0] val, input load, output R);
    reg [3:0] state = 4'd0;

    always @(posedge clk) begin
        if (load) begin 
            state <= val;
        end else begin 
            state[0] <= ~state[0];
            state[1] <= state[1] & ~state[0] | state[0] & ~state[1];
            state[2] <= state[2] & ~state[0] | state[2] & ~state[1] | ~state[2] & state[1] & state[0]; 
            state[3] <= state[3] & ~state[1] | state[3] & ~state[0] | state[3] & ~state[2] | ~state[3] & state[2] & state[1] & state[0];
        end 
    end

    assign R = state[3] & state[2] & state[1] & state[0];
endmodule

 