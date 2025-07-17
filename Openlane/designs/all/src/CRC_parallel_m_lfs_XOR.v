


`timescale 1ns / 1ps
module CRC_parallel_m_lfs_XOR
#(
	parameter	DATA_WIDTH	=	32,
	parameter	HASH_LENGTH	=	64
)
(
	i_message		,
	i_cur_parity	,
	o_next_parity	
);
	input	[DATA_WIDTH-1:0]		i_message		;
	input	[HASH_LENGTH-1:0]		i_cur_parity	;
	output	[HASH_LENGTH-1:0]		o_next_parity	;
	
	wire	[HASH_LENGTH*(DATA_WIDTH+1)-1:0]	w_parallel_wire;
	
	genvar	i;
	generate
		for (i=0; i<DATA_WIDTH; i=i+1)
		begin: m_lfs_XOR_blade_enclosure
			CRC_serial_m_lfs_XOR
			#(
				.HASH_LENGTH(HASH_LENGTH)
			)
			CRC_mLFSXOR_blade(
			.i_message		(i_message[i]),
			.i_cur_parity	(w_parallel_wire[HASH_LENGTH*(i+2)-1:HASH_LENGTH*(i+1)]),
			.o_next_parity	(w_parallel_wire[HASH_LENGTH*(i+1)-1:HASH_LENGTH*(i)]));
		end
	endgenerate
	
	assign w_parallel_wire[HASH_LENGTH*(DATA_WIDTH+1)-1:HASH_LENGTH*(DATA_WIDTH)] = i_cur_parity[HASH_LENGTH-1:0];
	assign o_next_parity[HASH_LENGTH-1:0] = w_parallel_wire[HASH_LENGTH-1:0];
	
endmodule 
