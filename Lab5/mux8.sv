module mux8
(
	input logic select,
	input logic [7:0] HighSelect,
	input logic [7:0] LowSelect,
	output logic [7:0] out
);

	assign out = (select) ? HighSelect : LowSelect;

endmodule 