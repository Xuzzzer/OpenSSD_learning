


`timescale 1ns / 1ps


module pcie_tx_dma # (
	parameter 	P_SLOT_TAG_WIDTH			=  10, //slot_modified
	parameter	C_PCIE_DATA_WIDTH			= 512,
	parameter	C_PCIE_ADDR_WIDTH			= 48, //modified
	parameter	C_M_AXI_DATA_WIDTH			= 64
)
(
	input									pcie_user_clk,
	input									pcie_user_rst_n,

	input	[1:0]							pcie_max_payload_size,

	input									pcie_tx_cmd_wr_en,
	input	[45:0]							pcie_tx_cmd_wr_data, //modified
	output									pcie_tx_cmd_full_n,

	output									tx_dma_mwr_req,
	output	[7:0]							tx_dma_mwr_tag,
	output	[12:2]							tx_dma_mwr_len,
	output	[C_PCIE_ADDR_WIDTH-1:2]			tx_dma_mwr_addr,
	input									tx_dma_mwr_req_ack,
	input									tx_dma_mwr_data_last,

	input									pcie_tx_dma_fifo_rd_en,
	output	[C_PCIE_DATA_WIDTH-1:0]			pcie_tx_dma_fifo_rd_data,

	output									dma_tx_done_wr_en,
	output	[(P_SLOT_TAG_WIDTH+15)-1:0]		dma_tx_done_wr_data, //slot_modified
	input									dma_tx_done_wr_rdy_n,

	input									dma_bus_clk,
	input									dma_bus_rst_n,

	input									pcie_tx_fifo_alloc_en,
	input	[10:6]							pcie_tx_fifo_alloc_len, 
	input									pcie_tx_fifo_wr_en,
	input	[C_M_AXI_DATA_WIDTH-1:0]		pcie_tx_fifo_wr_data,
	output									pcie_tx_fifo_full_n
);

wire										w_pcie_tx_cmd_rd_en;
wire	[45:0]								w_pcie_tx_cmd_rd_data;
wire										w_pcie_tx_cmd_empty_n;

wire										w_pcie_tx_fifo_free_en;
wire	[10:6]								w_pcie_tx_fifo_free_len; 
wire										w_pcie_tx_fifo_empty_n;


pcie_tx_cmd_fifo 
pcie_tx_cmd_fifo_inst0
(
	.clk									(pcie_user_clk),
	.rst_n									(pcie_user_rst_n),

	.wr_en									(pcie_tx_cmd_wr_en),
	.wr_data								(pcie_tx_cmd_wr_data),
	.full_n									(pcie_tx_cmd_full_n),

	.rd_en									(w_pcie_tx_cmd_rd_en),
	.rd_data								(w_pcie_tx_cmd_rd_data),
	.empty_n								(w_pcie_tx_cmd_empty_n)
);

pcie_tx_fifo
pcie_tx_fifo_inst0
(
	.wr_clk									(dma_bus_clk),
	.wr_rst_n								(pcie_user_rst_n),

	.alloc_en								(pcie_tx_fifo_alloc_en),
	.alloc_len								(pcie_tx_fifo_alloc_len),
	.wr_en									(pcie_tx_fifo_wr_en),
	.wr_data								(pcie_tx_fifo_wr_data),
	.full_n									(pcie_tx_fifo_full_n),

	.rd_clk									(pcie_user_clk),
	.rd_rst_n								(pcie_user_rst_n),

	.rd_en									(pcie_tx_dma_fifo_rd_en),
	.rd_data								(pcie_tx_dma_fifo_rd_data),
	.free_en								(w_pcie_tx_fifo_free_en),
	.free_len								(w_pcie_tx_fifo_free_len),
	.empty_n								(w_pcie_tx_fifo_empty_n)
);

pcie_tx_req # (
	.P_SLOT_TAG_WIDTH						(P_SLOT_TAG_WIDTH), //slot_modified
	.C_PCIE_DATA_WIDTH						(C_PCIE_DATA_WIDTH),
	.C_PCIE_ADDR_WIDTH						(C_PCIE_ADDR_WIDTH)
)
pcie_tx_req_inst0(
	.pcie_user_clk							(pcie_user_clk),
	.pcie_user_rst_n						(pcie_user_rst_n),

	.pcie_max_payload_size					(pcie_max_payload_size),

	.pcie_tx_cmd_rd_en						(w_pcie_tx_cmd_rd_en),
	.pcie_tx_cmd_rd_data					(w_pcie_tx_cmd_rd_data),
	.pcie_tx_cmd_empty_n					(w_pcie_tx_cmd_empty_n),

	.pcie_tx_fifo_free_en					(w_pcie_tx_fifo_free_en),
	.pcie_tx_fifo_free_len					(w_pcie_tx_fifo_free_len),
	.pcie_tx_fifo_empty_n					(w_pcie_tx_fifo_empty_n),

	.tx_dma_mwr_req							(tx_dma_mwr_req),
	.tx_dma_mwr_tag							(tx_dma_mwr_tag),
	.tx_dma_mwr_len							(tx_dma_mwr_len),
	.tx_dma_mwr_addr						(tx_dma_mwr_addr),
	.tx_dma_mwr_req_ack						(tx_dma_mwr_req_ack),
	.tx_dma_mwr_data_last					(tx_dma_mwr_data_last),

	.dma_tx_done_wr_en						(dma_tx_done_wr_en),
	.dma_tx_done_wr_data					(dma_tx_done_wr_data),
	.dma_tx_done_wr_rdy_n					(dma_tx_done_wr_rdy_n)
);

endmodule
