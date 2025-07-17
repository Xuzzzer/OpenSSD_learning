

`timescale 1ns / 1ps

module DispRegID
(
    iClock          ,
    iReset          ,
    iWriteAddress   ,
    iWriteData      ,
    iWriteValid     ,
    oWriteAck       ,
    iReadAddress    ,
    oReadData       ,
    iReadValid      ,
    oReadAck        ,
    iPushBundleReady,
    iSPQueueCount
);
    input           iClock          ;
    input           iReset          ;
    input  [31:0]   iWriteAddress   ;
    input  [31:0]   iWriteData      ;
    input           iWriteValid     ;
    output          oWriteAck       ;
    input  [31:0]   iReadAddress    ;
    output [31:0]   oReadData       ;
    input           iReadValid      ;
    output          oReadAck        ;
    input           iPushBundleReady;
    input  [31:0]   iSPQueueCount   ;
    
    reg    [31:0]   rReadData       ;
    
    assign oWriteAck    = 1'b0;
    assign oReadData    = rReadData;
    assign oReadAck     = 1'b1;
    
    always @ (*)
    begin
        if (iReadAddress == 32'd0)
            rReadData <= (32'h02000000 | iPushBundleReady);
        else if (iReadAddress == 32'd4)
            rReadData <= iSPQueueCount;
        else
            rReadData <= 32'b0;
    end

endmodule
