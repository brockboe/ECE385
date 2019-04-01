/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

enum logic [4:0] {
WAIT, 				//0
DONE, 				//1
CREATEKEYS, 		//2
INVSHIFTROWS, 		//3
INVSUBBYTES,		//4
ADDROUNDKEY, 		//5
INVMIXCOLUMNS1, 	//6
INVMIXCOLUMNS2, 	//7
INVMIXCOLUMNS3,	//8
INVMIXCOLUMNS4, 	//9
INVMIXCOLUMNS5, 	//10
INVSHIFTROWSLR, 	//11
INVSUBBYTESLR, 	//12
ADDROUNDKEYLR, 	//13
ADDROUNDKEYINIT	//14
} sm_state, sm_next_state;
						
logic [3:0] count;
logic [3:0] next_count;
logic [127:0] state;
logic [127:0] next_state;
logic [1407:0] KeySchedule;
logic [127:0] current_key;
logic [127:0] next_current_key;
logic [31:0] ColumnToUse;
logic [31:0] NextcolumnToUse;

logic [127:0] AddRoundKeyOut;
logic [127:0] InvShiftRowsOut;
logic [127:0] SubBytesOut;
logic [31:0] InvMixColumnsOut;

KeyExpansion KE(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));
AddRoundKey ARK(.state(state), .roundkey(current_key), .result(AddRoundKeyOut));
InvShiftRows ISR(.data_in(state), .data_out(InvShiftRowsOut));
InvMixColumns IMC(.in(ColumnToUse), .out(InvMixColumnsOut));

InvSubBytes sb0 (.clk(CLK), .in(state[7:0]    ), .out(SubBytesOut[7:0]    ));
InvSubBytes sb1 (.clk(CLK), .in(state[15:8]   ), .out(SubBytesOut[15:8]   ));
InvSubBytes sb2 (.clk(CLK), .in(state[23:16]  ), .out(SubBytesOut[23:16]  ));
InvSubBytes sb3 (.clk(CLK), .in(state[31:24]  ), .out(SubBytesOut[31:24]  ));
InvSubBytes sb4 (.clk(CLK), .in(state[39:32]  ), .out(SubBytesOut[39:32]  ));
InvSubBytes sb5 (.clk(CLK), .in(state[47:40]  ), .out(SubBytesOut[47:40]  ));
InvSubBytes sb6 (.clk(CLK), .in(state[55:48]  ), .out(SubBytesOut[55:48]  ));
InvSubBytes sb7 (.clk(CLK), .in(state[63:56]  ), .out(SubBytesOut[63:56]  ));
InvSubBytes sb8 (.clk(CLK), .in(state[71:64]  ), .out(SubBytesOut[71:64]  ));
InvSubBytes sb9 (.clk(CLK), .in(state[79:72]  ), .out(SubBytesOut[79:72]  ));
InvSubBytes sbA (.clk(CLK), .in(state[87:80]  ), .out(SubBytesOut[87:80]  ));
InvSubBytes sbB (.clk(CLK), .in(state[95:88]  ), .out(SubBytesOut[95:88]  ));
InvSubBytes sbC (.clk(CLK), .in(state[103:96] ), .out(SubBytesOut[103:96] ));
InvSubBytes sbD (.clk(CLK), .in(state[111:104]), .out(SubBytesOut[111:104]));
InvSubBytes sbE (.clk(CLK), .in(state[119:112]), .out(SubBytesOut[119:112]));
InvSubBytes sbF (.clk(CLK), .in(state[127:120]), .out(SubBytesOut[127:120]));

always_ff @ (posedge CLK) begin

	if(RESET) begin
		state = 128'b0;
		sm_state = WAIT;
		count = 4'b0;
	end
		
	else begin
		sm_state = sm_next_state;
		state = next_state;
		count = next_count;
		current_key = next_current_key;
		ColumnToUse = NextcolumnToUse;
	end
	
end


always_comb begin

	next_count = count;
	next_state = state;
	AES_DONE = 1'b0;
	next_current_key = current_key;
	NextcolumnToUse = ColumnToUse;
	AES_MSG_DEC = 128'b0;

	case(sm_state)
	
		WAIT: begin
		
			next_count = 4'd10;
			next_state = 128'b0;
			AES_DONE = 1'b0;
			next_state = AES_MSG_ENC;
			AES_MSG_DEC = AES_MSG_DEC;
		
			if(AES_START == 0)
				sm_next_state = WAIT;
			else
				sm_next_state = CREATEKEYS;

		end
		
		CREATEKEYS: begin
				
			next_count = count - 4'd1;
			if(count == 4'd0) begin
				next_current_key = KeySchedule[127:0];
				sm_next_state = ADDROUNDKEYINIT;
			end
			else
				sm_next_state = CREATEKEYS;
		
		end
		
		ADDROUNDKEYINIT: begin
		
			next_count = 4'd9;
			sm_next_state = INVSHIFTROWS;
			next_state = AddRoundKeyOut;
		
		end
		
		INVSHIFTROWS: begin
		
			if(count == 0)
				sm_next_state = INVSHIFTROWSLR;
			else begin
				sm_next_state = INVSUBBYTES;
				next_state = InvShiftRowsOut;
				
				case(count)
					4'd1: next_current_key = KeySchedule[1279:1152];
					4'd2: next_current_key = KeySchedule[1151:1024];
					4'd3: next_current_key = KeySchedule[1023:896];
					4'd4: next_current_key = KeySchedule[895:768];
					4'd5: next_current_key = KeySchedule[767:640];
					4'd6: next_current_key = KeySchedule[639:512];
					4'd7: next_current_key = KeySchedule[511:384];
					4'd8: next_current_key = KeySchedule[383:256];
					4'd9: next_current_key = KeySchedule[255:128];
					default: next_current_key = 127'b0;
				endcase
				
			end
			
		end
		
		INVSUBBYTES: begin
			sm_next_state = ADDROUNDKEY;
			next_state = SubBytesOut;
		end
		
		ADDROUNDKEY: begin
			sm_next_state = INVMIXCOLUMNS1;
			next_state = AddRoundKeyOut;
		end

		INVMIXCOLUMNS1: begin
			next_count = count - 4'd1;
			
			NextcolumnToUse = state[31:0];
			sm_next_state = INVMIXCOLUMNS2;
		end
		
		INVMIXCOLUMNS2: begin
			NextcolumnToUse = state[63:32];
			next_state[31:0] = InvMixColumnsOut;
			next_state[127:32] = state[127:32];
			sm_next_state = INVMIXCOLUMNS3;
		end
		
		INVMIXCOLUMNS3: begin
			NextcolumnToUse = state[95:64];
			next_state[31:0] = state[31:0];
			next_state[63:32] = InvMixColumnsOut;
			next_state[127:64] = state[127:64];
			sm_next_state = INVMIXCOLUMNS4;
		end
		
		INVMIXCOLUMNS4: begin
			NextcolumnToUse = state[127:96];
			next_state[63:0] = state[63:0];
			next_state[95:64] = InvMixColumnsOut;
			next_state[127:96] = state[127:96];
			sm_next_state = INVMIXCOLUMNS5;
		end
		
		INVMIXCOLUMNS5: begin
			next_state[95:0] = state[95:0];
			next_state[127:96] = InvMixColumnsOut;
			sm_next_state = INVSHIFTROWS;
		end
		
		INVSHIFTROWSLR: begin
			next_current_key = KeySchedule[1407:1280];
			next_state = InvShiftRowsOut;
			sm_next_state = INVSUBBYTESLR;
		end
		
		INVSUBBYTESLR: begin
			sm_next_state = ADDROUNDKEYLR;
			next_state = SubBytesOut;
		end
		
		ADDROUNDKEYLR: begin
			sm_next_state = DONE;
			next_state = AddRoundKeyOut;
		end
		
		DONE: begin
			AES_MSG_DEC = state;
			AES_DONE = 1'b1;
			
			if(AES_START == 1)
				sm_next_state = DONE;
			else
				sm_next_state = WAIT;
				
		end
		
		default: begin
			sm_next_state = WAIT;
		end
	
	endcase
end

endmodule
