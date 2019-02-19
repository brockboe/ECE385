module register_unit
(
	input logic DR,
	input logic LDREG,
	input logic SR1,
	input logic [2:0] IR_slice_119,
	input logic [2:0] IR_slice_86,
	input logic [2:0] SR2,
	input logic [15:0] bus,
	input logic clk,
	
	output logic [15:0] SR1_out,
	output logic [15:0] SR2_out
);

	logic [2:0][15:0] Reg;
	logic [2:0] SR1MUXOUT;
	logic [2:0] DRMUXOUT;
	
	mux_3bit_2input DRMUX
	(
		.In1(3'b111), 
		.In0(IR_slice_119), 
		.select(DR), 
		.out(DRMUXOUT)
	);
	
	mux_3bit_2input SR1MUX
	(
		.In0(IR_slice_119), 
		.In1(IR_slice_86), 
		.select(SR1), 
		.out(SR1MUXOUT)
	);
	
	always_ff @ (posedge clk) begin

		SR2_out 					<= Reg[SR1MUXOUT][15:0];
		SR1_out 					<= Reg[SR2][15:0];

		if(LDREG)
			Reg[DRMUXOUT][15:0] 	<= bus;
	
	end
	
endmodule 