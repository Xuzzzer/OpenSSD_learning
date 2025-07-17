


`timescale 1ns / 1ps


module pcie_rx_cpld_sel# (
	parameter	C_PCIE_DATA_WIDTH			= 512
)
(
	input									pcie_user_clk,

	input									cpld_fifo_wr_en,
	input	[C_PCIE_DATA_WIDTH-1:0]			cpld_fifo_wr_data,
	input	[7:0]							cpld_fifo_tag,
	input									cpld_fifo_tag_last,

	output	[7:0]							cpld0_fifo_tag,
	output									cpld0_fifo_tag_last,
	output									cpld0_fifo_wr_en,
	output	[C_PCIE_DATA_WIDTH-1:0]			cpld0_fifo_wr_data,

	output	[7:0]							cpld1_fifo_tag,
	output									cpld1_fifo_tag_last,
	output									cpld1_fifo_wr_en,
	output	[C_PCIE_DATA_WIDTH-1:0]			cpld1_fifo_wr_data,

	output	[7:0]							cpld2_fifo_tag,
	output									cpld2_fifo_tag_last,
	output									cpld2_fifo_wr_en,
	output	[C_PCIE_DATA_WIDTH-1:0]			cpld2_fifo_wr_data
);

reg		[7:0]								r_cpld_fifo_tag;
reg		[C_PCIE_DATA_WIDTH-1:0]				r_cpld_fifo_wr_data;

reg											r_cpld0_fifo_tag_last;
reg											r_cpld0_fifo_wr_en;

reg											r_cpld1_fifo_tag_last;
reg											r_cpld1_fifo_wr_en;

reg											r_cpld2_fifo_tag_last;
reg											r_cpld2_fifo_wr_en;

wire	[2:0]								w_cpld_prefix_tag_hit;


assign w_cpld_prefix_tag_hit[0] = (cpld_fifo_tag[7:3] == 5'b00000);
assign w_cpld_prefix_tag_hit[1] = (cpld_fifo_tag[7:3] == 5'b00001);
assign w_cpld_prefix_tag_hit[2] = (cpld_fifo_tag[7:4] == 4'b0001);

assign cpld0_fifo_tag = r_cpld_fifo_tag;
assign cpld0_fifo_tag_last = r_cpld0_fifo_tag_last;
assign cpld0_fifo_wr_en = r_cpld0_fifo_wr_en;
assign cpld0_fifo_wr_data = r_cpld_fifo_wr_data;

assign cpld1_fifo_tag = r_cpld_fifo_tag;
assign cpld1_fifo_tag_last = r_cpld1_fifo_tag_last;
assign cpld1_fifo_wr_en = r_cpld1_fifo_wr_en;
assign cpld1_fifo_wr_data = r_cpld_fifo_wr_data;

assign cpld2_fifo_tag = r_cpld_fifo_tag;
assign cpld2_fifo_tag_last = r_cpld2_fifo_tag_last;
assign cpld2_fifo_wr_en = r_cpld2_fifo_wr_en;
assign cpld2_fifo_wr_data = r_cpld_fifo_wr_data;

always @(posedge pcie_user_clk)
begin
	r_cpld_fifo_tag <= cpld_fifo_tag;
	r_cpld_fifo_wr_data <= cpld_fifo_wr_data;

	r_cpld0_fifo_tag_last = cpld_fifo_tag_last & w_cpld_prefix_tag_hit[0];
	r_cpld0_fifo_wr_en <= cpld_fifo_wr_en & w_cpld_prefix_tag_hit[0];

	r_cpld1_fifo_tag_last = cpld_fifo_tag_last & w_cpld_prefix_tag_hit[1];
	r_cpld1_fifo_wr_en <= cpld_fifo_wr_en & w_cpld_prefix_tag_hit[1];

	r_cpld2_fifo_tag_last = cpld_fifo_tag_last & w_cpld_prefix_tag_hit[2];
	r_cpld2_fifo_wr_en <= cpld_fifo_wr_en & w_cpld_prefix_tag_hit[2];
end


endmodule
