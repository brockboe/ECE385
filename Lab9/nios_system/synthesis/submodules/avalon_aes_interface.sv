/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] regFile [15:0];
	
	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_ENC;
	logic [127:0] AES_MSG_DEC;
	logic AES_START;
	logic AES_DONE;
	
	AES AES_INSTANCE
	(
		.CLK(CLK), 
		.RESET(RESET), 
		.AES_START(AES_START),
		.AES_DONE(AES_DONE), 
		.AES_KEY({regFile[0], regFile[1], regFile[2], regFile[3]}),
		.AES_MSG_ENC({regFile[4], regFile[5], regFile[6], regFile[7]}), 
		.AES_MSG_DEC(AES_MSG_DEC)
	);
	
	
	always_ff @ (posedge CLK) begin
	
		regFile[8] = AES_MSG_DEC[31:0];
		regFile[9] = AES_MSG_DEC[63:32];
		regFile[10] = AES_MSG_DEC[95:64];
		regFile[11] = AES_MSG_DEC[127:96];
		
		regFile[15] = {31'b0, AES_DONE};
	
		if(RESET) begin
		
		end
		
		else if(AVL_WRITE && AVL_CS) begin
			case (AVL_BYTE_EN)
				4'b1111: regFile[AVL_ADDR][31:0]  = AVL_WRITEDATA[31:0];
				4'b1100: regFile[AVL_ADDR][31:16] = AVL_WRITEDATA[31:16];
				4'b0011: regFile[AVL_ADDR][15:0]  = AVL_WRITEDATA[15:0];
				4'b1000: regFile[AVL_ADDR][31:24] = AVL_WRITEDATA[31:24];
				4'b0100: regFile[AVL_ADDR][23:16] = AVL_WRITEDATA[23:16];
				4'b0010: regFile[AVL_ADDR][15:8]  = AVL_WRITEDATA[15:8];
				4'b0001: regFile[AVL_ADDR][7:0]   = AVL_WRITEDATA[7:0];
			endcase
		end
		
		else if(AVL_READ && AVL_CS) begin
			AVL_READDATA[31:0] = regFile[AVL_ADDR][31:0];
		end
		
	end
	
	
	always_comb begin
	
		//assign export data to show the first and last bytes of the key
		EXPORT_DATA <= {regFile[0][31:16], regFile[3][15:0]};
		
		AES_KEY <= {regFile[0][31:24], regFile[1][31:24], regFile[2][31:24], regFile[3][31:24],
						regFile[0][23:16], regFile[1][23:16], regFile[2][23:16], regFile[3][23:16],
						regFile[0][15:8],  regFile[1][15:8],  regFile[2][15:8],  regFile[3][15:8],
						regFile[0][7:0],   regFile[1][7:0],   regFile[2][7:0],   regFile[3][7:0]};
		
		AES_MSG_ENC <= {regFile[4][31:24], regFile[5][31:24], regFile[6][31:24], regFile[7][31:24],
							 regFile[4][23:16], regFile[5][23:16], regFile[6][23:16], regFile[7][23:16],
							 regFile[4][15:8],  regFile[5][15:8],  regFile[6][15:8],  regFile[7][15:8],
							 regFile[4][7:0],   regFile[5][7:0],   regFile[6][7:0],   regFile[7][7:0]};
		
		AES_START <= regFile[14][0];
		
		
	end

endmodule
