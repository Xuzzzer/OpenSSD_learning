

`timescale 1ns / 1ps

module SCFIFO_80x64_withCount
(
    input           iClock          ,
    input           iReset          ,

    input   [79:0]  iPushData       ,
    input           iPushEnable     ,
    output          oIsFull         ,
    
    output  [79:0]  oPopData        ,
    input           iPopEnable      ,
    output          oIsEmpty        ,
    
    output  [5:0]   oDataCount
);

    
  wire [6:0] data_count_internal;

    SCFIFO_sync #(
        .DATA_WIDTH(80),
        .FIFO_DEPTH(64)
    ) u4_fifo_sync (
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
assign oDataCount = data_count_internal[5:0];


endmodule
