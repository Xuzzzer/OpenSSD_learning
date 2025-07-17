module FIFO_sync
#(
    parameter DATA_WIDTH = 64, 
    parameter FIFO_DEPTH = 64
)
(
    input                       clk,
    input                       rst,     

   
    input                       wr_en,     
    input  [DATA_WIDTH-1:0]     wr_data,
    output                      wr_full,   

   
    input                       rd_en,     
    output [DATA_WIDTH-1:0]     rd_data,   
    output                      rd_empty,
    output [$clog2(FIFO_DEPTH):0]   data_count 
);


    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH); 
 
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
    reg [ADDR_WIDTH-1:0]   wr_ptr_int; 
    reg [ADDR_WIDTH-1:0]   rd_ptr_int; 
    reg [ADDR_WIDTH:0]   data_count_reg; 
    reg [DATA_WIDTH-1:0] rd_data_reg;

    assign wr_full  = (data_count_reg == FIFO_DEPTH);
    assign rd_empty = (data_count_reg == 0);
    assign rd_data = rd_data_reg;
    assign data_count = data_count_reg;

    wire do_write = wr_en && !wr_full;
    wire do_read  = rd_en && !rd_empty;
   
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr_int <= '0;
            rd_ptr_int <= '0;
            data_count_reg <= '0;
            rd_data_reg <= '0;
        end else begin
            if (do_write) begin
                fifo_mem[wr_ptr_int] <= wr_data; 
                wr_ptr_int <= wr_ptr_int + 1'b1;
            end           
            if (do_read) begin
                rd_data_reg <= fifo_mem[rd_ptr_int];
                rd_ptr_int <= rd_ptr_int + 1'b1;
            end

            if(do_write && !do_read) 
                data_count_reg <= data_count_reg +1'b1;
            else if(!do_write && do_read) 
                data_count_reg <= data_count_reg - 1'b1;
                
        end
    end

endmodule
