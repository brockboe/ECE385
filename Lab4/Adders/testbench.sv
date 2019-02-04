module testbench();

	timeunit 10ns;

	timeprecision 1ns;
	
	logic [15:0] A;
	logic [15:0] B;
	logic [15:0] Sum_RC;
	logic [15:0] Sum_CSA;
	logic [15:0] Sum_CLA;
	logic CO_RC;
	logic CO_CSA;
	logic CO_CLA;
	
	carry_select_adder 		CSA(.A(A), .B(B), .Sum(Sum_CSA), .CO(CO_CSA));
	carry_lookahead_adder 	CLA(.A(A), .B(B), .Sum(Sum_CLA), .CO(CO_CLA));
	ripple_adder 				 RA(.A(A), .B(B), .Sum(Sum_RC),  .CO(CO_RC));
		
	//Begin the testing
	initial begin
	
	
		A = 16'h3333;
		B = 16'h4444;
		
		#20
		
		A = 16'h8888;
		B = 16'h8888;
		
		#20
		
		A = 16'h6789;
		B = 16'hABCD;
		
		#20
		
		A = 16'h1234;
		B = 16'h5678;
	
	end
	

endmodule 