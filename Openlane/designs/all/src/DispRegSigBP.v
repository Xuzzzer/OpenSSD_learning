

`timescale 1ns / 1ps

module DispRegSigBP
#
(
    parameter NumberOfWays          = 4
)
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
    iWaysReadyBusy
);
    input                           iClock          ;
    input                           iReset          ;
    input   [31:0]                  iWriteAddress   ;
    input   [31:0]                  iWriteData      ;
    input                           iWriteValid     ;
    output                          oWriteAck       ;
    input   [31:0]                  iReadAddress    ;
    output  [31:0]                  oReadData       ;
    input                           iReadValid      ;
    output                          oReadAck        ;
    input   [NumberOfWays - 1:0]    iWaysReadyBusy  ;
    
    assign oWriteAck        = 1'b0;
    assign oReadData        = (iReadAddress == 32'b0)?iWaysReadyBusy:32'b0;
    assign oReadAck         = 1'b1;

endmodule
