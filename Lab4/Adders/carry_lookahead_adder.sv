module carry_lookahead_adder_4bit
(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic Cin,
	output logic [3:0] Sum,
	output logic Cout, PG, GG
);

	logic [3:0] P;
	logic [3:0] G;
	logic [3:0] C;
	
	assign C[0] = Cin;
	assign C[1] = (Cin & P[0]) | G[0];
	assign C[2] = (Cin & P[0] & P[1]) | (G[0] & P[1]) | G[1];
	assign C[3] = (Cin & P[0] & P[1] & P[2]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];

	
	fullAdder FA0(.A(A[0]), .B(B[0]), .Cin(C[0]), .S(Sum[0]), .P(P[0]), .G(G[0]), .Cout());
	fullAdder FA1(.A(A[1]), .B(B[1]), .Cin(C[1]), .S(Sum[1]), .P(P[1]), .G(G[1]), .Cout());
	fullAdder FA2(.A(A[2]), .B(B[2]), .Cin(C[2]), .S(Sum[2]), .P(P[2]), .G(G[2]), .Cout());
	fullAdder FA3(.A(A[3]), .B(B[3]), .Cin(C[3]), .S(Sum[3]), .P(P[3]), .G(G[3]), .Cout());		
	
	assign Cout = (Cin & P[0] & P[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[2] & P[3]) | G[3];
	assign PG = (P[0] & P[1] & P[2] & P[3]);
	assign GG = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]);
	
endmodule 

module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic C0, C4, C8, C12;
	logic [3:0] PG;
	logic [3:0] GG;
	
	assign C0 = 1'b0;
	assign C4 = GG[0] | (C0 & PG[0]);
	assign C8 = GG[1] | (GG[0] & PG[1]) | (C0 & PG[0] & PG[1]);
	assign C12 = GG[2] | (GG[0] & PG[1] & PG[2]) | (C0 & PG[2] & PG[1] & PG[0]);

	carry_lookahead_adder_4bit CLA1(.A(A[3:0]), .B(B[3:0]), .Cin(C0), .Sum(Sum[3:0]), .Cout(), .PG(PG[0]), .GG(GG[0]));
	carry_lookahead_adder_4bit CLA2(.A(A[7:4]), .B(B[7:4]), .Cin(C4), .Sum(Sum[7:4]), .Cout(), .PG(PG[1]), .GG(GG[1]));
	carry_lookahead_adder_4bit CLA3(.A(A[11:8]), .B(B[11:8]), .Cin(C8), .Sum(Sum[11:8]), .Cout(), .PG(PG[2]), .GG(GG[2]));
	carry_lookahead_adder_4bit CLA4(.A(A[15:12]), .B(B[15:12]), .Cin(C12), .Sum(Sum[15:12]), .Cout(), .PG(PG[3]), .GG(GG[3]));

	assign CO = (C0 & PG[0] & PG[1] & PG[2] & PG[3]) | (GG[1] & PG[2] & PG[3]) | (GG[2] & PG[3]) | GG[3];
	     
endmodule
