

`timescale 1ns / 1ps

module BCHEncoderControl
#
(
    parameter AddressWidth          = 32    ,
    parameter DataWidth             = 32    ,
    parameter InnerIFLengthWidth    = 16    ,
    parameter ThisID                = 2
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
    oSrcReadData    ,
    oSrcReadValid   ,
    oSrcReadLast    ,
    iSrcReadReady   ,
    oDstOpcode      ,
    oDstTargetID    ,
    oDstSourceID    ,
    oDstAddress     ,
    oDstLength      ,
    oDstCmdValid    ,
    iDstCmdReady    ,
    iDstReadData    ,
    iDstReadValid   ,
    iDstReadLast    ,
    oDstReadReady
);

    input                               iClock          ;
    input                               iReset          ;
    
    // Master side
    input   [5:0]                       iSrcOpcode      ;
    input   [4:0]                       iSrcTargetID    ;
    input   [4:0]                       iSrcSourceID    ;
    input   [AddressWidth - 1:0]        iSrcAddress     ;
    input   [InnerIFLengthWidth - 1:0]  iSrcLength      ;
    input                               iSrcCmdValid    ;
    output                              oSrcCmdReady    ;
    
    output  [DataWidth - 1:0]           oSrcReadData    ;
    output                              oSrcReadValid   ;
    output                              oSrcReadLast    ;
    input                               iSrcReadReady   ;
    
    // Slave side
    output  [5:0]                       oDstOpcode      ;
    output  [4:0]                       oDstTargetID    ;
    output  [4:0]                       oDstSourceID    ;
    output  [AddressWidth - 1:0]        oDstAddress     ;
    output  [InnerIFLengthWidth - 1:0]  oDstLength      ;
    output                              oDstCmdValid    ;
    input                               iDstCmdReady    ;
    
    input   [DataWidth - 1:0]           iDstReadData    ;
    input                               iDstReadValid   ;
    input                               iDstReadLast    ;
    output                              oDstReadReady   ;
    
    wire                                wOpQPushSignal  ;
    wire    [InnerIFLengthWidth+2-1:0]  wOpQPushData    ;
    wire    [InnerIFLengthWidth+2-1:0]  wOpQPopData     ;
    wire                                wOpQIsFull      ;
    wire                                wOpQIsEmpty     ;
    wire                                wOpQOpValid     ;
    wire                                wOpQOpReady     ;
    wire    [InnerIFLengthWidth - 1:0]  wOpQOpLength    ;
    wire    [1:0]                       wOpQOpType      ;
    
    wire    wOpQPopSignal   ;
    wire [63:0] oPopData_tmp;
    SCFIFO_64x64_withCount
    DataBuffer
    (
        .iClock         (iClock                         ),
        .iReset         (iReset                         ),
        .iPushData      ({46'b0,wOpQPushData }           ),
        .iPushEnable    (wOpQPushSignal                 ),
        .oIsFull        (wOpQIsFull                     ),
        .oPopData       (oPopData_tmp                   ),
        .iPopEnable     (wOpQPopSignal                  ),
        .oIsEmpty       (wOpQIsEmpty                    ),
        .oDataCount     (                               )
    );
    assign wOpQPopData = oPopData_tmp[InnerIFLengthWidth+2-1:0];
    
    AutoFIFOPopControl
    DataBufferControl
    (
        .iClock         (iClock                         ),
        .iReset         (iReset                         ),
        .oPopSignal     (wOpQPopSignal                  ),
        .iEmpty         (wOpQIsEmpty                    ),
        .oValid         (wOpQOpValid                    ),
        .iReady         (wOpQOpReady                    )
    );
    
    BCHEncoderCommandChannel
    #
    (
        .AddressWidth          (AddressWidth        ),
        .DataWidth             (DataWidth           ),
        .InnerIFLengthWidth    (InnerIFLengthWidth  ),
        .ThisID                (ThisID              )
    )
    Inst_BCHEncoderCommandChannel
    (
        .iClock         (iClock         ),
        .iReset         (iReset         ),
        .iSrcOpcode     (iSrcOpcode     ),
        .iSrcTargetID   (iSrcTargetID   ),
        .iSrcSourceID   (iSrcSourceID   ),
        .iSrcAddress    (iSrcAddress    ),
        .iSrcLength     (iSrcLength     ),
        .iSrcCmdValid   (iSrcCmdValid   ),
        .oSrcCmdReady   (oSrcCmdReady   ),
        .oOpQPushSignal (wOpQPushSignal ),
        .oOpQPushData   (wOpQPushData   ),
        .oDstOpcode     (oDstOpcode     ),
        .oDstTargetID   (oDstTargetID   ),
        .oDstSourceID   (oDstSourceID   ),
        .oDstAddress    (oDstAddress    ),
        .oDstLength     (oDstLength     ),
        .oDstCmdValid   (oDstCmdValid   ),
        .iDstCmdReady   (iDstCmdReady   ),
        .iSrcValidCond  (!wOpQIsFull    )
    );
    
    assign {wOpQOpLength, wOpQOpType} = wOpQPopData;
    
    BCHEncoderDataChannel
    #
    (
        .DataWidth              (DataWidth          ),
        .InnerIFLengthWidth     (InnerIFLengthWidth )
    )
    Inst_BCHEncoderDataChannel
    (
        .iClock         (iClock         ),
        .iReset         (iReset         ),
        .iLength        (wOpQOpLength   ),
        .iCmdType       (wOpQOpType     ),
        .iCmdValid      (wOpQOpValid    ),
        .oCmdReady      (wOpQOpReady    ),
        .oSrcReadData   (oSrcReadData   ),
        .oSrcReadValid  (oSrcReadValid  ),
        .oSrcReadLast   (oSrcReadLast   ),
        .iSrcReadReady  (iSrcReadReady  ),
        .iDstReadData   (iDstReadData   ),
        .iDstReadValid  (iDstReadValid  ),
        .iDstReadLast   (iDstReadLast   ),
        .oDstReadReady  (oDstReadReady  )
    );

endmodule
