module full_adder(
	input a, b, cin, CLOCK_50,
	output reg cout, p, sum
);

	always @(posedge CLOCK_50) begin
	  p <= a^b;
	  cout <= ~(~(a&b) & ~(p&cin));
	  sum <= p^cin;
	end
endmodule

module stopwatch #(parameter N)(
	input CLOCK_50, F, ready_c,
	output reg [N-1:0] C
);

	always @(posedge CLOCK_50) begin
		if (F == 1) begin
			C[N-1:0] <= {N{1'b0}};
		end else if (ready_c == 0) begin
			C <= C + 1;
		end
	end
endmodule

module RCA #(
    parameter N = 16
) (S, P, Cout, A, B, Cin, CLOCK_50);

    // I/O type specification
    input [N-1:0] A, B;
    input Cin;
	 input CLOCK_50;
    output wire Cout;
    output wire [N-1: 0] P, S;

    //internal ripple carry wiring
    wire [N:1] C;

    //instantiating bitslices
    full_adder instance1 (.a(A[0]),.b(B[0]),.cin(Cin),.CLOCK_50(CLOCK_50),.cout(C[1]),.p(P[0]),.sum(S[0]));
    genvar i;
	 generate
        for (i = 1; i < N; i=i+1) begin : adder
				full_adder bitslice (.a(A[i]),.b(B[i]),.cin(C[i]),.CLOCK_50(CLOCK_50),.cout(C[i+1]),.p(P[i]),.sum(S[i]));
        end
    endgenerate

    assign Cout = C[N];

endmodule

module buffer #(parameter N = 16) (enable, in, out);
    
    // I/O type specification
    input [N:0] in;
    input enable;
    output wire [N:0] out;

    // logic: out = in, if control = 1, else out = N'bz
    assign out = enable ? in : {(N+1){1'bz}};

endmodule

module CRCA
	#(parameter N = 16) (CLOCK_50, ready_c, run_time, S, P, Cout, A, B, Cin, first, request, ready_c);

    // I/O type specification
	 input CLOCK_50;
    input [N-1:0] A, B;
    input Cin, first, request;
    output reg Cout; 
    output wire [$clog2(4*N)-1:0] run_time;
	 output reg ready_c;
    output wire [N-1:0] P;
	 output reg [N-1:0] S;
 
	wire [N:0] RCA_out;
    // core logic
    RCA adder (.CLOCK_50(CLOCK_50), .S(RCA_out[N-1:0]), .P(P), .Cout(RCA_out[N]), .A(A), .B(B), .Cin(Cin));

    // encoding of carry chain breaks at quadrants
    wire [2:0] quadrant_breaks; 
    localparam Q1 = N/4;
    localparam Q2 = N/2;
    localparam Q3 = (3*N)/4;
    assign quadrant_breaks = {~&P[Q3:Q3-1], ~&P[Q2:Q2-1], ~&P[Q1:Q1-1]};

    // timer module
    stopwatch  #(.N($clog2(4*N))) timer (.ready_c(ready_c), .CLOCK_50(CLOCK_50), .F(first), .C(run_time));

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
	 
	 always @(posedge ready_c) begin
		S <= RCA_out[N-1:0];
		Cout <= RCA_out[N];
	 end
	 

    //output buffer
    //buffer buff_out (.enable(ready_c), .in(RCA_out), .out({Cout, S}));

endmodule