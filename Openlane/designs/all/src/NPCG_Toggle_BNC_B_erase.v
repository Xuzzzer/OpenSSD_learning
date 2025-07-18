

`timescale 1ns / 1ps

module NPCG_Toggle_BNC_B_erase
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
    iCMDValid           ,
    oCMDReady           ,
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
    oPM_CAData   
);
    input                           iSystemClock            ;
    input                           iReset                  ;
    input   [5:0]                   iOpcode                 ;
    input   [4:0]                   iTargetID               ;
    input   [4:0]                   iSourceID               ;
    input                           iCMDValid               ;
    output                          oCMDReady               ;
    input   [NumberOfWays - 1:0]    iWaySelect              ;
    input   [15:0]                  iColAddress             ;
    input   [23:0]                  iRowAddress             ;
    output                          oStart                  ;
    output                          oLastStep               ;
    input   [7:0]                   iPM_Ready               ;
    input   [7:0]                   iPM_LastStep            ;
    output  [7:0]                   oPM_PCommand            ;
    output  [2:0]                   oPM_PCommandOption      ;
    output  [NumberOfWays - 1:0]    oPM_TargetWay           ;
    output  [15:0]                  oPM_NumOfData           ;
    output                          oPM_CASelect            ;
    output  [7:0]                   oPM_CAData              ;

    reg [NumberOfWays - 1:0]    rTargetWay  ;
    reg [15:0]                  rColAddress ;
    reg [23:0]                  rRowAddress ;
    wire                        wModuleTriggered;
    wire                        wTMStart    ;
    
    reg [7:0]                   rPMTrigger  ;
    reg [2:0]                   rPCommandOption ;
    reg [15:0]                  rNumOfData  ;
    
    reg [7:0]                   rCAData     ;
    reg                         rPMCommandOrAddress ;
    
    reg                         rDoNotCommit    ;
    reg                         rEraseResume    ;
    reg                         rMultiplaneSuspend;

    localparam  State_Idle          = 4'b0000   ;
    localparam  State_NCALIssue     = 4'b0001   ;
    localparam  State_NCmdPreset    = 4'b0011   ;
    localparam  State_NCmdWrite0    = 4'b0010   ;
    localparam  State_NCmdWrite1    = 4'b0110   ;
    localparam  State_NAddrWrite0   = 4'b0111   ;
    localparam  State_NAddrWrite1   = 4'b0101   ;
    localparam  State_NAddrWrite2   = 4'b0100   ;
    localparam  State_NCmdWrite2    = 4'b1100   ;
    localparam  State_NTMIssue      = 4'b1101   ;
    localparam  State_WaitDone      = 4'b1111   ;
    
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
            rNextState <= (wModuleTriggered)?State_NCALIssue:State_Idle;
        State_NCALIssue:
            if (iPM_Ready[6:0] == 7'b1111111)
            begin
                if (rEraseResume)
                    rNextState <= State_NCmdPreset;
                else
                    rNextState <= State_NCmdWrite0;
            end
            else
                rNextState <= State_NCALIssue;
        State_NCmdPreset:
            rNextState <= State_NCmdWrite0;
        State_NCmdWrite0:
            rNextState <= State_NCmdWrite1;
        State_NCmdWrite1:
            rNextState <= State_NAddrWrite0;
        State_NAddrWrite0:
            rNextState <= State_NAddrWrite1;
        State_NAddrWrite1:
            rNextState <= State_NAddrWrite2;
        State_NAddrWrite2:
            if (rDoNotCommit)
                rNextState <= State_NTMIssue;
            else
                rNextState <= State_NCmdWrite2;
        State_NCmdWrite2:
            rNextState <= State_NTMIssue;
        State_NTMIssue:
            rNextState <= (wTMStart)?State_WaitDone:State_NTMIssue;
        State_WaitDone:
            rNextState <= (oLastStep)?State_Idle:State_WaitDone;
        default:
            rNextState <= State_Idle;
        endcase
    
    assign wModuleTriggered = (iCMDValid && iTargetID == 5'b00101 && iOpcode == 6'b000100);
    assign wTMStart = (rCurState == State_NTMIssue) & iPM_LastStep[3];
    assign oCMDReady = (rCurState == State_Idle);
    
    always @ (posedge iSystemClock)
        if (iReset)
        begin
            rTargetWay <= {(NumberOfWays){1'b0}};
            rColAddress <= 16'b0;
            rRowAddress <= 24'b0;
            rDoNotCommit <= 1'b0;
            rEraseResume <= 1'b0;
            rMultiplaneSuspend <= 1'b0;
        end
        else
            if (wModuleTriggered && (rCurState == State_Idle))
            begin
                rTargetWay  <= iWaySelect   ;
                rColAddress <= iColAddress  ;
                rRowAddress <= iRowAddress  ;
                rDoNotCommit <= iSourceID[0];
                rEraseResume <= iSourceID[1];
                rMultiplaneSuspend <= iSourceID[2];
            end
    
    always @ (*)
        case (rCurState)
        State_NCALIssue:
            rPMTrigger <= 8'b00001000;
        State_NTMIssue:
            rPMTrigger <= 8'b00000001;
        default:
            rPMTrigger <= 0;
        endcase
    
    always @ (*)
        case (rCurState)
        State_NTMIssue:
            rPCommandOption[2:0] <= 3'b110;
        default:
            rPCommandOption[2:0] <= 0;
        endcase
    
    always @ (*)
        case (rCurState)
        State_NCALIssue:
            rNumOfData[15:0] <= 16'd5 - ((rDoNotCommit)?16'd1:16'd0) + ((rEraseResume)?16'd1:16'd0);
        State_NTMIssue:
            rNumOfData[15:0] <= 16'd10; // 110 ns
        default:
            rNumOfData[15:0] <= 0;
        endcase
    
    always @ (*)
        case (rCurState)
        State_NCmdPreset:
            rPMCommandOrAddress <= 1'b0;
        State_NCmdWrite0:
            rPMCommandOrAddress <= 1'b0;
        State_NCmdWrite1:
            rPMCommandOrAddress <= 1'b0;
        State_NCmdWrite2:
            rPMCommandOrAddress <= 1'b0;
        State_NAddrWrite0:
            rPMCommandOrAddress <= 1'b1;
        State_NAddrWrite1:
            rPMCommandOrAddress <= 1'b1;
        State_NAddrWrite2:
            rPMCommandOrAddress <= 1'b1;
        default:
            rPMCommandOrAddress <= 1'b0;
        endcase
    
    always @ (posedge iSystemClock)
        if (iReset)
            rCAData <= 8'b0;
        else
            case (rNextState)
            State_NCmdPreset:
                rCAData <= 8'h27;
            State_NCmdWrite0:
                rCAData <= (rMultiplaneSuspend)?8'hFA:8'ha2;
            State_NCmdWrite1:
                rCAData <= 8'h60;
            State_NAddrWrite0:
                rCAData <= rRowAddress[7:0];
            State_NAddrWrite1:
                rCAData <= rRowAddress[15:8];
            State_NAddrWrite2:
                rCAData <= rRowAddress[23:16];
            State_NCmdWrite2:
                rCAData <= 8'hD0;
            default:
                rCAData <= 0;
            endcase
    
    assign oStart = wModuleTriggered;
    assign oLastStep            = (rCurState == State_WaitDone) & iPM_LastStep[0];
    //assign oDoneWay             = rTargetWay;
    
    assign oPM_PCommand         = rPMTrigger;
    assign oPM_PCommandOption   = rPCommandOption;//1'b0;
    assign oPM_TargetWay        = rTargetWay;
    assign oPM_NumOfData        = rNumOfData;   //16'd4;
    assign oPM_CASelect         = rPMCommandOrAddress;
    assign oPM_CAData           = rCAData;
    //assign oPM_WriteData        = 32'b0;
    //assign oPM_WriteLast        = 1'b0;
    //assign oPM_WriteValid       = 1'b0;
    //assign oPM_ReadReady        = 1'b0;

endmodule
