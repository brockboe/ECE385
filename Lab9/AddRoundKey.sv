module AddRoundKey
(
	input logic [127:0] state,
	input logic [127:0] roundkey,
	output logic [127:0] result
);

always_comb begin
	result <= state ^ roundkey;
end

endmodule 