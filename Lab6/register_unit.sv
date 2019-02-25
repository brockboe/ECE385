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
	input logic reset,
	
	output logic [15:0] SR1_out,
	output logic [15:0] SR2_out
);

	logic [7:0][15:0] Reg;
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
	
		if(reset) begin
			Reg[0] <= 16'h0000;
			Reg[1] <= 16'h0000;
			Reg[2] <= 16'h0000;
			Reg[3] <= 16'h0000;
			Reg[4] <= 16'h0000;
			Reg[5] <= 16'h0000;
			Reg[6] <= 16'h0000;
			Reg[7] <= 16'h0000;			
		end

		else if(LDREG) begin
		
			case(DRMUXOUT)
				3'b000: Reg[0] <= bus;
				3'b001: Reg[1] <= bus;
				3'b010: Reg[2] <= bus;
				3'b011: Reg[3] <= bus;
				3'b100: Reg[4] <= bus;
				3'b101: Reg[5] <= bus;
				3'b110: Reg[6] <= bus;
				3'b111: Reg[7] <= bus;
			endcase
			
		end
			
	end
	
	always_comb begin
			case(SR1MUXOUT)
				3'b000: SR1_out <= Reg[0];
				3'b001: SR1_out <= Reg[1];
				3'b010: SR1_out <= Reg[2];
				3'b011: SR1_out <= Reg[3];
				3'b100: SR1_out <= Reg[4];
				3'b101: SR1_out <= Reg[5];
				3'b110: SR1_out <= Reg[6];
				3'b111: SR1_out <= Reg[7];
			endcase
		
			case(SR2)
				3'b000: SR2_out <= Reg[0];
				3'b001: SR2_out <= Reg[1];
				3'b010: SR2_out <= Reg[2];
				3'b011: SR2_out <= Reg[3];
				3'b100: SR2_out <= Reg[4];
				3'b101: SR2_out <= Reg[5];
				3'b110: SR2_out <= Reg[6];
				3'b111: SR2_out <= Reg[7];
			endcase			
	end
	
endmodule 