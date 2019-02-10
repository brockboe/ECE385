module FullAdder
(
	input logic A,
	input logic B,
	input logic C,
	output logic S,
	output logic CO
);


	always_comb
	begin
		S = A ^ B ^ C;
		CO = (A & B) | (B & C) | (A & C);
	end

endmodule 


module RippleCarryAdder8bit
(
	input logic [7:0] A,
	input logic [7:0] B,
	output logic [7:0] S,
	output logic CO
);

	logic [6:0] Cinner;

	FullAdder FA1(.A(A[0]), .B(B[0]), .C(1'b0), .S(S[0]), .CO(Cinner[0]));
	FullAdder FA2(.A(A[1]), .B(B[1]), .C(Cinner[0]), .S(S[1]), .CO(Cinner[1]));
	FullAdder FA3(.A(A[2]), .B(B[2]), .C(Cinner[1]), .S(S[2]), .CO(Cinner[2]));
	FullAdder FA4(.A(A[3]), .B(B[3]), .C(Cinner[2]), .S(S[3]), .CO(Cinner[3]));
	FullAdder FA5(.A(A[4]), .B(B[4]), .C(Cinner[3]), .S(S[4]), .CO(Cinner[4]));
	FullAdder FA6(.A(A[5]), .B(B[5]), .C(Cinner[4]), .S(S[5]), .CO(Cinner[5]));
	FullAdder FA7(.A(A[6]), .B(B[6]), .C(Cinner[5]), .S(S[6]), .CO(Cinner[6]));
	FullAdder FA8(.A(A[7]), .B(B[7]), .C(Cinner[6]), .S(S[7]), .CO(CO));
		
endmodule


//Perform A - B
module RippleCarrySubtractor8bit
(
	input logic [7:0] A,
	input logic [7:0] B,
	output logic [7:0] S,
	output logic CO
);

	logic [7:0] minusB;
	
	RippleCarryAdder8bit inverter(.A(8'h01), .B(~B), .S(minusB), .CO());
	RippleCarryAdder8bit subtractor(.A(A), .B(minusB), .S(S), .CO(CO));
	
endmodule 