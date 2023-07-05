`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Copyright 2023 D Henderson
// 
// Create Date:    21:55:54 06/29/2023 
// Design Name: 
// Module Name:    ide_autoswap 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Released under the terms of the GPL v2
//
//////////////////////////////////////////////////////////////////////////////////
module ide_autoswap(
	inout [15:0] D,	// host data lines
	inout [15:0] DD, 	// drive data lines

	input [1:0] _CS,
	input _LED,
	input _RESET,
	
	input _DIOW,
	input _DIOR,
	input INTRQ,
	input [2:0] DA

    );

	reg [7:0] cmd;	
	wire commandsend = { _CS, DA, _DIOW } == 6'b101110;
	wire data = { _CS, DA } == 5'b10000;
	wire swap = data && ( cmd != 8'hEC ); // command 0xEC is Identify Drive. This is the only PIO data transfer that must remain unswapped

	always @( posedge commandsend ) begin
		cmd <= D[7:0];
	end

	assign D = _DIOR ? 16'hzz : ( swap ? { DD[7:0], DD[15:8] } : DD );
	assign DD = _DIOW	? 16'hzz : ( swap ? { D[7:0], D[15:8] } : D );

endmodule
