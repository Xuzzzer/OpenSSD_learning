

`timescale 1ns / 1ps

module SCFIFO_64x16DR_withCount
(
    input           iClock          ,
    input           iReset          ,

    input   [63:0]  iPushData       ,
    input           iPushEnable     ,
    output          oIsFull         ,
    
    output  [63:0]  oPopData        ,
    input           iPopEnable      ,
    output          oIsEmpty        ,
    
    output  [3:0]   oDataCount
);
     
  wire [4:0] data_count_internal;

    SCFIFO_sync #(
        .DATA_WIDTH(64),
        .FIFO_DEPTH(16)
    ) u2_fifo_sync (
        .clk        (iClock),
        .rst        (iReset),
        .wr_en      (iPushEnable),
        .wr_data    (iPushData),
        .wr_full    (oIsFull),
        .rd_en      (iPopEnable),
        .rd_data    (oPopData),
        .rd_empty   (oIsEmpty),
        .data_count (data_count_internal)
    );
assign oDataCount = data_count_internal[3:0];



endmodule
