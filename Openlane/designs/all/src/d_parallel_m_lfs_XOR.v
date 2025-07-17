


`include "d_BCH_encoder_parameters.vh"
`timescale 1ns / 1ps

module d_parallel_m_lfs_XOR
(
    input  wire [`D_BCH_ENC_P_LVL-1:0]         i_message,
	input  wire [`D_BCH_ENC_PRT_LENGTH-1:0]    i_cur_parity,
	
	output wire [`D_BCH_ENC_PRT_LENGTH-1:0]    o_nxt_parity
);
	
	wire [`D_BCH_ENC_PRT_LENGTH*(`D_BCH_ENC_P_LVL+1)-1:0] w_parallel_wire;
	
	
	
	genvar i;
	generate
		for (i=0; i<`D_BCH_ENC_P_LVL; i=i+1)
		begin: m_lfs_XOR_blade_enclosure
			
			// modified(improved) linear feedback shift XOR blade
			// LFSR = LFSXOR + register
			d_serial_m_lfs_XOR d_mLFSXOR_blade(
			.i_message   (i_message[i]),
			.i_cur_parity(w_parallel_wire[`D_BCH_ENC_PRT_LENGTH*(i+2)-1:`D_BCH_ENC_PRT_LENGTH*(i+1)]),
			.o_nxt_parity(w_parallel_wire[`D_BCH_ENC_PRT_LENGTH*(i+1)-1:`D_BCH_ENC_PRT_LENGTH*(i)  ]));
		
		end
	endgenerate
	
	assign w_parallel_wire[`D_BCH_ENC_PRT_LENGTH*(`D_BCH_ENC_P_LVL+1)-1:`D_BCH_ENC_PRT_LENGTH*(`D_BCH_ENC_P_LVL)] = i_cur_parity[`D_BCH_ENC_PRT_LENGTH-1:0];
	assign o_nxt_parity[`D_BCH_ENC_PRT_LENGTH-1:0] = w_parallel_wire[`D_BCH_ENC_PRT_LENGTH-1:0];

	
endmodule
