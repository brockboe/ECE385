module SEXT10
(
	input logic [10:0] in,
	output logic [15:0] out
);

	assign out = {in[10], in[10], in[10], in[10], in[10], in};

endmodule 


module SEXT8
(
	input logic [8:0] in,
	output logic [15:0] out
);

	assign out = {in[8], in[8], in[8], in[8], in[8], in[8], in[8], in};

endmodule 


module SEXT5
(
	input logic [5:0] in,
	output logic [15:0] out
);

	assign out = {in[5], in[5], in[5], in[5], in[5], in[5], in[5], in[5], in[5], in[5], in};

endmodule 


module SEXT4
(
	input logic [4:0] in,
	output logic [15:0] out
);

	assign out = {in[4], in[4], in[4], in[4], in[4], in[4], in[4], in[4], in[4], in[4], in[4], in};

endmodule


module ZEXT16
(
	input logic [15:0] in,
	output logic [19:0] out
);

	assign out = {4'b0000, in};

endmodule 