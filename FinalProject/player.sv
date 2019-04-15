module player
(
	input logic reset,
	input logic vsync,
	input logic [7:0] keycode,
	input logic pcollision,
	
	output logic pmissile_create,
	output logic player_flash,
	output logic [9:0] x_pos,
	output logic [2:0] lives
);

	// w = 8'd26
	// a = 8'd4
	// s = 8'd22
	// d = 8'd7
	// space = 8'd44
	
	logic [11:0] subpixel_position;
	logic invincible;
	logic [7:0] invincible_counter;
	
	assign player_flash = invincible_counter[3];
	
	always_ff @ (posedge vsync or posedge reset) begin
	
		subpixel_position = subpixel_position;
	
		if(reset) begin
			subpixel_position[11:2] = 10'd288;
			pmissile_create = 1'b0;
			lives = 3'd3;
			invincible = 1'b0;
			invincible_counter = 8'd0;
		end
		
		else begin
		
			if(pcollision && lives > 3'd0 && !invincible) begin
				lives = lives - 3'd1;
				invincible = 1'b1;
				invincible_counter = 1'b0;
			end
			else if(invincible && invincible_counter <= 8'd180) begin
				invincible_counter = invincible_counter + 8'd1;
			end
			else begin
				invincible_counter = 8'd0;
				invincible = 1'b0;
			end
							
			if(keycode == 8'd4)
				subpixel_position = subpixel_position - 12'd6;
			else if(keycode == 8'd7)
				subpixel_position = subpixel_position + 12'd6;
			else if(keycode == 8'd44)
				pmissile_create = 1'b1;
			else
				pmissile_create = 1'b0;
			
			//check the left bound
			if(subpixel_position[11:2] == 10'd0)
				subpixel_position = 12'd0;
			
			//check for overflow
			else if(subpixel_position[11:2] >= 10'd999)
				subpixel_position = 12'd0;
			
			//check the right bound
			else if(subpixel_position[11:2] > 10'd576)
				subpixel_position[11:2] = 10'd576;
			
		end
	
	end
	
	assign x_pos = subpixel_position[11:2];
	
endmodule 