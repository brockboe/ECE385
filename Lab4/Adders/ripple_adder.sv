module CRA_4bit
(
	input logic[3:0] A,
	input logic[3:0] B,
	input logic Cin,
	output logic[3:0] S,
	output logic Cout
);

	logic[2:0] C;
	
	fullAdder A1(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(C[0]), .P(), .G());
	fullAdder A2(.A(A[1]), .B(B[1]), .Cin(C[0]), .S(S[1]), .Cout(C[1]), .P(), .G());
	fullAdder A3(.A(A[2]), .B(B[2]), .Cin(C[1]), .S(S[2]), .Cout(C[2]), .P(), .G());
	fullAdder A4(.A(A[3]), .B(B[3]), .Cin(C[2]), .S(S[3]), .Cout(Cout), .P(), .G());
	

endmodule

module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
	  
	  logic [14:0] C;
	  
	  fullAdder A1(.A(A[0]), .B(B[0]), .Cin(1'b0), .S(Sum[0]), .Cout(C[0]), .P(), .G());
	  fullAdder A2(.A(A[1]), .B(B[1]), .Cin(C[0]), .S(Sum[1]), .Cout(C[1]), .P(), .G());
	  fullAdder A3(.A(A[2]), .B(B[2]), .Cin(C[1]), .S(Sum[2]), .Cout(C[2]), .P(), .G());
	  fullAdder A4(.A(A[3]), .B(B[3]), .Cin(C[2]), .S(Sum[3]), .Cout(C[3]), .P(), .G());
	  fullAdder A5(.A(A[4]), .B(B[4]), .Cin(C[3]), .S(Sum[4]), .Cout(C[4]), .P(), .G());
	  fullAdder A6(.A(A[5]), .B(B[5]), .Cin(C[4]), .S(Sum[5]), .Cout(C[5]), .P(), .G());
	  fullAdder A7(.A(A[6]), .B(B[6]), .Cin(C[5]), .S(Sum[6]), .Cout(C[6]), .P(), .G());
	  fullAdder A8(.A(A[7]), .B(B[7]), .Cin(C[6]), .S(Sum[7]), .Cout(C[7]), .P(), .G());
	  fullAdder A9(.A(A[8]), .B(B[8]), .Cin(C[7]), .S(Sum[8]), .Cout(C[8]), .P(), .G());
	  fullAdder A10(.A(A[9]), .B(B[9]), .Cin(C[8]), .S(Sum[9]), .Cout(C[9]), .P(), .G());
	  fullAdder A11(.A(A[10]), .B(B[10]), .Cin(C[9]), .S(Sum[10]), .Cout(C[10]), .P(), .G());
	  fullAdder A12(.A(A[11]), .B(B[11]), .Cin(C[10]), .S(Sum[11]), .Cout(C[11]), .P(), .G());
	  fullAdder A13(.A(A[12]), .B(B[12]), .Cin(C[11]), .S(Sum[12]), .Cout(C[12]), .P(), .G());
	  fullAdder A14(.A(A[13]), .B(B[13]), .Cin(C[12]), .S(Sum[13]), .Cout(C[13]), .P(), .G());
	  fullAdder A15(.A(A[14]), .B(B[14]), .Cin(C[13]), .S(Sum[14]), .Cout(C[14]), .P(), .G());
	  fullAdder A16(.A(A[15]), .B(B[15]), .Cin(C[14]), .S(Sum[15]), .Cout(CO), .P(), .G());

     
endmodule
