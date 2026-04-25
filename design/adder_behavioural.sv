// TODO: check stopwatch width for sensibility

//imports 
`include "source/buffer.sv"
`include "RCA/RCA.sv"
`include "RCA/FA.sv"
`include "Stopwatch/stopwatch_behavioural.sv"

// behavioural verilog code for new adder with width and gate delay parameterized
module CRCA #(
    parameter N = 8, NAND_D = 1, NOR_D = 1, XOR_D = 1
) (ready_c, S, P, Cout, A, B, Cin, first, request);

    // I/O type specification
    input [N-1:0] A, B;
    input Cin, first, request;
    output Cout; 
    output reg ready_c; 
    output [N-1:0] P, S;

    // wire between RCA and output buffer
    wire [N:0] RCA_out;

    // core logic
    RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.S(RCA_out[N-1:0]), .P(P), .Cout(RCA_out[N]), .A(A), .B(B), .Cin(Cin));

    // encoding of carry chain breaks at quadrants
    wire [2:0] quadrant_breaks; 
    localparam Q1 = N/4;
    localparam Q2 = N/2;
    localparam Q3 = (3*N)/4;
    assign quadrant_breaks = {~&P[Q3:Q3-1], ~&P[Q2:Q2-1], ~&P[Q1:Q1-1]};

    // timer module
    reg [$clog2(4*N)-1:0] run_time;
    stopwatch_behavioural #(.N($clog2(4*N)), .half_period(0.5)) timer (.reset(first), .state(run_time));

    // Set ready_c = 1 when appropriate time has passed
    always @(*) begin
        if (!request) begin
            ready_c = 1'b0;
        end else begin
            case (quadrant_breaks)
                // Multiplication before division to avoid integer zeroing (e.g., 3/4 = 0)
                3'b000: ready_c = (run_time >= 2*N - 1);
                3'b001: ready_c = (run_time >= 2*((N*3)/4 + 2));
                3'b010: ready_c = (run_time >= N + 2);
                3'b011: ready_c = (run_time >= N + 2);
                3'b100: ready_c = (run_time >= 2*((N*3)/4 + 2));
                3'b101: ready_c = (run_time >= N + 2);
                3'b110: ready_c = (run_time >= N + 2);
                3'b111: ready_c = (run_time >= 2*((N/4) + 2)); 
                default: ready_c = (run_time >= 2*N - 1);
            endcase
        end
    end

    //output buffer
    buffer #(.N(N + 1), .delay(0)) buff_out (.enable(ready_c), .in(RCA_out), .out({Cout, S}));

endmodule