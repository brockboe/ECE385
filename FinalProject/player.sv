module player
(
	input logic reset,
	input logic vsync,
	input logic [7:0] keycode,
	
	output logic pmissile_create,
	output logic [9:0] x_pos
);

	// w = 8'd26
	// a = 8'd4
	// s = 8'd22
	// d = 8'd7
	// space = 8'd44
	
	logic [11:0] subpixel_position;
	
	always_ff @ (posedge vsync or posedge reset) begin
	
		subpixel_position = subpixel_position;
	
		if(reset) begin
			subpixel_position[11:2] = 10'd288;
			pmissile_create = 1'b0;
		end
		
		else begin
		
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