

`timescale 1ns / 1ps

module DispRegConf
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
    oReadAck
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
    
    assign oWriteAck        = 1'b0;
    assign oReadData        = 32'b0;
    assign oReadAck         = 1'b1;

endmodule
