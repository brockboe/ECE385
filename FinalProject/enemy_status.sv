module enemy_status
(
	input		logic	reset,
	input		logic [6:0] enemy_hit,
	input		logic collision,

	output	logic [9:0][5:0]	enemy_status
);

	always_ff @ (posedge reset or posedge collision) begin
		
		if(reset) begin
			enemy_status <= {
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111 
			};
		end
		
		else if(collision) begin
			enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
		end
		
	end

endmodule 