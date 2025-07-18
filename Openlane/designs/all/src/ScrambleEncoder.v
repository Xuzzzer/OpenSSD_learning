

`timescale 1ns / 1ps

module ScrambleEncoder
#
(
    parameter AddressWidth          = 32    ,
    parameter DataWidth             = 32    ,
    parameter InnerIFLengthWidth    = 16    ,
    parameter ThisID                = 3
)
(
    iClock          ,
    iReset          ,
    iSrcOpcode      ,
    iSrcTargetID    ,
    iSrcSourceID    ,
    iSrcAddress     ,
    iSrcLength      ,
    iSrcCmdValid    ,
    oSrcCmdReady    ,
    oDstOpcode      ,
    oDstTargetID    ,
    oDstSourceID    ,
    oDstAddress     ,
    oDstLength      ,
    oDstCmdValid    ,
    iDstCmdReady    ,
    oSrcReadData   ,
    oSrcReadValid  ,
    oSrcReadLast   ,
    iSrcReadReady  ,
    iDstReadData   ,
    iDstReadValid  ,
    iDstReadLast   ,
    oDstReadReady
);

    input                               iClock          ;
    input                               iReset          ;
    
    input   [5:0]                       iSrcOpcode      ;
    input   [4:0]                       iSrcTargetID    ;
    input   [4:0]                       iSrcSourceID    ;
    input   [AddressWidth - 1:0]        iSrcAddress     ;
    input   [InnerIFLengthWidth - 1:0]  iSrcLength      ;
    input                               iSrcCmdValid    ;
    output                              oSrcCmdReady    ;
    
    output  [5:0]                       oDstOpcode      ;
    output  [4:0]                       oDstTargetID    ;
    output  [4:0]                       oDstSourceID    ;
    output  [AddressWidth - 1:0]        oDstAddress     ;
    output  [InnerIFLengthWidth - 1:0]  oDstLength      ;
    output                              oDstCmdValid    ;
    input                               iDstCmdReady    ;
    
    output  [DataWidth - 1:0]           oSrcReadData    ;
    output                              oSrcReadValid   ;
    output                              oSrcReadLast    ;
    input                               iSrcReadReady   ;
    
    input   [DataWidth - 1:0]           iDstReadData    ;
    input                               iDstReadValid   ;
    input                               iDstReadLast    ;
    output                              oDstReadReady   ;
    
    reg     [5:0]                       rOpcode         ;
    reg     [4:0]                       rTargetID       ;
    reg     [4:0]                       rSourceID       ;
    reg     [AddressWidth - 1:0]        rAddress        ;
    reg     [InnerIFLengthWidth - 1:0]  rLength         ;
    reg                                 rDstCValid      ;
    
    reg     [DataWidth - 1:0]           rRowAddress     ;
    reg                                 rScramblerGEn   ;
    
    parameter   DispatchCmd_PageReadFromRAM     = 6'b000001 ;
    parameter   DispatchCmd_SpareReadFromRAM    = 6'b000010 ;
    
    localparam  State_Idle      = 3'b000;
    localparam  State_BypassCmd = 3'b001;
    localparam  State_BypassTrf = 3'b011;
    localparam  State_EncTrfCmd = 3'b010;
    localparam  State_EncTrf    = 3'b110;
    reg     [2:0]   rCurState;
    reg     [2:0]   rNextState;
    
    always @ (posedge iClock)
        if (iReset)
            rCurState <= State_Idle;
        else
            rCurState <= rNextState;
    
    always @ (*)
        case (rCurState)
        State_Idle:
            if (iSrcCmdValid && (iSrcTargetID != ThisID))
            begin
                if (rScramblerGEn && (iSrcTargetID == 0) && ((iSrcOpcode == DispatchCmd_PageReadFromRAM) || (iSrcOpcode == DispatchCmd_SpareReadFromRAM)))
                    rNextState <= State_EncTrfCmd;
                else
                    rNextState <= State_BypassCmd;
            end
            else
                rNextState <= State_Idle;
        State_BypassCmd:
            if (iDstCmdReady)
            begin
                if (rLength == 0)
                    rNextState <= State_Idle;
                else
                    rNextState <= State_BypassTrf;
            end
            else
                rNextState <= State_BypassCmd;
        State_BypassTrf:
            rNextState <= (iDstReadValid && iDstReadLast && iSrcReadReady)?State_Idle:State_BypassTrf;
        State_EncTrfCmd:
            rNextState <= (iDstCmdReady)?State_EncTrf:State_EncTrfCmd;
        State_EncTrf:
            rNextState <= (iDstReadValid && iDstReadLast && iSrcReadReady)?State_Idle:State_EncTrf;
        default:
            rNextState <= State_Idle;
        endcase
    
    assign oSrcCmdReady = (rCurState == State_Idle);
    assign oDstOpcode       = rOpcode       ;
    assign oDstTargetID     = rTargetID     ;
    assign oDstSourceID     = rSourceID     ;
    assign oDstAddress      = rAddress      ;
    assign oDstLength       = rLength       ;
    assign oDstCmdValid     = rDstCValid    ;
    
    always @ (posedge iClock)
        if (iReset)
        begin
            rOpcode     <= 6'b0;
            rTargetID   <= 5'b0;
            rSourceID   <= 5'b0;
            rAddress    <= {(AddressWidth){1'b0}};
            rLength     <= {(InnerIFLengthWidth){1'b0}};
        end
        else
        begin
            if (rCurState == State_Idle && iSrcCmdValid)
            begin
                rOpcode     <= iSrcOpcode   ;
                rTargetID   <= iSrcTargetID ;
                rSourceID   <= iSrcSourceID ;
                rAddress    <= iSrcAddress  ;
                rLength     <= iSrcLength   ;
            end
        end
    
    always @ (*)
        case (rCurState)
        State_BypassCmd:
            rDstCValid <= 1'b1;
        State_EncTrfCmd:
            rDstCValid <= 1'b1;
        default:
            rDstCValid <= 1'b0;
        endcase
    
    always @ (posedge iClock)
        if (iReset)
        begin
            rRowAddress <= {(DataWidth){1'b0}};
            rScramblerGEn <= 1'b1;
        end
        else
        begin
            if (rCurState == State_Idle && iSrcCmdValid)
            begin
                if (iSrcTargetID == ThisID)
                begin
                    if (iSrcOpcode == 6'b000001)
                        rScramblerGEn <= 1'b0;
                    else if (iSrcOpcode == 6'b000011)
                        rScramblerGEn <= 1'b1;
                    else
                        rRowAddress <= iSrcAddress;
                end
            end
        end
    
    wire    [DataWidth - 1:0]   wLFSROut;
    genvar i;
    parameter IndexWidth = $clog2(DataWidth / 8);
    wire    [IndexWidth * (DataWidth / 8) - 1:0] wIndex;
    
    generate
        for (i = 0; i < DataWidth / 8; i = i + 1)
        begin
            assign wIndex[IndexWidth * (i + 1) - 1:IndexWidth * i] = {(IndexWidth){1'b1}} & i;
            wire [IndexWidth-1:0] cur_index = wIndex[IndexWidth * (i + 1) - 1:IndexWidth * i];
            wire [17:0] seed_concat = {rRowAddress, cur_index};
            LFSR8
            Inst_LFSR
            (
                .iClock         (iClock                                         ),
                .iReset         (iReset                                         ),
                .iSeed          (seed_concat[7:0]),
                .iSeedEnable    (rCurState == State_EncTrfCmd                   ),
                .iShiftEnable   ((rCurState == State_EncTrf) &&
                                    iDstReadValid && iSrcReadReady              ),
                .oData          (wLFSROut[8 * (i + 1) - 1:8 * i]                )
            );
        end
    endgenerate
    
    assign oSrcReadValid    = iDstReadValid && ((rCurState == State_EncTrf) || (rCurState == State_BypassTrf));
    assign oSrcReadLast     = iDstReadLast;
    assign oSrcReadData     = (rCurState == State_EncTrf)?(wLFSROut ^ iDstReadData):iDstReadData;
    assign oDstReadReady    = iSrcReadReady && ((rCurState == State_EncTrf) || (rCurState == State_BypassTrf));
    
endmodule
