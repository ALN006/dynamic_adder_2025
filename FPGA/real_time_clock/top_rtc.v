module top_rtc (
	input CLOCK_50,
	input [2:0] KEY,
	output [8:0] LEDG, // green LED for blinking every half second
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	// 1 Hz tick
	reg [24:0] clk_counter;
	reg tick_1s;
	always @(posedge CLOCK_50) begin
		if (clk_counter == 25'd25000000) begin // 50 MHz clock frequency, turn on/off every 25 million cycles to blink every second
			tick_1s <= ~tick_1s;
			clk_counter <= 0;
		end else begin
			clk_counter <= clk_counter + 1;
		end
	end
	
	assign LEDG[8] = tick_1s;

	reg [5:0] sec, min;
	reg [4:0] hour;
	
	reg [1:0] h_sync, m_sync;
   always @(posedge CLOCK_50) begin
        h_sync <= {h_sync[0], ~KEY[2]};
        m_sync <= {m_sync[0], ~KEY[1]};
   end
	
	reg tick_reg;
	
	always @(posedge CLOCK_50) begin
			tick_reg <= tick_1s;
	end
	
	always @(posedge CLOCK_50 or negedge KEY[0]) begin
		if (!KEY[0]) begin
			{sec, min, hour} <= 0;
		end else begin
			if (tick_1s && !tick_reg) begin // when tick is on but prev_tick was off
				if (sec == 59) begin
					sec <= 0;
					if (min == 59) begin
						min <= 0;
						hour <= (hour == 23) ? 0 : hour + 1;
					end else min <= min + 1;
				end else sec <= sec + 1;
			end
			// manually change hours and minutes
			if (h_sync == 2'b01)
				hour <= (hour == 23) ? 0 : hour + 1;
			if (m_sync == 2'b01)
				min <= (min == 59) ? 0 : min + 1;
		end
	end
	
	
	hex_decoder h0 (.bin_in(sec % 10), .hex_out(HEX0));
	hex_decoder h1 (.bin_in(sec / 10), .hex_out(HEX1));
	hex_decoder h2 (.bin_in(min % 10), .hex_out(HEX2));
	hex_decoder h3 (.bin_in(min / 10), .hex_out(HEX3));
	hex_decoder h4 (.bin_in(hour % 10), .hex_out(HEX4));
	hex_decoder h5 (.bin_in(hour / 10), .hex_out(HEX5));
	
endmodule
	
