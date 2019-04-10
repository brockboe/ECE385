module enemy_missile
(
	input		logic				reset,
	input		logic	[9:0]		playerX,
	input		logic [9:0][5:0] 	enemy_status,
	input		logic				vsync,
	input		logic [9:0]		enemy_offset,
	
	output	logic				exists,
	output 	logic	[9:0]		missileX,
	output	logic	[9:0]		missileY
);

	logic [7:0] missile_timer;
	logic [5:0] enemy_column;
	logic [3:0] column_index;
	
	always_ff @ (posedge vsync or posedge reset) begin

		if(reset) begin
			missile_timer = 8'd0;
			exists = 1'b0;
		end
		
		else begin
		
			missileX = missileX;
		
			//wait for when we can send the next missile
			if(missile_timer < 8'd120 && !exists) begin
				missile_timer = missile_timer + 8'd1;
			end
			
			//if it's time, create the missile (if we can)
			else if(!exists && missile_timer >= 8'd120) begin
			
				missileX = {column_index, 6'b0} + enemy_offset + 10'd16;
				missile_timer = 8'd0;
			
				if(enemy_column[5]) begin
					exists = 1'b1;
					missileY = 10'd224;
				end
				
				else if(enemy_column[4]) begin
					exists = 1'b1;
					missileY = 10'd192;
				end
				
				else if(enemy_column[3]) begin
					exists = 1'b1;
					missileY = 10'd160;
				end
				
				else if(enemy_column[2]) begin
					exists = 1'b1;
					missileY = 10'd128;
				end
				
				else if(enemy_column[1]) begin
					exists = 1'b1;
					missileY = 10'd96;
				end
				
				else if(enemy_column[0]) begin
					exists = 1'b1;
					missileY = 10'd64;
				end
				
			end
			
			//check for collision
			else if (missileY >= 480) begin
				
				exists = 1'b0;
				
			end
			
			//otherwise update y position
			else if(exists) begin
				
				missileY = missileY + 10'd3;
				
			end
							
		end
		
	end
	
	always_comb begin
	
		column_index = playerX[9:6];
		enemy_column = enemy_status[column_index];

	end

endmodule 