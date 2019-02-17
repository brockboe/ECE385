module testbench();

timeunit 10ns;
timeprecision 1ns;

logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [11:0] LED;

logic [15:0] PC;
logic [15:0] IR;
logic [15:0] MAR;

logic [19:0] ADDR;

logic [15:0] R0;
logic [15:0] R1;


always begin
	#1 Clk = ~Clk;
end

initial begin	
	Clk = 1'b0;
end

lab6_toplevel LC3
(
	.S(S),
	.Clk,
	.Reset,
	.Run,
	.Continue,
	
	.LED,
	.HEX0(),
	.HEX1(),
	.HEX2(),
	.HEX3(),
	.HEX4(),
	.HEX5(),
	.HEX6(),
	.HEX7(),
	
	.CE(),
	.UB(),
	.LB(),
	.OE(),
	.WE(),
	
	.ADDR,
	
	.Data()
);

always_comb begin

	PC = LC3.my_slc.d0.PC.dout;
	IR = LC3.my_slc.d0.IR.dout;
	MAR = LC3.my_slc.d0.MAR.dout;
	R0 = LC3.my_slc.d0.regUnitInstance.Reg[0][15:0];
	R1 = LC3.my_slc.d0.regUnitInstance.Reg[1][15:0];

end

always begin

	Reset = 0;
	Run = 1;
	Continue = 1;
	S = 16'h0003;
	
	#4
	Reset = 1;
	
	#2
	Run = 0;
	#2
	Run = 1;
	
	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;

	#10
	Continue = 0;
	#2
	Continue = 1;	
	
end

endmodule  