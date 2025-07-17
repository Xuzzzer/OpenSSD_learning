

`timescale 1ns / 1ps

module ComSPBRAMDPControl
(
    iClock              ,
    iReset              ,
    iWriteAddress       ,
    iWriteData          ,
    iWriteValid         ,
    oWriteAck           ,
    iReadAddress        ,
    oReadData           ,
    iReadValid          ,
    oReadAck            ,
    oBRAMAddress        ,
    oBRAMWriteData      ,
    iBRAMReadData       ,
    oBRAMEn             ,
    oBRAMWEnable
);
    input           iClock                  ;
    input           iReset                  ;

    input   [31:0]  iWriteAddress           ;
    input   [31:0]  iWriteData              ;
    input           iWriteValid             ;
    output          oWriteAck               ;
    
    input   [31:0]  iReadAddress            ;
    output  [31:0]  oReadData               ;
    input           iReadValid              ;
    output          oReadAck                ;
    
    output  [31:0]  oBRAMAddress            ;
    output  [31:0]  oBRAMWriteData          ;
    input   [31:0]  iBRAMReadData           ;
    output          oBRAMEn                 ;
    output          oBRAMWEnable            ;
    
    assign          oBRAMEn     = 1'b1;
    
    localparam      State_Idle  = 1'b0      ;
    localparam      State_Read  = 1'b1      ;
    
    reg             rCurState               ;
    reg             rNextState              ;
    
    always @ (posedge iClock)
        if (iReset)
            rCurState <= State_Idle;
        else
            rCurState <= rNextState;
    
    always @ (*)
        case (rCurState)
        State_Idle:
            rNextState <= (!iWriteValid && iReadValid)?State_Read:State_Idle;
        State_Read:
            rNextState <= State_Idle;
        endcase

    assign oWriteAck        = (rCurState == State_Idle);
    assign oReadAck         = (rCurState == State_Read);
    
    assign oBRAMAddress     = (oBRAMWEnable)?iWriteAddress:iReadAddress;
    assign oBRAMWEnable     = (iWriteValid && oWriteAck);
    
    assign oBRAMWriteData   = iWriteData    ;
    assign oReadData        = iBRAMReadData ;
    
endmodule
