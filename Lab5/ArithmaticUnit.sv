module ArithmaticUnit
(
	input logic [7:0] S,
	input logic shift,
	input logic add,
	input logic sub,
	input logic clearA_LoadB,
	input logic clk,
	input logic reset,
	
	output logic [7:0] Aout,
	output logic [7:0] Bout,
	output logic x,
	output logic m
);

	logic Aloaden, Bloaden;
	logic Ashiften, Bshiften;
	logic Areset, Breset;

	logic [7:0] ALoadData;
	logic [7:0] BLoadData;
	logic AshiftDataOut;
	
	logic [7:0] AminusS;
	logic AminusSCO;
	logic [7:0] AplusS;
	logic AplusSCO;
	
	RippleCarryAdder8bit Adder
	(
		.A(Aout),
		.B(S),
		.S(AplusS),
		.CO(AplusSCO)
	);
	
	RippleCarrySubtractor8bit Subtractor
	(
		.A(Aout),
		.B(S),
		.S(AminusS),
		.CO(AminusSCO)
	);
	
	ShiftRegister A
	(
		.clk(clk),
		.data_in(ALoadData),
		.reset(Areset),
		.shift_en(Ashiften),
		.load(Aloaden),
		.shift_in(x),
		.data_out(Aout),
		.shiftout(AshiftDataOut)
	);
	
	ShiftRegister B
	(
		.clk(clk),
		.data_in(BLoadData),
		.reset(Breset),
		.shift_en(Bshiften),
		.load(Bloaden),
		.shift_in(AshiftDataOut),
		.data_out(Bout),
		.shiftout(m)	
	);
							
	always_ff @ (posedge clk)
	begin
		
		if(reset) begin
			Areset <= 1'b1;
			Breset <= 1'b1;
			Aloaden <= 1'b0;
			Bloaden <= 1'b0;
			Ashiften <= 1'b0;
			Bshiften <= 1'b0;
		end
		
		else if (clearA_LoadB) begin
			Areset <= 1'b1;
			
			Breset <= 1'b0;
			Bshiften <= 1'b0;
			Bloaden <= 1'b1;
			BLoadData <= S;
			
			x = S[7];
			
		end
		
		else if (shift) begin
			Areset <= 1'b0;
			Breset <= 1'b0;
			
			Ashiften <= 1'b1;
			Bshiften <= 1'b1;
			
			Aloaden <= 1'b0;
			Bloaden <= 1'b0;
			
		end
		
		else if (add) begin
			Areset <= 1'b0;
			Breset <= 1'b0;
			Ashiften <= 1'b0;
			Bshiften <= 1'b0;

			Aloaden <= 1'b1;
			Bloaden <= 1'b0;
			
			ALoadData = AplusS;
			x = AplusS[7];
		end
		
		else if (sub) begin
			Areset <= 1'b0;
			Breset <= 1'b0;
			Ashiften <= 1'b0;
			Bshiften <= 1'b0;

			Aloaden <= 1'b1;
			Bloaden <= 1'b0;

			ALoadData = AminusS;
			x = AminusS[7];
		end
		
		else begin
			Areset <= 1'b0;
			Breset <= 1'b0;
			Ashiften <= 1'b0;
			Bshiften <= 1'b0;
			Aloaden <= 1'b0;
			Bloaden <= 1'b0;
		end
		
	end

endmodule 