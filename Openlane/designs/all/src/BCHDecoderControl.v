`timescale 1ns / 1ps



module BCHDecoderControl
#
(
    parameter AddressWidth          = 32    ,
    parameter DataWidth             = 32    ,
    parameter InnerIFLengthWidth    = 16    ,
    parameter ThisID                = 2     ,
    parameter Multi                 = 2     ,
    parameter GaloisFieldDegree     = 12    ,
    parameter MaxErrorCountBits     = 9     ,
    parameter Syndromes             = 27    ,
    parameter ELPCoefficients       = 15
)
(
    iClock              ,
    iReset              ,
    iSrcOpcode          ,
    iSrcTargetID        ,
    iSrcSourceID        ,
    iSrcAddress         ,
    iSrcLength          ,
    iSrcCmdValid        ,
    oSrcCmdReady        ,
    iSrcWriteData       ,
    iSrcWriteValid      ,
    iSrcWriteLast       ,
    oSrcWriteReady      ,
    oDstOpcode          ,
    oDstTargetID        ,
    oDstSourceID        ,
    oDstAddress         ,
    oDstLength          ,
    oDstCmdValid        ,
    iDstCmdReady        ,
    oDstWriteData       ,
    oDstWriteValid      ,
    oDstWriteLast       ,
    iDstWriteReady      ,
    
    iSharedKESReady     ,
    oErrorDetectionEnd  ,
    oDecodeNeeded       ,
    oSyndromes          ,
    iIntraSharedKESEnd  ,
    iErroredChunk       ,
    iCorrectionFail     ,
    iErrorCount         ,
    iELPCoefficients    ,
    oCSAvailable
);

    input                                                   iClock              ;
    input                                                   iReset              ;
    
    input   [5:0]                                           iSrcOpcode          ;
    input   [4:0]                                           iSrcTargetID        ;
    input   [4:0]                                           iSrcSourceID        ;
    input   [AddressWidth - 1:0]                            iSrcAddress         ;
    input   [InnerIFLengthWidth - 1:0]                      iSrcLength          ;
    input                                                   iSrcCmdValid        ;
    output                                                  oSrcCmdReady        ;
    
    output  [5:0]                                           oDstOpcode          ;
    output  [4:0]                                           oDstTargetID        ;
    output  [4:0]                                           oDstSourceID        ;
    output  [AddressWidth - 1:0]                            oDstAddress         ;
    output  [InnerIFLengthWidth - 1:0]                      oDstLength          ;
    output                                                  oDstCmdValid        ;
    input                                                   iDstCmdReady        ;
    
    input   [DataWidth - 1:0]                               iSrcWriteData       ;
    input                                                   iSrcWriteValid      ;
    input                                                   iSrcWriteLast       ;
    output                                                  oSrcWriteReady      ;
    
    output  [DataWidth - 1:0]                               oDstWriteData       ;
    output                                                  oDstWriteValid      ;
    output                                                  oDstWriteLast       ;
    input                                                   iDstWriteReady      ;
    
    input                                                   iSharedKESReady     ;
    output  [Multi - 1:0]                                   oErrorDetectionEnd  ;
    output  [Multi - 1:0]                                   oDecodeNeeded       ;
    output  [Multi*GaloisFieldDegree*Syndromes - 1:0]       oSyndromes          ;
    input                                                   iIntraSharedKESEnd  ;
    input   [Multi - 1:0]                                   iErroredChunk       ;
    input   [Multi - 1:0]                                   iCorrectionFail     ;
    input   [Multi*MaxErrorCountBits - 1:0]                 iErrorCount         ;
    input   [Multi*GaloisFieldDegree*ELPCoefficients - 1:0] iELPCoefficients    ;
    output                                                  oCSAvailable        ;
    
    wire    [4:0]                                           wQueuedCmdSourceID  ;
    wire    [4:0]                                           wQueuedCmdTargetID  ;
    wire    [5:0]                                           wQueuedCmdOpcode    ;
    wire    [1:0]                                           wQueuedCmdType      ;
    wire    [AddressWidth - 1:0]                            wQueuedCmdAddress   ;
    wire    [InnerIFLengthWidth - 1:0]                      wQueuedCmdLength    ;
    wire                                                    wQueuedCmdValid     ;
    wire                                                    wQueuedCmdReady     ;
    
    wire    [4:0]                                           wCmdSourceID        ;
    wire    [4:0]                                           wCmdTargetID        ;
    wire    [5:0]                                           wCmdOpcode          ;
    wire    [1:0]                                           wCmdType            ;
    wire    [AddressWidth - 1:0]                            wCmdAddress         ;
    wire    [InnerIFLengthWidth - 1:0]                      wCmdLength          ;
    wire                                                    wCmdValid           ;
    wire                                                    wCmdReady           ;
    
    wire    [DataWidth - 1:0]                               wBufferedWriteData  ;
    wire                                                    wBufferedWriteValid ;
    wire                                                    wBufferedWriteLast  ;
    wire                                                    wBufferedWriteReady ;
    
    wire                                                    wDataQueuePushSignal; 
    wire                                                    wDataQueuePopSignal ;
    wire                                                    wDataQueueFull      ;
    wire                                                    wDataQueueEmpty     ;
    
    wire    [DataWidth - 1:0]                               wBypassWriteData    ;
    wire                                                    wBypassWriteLast    ;
    wire                                                    wBypassWriteValid   ;
    wire                                                    wBypassWriteReady   ;
    wire    [DataWidth - 1:0]                               wDecWriteData       ;
    wire                                                    wDecWriteValid      ;
    wire                                                    wDecWriteReady      ;
    wire                                                    wDecInDataLast      ;
    wire                                                    wDecAvailable       ;
    wire                                                    wDecodeFinished     ;
    wire                                                    wDecodeSuccess      ;
    wire    [MaxErrorCountBits - 1:0]                       wErrorSum           ;
    wire    [4*Multi - 1:0]                                 wErrorCountOut      ;
    wire    [DataWidth - 1:0]                               wCorrectedData      ;
    wire                                                    wCorrectedDataLast  ;
    wire                                                    wCorrectedDataValid ;
    wire                                                    wCorrectedDataReady ;
    wire                                                    wCSReset            ;
    wire                                                    wCSAvailable        ;
    wire                                                    wDecStandby         ;
    
    assign  oCSAvailable = wCSAvailable && wDecStandby;
    
    BCHDecoderCommandReception
    #
    (
        .AddressWidth       (AddressWidth       ),
        .DataWidth          (DataWidth          ),
        .InnerIFLengthWidth (InnerIFLengthWidth ),
        .ThisID             (ThisID             )
    )
    Inst_BCHDecoderCommandReception
    (
        .iClock             (iClock             ),
        .iReset             (iReset             ),
        .iSrcOpcode         (iSrcOpcode         ),
        .iSrcTargetID       (iSrcTargetID       ),
        .iSrcSourceID       (iSrcSourceID       ),
        .iSrcAddress        (iSrcAddress        ),
        .iSrcLength         (iSrcLength         ),
        .iSrcCmdValid       (iSrcCmdValid       ),
        .oSrcCmdReady       (oSrcCmdReady       ),
        .oQueuedCmdType     (wQueuedCmdType     ),
        .oQueuedCmdSourceID (wQueuedCmdSourceID ),
        .oQueuedCmdTargetID (wQueuedCmdTargetID ),
        .oQueuedCmdOpcode   (wQueuedCmdOpcode   ),
        .oQueuedCmdAddress  (wQueuedCmdAddress  ),
        .oQueuedCmdLength   (wQueuedCmdLength   ),
        .oQueuedCmdValid    (wQueuedCmdValid    ),
        .iQueuedCmdReady    (wQueuedCmdReady    )
    );
    
    BCHDecoderInputControl
    #
    (
        .AddressWidth       (AddressWidth       ),
        .DataWidth          (DataWidth          ),
        .InnerIFLengthWidth (InnerIFLengthWidth ),
        .ThisID             (ThisID             )
    )
    Inst_BCHDecoderInControlCore
    (
        .iClock             (iClock             ),
        .iReset             (iReset             ),
        .oDstOpcode         (wCmdOpcode         ),
        .oDstTargetID       (wCmdTargetID       ),
        .oDstSourceID       (wCmdSourceID       ),
        .oDstCmdType        (wCmdType           ),
        .oDstAddress        (wCmdAddress        ),
        .oDstLength         (wCmdLength         ),
        .oDstCmdValid       (wCmdValid          ),
        .iDstCmdReady       (wCmdReady          ),
        .iCmdSourceID       (wQueuedCmdSourceID ),
        .iCmdTargetID       (wQueuedCmdTargetID ),
        .iCmdOpcode         (wQueuedCmdOpcode   ),
        .iCmdType           (wQueuedCmdType     ),
        .iCmdAddress        (wQueuedCmdAddress  ),
        .iCmdLength         (wQueuedCmdLength   ),
        .iCmdValid          (wQueuedCmdValid    ),
        .oCmdReady          (wQueuedCmdReady    ),
        .iSrcWriteData      (iSrcWriteData      ),
        .iSrcWriteValid     (iSrcWriteValid     ),
        .iSrcWriteLast      (iSrcWriteLast      ),
        .oSrcWriteReady     (oSrcWriteReady     ),
        .oBypassWriteData   (wBypassWriteData   ),
        .oBypassWriteLast   (wBypassWriteLast   ),
        .oBypassWriteValid  (wBypassWriteValid  ),
        .iBypassWriteReady  (wBypassWriteReady  ),
        .oDecWriteData      (wDecWriteData      ),
        .oDecWriteValid     (wDecWriteValid     ),
        .iDecWriteReady     (wDecWriteReady     ),
        .iDecInDataLast     (wDecInDataLast     ),
        .iDecAvailable      (wDecAvailable      )
    );
    
    BCHDecoderX
    #
    (   
        .DataWidth          (DataWidth          ),
        .Multi              (Multi              ),
        .MaxErrorCountBits  (MaxErrorCountBits  ),
        .GaloisFieldDegree  (GaloisFieldDegree  ),
        .Syndromes          (Syndromes          ),
        .ELPCoefficients    (ELPCoefficients    )
    )
    Inst_BCHDecoderIO
    (
        .iClock                 (iClock                 ),
        .iReset                 (iReset                 ),
        .iData                  (wDecWriteData          ),
        .iDataValid             (wDecWriteValid         ),
        .oDataReady             (wDecWriteReady         ),
        .oDataLast              (wDecInDataLast         ),
        .oDecoderReady          (wDecAvailable          ),
        .oDecodeFinished        (wDecodeFinished        ),
        .oDecodeSuccess         (wDecodeSuccess         ),
        .oErrorSum              (wErrorSum              ),
        .oErrorCountOut         (wErrorCountOut         ),
        .oCorrectedData         (wCorrectedData         ),
        .oCorrectedDataValid    (wCorrectedDataValid    ),
        .oCorrectedDataLast     (wCorrectedDataLast     ),
        .iCorrectedDataReady    (wCorrectedDataReady    ),
        
        .iSharedKESReady        (iSharedKESReady        ),
        .oErrorDetectionEnd     (oErrorDetectionEnd     ),
        .oDecodeNeeded          (oDecodeNeeded          ),
        .oSyndromes             (oSyndromes             ),
        .iIntraSharedKESEnd     (iIntraSharedKESEnd     ),
        .iErroredChunk          (iErroredChunk          ),
        .iCorrectionFail        (iCorrectionFail        ),
        .iErrorCount            (iErrorCount            ),
        .iELPCoefficients       (iELPCoefficients       ),
        .oCSAvailable           (wCSAvailable           ),
        .iCSReset               (wCSReset               )
    );    
    
    
    BCHDecoderOutputControl
    #
    (
        .AddressWidth           (AddressWidth           ),
        .DataWidth              (DataWidth              ),
        .InnerIFLengthWidth     (InnerIFLengthWidth     ),
        .ThisID                 (ThisID                 ),
        .Multi                  (Multi                  ),
        .MaxErrorCountBits      (MaxErrorCountBits      )
    )
    Inst_BCHDecoderOutControlCore
    (
        .iClock                 (iClock                 ),
        .iReset                 (iReset                 ),
        .oDstOpcode             (oDstOpcode             ),
        .oDstTargetID           (oDstTargetID           ),
        .oDstSourceID           (oDstSourceID           ),
        .oDstAddress            (oDstAddress            ),
        .oDstLength             (oDstLength             ),
        .oDstCmdValid           (oDstCmdValid           ),
        .iDstCmdReady           (iDstCmdReady           ),
        .iCmdSourceID           (wCmdSourceID           ),
        .iCmdTargetID           (wCmdTargetID           ),
        .iCmdOpcode             (wCmdOpcode             ),
        .iCmdType               (wCmdType               ),
        .iCmdAddress            (wCmdAddress            ),
        .iCmdLength             (wCmdLength             ),
        .iCmdValid              (wCmdValid              ),
        .oCmdReady              (wCmdReady              ),
        .iBypassWriteData       (wBypassWriteData       ),
        .iBypassWriteLast       (wBypassWriteLast       ),
        .iBypassWriteValid      (wBypassWriteValid      ),
        .oBypassWriteReady      (wBypassWriteReady      ),
        .iDecWriteData          (wCorrectedData         ),
        .iDecWriteValid         (wCorrectedDataValid    ),
        .iDecWriteLast          (wCorrectedDataLast     ),
        .oDecWriteReady         (wCorrectedDataReady    ),
        .oDstWriteData          (wBufferedWriteData     ),
        .oDstWriteValid         (wBufferedWriteValid    ),
        .oDstWriteLast          (wBufferedWriteLast     ),
        .iDstWriteReady         (wBufferedWriteReady    ),
        .iDecodeFinished        (wDecodeFinished        ),
        .iDecodeSuccess         (wDecodeSuccess         ),
        .iErrorSum              (wErrorSum              ),
        .iErrorCountOut         (wErrorCountOut         ),
        .oCSReset               (wCSReset               ),
        .oDecStandby            (wDecStandby            )
    );
    
    assign wDataQueuePushSignal = wBufferedWriteValid && !wDataQueueFull;
    assign wBufferedWriteReady  = !wDataQueueFull;
    
    AutoFIFOPopControl
    Inst_DataQueueAutoPopControl
    (
        .iClock         (iClock             ),
        .iReset         (iReset             ),
        .oPopSignal     (wDataQueuePopSignal),
        .iEmpty         (wDataQueueEmpty    ),
        .oValid         (oDstWriteValid     ),
        .iReady         (iDstWriteReady     )
    );
    wire [63:0] oPopData_tmp;
    SCFIFO_64x64_withCount
    Inst_DataQueue
    (
        .iClock         (iClock                                             ),
        .iReset         (iReset                                             ),
        .iPushData      ({31'b0,wBufferedWriteData, wBufferedWriteLast}           ),
        .iPushEnable    (wDataQueuePushSignal                               ),
        .oIsFull        (wDataQueueFull                                     ),
        .oPopData       (oPopData_tmp                     ),
        .iPopEnable     (wDataQueuePopSignal                                ),
        .oIsEmpty       (wDataQueueEmpty                                    ),
        .oDataCount     (                                                   )
    );
    assign oPopData_tmp[DataWidth:0] = {oDstWriteData, oDstWriteLast};
    
endmodule
