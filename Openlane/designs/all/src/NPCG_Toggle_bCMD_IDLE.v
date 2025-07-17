

`timescale 1ns / 1ps

module NPCG_Toggle_bCMD_IDLE
#
(
    parameter NumberOfWays    =   4
)
(
    oWriteReady             ,
    oReadData               ,
    oReadLast               ,
    oReadValid              ,
    oPM_PCommand            ,
    oPM_PCommandOption      ,
    oPM_TargetWay           ,
    oPM_NumOfData           ,
    oPM_CASelect            ,
    oPM_CAData              ,
    oPM_WriteData           ,
    oPM_WriteLast           ,
    oPM_WriteValid          ,
    oPM_ReadReady           
);
    output                          oWriteReady             ;
    output  [31:0]                  oReadData               ;
    output                          oReadLast               ;
    output                          oReadValid              ;
    output  [7:0]                   oPM_PCommand            ;
    output  [2:0]                   oPM_PCommandOption      ;
    output  [NumberOfWays - 1:0]    oPM_TargetWay           ;
    output  [15:0]                  oPM_NumOfData           ;
    output                          oPM_CASelect            ;
    output  [7:0]                   oPM_CAData              ;
    output  [31:0]                  oPM_WriteData           ;
    output                          oPM_WriteLast           ;
    output                          oPM_WriteValid          ;
    output                          oPM_ReadReady           ;
    
    // Output
    // Dispatcher Interface
    //  - Data Write Channel
    assign oWriteReady = 1'b0;
    
    //  - Data Read Channel
    assign oReadData[31:0] = 32'h6789_ABCD;
    assign oReadLast = 1'b0;
    assign oReadValid = 1'b0;
    
    // NPCG_Toggle Interface
    assign oPM_PCommand[7:0] = 8'b0000_0000;
    assign oPM_PCommandOption[2:0] = 3'b000;
    assign oPM_TargetWay[NumberOfWays - 1:0] = 4'b0000;
    assign oPM_NumOfData[15:0] = 16'h1234;
    
    assign oPM_CASelect = 1'b0;
    assign oPM_CAData[7:0] = 8'hCC;
    
    assign oPM_WriteData[31:0] = 32'h6789_ABCD;
    assign oPM_WriteLast = 1'b0;
    assign oPM_WriteValid = 1'b0;
    
    assign oPM_ReadReady = 1'b0;
    
endmodule
