module Multiplier
(
	input logic clk,
	input logic run,
	input logic clearA_loadB,
	input logic reset,
	input logic [7:0] S,

	output logic x,	
	output logic [7:0] Aval,
	output logic [7:0] Bval,
	output logic [6:0] AhexU,
	output logic [6:0] AhexL,
	output logic [6:0] BhexU,
	output logic [6:0] BhexL
);

	logic [7:0] count;
	logic reset_counter;
	logic increment_counter;
	
	logic m;
	logic shift, add, sub, reset_au, clr_ld, clearA;
	
	HexDriver AUd(.In0(Aval[7:4]), .Out0(AhexU));
	HexDriver ALd(.In0(Aval[3:0]), .Out0(AhexL));
	HexDriver BUd(.In0(Bval[7:4]), .Out0(BhexU));
	HexDriver BLd(.In0(Bval[3:0]), .Out0(BhexL));

	
	ArithmaticUnit AU
	(
		.S(S),
		.shift(shift),
		.add(add),
		.sub(sub),
		.clearA_LoadB(clr_ld),
		.clk(clk),
		.reset(reset_au),
		.clearA(clearA),
		
		.Aout(Aval),
		.Bout(Bval),
		.x(x),
		.m(m)
	);

	controlUnit CU
	(
		.reset(~reset),
		.clk(clk),
		.run(~run),
		.ClearA_LoadB(~clearA_loadB),
		.counter(count),
		.m(m),
		
		.clr_ld(clr_ld),
		.shift(shift),
		.add(add),
		.sub(sub),
		.reset_au(reset_au),
		.reset_counter(reset_counter),
		.increment_counter(increment_counter),
		.clearA(clearA)
	);

	counter8 Counter
	(
		.reset(reset_counter),
		.clk(clk),
		.count_enable(increment_counter),
		
		.count(count)
	);

endmodule 