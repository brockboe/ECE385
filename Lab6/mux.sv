module mux_16bit_2input
(
	input logic select,
	input logic [15:0] In0,
	input logic [15:0] In1,
	
	output logic [15:0] out
);

	always_comb begin
	
		case(select)
		1'b0: out <= In0;
		1'b1: out <= In1;
		endcase
	
	end

endmodule 


module mux_16bit_4input
(
	input logic [1:0] select,
	input logic [15:0] In0,
	input logic [15:0] In1,
	input logic [15:0] In2,
	input logic [15:0] In3,
	
	output logic [15:0] out
);

	always_comb begin
	
		case(select)
		2'b00: out <= In0;
		2'b01: out <= In1;
		2'b10: out <= In2;
		2'b11: out <= In3;
		endcase
	
	end

endmodule 

module mux_3bit_2input
(
	input logic select,
	input logic [2:0] In0,
	input logic [2:0] In1,

	output logic [2:0] out
);

	always_comb begin
	
		case(select)
		1'b0: out <= In0;
		1'b1: out <= In1;
		endcase
		
	end

endmodule 

module bus_mux
(
	input logic GateMARMUX,
	input logic GatePC,
	input logic GateMDR,
	input logic GateALU,
	
	input logic [15:0] ADDRSum,
	input logic [15:0] ALUOUT,
	input logic [15:0] PCOUT,
	input logic [15:0] MDROUT,
	
	output logic [15:0] out
);

	always_comb begin
	
		if(GateMARMUX)
			out <= ADDRSum;
		else if (GatePC)
			out <= PCOUT;
		else if (GateMDR)
			out <= MDROUT;
		else if (GateALU)
			out <= ALUOUT;
		else
			out <= 16'h0000;
	
	end

endmodule 