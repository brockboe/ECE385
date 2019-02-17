module datapath
(
	input logic reset,
					clk,

	input logic LD_MAR,
					LD_MDR,
					LD_IR,
					LD_BEN,
					LD_CC,
					LD_REG,
					LD_PC,
					LD_LED,

	input logic	GatePC,
					GateMDR,
					GateALU,
					GateMARMUX,

	input logic [1:0] PCMUX,
	input logic [1:0] ADDR2MUX,
	input logic DRMUX,
					SR1MUX,
					SR2MUX,
					ADDR1MUX,
	input logic[1:0] ALUK,
							
	input logic MEMIO,
					
	input logic [15:0] Data_to_CPU,
					
	output logic BEN,
					
	output logic [15:0] IR_OUT,
	output logic [15:0] PC_OUT,
	output logic [15:0] MAR_OUT,
	
	output logic [15:0] Data_from_CPU
);

	logic [15:0] bus;
	
	logic [15:0] PCMUXOUT;
	logic [15:0] PCOUT;
	logic [15:0] IROUT;

	logic [15:0] IRSEXT10;
	logic [15:0] IRSEXT8;
	logic [15:0] IRSEXT5;
	logic [15:0] IRSEXT4;
	
	logic [15:0] ADDR2MUXOUT;
	logic [15:0] ADDR1MUXOUT;

	logic [15:0] SR1_OUT;
	logic [15:0] SR2_OUT;
	
	logic [15:0] SR2MUXOUT;

	logic [15:0] ALUOUT;
	
	logic [15:0] MDROUT;
	
	logic [15:0] MDRMUXOUT;
	
	
	reg16 PC
	(
		.din(PCMUXOUT),
		.clk(clk),
		.load(LD_PC),
		.reset(reset),
		
		.dout(PCOUT)
	);
	
	reg16 IR
	(
		.din(bus),
		.clk(clk),
		.load(LD_IR),
		.reset(reset),
		
		.dout(IROUT)
	);
	
	mux_16bit_4input PCMUXinstance
	(
		.select(PCMUX),
		.In1(bus),
		.In2(ADDR1MUXOUT + ADDR2MUXOUT),
		.In0(PCOUT + 16'h0001),
		.In3(),
		
		.out(PCMUXOUT)
	);
		
	SEXT10 IRsexter10 (.in(IROUT[10:0]), .out(IRSEXT10));
	SEXT8 IRsexter8 (.in(IROUT[8:0]), .out(IRSEXT8));
	SEXT5 IRsexter5 (.in(IROUT[5:0]), .out(IRSEXT5));
	SEXT4 IRsexter4 (.in(IROUT[4:0]), .out(IRSEXT4));
	
	mux_16bit_4input ADDR2MUXinstance
	(
		.select(ADDR2MUX),
		.In0(IRSEXT10),
		.In1(IRSEXT8),
		.In2(IRSEXT5),
		.In3(16'h0000),
		
		.out(ADDR2MUXOUT)
	);
	
	mux_16bit_2input ADDR1MUXinstance
	(
		.select(ADDR1MUX),
		.In0(PCOUT),
		.In1(SR1_OUT),
		
		.out(ADDR1MUXOUT)
	);
	
	
	register_unit regUnitInstance
	(
		.DR(DRMUX),
		.LDREG(LD_REG),
		.SR1(SR1MUX),
		.IR_slice_119(IROUT[11:9]),
		.IR_slice_86(IROUT[8:6]),
		.SR2(),									//fill me in - part 2
		.bus(bus),
		.clk(clk),
		
		.SR1_out(SR1_OUT),
		.SR2_out(SR2_OUT)
	);
	
	
	mux_16bit_2input SR2MUXinstance
	(
		.select(SR2MUX),
		.In0(IRSEXT4),
		.In1(SR2_OUT),
		
		.out(SR2MUXOUT)
	);
	
	
	alu aluInstance
	(
		.ALUK(ALUK),
		.A(SR1_OUT),
		.B(SR2MUXOUT),
		
		.out(ALUOUT)
	);
	
	BEN_block BENLogic
	(
		.bus(bus),
		.LDCC(LD_CC),
		.IR_in(IROUT[11:9]),
		.LDBEN(LD_BEN),
		.clk(clk),
		
		.BEN(BEN)
	);
	
	bus_mux BusMuxInstance
	(
		.GateMARMUX(GateMARMUX),
		.GatePC(GatePC),
		.GateMDR(GateMDR),
		.GateALU(GateALU),
		
		.ADDRSum(ADDR1MUXOUT + ADDR2MUXOUT),
		.ALUOUT(ALUOUT),
		.PCOUT(PCOUT),
		.MDROUT(MDROUT),
		
		.out(bus)
	);
	
	
	reg16 MDR
	(
		.din(MDRMUXOUT),
		.clk(clk),
		.load(LD_MDR),
		.reset(reset),
		
		.dout(MDROUT)
	);
		
	reg16 MAR
	(
		.din(bus),
		.clk(clk),
		.load(LD_MAR),
		.reset(reset),
		
		.dout(MAR_OUT)
	);
		
	
	mux_16bit_2input MDRMUXInstance
	(
		.select(MEMIO),
		.In0(bus),
		.In1(Data_to_CPU),
		
		.out(MDRMUXOUT)
	);
	
	
endmodule 