module rca_test (
    input  [17:0] SW,       // SW[15:0] for data, SW[17] for Select
    input  [3:0]  KEY,      // KEY[0] for Load, KEY[3] for Reset
    input         CLOCK_50,
    output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);
		reg [15:0] reg_A, reg_B;
		 reg reg_A_set, reg_B_set;
		 reg first_pulse, first_done;
		 reg KEY0_d; // Delayed version of KEY0 to detect the press
		 
		 wire [7:0] run_time;
		 wire [15:0] S, P;
		 wire Cout;
		 wire both_set = (reg_A_set && reg_B_set);
		 wire ready_c;

    always @(posedge CLOCK_50) begin
        // Track previous state of button to detect the "Edge"
        KEY0_d <= KEY[0];

        // 1. Reset (KEY3)
        if (KEY[3] == 1'b0) begin
            reg_A <= 16'b0; reg_B <= 16'b0;
            reg_A_set <= 1'b0; reg_B_set <= 1'b0;
            first_pulse <= 1'b0; first_done <= 1'b0;
        end 
        
        // 2. Loading: Triggers once when you PRESS KEY0
        else if (KEY[0] == 1'b0 && KEY0_d == 1'b1) begin 
            if (SW[17] == 1'b0) begin
                reg_A <= SW[15:0];
                reg_A_set <= 1'b1;
            end else begin
                reg_B <= SW[15:0];
                reg_B_set <= 1'b1;
            end
        end 

        // 3. Pulse Generation for "First"
        else if (both_set && !first_done) begin
            first_pulse <= 1'b1;
            first_done  <= 1'b1;
        end 
        else begin
            first_pulse <= 1'b0; // Resets to 0 after 1 cycle
        end
    end

    // --- 2. Instantiate your CRCA ---
    CRCA #(.N(16)) my_adder (
        .CLOCK_50(CLOCK_50),
        .run_time(run_time),
        .S(S),
        .P(P),
        .Cout(Cout),
        .A(reg_A),
        .B(reg_B),
        .Cin(1'b0),
        .first(first_pulse), // Fires 1-cycle pulse when both regs are ready
		  .ready_c(ready_c),
        .request(1'b1)       // Always high as requested
    );

    // --- 3. Output to Hex Displays ---
    hex_decoder h7(run_time[7:4], HEX7);
    hex_decoder h6(run_time[3:0], HEX6);
	 hex_decoder h4({3'b000, Cout}, HEX4);
    hex_decoder h5({3'b000, ready_c}, HEX5);
    hex_decoder h3(S[15:12], HEX3);
    hex_decoder h2(S[11:8],  HEX2);
    hex_decoder h1(S[7:4],   HEX1);
    hex_decoder h0(S[3:0],   HEX0);

endmodule
