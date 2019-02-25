module LED_Handler
(
	input logic [11:0] in,
	input logic clk,
	input logic reset,
	input logic LD_LED,
	
	output logic [11:0] LED
);

	always_ff @ (posedge clk) begin
	
	if(reset)
		LED <= 12'h000;
	else if (LD_LED)
		LED <= in;
	
	end

endmodule 