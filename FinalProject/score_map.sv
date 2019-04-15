module score_map
(
	input logic 		vsync,
	input logic 		reset,
	input logic [5:0] X,
	input logic	[3:0] Y,

	input logic enemy_collision,
	
	output logic pixel
);

	logic [3:0] score_hundreds;
	logic [3:0] score_tens;
	logic [3:0] score_ones;
	
	logic [7:0] number_slice;
	logic [7:0] number_address;
	
	number_rom rom_instance(.address(number_address), .data(number_slice));
	
	assign pixel = number_slice[3'b111 - X[2:0]];
	
	always_ff @ (posedge reset or posedge vsync) begin
		if(reset) begin
			score_hundreds = 4'd1;
			score_tens = 4'd2;
			score_ones = 4'd3;
		end
		
		else if(enemy_collision) begin
			score_ones = score_ones + 4'd1;

			if(score_ones > 4'd9) begin
				score_ones = 4'd0;
				score_tens = score_tens + 4'd1;
			end

			if(score_tens > 4'd9) begin
				score_tens = 4'd0;
				score_hundreds = score_hundreds + 4'd1;
			end
			
			if(score_hundreds > 4'd9) begin
				score_hundreds = 4'd0;
			end
			
		else begin
			score_hundreds = score_hundreds;
			score_tens = score_tens;
			score_ones = score_ones;
		end
			
		end
		
	end

	always_comb begin
	
		if(X >= 6'd0 && X < 6'd8) begin
			number_address = {score_hundreds, 4'b0} + Y;
		end
		
		else if(X >= 6'd8 && X < 6'd16) begin
			number_address = {score_tens, 4'b0} + Y;
		end
		
		else begin
			number_address = {score_ones, 4'b0} + Y;
		end
	
	end
	
endmodule 