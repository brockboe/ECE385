`define NOPST	 		8'h00
`define CALBST 		8'h01
`define RESETST 		8'h02
`define RSTCOUNTST	8'h03
`define CCOMPAREST	8'h04
`define ADDST			8'h05
`define SHIFTST		8'h06
`define INCCST			8'h07

typedef enum logic[7:0] {NOPST, CALBST, RESETST, RSTCOUNTST, CCOMPAREST, ADDST, SHIFTST, INCCST} state;
state current_state;
state next_state;

module controlUnit
(
	input logic reset, clk, run, ClearA_LoadB,
	input logic [7:0] counter,
	input logic m,
	
	output logic clr_ld,
	output logic shift,
	output logic add,
	output logic sub,
	output logic reset_au,
	output logic reset_counter,
	output logic increment_counter
);

	logic [7:0] current_state;
	logic [7:0] next_state;
	
	always_ff @ (posedge clk) begin
	
		if(reset) begin
			next_state = RESETST;
		end
		
		else begin
		
			current_state = next_state;
			
			case(current_state)
			
				NOPST:
					begin
					
						if(ClearA_LoadB)
							next_state = CALBST;
						else if(reset)
							next_state = RESETST;
						else if(run)
							next_state = RSTCOUNTST;
						else
							next_state = NOPST;
						
						clr_ld = 1'b0;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b0;
						increment_counter = 1'b0;
						reset_au = 1'b0;
					
					end
				
				CALBST:
					begin
						
						clr_ld = 1'b1;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b0;
						increment_counter = 1'b0;
						reset_au = 1'b0;
	
						next_state = NOPST;
						
					end
				
				RESETST:
				
					begin
					
						clr_ld = 1'b0;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b1;
						increment_counter = 1'b0;
						reset_au = 1'b1;
						
						next_state = NOPST;

					
					end
				
				RSTCOUNTST:
				
					begin
					
						clr_ld = 1'b0;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b1;
						increment_counter = 1'b0;
	
						next_state = CCOMPAREST;
						
					end
				
				CCOMPAREST:
				
					begin
				
						clr_ld = 1'b0;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b0;
						increment_counter = 1'b0;

						if(counter >= 8'h07)
							next_state = NOPST;
						else
							next_state = ADDST;
						end
				
				ADDST:
				
					begin 
					
						if(m == 0 | counter == 8'h07) begin
							clr_ld = 1'b0;
							shift = 1'b0;
							add = 1'b0;
							sub = 1'b0;
							reset_counter = 1'b0;
							increment_counter = 1'b0;						
						end
					
						else if(counter == 8'h06) begin
							clr_ld = 1'b0;
							shift = 1'b0;
							add = 1'b0;
							sub = 1'b1;
							reset_counter = 1'b0;
							increment_counter = 1'b0;
						end

						else begin
							clr_ld = 1'b0;
							shift = 1'b0;
							add = 1'b1;
							sub = 1'b0;
							reset_counter = 1'b0;
							increment_counter = 1'b0;		
						end
						
						next_state = SHIFTST;
						
					end
				
				SHIFTST:
				
					begin
					
						clr_ld = 1'b0;
						shift = 1'b1;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b0;
						increment_counter = 1'b0;
						
						next_state = INCCST;
						
					end
				
				INCCST:
				
					begin

						clr_ld = 1'b0;
						shift = 1'b0;
						add = 1'b0;
						sub = 1'b0;
						reset_counter = 1'b0;
						increment_counter = 1'b1;
					
						next_state = CCOMPAREST;
					
					end
			
			endcase
		
		end
		
	end

endmodule 