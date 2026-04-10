//module whoose output counts up from 0 every 3 gate delays, except for the count from 0 to 1 which takes just one gate delay
module stopwatch #(parameter N = 3, AND_D = 1, XOR_D = 1) (
    input F, 
    output [N - 1: 0] out
);
    wire [N-1:0] and1_out;
    wire [N-1:0] xor_out; 
    wire [N-1:0] and2_out;

    genvar i;
    generate
        for (i = 0; i < N; i ++) begin : bit_N
            and #(AND_D) delay_and_N (and1_out[i], out[i], out[i]);
            and #(AND_D) f_and_N (out[i], xor_out[i], ~F);
            assign and2_out[i] = &{out[i:0], 1'b1};
            xor #(XOR_D) main_x_N (xor_out[i], and1_out[i], and2_out[i]);
        end 
    endgenerate
endmodule