

`timescale 1ns / 1ps

module DispRegExt
(
    iClock                  ,
    iReset                  ,
    iWriteAddress           ,
    iWriteData              ,
    iWriteValid             ,
    oWriteAck               ,
    iReadAddress            ,
    oReadData               ,
    iReadValid              ,
    oReadAck                ,
    iLLNFCCmdReady          ,
    iLLNFCWriteHandshake    ,
    iLLNFCReadHandshake     ,
    iDPLWCCmdReady          ,
    iDPLWCDataHandshake     ,
    iDPLRCCmdReady          ,
    iDPLRCDataHandshake     ,
    iNANDReadyBusy
);
    input           iClock                      ;
    input           iReset                      ;
    input  [31:0]   iWriteAddress               ;
    input  [31:0]   iWriteData                  ;
    input           iWriteValid                 ;
    output          oWriteAck                   ;
    input  [31:0]   iReadAddress                ;
    output [31:0]   oReadData                   ;
    input           iReadValid                  ;
    output          oReadAck                    ;
    
    input           iLLNFCCmdReady              ;
    input           iLLNFCWriteHandshake        ;
    input           iLLNFCReadHandshake         ;
    input           iDPLWCCmdReady              ;
    input           iDPLWCDataHandshake         ;
    input           iDPLRCCmdReady              ;
    input           iDPLRCDataHandshake         ;
    input           iNANDReadyBusy              ;
    
    wire   [31:0]   wLLNFCCmdIdleTimeCounter    ;
    wire   [31:0]   wLLNFCWriteIdleTimeCounter  ;
    wire   [31:0]   wLLNFCReadIdleTimeCounter   ;
    wire   [31:0]   wDPLWCCmdIdleTimeCounter    ;
    wire   [31:0]   wDPLWCDataIdleTimeCounter   ;
    wire   [31:0]   wDPLRCCmdIdleTimeCounter    ;
    wire   [31:0]   wDPLRCDataIdleTimeCounter   ;
    wire   [31:0]   wNANDIdleTimeCounter        ;
    
    wire   [31:0]   wLLNFCCmdIdleTimePeriod     ;
    wire   [31:0]   wLLNFCWriteIdleTimePeriod   ;
    wire   [31:0]   wLLNFCReadIdleTimePeriod    ;
    wire   [31:0]   wDPLWCCmdIdleTimePeriod     ;
    wire   [31:0]   wDPLWCDataIdleTimePeriod    ;
    wire   [31:0]   wDPLRCCmdIdleTimePeriod     ;
    wire   [31:0]   wDPLRCDataIdleTimePeriod    ;
    wire   [31:0]   wNANDIdleTimePeriod         ;
    
    reg             rReadAck                    ;
    reg    [31:0]   rReadData                   ;
    
    assign oWriteAck        = 1'b1;
    assign oReadData        = rReadData;
    assign oReadAck         = rReadAck;
    
    always @ (posedge iClock)
        if (iReset)
            rReadAck <= 1'b0;
        else
            if (!rReadAck && iReadValid)
                rReadAck <= 1'b1;
            else
                rReadAck <= 1'b0;
    
    always @ (posedge iClock)
        if (iReset)
            rReadData <= 32'b0;
        else
            if (!rReadAck && iReadValid)
            begin
                case (iReadAddress[15:0])
                16'h0000:   rReadData <= wLLNFCCmdIdleTimePeriod    ;
                16'h0004:   rReadData <= wLLNFCCmdIdleTimeCounter   ;
                16'h0008:   rReadData <= wLLNFCWriteIdleTimePeriod  ;
                16'h000C:   rReadData <= wLLNFCWriteIdleTimeCounter ;
                16'h0010:   rReadData <= wLLNFCReadIdleTimePeriod   ;
                16'h0014:   rReadData <= wLLNFCReadIdleTimeCounter  ;
                16'h0018:   rReadData <= wDPLWCCmdIdleTimePeriod    ;
                16'h001C:   rReadData <= wDPLWCCmdIdleTimeCounter   ;
                16'h0020:   rReadData <= wDPLWCDataIdleTimePeriod   ;
                16'h0024:   rReadData <= wDPLWCDataIdleTimeCounter  ;
                16'h0028:   rReadData <= wDPLRCCmdIdleTimePeriod    ;
                16'h002C:   rReadData <= wDPLRCCmdIdleTimeCounter   ;
                16'h0030:   rReadData <= wDPLRCDataIdleTimePeriod   ;
                16'h0034:   rReadData <= wDPLRCDataIdleTimeCounter  ;
                16'h0038:   rReadData <= wNANDIdleTimePeriod        ;
                16'h003C:   rReadData <= wNANDIdleTimeCounter       ;
                default:    rReadData <= 32'b0;
                endcase
            end
    
    ExtTimeCounter
    LLNFCCmdIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0000)   ),
        .iProbe         (iLLNFCCmdReady                                                 ),
        .oCountValue    (wLLNFCCmdIdleTimeCounter                                       ),
        .oPeriodValue   (wLLNFCCmdIdleTimePeriod                                        )
    );
    
    ExtTimeCounter
    LLNFCWriteIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0008)   ),
        .iProbe         (!iLLNFCWriteHandshake                                          ),
        .oCountValue    (wLLNFCWriteIdleTimeCounter                                     ),
        .oPeriodValue   (wLLNFCWriteIdleTimePeriod                                      )
    );
    
    ExtTimeCounter
    LLNFCReadIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0010)   ),
        .iProbe         (!iLLNFCReadHandshake                                           ),
        .oCountValue    (wLLNFCReadIdleTimeCounter                                      ),
        .oPeriodValue   (wLLNFCReadIdleTimePeriod                                       )
    );
    
    ExtTimeCounter
    DPLWCCmdIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0018)   ),
        .iProbe         (iDPLWCCmdReady                                                 ),
        .oCountValue    (wDPLWCCmdIdleTimeCounter                                       ),
        .oPeriodValue   (wDPLWCCmdIdleTimePeriod                                        )
    );
    
    ExtTimeCounter
    DPLWCDataIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0020)   ),
        .iProbe         (!iDPLWCDataHandshake                                           ),
        .oCountValue    (wDPLWCDataIdleTimeCounter                                      ),
        .oPeriodValue   (wDPLWCDataIdleTimePeriod                                       )
    );
    
    ExtTimeCounter
    DPLRCCmdIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0028)   ),
        .iProbe         (iDPLRCCmdReady                                                 ),
        .oCountValue    (wDPLRCCmdIdleTimeCounter                                       ),
        .oPeriodValue   (wDPLRCCmdIdleTimePeriod                                        )
    );
    
    ExtTimeCounter
    DPLRCDataIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0030)   ),
        .iProbe         (!iDPLRCDataHandshake                                           ),
        .oCountValue    (wDPLRCDataIdleTimeCounter                                      ),
        .oPeriodValue   (wDPLRCDataIdleTimePeriod                                       )
    );
    
    ExtTimeCounter
    NANDIdleTimeCounter
    (
        .iClock         (iClock                                                         ),
        .iReset         (iReset                                                         ),
        .iEnabled       (1'b1                                                           ),
        .iPeriodSetting (iWriteData                                                     ),
        .iSettingValid  (iWriteValid && oWriteAck & (iWriteAddress[15:0] == 16'h0038)   ),
        .iProbe         (iNANDReadyBusy                                                 ),
        .oCountValue    (wNANDIdleTimeCounter                                           ),
        .oPeriodValue   (wNANDIdleTimePeriod                                            )
    );

endmodule
