module fullAdder
(
	input logic A, B, Cin,
	output logic S, P, G, Cout
);

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);
	assign P = A ^ B;
	assign G = A & B;

endmodule
