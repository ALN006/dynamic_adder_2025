module top_level (
	input CLOCK_50,
	output LCD_ON,
	output LCD_BLON,
	output LCD_RW,
	output LCD_EN,
	output LCD_RS,
	inout [7:0] LCD_DATA
);

	assign LCD_ON = 1'b1;
	assign LCD_BLON = 1'b1;
	
	nios_system u0 (
		.clk_clk				(CLOCK_50),
		.reset_reset_n		(1'b1),
		.lcd_pins_data		(LCD_DATA),
		.lcd_pins_E			(LCD_EN),
		.lcd_pins_RS		(LCD_RS),
		.lcd_pins_RW		(LCD_RW)
	);
endmodule
