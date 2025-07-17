


`include "d_BCH_encoder_parameters.vh"
`timescale 1ns / 1ps

module d_serial_m_lfs_XOR
(
    input  wire                             i_message,
	input  wire [`D_BCH_ENC_PRT_LENGTH-1:0] i_cur_parity,
	
	output wire [`D_BCH_ENC_PRT_LENGTH-1:0] o_nxt_parity
);

	// generate polynomial
	parameter [0:168] D_BCH_ENC_G_POLY = 169'b1100011001001101001001011010010000001010100100010101010000111100111110110010110000100000001101100011000011111011010100011001110110100011110100100001001101010100010111001;
	// LSB is MAXIMUM order term, so parameter has switched order
	
	
	
	wire w_FB_term;

	
	
	assign w_FB_term = i_message ^ i_cur_parity[`D_BCH_ENC_PRT_LENGTH-1];
	
	assign o_nxt_parity[0] = w_FB_term;
	
	genvar i;
	generate
		for (i=1; i<`D_BCH_ENC_PRT_LENGTH; i=i+1)
		begin: linear_function
		
			// modified(improved) linear feedback shift XOR
		
			if (D_BCH_ENC_G_POLY[i] == 1)
			begin
				assign o_nxt_parity[i] = i_cur_parity[i-1] ^ w_FB_term;
			end
			
			else
			begin
				assign o_nxt_parity[i] = i_cur_parity[i-1];
			end
			
		end
	endgenerate
	

endmodule
