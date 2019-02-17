module BEN_block
(
	input logic [15:0] bus,
	input logic LDCC,
	input logic [2:0]IR_in,
	input logic LDBEN,
	input logic clk,
	
	output logic BEN
);

	logic Nreg, Zreg, Preg;
	logic N, Z, P;
	logic BENlogic;
	
	
	always_ff @ (posedge clk) begin
	
		if(LDCC) begin
			Nreg <= N;
			Zreg <= Z;
			Preg <= P;
		end
		
		if(LDBEN) begin
			BEN <= BENlogic;
		end
	
	end
	
	always_comb begin
	
		BENlogic <= (IR_in[2] & Nreg) | (IR_in[1] & Zreg) | (IR_in[0] & Preg);
		
		if(bus == 16'h0000) begin
			N <= 1'b0;
			Z <= 1'b1;
			P <= 1'b0;
		end
		
		else if(bus[15] == 0) begin
			N <= 1'b0;
			Z <= 1'b0;
			P <= 1'b1;
		end
		
		else begin
			N <= 1'b1;
			Z <= 1'b0;
			P <= 1'b0;
		end
		
	end

endmodule 