

`timescale 1ns / 1ps

module Completion
#
(
    parameter AddressWidth          = 32    ,
    parameter DataWidth             = 32    ,
    parameter InnerIFLengthWidth    = 16    ,
    parameter ThisID                = 1     ,
    parameter NumberOfWays          = 8
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
    iSrcWriteData   ,
    iSrcWriteValid  ,
    iSrcWriteLast   ,
    oSrcWriteReady  ,
    oDstOpcode      ,
    oDstTargetID    ,
    oDstSourceID    ,
    oDstAddress     ,
    oDstLength      ,
    oDstCmdValid    ,
    iDstCmdReady    ,
    oDstWriteData   ,
    oDstWriteValid  ,
    oDstWriteLast   ,
    iDstWriteReady  ,
    iNANDReadyBusy
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
    
    input   [DataWidth - 1:0]           iSrcWriteData   ;
    input                               iSrcWriteValid  ;
    input                               iSrcWriteLast   ;
    output                              oSrcWriteReady  ;
    
    // Slave side
    output  [5:0]                       oDstOpcode      ;
    output  [4:0]                       oDstTargetID    ;
    output  [4:0]                       oDstSourceID    ;
    output  [AddressWidth - 1:0]        oDstAddress     ;
    output  [InnerIFLengthWidth - 1:0]  oDstLength      ;
    output                              oDstCmdValid    ;
    input                               iDstCmdReady    ;
    
    output  [DataWidth - 1:0]           oDstWriteData   ;
    output                              oDstWriteValid  ;
    output                              oDstWriteLast   ;
    input                               iDstWriteReady  ;
    
    input   [NumberOfWays - 1:0]        iNANDReadyBusy  ;
    
    wire                                wDataChReady    ;
    
    CompletionCommandChannel
    #
    (
        .AddressWidth       (AddressWidth       ),
        .DataWidth          (DataWidth          ),
        .InnerIFLengthWidth (InnerIFLengthWidth ),
        .ThisID             (ThisID             )
    )
    Inst_CompletionCommandChannel
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
        .oDstOpcode     (oDstOpcode     ),
        .oDstTargetID   (oDstTargetID   ),
        .oDstSourceID   (oDstSourceID   ),
        .oDstAddress    (oDstAddress    ),
        .oDstLength     (oDstLength     ),
        .oDstCmdValid   (oDstCmdValid   ),
        .iDstCmdReady   (iDstCmdReady   ),
        .iSrcValidCond  (wDataChReady   )
    );
    
    CompletionDataChannel
    #
    (
        .DataWidth          (DataWidth          ),
        .InnerIFLengthWidth (InnerIFLengthWidth ),
        .ThisID             (ThisID             )
    )
    Inst_CompletionDataChannel
    (
        .iClock         (iClock                         ),
        .iReset         (iReset                         ),
        .iSrcLength     (iSrcLength                     ),
        .iSrcTargetID   (iSrcTargetID                   ),
        .iSrcValid      (iSrcCmdValid && oSrcCmdReady   ),
        .oSrcReady      (wDataChReady                   ),
        .iSrcWriteData  (iSrcWriteData                  ),
        .iSrcWriteValid (iSrcWriteValid                 ),
        .iSrcWriteLast  (iSrcWriteLast                  ),
        .oSrcWriteReady (oSrcWriteReady                 ),
        .oDstWriteData  (oDstWriteData                  ),
        .oDstWriteValid (oDstWriteValid                 ),
        .oDstWriteLast  (oDstWriteLast                  ),
        .iDstWriteReady (iDstWriteReady                 ),
        .iNANDReadyBusy (iNANDReadyBusy                 )
    );
    
endmodule
