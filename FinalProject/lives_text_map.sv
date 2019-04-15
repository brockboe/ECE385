module lives_text_map
(
	input logic [5:0] X,
	input logic [3:0] Y,
	output logic pixel
);

	logic [7:0] rom_address;
	logic [7:0] text_slice;
	
	assign pixel = text_slice[3'b111 - X[2:0]];

	lives_text_rom text_rom(.address(rom_address), .data(text_slice));
	
	always_comb begin
		
		if(X >= 6'd0 && X < 6'd8) begin
			rom_address = 8'd0 + Y;
		end
		
		else if(X >= 8'd8 && X < 6'd16) begin
			rom_address = 8'd16 + Y;
		end
		
		else if(X >= 6'd16 && X < 6'd24) begin
			rom_address = 8'd32 + Y;
		end
		
		else begin
			rom_address = 8'd48 + Y;
		end
		
	end

endmodule 