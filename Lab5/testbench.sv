module testbench();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic run;
logic ClearA_LoadB;
logic reset;
logic [7:0] S;

logic [7:0] state;
logic [7:0] next_state;
logic [7:0] count;
logic m;

logic x;
logic [7:0] Aval;
logic [7:0] Bval;

Multiplier M
(
	.clk(clk),
	.run(run),
	.clearA_loadB(ClearA_LoadB),
	.reset(reset),
	.S(S),
	
	.x(x),
	.Aval(Aval),
	.Bval(Bval),
	
	.AhexU(),
	.AhexL(),
	.BhexU(),
	.BhexL()
);

assign state = M.CU.current_state;
assign next_state = M.CU.next_state;
assign count = M.count;
assign m = M.m;

always begin : CLOCK_GENERATION
#1		clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
		clk = 0;
end 


initial begin

reset = 1'b0;
run = 1'b1;
ClearA_LoadB = 1'b1;
S = 8'd00;

#2
reset = 1'b1;

#4
S = 8'd127;
#2
ClearA_LoadB = 1'b0;
#2
ClearA_LoadB = 1'b1;

#4
S = 8'd127;

#2
run = 1'b0;
#2
run = 1'b1;


end

endmodule 