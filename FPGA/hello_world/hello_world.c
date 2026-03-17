/*
 * Specific header files used so the executable that will be loaded on to the FPGA
 * is within 32 KB. The FPGA can hold more data though, but I'm just doing a small
 * programs for now.
 */

#include <stdio.h>
#include <sys/alt_stdio.h>
#include "system.h"
#include "altera_avalon_lcd_16207_regs.h"

int main() {

	alt_putstr("Sending to LCD...\n");

	IOWR_ALTERA_AVALON_LCD_16207_COMMAND(LCD_16207_0_BASE, 0x01);
	usleep(15000); // each time the program should sleep for a short while because the program is much
                 // faster than the LCD, without the sleep it wouldn't print the letters
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'H');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'e');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'l');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'l');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'o');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, ',');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, ' ');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'W');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'o');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'r');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'l');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, 'd');
	usleep(15000);
	IOWR_ALTERA_AVALON_LCD_16207_DATA(LCD_16207_0_BASE, '!');


	return 0;
}
