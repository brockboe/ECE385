module counter8
(
	input logic reset,
	input logic clk,
	input logic count_enable,
	
	output logic [7:0] count
);

	logic [7:0] next_count;
	
	always_ff @ (posedge reset or posedge count_enable) begin

		if(reset)
			count <= 8'h00;
		else if(count_enable)
			count <= next_count;

	end
	
	RippleCarryAdder8bit stepper
	(
		.A(count),
		.B(8'h01),
		.S(next_count),
		.CO()
	);
	
endmodule 