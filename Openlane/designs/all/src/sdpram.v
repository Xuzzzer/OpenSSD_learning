module RTL_Simple_Dual_Port_RAM #(
    parameter ADDR_WIDTH  = 5,
    parameter DATA_WIDTH_R  = 32,
    parameter DATA_WIDTH_W  = 64,
    parameter WRITE_MODE  = "READ_FIRST"  // "WRITE_FIRST", "NO_CHANGE"
)(
    input                       wr_clk,
    input                       rd_clk,

    input                       ena,     
    input  [ADDR_WIDTH-1:0]     addra,   
    input  [DATA_WIDTH_W-1:0]     dina,    

    input                       enb,     
    input  [ADDR_WIDTH-1:0]     addrb,   
    output reg [DATA_WIDTH_R-1:0] doutb    
);
     integer i;
    parameter tmp = (DATA_WIDTH_W / DATA_WIDTH_R);
    reg [DATA_WIDTH_R-1:0] mem [(1<<ADDR_WIDTH)-1:0];

    always @(posedge wr_clk) begin
        if (ena)
        for(i=0;i < tmp;i++)
            mem[addra + i] <= dina[(i+1) * DATA_WIDTH_R -1 : i * DATA_WIDTH_R];
    end

    reg [ADDR_WIDTH-1:0] wraddr_sync;
    reg                  wr_en_sync;
    reg [DATA_WIDTH_W-1:0] wr_data_sync;

    always @(posedge rd_clk) begin
        wraddr_sync  <= addra;
        wr_en_sync   <= ena;
        wr_data_sync <= dina;
    end


    always @(posedge rd_clk) begin
        if (enb) begin
            if ((WRITE_MODE == "WRITE_FIRST") && wr_en_sync && (wraddr_sync == addrb)) begin
            doutb <= wr_data_sync[DATA_WIDTH_R - 1 : 0];  // 写优先
            end else if (WRITE_MODE == "READ_FIRST") begin
                doutb <= mem[addrb];    // 读优先
            end else if (WRITE_MODE == "NO_CHANGE") begin
                doutb <= doutb;         // 保持上一次
            end else begin
                doutb <= mem[addrb];    // 默认读优先
            end
        end
    end

endmodule
