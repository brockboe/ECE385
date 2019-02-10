module ShiftRegister
(
	input logic clk,
	input logic [7:0] data_in,
	input logic reset,
	input logic shift_en,
	input logic load,
	input logic shift_in,
	
	output logic [7:0] data_out,
	output logic shiftout
);

	always_ff @ (posedge clk)
	begin

		if (reset)
			data_out = 8'h00;

		else if (load)
			data_out = data_in;
		
		else if (shift_en) begin
			data_out = {shift_in, data_out[7:1]};
		end
			
	end
	
	assign shiftout = data_out[0];
	
endmodule 