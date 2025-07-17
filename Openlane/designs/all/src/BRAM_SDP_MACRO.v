module BRAM_SDP_MACRO #(
    parameter DEVICE = "NULL",
    parameter BRAM_SIZE = "2Kb",
    parameter DO_REG = 1'b0,
    parameter READ_WIDTH  = 32,
    parameter WRITE_WIDTH  = 64,
    parameter WRITE_MODE  = "READ_FIRST"  // "WRITE_FIRST", "NO_CHANGE"
)(
    output reg [READ_WIDTH-1:0] DO     ,
    input  [WRITE_WIDTH-1:0] DI		,
    input   [8:0] RDADDR  ,
    input   RDCLK	,
    input   RDEN	,
    input   REGCE	,
    input   RST	    ,
    input   [8:0] WRADDR  ,
    input   WRCLK	,
    input   WREN	
);
    localparam ADDR_WIDTH = 9;
    localparam integer TMP = (WRITE_WIDTH / READ_WIDTH);
    reg [READ_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];
     integer i;

    always @(posedge WRCLK) begin
        if (WREN)
        for(i=0;i < TMP;i++)
            mem[RDADDR + i] <= DI[(i+1) * READ_WIDTH -1 : i * READ_WIDTH];
    end

    reg [ADDR_WIDTH-1:0] wraddr_sync;
    reg                  wr_en_sync;
    reg [WRITE_WIDTH-1:0] wr_data_sync;

    always @(posedge RDCLK) begin
        wraddr_sync  <= RDADDR;
        wr_en_sync   <= WREN;
        wr_data_sync <= DI;
    end


    always @(posedge RDCLK) begin
        if (RDEN) begin
            if ((WRITE_MODE == "WRITE_FIRST") && wr_en_sync && (wraddr_sync == RDADDR)) begin
            DO <= wr_data_sync[READ_WIDTH - 1 : 0];  // 写优先
            end else if (WRITE_MODE == "READ_FIRST") begin
                DO <= mem[RDADDR];    // 读优先
            end else if (WRITE_MODE == "NO_CHANGE") begin
                DO <= DO;         // 保持上一次
            end else begin
                DO <= mem[RDADDR];    // 默认读优先
            end
        end
    end

endmodule

module BRAM_SDP_MACRO_10 #(
    parameter DEVICE = "NULL",
    parameter BRAM_SIZE = "2Kb",
    parameter DO_REG = 1'b0,
    parameter READ_WIDTH  = 32,
    parameter WRITE_WIDTH  = 64,
    parameter WRITE_MODE  = "READ_FIRST"  // "WRITE_FIRST", "NO_CHANGE"
)(
    output reg [READ_WIDTH-1:0] DO     ,
    input  [9:0] DI		,
    input   [9:0] RDADDR  ,
    input   RDCLK	,
    input   RDEN	,
    input   REGCE	,
    input   RST	    ,
    input   [ADDR_WIDTH -1:0] WRADDR  ,
    input   WRCLK	,
    input   WREN	
);
    localparam  ADDR_WIDTH = 10;
    localparam integer TMP = (WRITE_WIDTH / READ_WIDTH);
    reg [READ_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];
     integer i;

    always @(posedge WRCLK) begin
        if (WREN)
        for(i=0;i < TMP;i++)
            mem[RDADDR + i] <= DI[(i+1) * READ_WIDTH -1 : i * READ_WIDTH];
    end

    reg [ADDR_WIDTH-1:0] wraddr_sync;
    reg                  wr_en_sync;
    reg [WRITE_WIDTH-1:0] wr_data_sync;

    always @(posedge RDCLK) begin
        wraddr_sync  <= RDADDR;
        wr_en_sync   <= WREN;
        wr_data_sync <= DI;
    end


    always @(posedge RDCLK) begin
        if (RDEN) begin
            if ((WRITE_MODE == "WRITE_FIRST") && wr_en_sync && (wraddr_sync == RDADDR)) begin
            DO <= wr_data_sync[READ_WIDTH - 1 : 0];  // 写优先
            end else if (WRITE_MODE == "READ_FIRST") begin
                DO <= mem[RDADDR];    // 读优先
            end else if (WRITE_MODE == "NO_CHANGE") begin
                DO <= DO;         // 保持上一次
            end else begin
                DO <= mem[RDADDR];    // 默认读优先
            end
        end
    end

endmodule


module BRAM_SDP_MACRO_11 #(
    parameter DEVICE = "NULL",
    parameter BRAM_SIZE = "2Kb",
    parameter DO_REG = 1'b0,
    parameter READ_WIDTH  = 32,
    parameter WRITE_WIDTH  = 64,
    parameter WRITE_MODE  = "READ_FIRST"  // "WRITE_FIRST", "NO_CHANGE"
)(
    output reg [READ_WIDTH-1:0] DO     ,
    input  [WRITE_WIDTH:0] DI		,
    input   [10:0] RDADDR  ,
    input   RDCLK	,
    input   RDEN	,
    input   REGCE	,
    input   RST	    ,
    input   [10:0] WRADDR  ,
    input   WRCLK	,
    input   WREN	
);
    localparam  ADDR_WIDTH = 11;
    localparam integer TMP = (WRITE_WIDTH / READ_WIDTH);
    reg [READ_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];
     integer i;

    always @(posedge WRCLK) begin
        if (WREN)
        for(i=0;i < TMP;i++)
            mem[RDADDR + i] <= DI[(i+1) * READ_WIDTH -1 : i * READ_WIDTH];
    end

    reg [ADDR_WIDTH-1:0] wraddr_sync;
    reg                  wr_en_sync;
    reg [WRITE_WIDTH-1:0] wr_data_sync;

    always @(posedge RDCLK) begin
        wraddr_sync  <= RDADDR;
        wr_en_sync   <= WREN;
        wr_data_sync <= DI;
    end


    always @(posedge RDCLK) begin
        if (RDEN) begin
            if ((WRITE_MODE == "WRITE_FIRST") && wr_en_sync && (wraddr_sync == RDADDR)) begin
            DO <= wr_data_sync[READ_WIDTH - 1 : 0];  // 写优先
            end else if (WRITE_MODE == "READ_FIRST") begin
                DO <= mem[RDADDR];    // 读优先
            end else if (WRITE_MODE == "NO_CHANGE") begin
                DO <= DO;         // 保持上一次
            end else begin
                DO <= mem[RDADDR];    // 默认读优先
            end
        end
    end

endmodule


module BRAM_SDP_MACRO_12 #(
    parameter DEVICE = "NULL",
    parameter BRAM_SIZE = "2Kb",
    parameter DO_REG = 1'b0,
    parameter READ_WIDTH  = 32,
    parameter WRITE_WIDTH  = 64,
    parameter WRITE_MODE  = "READ_FIRST"  // "WRITE_FIRST", "NO_CHANGE"
)(
    output reg [READ_WIDTH-1:0] DO     ,
    input  [WRITE_WIDTH:0] DI		,
    input   [11:0] RDADDR  ,
    input   RDCLK	,
    input   RDEN	,
    input   REGCE	,
    input   RST	    ,
    input   [11:0] WRADDR  ,
    input   WRCLK	,
    input   WREN	
);
    localparam  ADDR_WIDTH = 12;
    localparam integer TMP = (WRITE_WIDTH / READ_WIDTH);
    reg [READ_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];
     integer i;

    always @(posedge WRCLK) begin
        if (WREN)
        for(i=0;i < TMP;i++)
            mem[RDADDR + i] <= DI[(i+1) * READ_WIDTH -1 : i * READ_WIDTH];
    end

    reg [ADDR_WIDTH-1:0] wraddr_sync;
    reg                  wr_en_sync;
    reg [WRITE_WIDTH-1:0] wr_data_sync;

    always @(posedge RDCLK) begin
        wraddr_sync  <= RDADDR;
        wr_en_sync   <= WREN;
        wr_data_sync <= DI;
    end


    always @(posedge RDCLK) begin
        if (RDEN) begin
            if ((WRITE_MODE == "WRITE_FIRST") && wr_en_sync && (wraddr_sync == RDADDR)) begin
            DO <= wr_data_sync[READ_WIDTH - 1 : 0];  // 写优先
            end else if (WRITE_MODE == "READ_FIRST") begin
                DO <= mem[RDADDR];    // 读优先
            end else if (WRITE_MODE == "NO_CHANGE") begin
                DO <= DO;         // 保持上一次
            end else begin
                DO <= mem[RDADDR];    // 默认读优先
            end
        end
    end

endmodule
