//enumeration of states
// 0 - Halted
// 1 - PauseIR1
// 2 - PauseIR2
// 3 - S_18
// 4 - S_33_1
// 5 - S_33_2
// 6 - S_35
// 7 - S_32
// 8 - S_01
// 9 - S_05
// 10 - S_09
// 11 - S_06
// 12 - S_25_1
// 13 - S_25_2
// 14 - S_25_3
// 15 - S_27
// 16 - S_07
// 17 - S_23
// 18 - S_16_1
// 19 - S_16_2
// 20 - S_16_3
// 21 - S_04
// 22 - S_21
// 23 - S_12
// 24 - S_00
// 25 - S_22

module testbench();

timeunit 10ns;
timeprecision 1ns;

logic [15:0] S;
logic Clk, Reset, Run, Continue;

logic [15:0] PC;
logic [15:0] IR;
logic [15:0] MAR;
logic [15:0] MDR;
logic [15:0] HEX;
logic [4:0] STATE;
logic [11:0] LED;
logic [3:0] BRNZP;
logic [15:0] bus;

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

	.ADDR(),

	.Data()
);

always_comb begin

	PC = LC3.my_slc.d0.PC.dout;
	IR = LC3.my_slc.d0.IR.dout;
	MAR = LC3.my_slc.d0.MAR.dout;
	MDR = LC3.my_slc.d0.MDR.dout;
	HEX = LC3.my_slc.hex_4;
	STATE = LC3.my_slc.state_controller.State;
	bus = LC3.my_slc.d0.bus;
	BRNZP = {LC3.my_slc.d0.BENLogic.BEN, LC3.my_slc.d0.BENLogic.N, LC3.my_slc.d0.BENLogic.Z, LC3.my_slc.d0.BENLogic.P};
	
end

always begin

	Reset = 0;
	Run = 1;
	Continue = 1;
	S = 16'h005A;

	#4
	Reset = 1;

	#2
	Run = 0;
	#2
	Run = 1;


	#100
	S = 16'h0003;
	#2
	Continue = 0;
	#2
	Continue = 1;
	
	#100
	Continue = 0;
	#2
	Continue = 1;
	
	#100
	Continue = 0;
	#2
	Continue = 1;

	#100
	Continue = 0;
	#2
	Continue = 1;

	#100
	Continue = 0;
	#2
	Continue = 1;

	#100
	Continue = 0;
	#2
	Continue = 1;
	
end

endmodule
