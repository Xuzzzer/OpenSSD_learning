


`timescale 1ns / 1ps

 module pcie_tx_fifo # (
	parameter	P_FIFO_WR_DATA_WIDTH		= 64,
	parameter	P_FIFO_RD_DATA_WIDTH		= 512,
	parameter	P_FIFO_DEPTH_WIDTH			= 9
)
    (
    input									wr_clk,
    input									wr_rst_n,
    
    input									alloc_en,
    input	[10:6]							alloc_len,
    input									wr_en,
    input	[P_FIFO_WR_DATA_WIDTH-1:0]		wr_data,
    output									full_n,
    
    input									rd_clk,
    input									rd_rst_n,
    
    input									rd_en,
    output	[P_FIFO_RD_DATA_WIDTH-1:0]		rd_data,
    input									free_en,
    input	[10:6]							free_len,
    output									empty_n
    );
    
    
    localparam P_FIFO_WR_DEPTH_WIDTH = P_FIFO_DEPTH_WIDTH + 3;
    
    localparam	S_SYNC_STAGE0					= 3'b001;
    localparam	S_SYNC_STAGE1					= 3'b010;
    localparam	S_SYNC_STAGE2					= 3'b100;
    
    reg		[2:0]								cur_wr_state;
    reg		[2:0]								next_wr_state;
    
    reg		[2:0]								cur_rd_state;
    reg		[2:0]								next_rd_state;
    
    reg		[P_FIFO_WR_DEPTH_WIDTH:0]			r_rear_addr;
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_rear_full_addr;
    
    wire	[7:0]								w_wr_en;
    
    (* KEEP = "TRUE", EQUIVALENT_REGISTER_REMOVAL = "NO" *)	reg											r_rear_sync;
    (* KEEP = "TRUE", EQUIVALENT_REGISTER_REMOVAL = "NO" *)	reg											r_rear_sync_en;
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_rear_sync_data;
    
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg											r_front_sync_en_d1;
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg											r_front_sync_en_d2;
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg		[P_FIFO_DEPTH_WIDTH:0]				r_front_sync_addr;
    
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_front_addr;
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_front_addr_p1;
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_front_empty_addr;
    (* KEEP = "TRUE", EQUIVALENT_REGISTER_REMOVAL = "NO" *)	reg											r_front_sync;
    (* KEEP = "TRUE", EQUIVALENT_REGISTER_REMOVAL = "NO" *)	reg											r_front_sync_en;
    reg		[P_FIFO_DEPTH_WIDTH:0]				r_front_sync_data;
    
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg											r_rear_sync_en_d1;
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg											r_rear_sync_en_d2;
    (* KEEP = "TRUE", SHIFT_EXTRACT = "NO" *)	reg		[P_FIFO_DEPTH_WIDTH:0]				r_rear_sync_addr;
    
    wire	[P_FIFO_DEPTH_WIDTH-1:0]			w_front_addr;
    
    wire	[P_FIFO_DEPTH_WIDTH:0]				w_valid_space;
    wire	[P_FIFO_DEPTH_WIDTH:0]				w_invalid_space;

assign w_invalid_space = r_front_sync_addr - r_rear_full_addr;
assign full_n = (w_invalid_space >= alloc_len);

assign w_wr_en[0] = wr_en & (r_rear_addr[2:0] == 3'b000);
assign w_wr_en[1] = wr_en & (r_rear_addr[2:0] == 3'b001);
assign w_wr_en[2] = wr_en & (r_rear_addr[2:0] == 3'b010);
assign w_wr_en[3] = wr_en & (r_rear_addr[2:0] == 3'b011);
assign w_wr_en[4] = wr_en & (r_rear_addr[2:0] == 3'b100);
assign w_wr_en[5] = wr_en & (r_rear_addr[2:0] == 3'b101);
assign w_wr_en[6] = wr_en & (r_rear_addr[2:0] == 3'b110);
assign w_wr_en[7] = wr_en & (r_rear_addr[2:0] == 3'b111);

always @(posedge wr_clk or negedge wr_rst_n)
begin
	if (wr_rst_n == 0) begin
		r_rear_addr <= 0;
		r_rear_full_addr <= 0;
	end
	else begin
		if (alloc_en == 1)
			r_rear_full_addr <= r_rear_full_addr + alloc_len;

		if (wr_en == 1)
			r_rear_addr  <= r_rear_addr + 1;
	end
end

assign w_valid_space = r_rear_sync_addr - r_front_empty_addr;
assign empty_n = (w_valid_space >= free_len);

always @(posedge rd_clk or negedge rd_rst_n)
begin
	if (rd_rst_n == 0) begin
		r_front_addr <= 0;
		r_front_addr_p1 <= 1;
		r_front_empty_addr <= 0;
	end
	else begin
		if (rd_en == 1) begin
			r_front_addr <= r_front_addr_p1;
			r_front_addr_p1 <= r_front_addr_p1 + 1;
		end
		if (free_en == 1)
			r_front_empty_addr <= r_front_empty_addr + free_len;
	end
end

assign w_front_addr[P_FIFO_DEPTH_WIDTH-1:0] = (rd_en == 1) ? r_front_addr_p1[P_FIFO_DEPTH_WIDTH-1:0] 
								: r_front_addr[P_FIFO_DEPTH_WIDTH-1:0];

/////////////////////////////////////////////////////////////////////////////////////////////



always @ (posedge wr_clk or negedge wr_rst_n)
begin
	if(wr_rst_n == 0)
		cur_wr_state <= S_SYNC_STAGE0;
	else
		cur_wr_state <= next_wr_state;
end

always @(posedge wr_clk or negedge wr_rst_n)
begin
	if(wr_rst_n == 0)
		r_rear_sync_en <= 0;
	else
		r_rear_sync_en <= r_rear_sync;
end

always @(posedge wr_clk)
begin
	r_front_sync_en_d1 <= r_front_sync_en;
	r_front_sync_en_d2 <= r_front_sync_en_d1;
end

always @ (*)
begin
	case(cur_wr_state)
		S_SYNC_STAGE0: begin
			if(r_front_sync_en_d2 == 1)
				next_wr_state <= S_SYNC_STAGE1;
			else
				next_wr_state <= S_SYNC_STAGE0;
		end
		S_SYNC_STAGE1: begin
			next_wr_state <= S_SYNC_STAGE2;
		end
		S_SYNC_STAGE2: begin
			if(r_front_sync_en_d2 == 0)
				next_wr_state <= S_SYNC_STAGE0;
			else
				next_wr_state <= S_SYNC_STAGE2;
		end
		default: begin
			next_wr_state <= S_SYNC_STAGE0;
		end
	endcase
end

always @ (posedge wr_clk or negedge wr_rst_n)
begin
	if(wr_rst_n == 0) begin
		r_rear_sync_data <= 0;
		r_front_sync_addr[P_FIFO_DEPTH_WIDTH] <= 1;
		r_front_sync_addr[P_FIFO_DEPTH_WIDTH-1:0] <= 0;
	end
	else begin
		case(cur_wr_state)
			S_SYNC_STAGE0: begin

			end
			S_SYNC_STAGE1: begin
				r_rear_sync_data <= r_rear_addr[P_FIFO_WR_DEPTH_WIDTH:3];
				r_front_sync_addr <= r_front_sync_data;
			end
			S_SYNC_STAGE2: begin

			end
			default: begin

			end
		endcase
	end
end

always @ (*)
begin
	case(cur_wr_state)
		S_SYNC_STAGE0: begin
			r_rear_sync <= 0;
		end
		S_SYNC_STAGE1: begin
			r_rear_sync <= 0;
		end
		S_SYNC_STAGE2: begin
			r_rear_sync <= 1;
		end
		default: begin
			r_rear_sync <= 0;
		end
	endcase
end


always @ (posedge rd_clk or negedge rd_rst_n)
begin
	if(rd_rst_n == 0)
		cur_rd_state <= S_SYNC_STAGE0;
	else
		cur_rd_state <= next_rd_state;
end

always @(posedge rd_clk or negedge rd_rst_n)
begin
	if(rd_rst_n == 0)
		r_front_sync_en <= 0;
	else
		r_front_sync_en <= r_front_sync;
end

always @(posedge rd_clk)
begin
	r_rear_sync_en_d1 <= r_rear_sync_en;
	r_rear_sync_en_d2 <= r_rear_sync_en_d1;
end

always @ (*)
begin
	case(cur_rd_state)
		S_SYNC_STAGE0: begin
			if(r_rear_sync_en_d2 == 1)
				next_rd_state <= S_SYNC_STAGE1;
			else
				next_rd_state <= S_SYNC_STAGE0;
		end
		S_SYNC_STAGE1: begin
			next_rd_state <= S_SYNC_STAGE2;
		end
		S_SYNC_STAGE2: begin
			if(r_rear_sync_en_d2 == 0)
				next_rd_state <= S_SYNC_STAGE0;
			else
				next_rd_state <= S_SYNC_STAGE2;
		end
		default: begin
			next_rd_state <= S_SYNC_STAGE0;
		end
	endcase
end

always @ (posedge rd_clk or negedge rd_rst_n)
begin
	if(rd_rst_n == 0) begin
		r_front_sync_data[P_FIFO_DEPTH_WIDTH] <= 1;
		r_front_sync_data[P_FIFO_DEPTH_WIDTH-1:0] <= 0;
		r_rear_sync_addr <= 0;
	end
	else begin
		case(cur_rd_state)
			S_SYNC_STAGE0: begin

			end
			S_SYNC_STAGE1: begin
				r_front_sync_data[P_FIFO_DEPTH_WIDTH] <= ~r_front_addr[P_FIFO_DEPTH_WIDTH];
				r_front_sync_data[P_FIFO_DEPTH_WIDTH-1:0] <= r_front_addr[P_FIFO_DEPTH_WIDTH-1:0];
				r_rear_sync_addr <= r_rear_sync_data;
			end
			S_SYNC_STAGE2: begin

			end
			default: begin

			end
		endcase
	end
end

always @ (*)
begin
	case(cur_rd_state)
		S_SYNC_STAGE0: begin
			r_front_sync <= 1;
		end
		S_SYNC_STAGE1: begin
			r_front_sync <= 1;
		end
		S_SYNC_STAGE2: begin
			r_front_sync <= 0;
		end
		default: begin
			r_front_sync <= 0;
		end
	endcase
end

/////////////////////////////////////////////////////////////////////////////////////////////


localparam LP_DEVICE = "7SERIES";
localparam LP_BRAM_SIZE = "36Kb";
localparam LP_DOB_REG = 0;
localparam LP_READ_WIDTH = P_FIFO_RD_DATA_WIDTH/8;
localparam LP_WRITE_WIDTH = P_FIFO_WR_DATA_WIDTH;
localparam LP_WRITE_MODE = "WRITE_FIRST";
localparam LP_WE_WIDTH = 8;
localparam LP_ADDR_TOTAL_WITDH = 9;
localparam LP_ADDR_ZERO_PAD_WITDH = LP_ADDR_TOTAL_WITDH - P_FIFO_DEPTH_WIDTH;


generate
	wire	[LP_ADDR_TOTAL_WITDH-1:0]			rdaddr;
	wire	[LP_ADDR_TOTAL_WITDH-1:0]			wraddr;
	wire	[LP_ADDR_ZERO_PAD_WITDH-1:0]		zero_padding = 0;

	if(LP_ADDR_ZERO_PAD_WITDH == 0) begin : calc_addr
		assign rdaddr = w_front_addr[P_FIFO_DEPTH_WIDTH-1:0];
		assign wraddr = r_rear_addr[P_FIFO_WR_DEPTH_WIDTH-1:3];
	end
	else begin
		assign rdaddr = {zero_padding[LP_ADDR_ZERO_PAD_WITDH-1:0], w_front_addr[P_FIFO_DEPTH_WIDTH-1:0]};
		assign wraddr = {zero_padding[LP_ADDR_ZERO_PAD_WITDH-1:0], r_rear_addr[P_FIFO_WR_DEPTH_WIDTH-1:3]};
	end
endgenerate

RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_0(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[0]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[LP_READ_WIDTH-1:0]),  
);/*
BRAM_SDP_MACR1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_0(
	.DO										(rd_data[LP_READ_WIDTH-1:0]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[0])
);*/


RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_1(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[1]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*2)-1:LP_READ_WIDTH]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_1(
	.DO										(rd_data[(LP_READ_WIDTH*2)-1:LP_READ_WIDTH]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[1])
);*/



RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_2(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[2]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*3)-1:(LP_READ_WIDTH*2)]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_2(
	.DO										(rd_data[(LP_READ_WIDTH*3)-1:(LP_READ_WIDTH*2)]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[2])
);*/

RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_3(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[3]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*4)-1:(LP_READ_WIDTH*3)]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_3(
	.DO										(rd_data[(LP_READ_WIDTH*4)-1:(LP_READ_WIDTH*3)]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[3])
);*/

RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_4(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[4]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*5)-1:(LP_READ_WIDTH*4)]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_4(
	.DO										(rd_data[(LP_READ_WIDTH*5)-1:(LP_READ_WIDTH*4)]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[4])
);*/



RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_5(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[5]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*6)-1:LP_READ_WIDTH*5]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_5(
	.DO										(rd_data[(LP_READ_WIDTH*6)-1:LP_READ_WIDTH*5]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[5])
);*/

RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_6(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[6]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*7)-1:LP_READ_WIDTH*6]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_6(
	.DO										(rd_data[(LP_READ_WIDTH*7)-1:(LP_READ_WIDTH*6)]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[6])
);*/


RTL_Simple_Dual_Port_RAM #(
     .ADDR_WIDTH(LP_ADDR_TOTAL_WITDH),
     .DATA_WIDTH_R(P_FIFO_RD_DATA_WIDTH),
	 .DATA_WIDTH_W(P_FIFO_RD_DATA_WIDTH),
     .WRITE_MODE(LP_WRITE_MODE)
)ramb36sdp_7(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .ena(w_wr_en[7]),  //write  
    .addra(wraddr),  
    .dina(wr_data[LP_WRITE_WIDTH-1:0]),

    .enb(1'b1),    
    .addrb(wraddr), 
    .doutb(rd_data[(LP_READ_WIDTH*8)-1:LP_READ_WIDTH*7]),  
);/*
BRAM_SDP_macr1 #(
	.DEVICE									(LP_DEVICE),
	.BRAM_SIZE								(LP_BRAM_SIZE),
	.DO_REG									(LP_DOB_REG),
	.READ_WIDTH								(LP_READ_WIDTH),
	.WRITE_WIDTH							(LP_WRITE_WIDTH),
	.WRITE_MODE								(LP_WRITE_MODE)
)
ramb36sdp_7(
	.DO										(rd_data[(LP_READ_WIDTH*8)-1:(LP_READ_WIDTH*7)]),
	.DI										(wr_data[LP_WRITE_WIDTH-1:0]),
	.RDADDR									(rdaddr),
	.RDCLK									(rd_clk),
	.RDEN									(1'b1),
	.REGCE									(1'b1),
	.RST									(1'b0),
	.WE										({LP_WE_WIDTH{1'b1}}),
	.WRADDR									(wraddr),
	.WRCLK									(wr_clk),
	.WREN									(w_wr_en[7])
);*/
endmodule
