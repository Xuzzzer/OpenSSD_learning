

`timescale 1ns / 1ps

module NPCG_Toggle_MNC_readID
#
(
    parameter NumberOfWays    =   4
)
(
    iSystemClock        ,
    iReset              ,
    iOpcode             ,
    iTargetID           ,
    iSourceID           ,
    iLength             ,
    iCMDValid           ,
    oCMDReady           ,
    oReadData           ,
    oReadLast           ,
    oReadValid          ,
    iReadReady          ,
    iWaySelect          ,
    iColAddress         ,
    iRowAddress         ,
    oStart              ,
    oLastStep           ,
    iPM_Ready           ,
    iPM_LastStep        ,
    oPM_PCommand        ,
    oPM_PCommandOption  ,
    oPM_TargetWay       ,
    oPM_NumOfData       ,
    oPM_CASelect        ,
    oPM_CAData          ,
    iPM_ReadData        ,
    iPM_ReadLast        ,
    iPM_ReadValid       ,
    oPM_ReadReady
);
    input                           iSystemClock        ;
    input                           iReset              ;
    input   [5:0]                   iOpcode             ;
    input   [4:0]                   iTargetID           ;
    input   [4:0]                   iSourceID           ;
    input   [15:0]                  iLength             ;
    input                           iCMDValid           ;
    output                          oCMDReady           ;
    output  [31:0]                  oReadData           ;
    output                          oReadLast           ;
    output                          oReadValid          ;
    input                           iReadReady          ;
    input  [NumberOfWays - 1:0]     iWaySelect          ;
    input   [15:0]                  iColAddress         ;
    input   [23:0]                  iRowAddress         ;
    output                          oStart              ;
    output                          oLastStep           ;
    input   [7:0]                   iPM_Ready           ;
    input   [7:0]                   iPM_LastStep        ;
    output  [7:0]                   oPM_PCommand        ;
    output  [2:0]                   oPM_PCommandOption  ;
    output  [NumberOfWays - 1:0]    oPM_TargetWay       ;
    output  [15:0]                  oPM_NumOfData       ;
    output                          oPM_CASelect        ;
    output  [7:0]                   oPM_CAData          ;
    input   [31:0]                  iPM_ReadData        ;
    input                           iPM_ReadLast        ;
    input                           iPM_ReadValid       ;
    output                          oPM_ReadReady       ;

    reg [NumberOfWays - 1:0]    rTargetWay  ;
    reg [15:0]                  rColAddress ;
    reg [23:0]                  rRowAddress ;
    reg [4:0]                   rSourceID   ;
    wire                        wModuleTriggered;
    
    reg [7:0]                   rPMTrigger  ;
    reg [2:0]                   rPCommandOption ;
    reg [15:0]                  rPMLength   ;
    reg [15:0]                  rTrfLength  ;
    
    reg [7:0]                   rCAData     ;
    reg                         rPMCommandOrAddress ;

    localparam  State_Idle              = 4'b0000   ;
    localparam  State_NPBRIssue         = 4'b0001   ;
    localparam  State_NCmdIssue         = 4'b0011   ;
    localparam  State_NCmdWrite0        = 4'b0010   ;
    localparam  State_NCmdWrite1        = 4'b0110   ;
    localparam  State_NTimer1Issue      = 4'b1111   ;
    localparam  State_DIIssue           = 4'b1110   ;
    localparam  State_NTimer2Issue      = 4'b1010   ;
    localparam  State_WaitDone          = 4'b1011   ;
    
    reg [3:0]   rCurState   ;
    reg [3:0]   rNextState  ;

    always @ (posedge iSystemClock)
        if (iReset)
            rCurState <= State_Idle;
        else
            rCurState <= rNextState;

    always @ (*)
        case (rCurState)
        State_Idle:
            rNextState <= (wModuleTriggered)?State_NPBRIssue:State_Idle;
        State_NPBRIssue:
            rNextState <= (iPM_Ready[6:0] == 7'b1111111)?State_NCmdIssue:State_NPBRIssue;
        State_NCmdIssue:
            rNextState <= (iPM_LastStep[6])? State_NCmdWrite0:State_NCmdIssue;
        State_NCmdWrite0:
            rNextState <= State_NCmdWrite1;
        State_NCmdWrite1: // col 0
            rNextState <= State_NTimer1Issue;
        State_NTimer1Issue:
            rNextState <= (iPM_LastStep[3])? State_DIIssue:State_NTimer1Issue;
        State_DIIssue:
            rNextState <= (iPM_LastStep[0])? State_NTimer2Issue:State_DIIssue;
        State_NTimer2Issue:
            rNextState <= (iPM_LastStep[1])? State_WaitDone:State_NTimer2Issue;
        State_WaitDone:
            rNextState <= (oLastStep)?State_Idle:State_WaitDone;
        default:
            rNextState <= State_Idle;
        endcase
    
    assign wModuleTriggered = (iCMDValid && iTargetID == 5'b00101 && iOpcode == 6'b101011);
    assign oCMDReady = (rCurState == State_Idle);
    
    always @ (posedge iSystemClock)
        if (iReset)
        begin
            rTargetWay <= {(NumberOfWays){1'b0}};
            rTrfLength  <= 16'b0;
            rColAddress <= 16'b0;
            rRowAddress <= 24'b0;
            rSourceID   <= 5'b0;
        end
        else
            if (wModuleTriggered && (rCurState == State_Idle))
            begin
                rTargetWay  <= iWaySelect   ;
                rTrfLength  <= iLength      ;
                rColAddress <= iColAddress  ;
                rRowAddress <= iRowAddress  ;
                rSourceID   <= iSourceID    ;
            end
    
    always @ (*)
        case (rCurState)
        State_NPBRIssue:
            rPMTrigger <= 8'b0100_0000;
        State_NCmdIssue:
            rPMTrigger <= 8'b0000_1000;
        State_NTimer1Issue:
            rPMTrigger <= 8'b0000_0001;
        State_DIIssue:
            rPMTrigger <= 8'b0000_0010;
        State_NTimer2Issue:
            rPMTrigger <= 8'b0000_0001;
        default:
            rPMTrigger <= 8'b0000_0000;
        endcase
    
    always @ (*)
        case (rCurState)
        State_NTimer1Issue:
            rPCommandOption[2:0] <= 3'b001; // CE on
        State_DIIssue:
            rPCommandOption[2:0] <= 3'b001; // word access
        State_NTimer2Issue:
            rPCommandOption[2:0] <= 3'b100;
        default:
            rPCommandOption[2:0] <= 0;
        endcase
    
    always @ (*)
        if (iReset)
            rPMLength <= 0;
        else
            case (rCurState)
            State_NCmdIssue:
                rPMLength <= 16'd1; // 1 cmd + 1 addr
            State_NTimer1Issue:
                rPMLength <= 16'd14; // 150 ns
            State_DIIssue:
                rPMLength <= rTrfLength;
            State_NTimer2Issue:
                rPMLength <= 16'd7; // 80 ns
            default:
                rPMLength <= 0;
            endcase
        
    always @ (*)
        case (rCurState)
        State_NCmdWrite0:
            rPMCommandOrAddress <= 1'b0;
        State_NCmdWrite1:
            rPMCommandOrAddress <= 1'b1;
        default:
            rPMCommandOrAddress <= 1'b0;
        endcase
    
    always @ (*)
        if (iReset)
            rCAData <= 0;
        else
            case (rCurState)
            State_NCmdWrite0:
                rCAData <= rColAddress[7:0];
            State_NCmdWrite1:
                rCAData <= rColAddress[15:8];
            default:
                rCAData <= 0;
            endcase
    
    assign oStart = wModuleTriggered;
    assign oLastStep            = (rCurState == State_WaitDone) & iPM_LastStep[0];
    
    assign oReadData            = iPM_ReadData;
    assign oReadLast            = iPM_ReadLast;
    assign oReadValid           = iPM_ReadValid;
    assign oPM_ReadReady        = iReadReady;
    
    assign oPM_PCommand         = rPMTrigger;
    assign oPM_PCommandOption   = rPCommandOption; // CE on of PM_Timer, Word access of PM_DI
    assign oPM_TargetWay        = rTargetWay;
    assign oPM_NumOfData        = rPMLength ;
    assign oPM_CASelect         = rPMCommandOrAddress;
    assign oPM_CAData           = rCAData;
    
endmodule
