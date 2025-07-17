

`timescale 1ns / 1ps

module DispRegCoreAcc
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
    oSPadTrigger
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
    output          oSPadTrigger    ;
    
    assign oWriteAck        = 1'b0;
    assign oReadData        = 32'b0;
    assign oReadAck         = 1'b1;
    assign oSPadTrigger     = ((iWriteAddress == 32'b0 && iWriteValid))?1'b1:1'b0;

endmodule
