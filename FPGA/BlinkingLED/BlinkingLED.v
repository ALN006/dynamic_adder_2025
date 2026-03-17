module BlinkingLED (
	input clk,
	output reg[0:0] led
);

reg [24:0] counter;

always @(posedge clk) begin
	if (counter == 25'd25000000) begin // 50 MHz clock frequency, turn on/off every 25 million cycles to blink every second
		led <= ~led;
		counter <= 0;
	end else begin
		counter <= counter + 1;
	end
end

endmodule
