


`timescale 1ns / 1ps

module d_BCH_CS_X
#
(
	parameter	Multi	= 2,
	parameter	GF		= 12
)
(
	i_clk,
	i_RESET,
	i_exe_cs,
    i_data_fowarding,
	i_MUX_data_ready,
	i_BRAM_read_data,
	
	i_v_000,
	i_v_001,
	i_v_002,
	i_v_003,
	i_v_004,
	i_v_005,
	i_v_006,
	i_v_007,
	i_v_008,
	i_v_009,
	i_v_010,
	i_v_011,
	i_v_012,
	i_v_013,
	i_v_014,
	
	o_cs_available,
	o_cs_cmplt,
	o_BRAM_read_enable,
	o_BRAM_read_address,
	o_c_message_valid,
	o_c_message_output_cmplt,
	o_c_message
);
	input						i_clk;
	input						i_RESET;
	input	            		i_exe_cs;
    input   [Multi - 1:0]       i_data_fowarding;
	input	                    i_MUX_data_ready;
	input	[Multi*8 - 1:0]		i_BRAM_read_data;
	
	input	[GF*Multi - 1:0]	i_v_000;
	input	[GF*Multi - 1:0]	i_v_001;
	input	[GF*Multi - 1:0]	i_v_002;
	input	[GF*Multi - 1:0]	i_v_003;
	input	[GF*Multi - 1:0]	i_v_004;
	input	[GF*Multi - 1:0]	i_v_005;
	input	[GF*Multi - 1:0]	i_v_006;
	input	[GF*Multi - 1:0]	i_v_007;
	input	[GF*Multi - 1:0]	i_v_008;
	input	[GF*Multi - 1:0]	i_v_009;
	input	[GF*Multi - 1:0]	i_v_010;
	input	[GF*Multi - 1:0]	i_v_011;
	input	[GF*Multi - 1:0]	i_v_012;
	input	[GF*Multi - 1:0]	i_v_013;
	input	[GF*Multi - 1:0]	i_v_014;
	
	output						o_cs_available;
	output	[Multi - 1:0]		o_cs_cmplt;
	output	[Multi - 1:0]		o_BRAM_read_enable;
	output	[Multi*8 - 1:0]		o_BRAM_read_address;
	output	[Multi - 1:0]		o_c_message_valid;
	output	[Multi - 1:0]		o_c_message_output_cmplt;
	output	[Multi*8 - 1:0]		o_c_message;
	
	wire	[Multi - 1:0]		w_cs_available;
	wire	[Multi - 1:0]		w_cs_start;
	wire	[Multi - 1:0]		w_cs_pause;
	wire	[Multi - 1:0]		w_c_message_output_start;
	
	genvar i;
	generate
		for (i = 0; i < Multi; i = i + 1)
		begin 
			d_BCH_CS_top
			d_clustered_CS
			(
				.i_clk                      (i_clk                                  ), 
				.i_RESET                    (i_RESET                                ), 
				.i_stop_dec                 (1'b0                                   ),
                
				.o_cs_available             (w_cs_available[i]                      ), 
                
				.i_exe_cs                   (i_exe_cs                               ), 
                .i_data_fowarding           (i_data_fowarding[i]                    ),
				.i_MUX_data_ready           (i_MUX_data_ready                       ),
                
				.i_v_000                    (i_v_000[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_001                    (i_v_001[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_002                    (i_v_002[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_003                    (i_v_003[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_004                    (i_v_004[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_005                    (i_v_005[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_006                    (i_v_006[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_007                    (i_v_007[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_008                    (i_v_008[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_009                    (i_v_009[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_010                    (i_v_010[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_011                    (i_v_011[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_012                    (i_v_012[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_013                    (i_v_013[GF * (i+1) - 1 : GF * i]       ), 
    			.i_v_014                    (i_v_014[GF * (i+1) - 1 : GF * i]       ),
                
    			.o_cs_start                 (                                       ), 
    			.o_cs_cmplt                 (o_cs_cmplt[i]                          ), 
				.o_cs_pause                 (                                       ),
                
    			.o_BRAM_read_enable         (o_BRAM_read_enable[i]                  ), 
    			.o_BRAM_read_address        (o_BRAM_read_address[(i+1)*8 - 1:i*8]   ), 
    			.i_BRAM_read_data           (i_BRAM_read_data[(i+1)*8 - 1:i*8]      ), 
                
				.o_c_message_valid          (o_c_message_valid[i]                   ), 
    			.o_c_message_output_start   (                                       ), 
    			.o_c_message_output_cmplt   (o_c_message_output_cmplt[i]            ), 
    			.o_c_message                (o_c_message[(i+1)*8 - 1:i*8]           )
			);
		end
	endgenerate
	
	assign o_cs_available 			=	w_cs_available[0]			;
		
endmodule
