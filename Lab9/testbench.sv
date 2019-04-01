module testbench();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic RESET;
logic AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;

logic [127:0] current_key;
logic [127:0] current_state;

logic [4:0] state;
logic [3:0] count;

always begin: CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

AES AESTEST
(
	.CLK(clk),
	.RESET(RESET),
	.AES_START(AES_START),
	.AES_DONE(AES_DONE),
	.AES_KEY(AES_KEY),
	.AES_MSG_ENC(AES_MSG_ENC),
	.AES_MSG_DEC(AES_MSG_DEC)
);

assign state = AESTEST.sm_state;
assign count = AESTEST.count;
assign current_state = AESTEST.state;
assign current_key = AESTEST.current_key;

initial begin

RESET = 1'b0;
AES_START = 1'b0;
AES_KEY = 128'h3b280014beaac269d613a16bfdc2be03;
AES_MSG_ENC = 128'h439d619920ce415661019634f59fcf63;

#2
RESET = 1'b1;
#2
RESET = 1'b0;

#2
AES_START = 1'b1;

#5000
AES_START = 1'b0;

end

endmodule 