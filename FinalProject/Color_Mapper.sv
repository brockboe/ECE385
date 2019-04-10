//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

//64

// First row = 32
// Second Row = 96
// Third Row = 160
// Third Row Limit = 224


// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input	logic	[7:0] animation_offset,	
							  input 	logic [9:0] enemy_offset,
							  input	logic	[9:0] player_offset,
							  
							  input 	logic 		missile_exists,
							  input	logic [9:0] missileX,
							  input 	logic [9:0] missileY,
							  
							  input	logic			pmissile_exists,
							  input 	logic [9:0] pMissileX,
							  input 	logic [9:0] pMissileY,
							  
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic [7:0] sprite_slice, sprite_addr;
	 logic current_sprite_pixel;
	 
	 logic [15:0] player_slice;
	 logic [7:0]  player_addr;
	 logic current_player_pixel;
	 
	 logic [9:0] enemy_x_normalized;
	 logic [9:0] player_x_normalized;
	 
	 assign enemy_x_normalized = DrawX - enemy_offset;
	 assign player_x_normalized = DrawX - player_offset;
	 
	 sprite_rom ROM_enemy(.addr(sprite_addr), .data(sprite_slice));
	 ship_rom ROM_player(.addr(player_addr), .data(player_slice));
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
	 
		if(DrawY < 10'd96)
			sprite_addr = { 5'b0, DrawY[4:2]} + animation_offset;
		else if(DrawY >= 10'd96 && DrawY < 10'd160)
			sprite_addr = { 5'b0, DrawY[4:2]} + animation_offset + 8'd16;
		else
			sprite_addr = { 5'b0, DrawY[4:2]} + animation_offset + 8'd32;
			
		player_addr = 	{5'b0, DrawY[4:2]};
			
		//some default pixel values
		current_player_pixel = 1'b0;
	 	current_sprite_pixel = 1'b0;
	 
		//Draw the enemies
      if (enemy_x_normalized[5] == 1'b0 && 
		DrawY < 10'd224 && 
		DrawY >= 10'd32 && 
		DrawX >= enemy_offset) begin				
				current_sprite_pixel = sprite_slice[enemy_x_normalized[4:2]];
				
				if(current_sprite_pixel == 1'b1) begin
					Red = 8'hff;
					Green = 8'h99;
					Blue = 8'h33;
				end
				
				else begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				
		end
		
		//draw the enemy missile
		else if(missile_exists &&
		DrawX[9:2] == missileX[9:2] &&
		DrawY[9:2] == missileY[9:2]) begin
		
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		
		end
		
		//draw the player missile
		else if(pmissile_exists &&
		DrawX[9:2] == pMissileX[9:2] &&
		DrawY[9:2] == pMissileY[9:2]) begin
		
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		
		end
		
		//Draw the ship
		else if(DrawY >= 10'd448 &&
		DrawX >= player_offset &&
		DrawX < player_offset + 10'd64) begin
		
			current_player_pixel = player_slice[player_x_normalized[5:2]];
			
			if(current_player_pixel == 1'b1) begin
				Red = 8'h00;
				Green = 8'hff;
				Blue = 8'hff;
			end
			
			else begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
		
		end
		
		else 
		begin
            // Background with nice color gradient
            //Red = 8'h3f; 
            //Green = 8'h00;
            //Blue = 8'h7f - {1'b0, DrawX[9:3]};
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
	  end
 end 
    
endmodule
