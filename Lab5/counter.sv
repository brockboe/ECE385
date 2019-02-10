module counter8
(
	input logic reset,
	input logic clk,
	input logic count_enable,
	
	output logic [7:0] count
);

	logic [7:0] next_count;

	always_ff @ (posedge clk) begin
	
		if (reset) begin
			count <= 8'h00;
		end
		
		else if (count_enable) begin
			count <= next_count;
		end
	
	end
	
	RippleCarryAdder8bit stepper
	(
		.A(count),
		.B(8'h01),
		.S(next_count),
		.CO()
	);
	
endmodule 