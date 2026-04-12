// TODO: add documentation in readme.md, add a picture of circuit diagram in ./new_adder

//module whoose output counts up from 0 every 3 gate delays, except for the count from 0 to 1 which takes just one gate delay
//it uses with combinational feedback loops to facilitate asynchronous timing
//wire length differances, differances in gate delay between different gates and temprature variations may cause reliability issues
module stopwatch #(parameter N = 3, AND_D = 1, XOR_D = 1) (
    input F, 
    output [N - 1: 0] out
);

    //time definition 
    timeunit 1ns;
    timeprecision 1ns;

    //internal wiring
    wire [N-1:0] and1_out;
    wire [N-1:0] xor_out; 
    wire [N-1:0] and2_out;

    //timing loops
    genvar i;
    generate
        for (i = 0; i < N; i ++) begin : bit_N
            and #(AND_D) delay_and_N (and1_out[i], out[i], out[i]);
            and #(AND_D) f_and_N (out[i], xor_out[i], ~F);
            if (i == 0) begin assign and2_out[i] = 1'b1; end 
            else begin assign #(AND_D) and2_out[i] = &out[i - 1:0]; end
            xor #(XOR_D) main_x_N (xor_out[i], and1_out[i], and2_out[i]);
        end 
    endgenerate
endmodule