module player_missile
(
	input		logic			reset,
	input		logic	[9:0]	playerx,
	input		logic			vsync,
	input		logic			create,
	input		logic			has_collided,
	
	output	logic exists,
	output	logic [9:0]	playerMissileX,
	output	logic [9:0] playerMissileY
);

	logic creation_flag;

	always_ff @ (posedge vsync or posedge reset) begin
	
		playerMissileX = playerMissileX;
		playerMissileY = playerMissileY;
	
		if(reset) begin
			exists = 1'b0;
			playerMissileX = 10'd0;
			playerMissileY = 10'd0;
		end
	
		else begin
			
			if(create) begin
				creation_flag = 1'b1;
			end
			
			else begin
				creation_flag = 1'b0;
			end
			
			if(has_collided) begin
				exists = 1'b0;
			end
			
			else if(creation_flag && !exists) begin
				exists = 1'b1;
				playerMissileX = playerx + 10'd30;
				playerMissileY = 10'd448;
			end
			
			else if(exists && playerMissileY == 10'd0) begin
				exists = 1'b0;
			end
			
			else if(exists) begin
				playerMissileY = playerMissileY - 10'd4;
			end
		
		end
	
	end
	
	always_comb begin
	
	
	
	end

endmodule