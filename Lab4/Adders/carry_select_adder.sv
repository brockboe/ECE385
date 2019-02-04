module M2t1Mux4bit
(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic Select,
	output logic [3:0] Out
);

	assign Out[0] = (Select) ? A[0] : B[0];
	assign Out[1] = (Select) ? A[1] : B[1];
	assign Out[2] = (Select) ? A[2] : B[2];
	assign Out[3] = (Select) ? A[3] : B[3];

endmodule

module CSA_4bit
(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic Cin,
	output logic Cout,
	output logic [3:0] S
);

	logic [3:0] SCarryHigh;
	logic [3:0] SCarryLow;
	logic CoutHigh, CoutLow;

	CRA_4bit CarryHigh(.A(A), .B(B), .Cin(1'b1), .S(SCarryHigh), .Cout(CoutHigh));
	CRA_4bit CarryLow(.A(A), .B(B), .Cin(1'b0), .S(SCarryLow), .Cout(CoutLow));
	
	M2t1Mux4bit outMux(SCarryHigh, SCarryLow, Cin, S);
	assign Cout = (Cin & CoutHigh) | CoutLow;
	
endmodule 

module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic [2:0] C;
	
	CRA_4bit initialAdder(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(Sum[3:0]), .Cout(C[0]));
	CSA_4bit CSA1(.A(A[7:4]), .B(B[7:4]), .Cin(C[0]), .Cout(C[1]), .S(Sum[7:4]));
	CSA_4bit CSA2(.A(A[11:8]), .B(B[11:8]), .Cin(C[1]), .Cout(C[2]), .S(Sum[11:8]));
	CSA_4bit CSA3(.A(A[15:12]), .B(B[15:12]), .Cin(C[2]), .Cout(CO), .S(Sum[15:12]));

endmodule
