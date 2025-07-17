


`timescale 1ns / 1ps

module pcie_hcmd_table_cid # (
	parameter 	P_SLOT_TAG_WIDTH			=  10, //slot_modified
	parameter	P_DATA_WIDTH				= 20,
	parameter	P_ADDR_WIDTH				= P_SLOT_TAG_WIDTH
)
(
	input									clk,

	input									wr_en,
	input	[P_ADDR_WIDTH-1:0]				wr_addr, //slot_modified
	input	[P_DATA_WIDTH-1:0]				wr_data,

	input	[P_ADDR_WIDTH-1:0]				rd_addr, //slot_modified
	output	[P_DATA_WIDTH-1:0]				rd_data
);

localparam LP_DEVICE = "7SERIES";
localparam LP_BRAM_SIZE = "36Kb";//slot_modified
localparam LP_DOB_REG = 0;
localparam LP_READ_WIDTH = P_DATA_WIDTH;
localparam LP_WRITE_WIDTH = P_DATA_WIDTH;
localparam LP_WRITE_MODE = "READ_FIRST";
localparam LP_WE_WIDTH = 4;
localparam LP_ADDR_TOTAL_WITDH = 10;
localparam LP_ADDR_ZERO_PAD_WITDH = LP_ADDR_TOTAL_WITDH - P_ADDR_WIDTH;

generate
	wire	[LP_ADDR_TOTAL_WITDH-1:0]			rdaddr;
	wire	[LP_ADDR_TOTAL_WITDH-1:0]			wraddr;
	wire	[LP_ADDR_ZERO_PAD_WITDH-1:0]		zero_padding = 0;

	if(LP_ADDR_ZERO_PAD_WITDH == 0) begin : CALC_ADDR
		assign rdaddr = rd_addr[P_ADDR_WIDTH-1:0];
		assign wraddr = wr_addr[P_ADDR_WIDTH-1:0];
	end
	else begin
		wire	[LP_ADDR_ZERO_PAD_WITDH-1:0]	zero_padding = 0;
		assign rdaddr = {zero_padding, rd_addr[P_ADDR_WIDTH-1:0]};
		assign wraddr = {zero_padding, wr_addr[P_ADDR_WIDTH-1:0]};
	end
endgenerate


BRAM_SDP_MACRO_10 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_0( //slot_modified
	.DO										(rd_data),
	.DI										(wr_data),
	.RDADDR									(rdaddr),
	.RDCLK									(clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),

	.WRADDR									(wraddr),
	.WRCLK									(clk),
	.WREN									(wr_en)
);



endmodule
