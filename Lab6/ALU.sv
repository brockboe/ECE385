module alu
(
	input logic [1:0] ALUK,
	input logic [15:0] A,
	input logic [15:0] B,
	output logic [15:0] out
);

	always_comb begin
	
		case(ALUK)
		2'b00: out <= A + B;
		2'b01: out <= A & B;
		2'b10: out <= ~A;
		2'b11: out <= A;
		endcase
	
	end

endmodule 