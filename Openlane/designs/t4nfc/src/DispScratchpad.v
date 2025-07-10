//////////////////////////////////////////////////////////////////////////////////
// DispScratchpad for Cosmos OpenSSD
// Copyright (c) 2015 Hanyang University ENC Lab.
// Contributed by Kibin Park <kbpark@enc.hanyang.ac.kr>
//                Yong Ho Song <yhsong@enc.hanyang.ac.kr>
//
// This file is part of Cosmos OpenSSD.
//
// Cosmos OpenSSD is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3, or (at your option)
// any later version.
//
// Cosmos OpenSSD is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Cosmos OpenSSD; see the file COPYING.
// If not, see <http://www.gnu.org/licenses/>. 
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Company: ENC Lab. <http://enc.hanyang.ac.kr>
// Engineer: Kibin Park <kbpark@enc.hanyang.ac.kr>
// 
// Project Name: Cosmos OpenSSD
// Design Name: DispScratchpad
// Module Name: DispScratchpad
// File Name: DispScratchpad.v
//
// Version: v1.0.0
//
// Description: Scratchpad/register file for request dispatcher
//
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Revision History:
//
// * v1.0.0
//   - first draft
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module DispScratchpad
(
    iClock              ,
    iReset              ,
    iCPLPushBundleValid ,
    oCPLPushBundleReady ,
    iCPLWriteAddress    ,
    iCPLWriteData       ,
    iCPLWriteValid      ,
    oCPLWriteAck        ,
    iCPLReadAddress     ,
    oCPLReadData        ,
    iCPLReadValid       ,
    oCPLReadAck         ,
    oSPPopBundleValid   ,
    iSPPopBundleReady   ,
    iSPWriteAddress     ,
    iSPWriteData        ,
    iSPWriteValid       ,
    oSPWriteAck         ,
    iSPReadAddress      ,
    oSPReadData         ,
    iSPReadValid        ,
    oSPReadAck          ,
    oSPQueueCount
);
    localparam      nNumberOfRegisters      = 32;
    localparam      nDepthOfQueue           = 32;
    localparam      nlogNumberOfRegisters   = 5;

    input           iClock              ;
    input           iReset              ;
    
    input           iCPLPushBundleValid ;
    output          oCPLPushBundleReady ;
    
    input   [31:0]  iCPLWriteAddress    ;
    input   [31:0]  iCPLWriteData       ;
    input           iCPLWriteValid      ;
    output          oCPLWriteAck        ;
    
    input   [31:0]  iCPLReadAddress     ;
    output  [31:0]  oCPLReadData        ;
    input           iCPLReadValid       ;
    output          oCPLReadAck         ;
    
    output          oSPPopBundleValid   ;
    input           iSPPopBundleReady   ;
    
    input   [31:0]  iSPWriteAddress     ;
    input   [31:0]  iSPWriteData        ;
    input           iSPWriteValid       ;
    output          oSPWriteAck         ;
    
    input   [31:0]  iSPReadAddress      ;
    output  [31:0]  oSPReadData         ;
    input           iSPReadValid        ;
    output          oSPReadAck          ;
    
    output  [31:0]  oSPQueueCount       ;
    
    reg     [31:0]                                  rNumberOfItems      ;
    reg     [31 - $clog2(nNumberOfRegisters):0]     rPushDataCursor     ;
    reg     [31 - $clog2(nNumberOfRegisters):0]     rPopDataCursor      ;
    
    wire            wItemPushAccepted   ;
    wire            wItemPopAccepted    ;
    
    assign wItemPushAccepted    = iCPLPushBundleValid & oCPLPushBundleReady ;
    assign wItemPopAccepted     = oSPPopBundleValid & iSPPopBundleReady     ;
    
    always @ (posedge iClock)
        if (iReset)
            rNumberOfItems <= 32'b0;
        else
            case ({wItemPushAccepted, wItemPopAccepted})
            2'b01:
                rNumberOfItems <= rNumberOfItems - 1'b1;
            2'b10:
                rNumberOfItems <= rNumberOfItems + 1'b1;
            endcase

    assign oSPQueueCount = rNumberOfItems;
    
    assign oCPLPushBundleReady  = (rNumberOfItems < nDepthOfQueue - 1);
    assign oSPPopBundleValid    = (rNumberOfItems > 0);
    
    always @ (posedge iClock)
        if (iReset)
            rPushDataCursor <= {(32 - nlogNumberOfRegisters){1'b0}};
        else
            if (wItemPushAccepted)
                rPushDataCursor <= rPushDataCursor + 1'b1;
    
    always @ (posedge iClock)
        if (iReset)
            rPopDataCursor <= {(32 - nlogNumberOfRegisters){1'b0}};
        else
            if (wItemPopAccepted)
                rPopDataCursor <= rPopDataCursor + 1'b1;

    wire    [31:0]  wPushSideAddress        ;
    wire    [31:0]  wPushSideWriteData      ;
    wire    [31:0]  wPushSideReadData       ;
    wire            wPushSideEn             ;
    wire            wPushSideWEnable        ;
    
    wire    [31:0]  wTranslatedCPLWAddress  ;
    wire    [31:0]  wTranslatedCPLRAddress  ;
    
    assign wTranslatedCPLWAddress = {rPushDataCursor, iCPLWriteAddress[$clog2(nNumberOfRegisters) + 1:2]};
    assign wTranslatedCPLRAddress = {rPushDataCursor, iCPLReadAddress[$clog2(nNumberOfRegisters) + 1:2]};
    
    ComSPBRAMDPControl
    Inst_PushSideScratchpadInterface
    (
        .iClock         (iClock                 ),
        .iReset         (iReset                 ),
        .iWriteAddress  (wTranslatedCPLWAddress ),
        .iWriteData     (iCPLWriteData          ),
        .iWriteValid    (iCPLWriteValid         ),
        .oWriteAck      (oCPLWriteAck           ),
        .iReadAddress   (wTranslatedCPLRAddress ),
        .oReadData      (oCPLReadData           ),
        .iReadValid     (iCPLReadValid          ),
        .oReadAck       (oCPLReadAck            ),
        .oBRAMAddress   (wPushSideAddress       ),
        .oBRAMWriteData (wPushSideWriteData     ),
        .iBRAMReadData  (wPushSideReadData      ),
        .oBRAMEn        (wPushSideEn            ),
        .oBRAMWEnable   (wPushSideWEnable       )
    );

    wire    [31:0]  wPopSideAddress         ;
    wire    [31:0]  wPopSideWriteData       ;
    wire    [31:0]  wPopSideReadData        ;
    wire            wPopSideEn              ;
    wire            wPopSideWEnable         ;
    
    wire    [31:0]  wTranslatedSPWAddress   ;
    wire    [31:0]  wTranslatedSPRAddress   ;
    
    assign wTranslatedSPWAddress = {rPopDataCursor, iSPWriteAddress[$clog2(nNumberOfRegisters) - 1:0]};
    assign wTranslatedSPRAddress = {rPopDataCursor, iSPReadAddress[$clog2(nNumberOfRegisters) - 1:0]};
    
    ComSPBRAMDPControl
    Inst_PopSideScratchpadInterface
    (
        .iClock         (iClock                 ),
        .iReset         (iReset                 ),
        .iWriteAddress  (wTranslatedSPWAddress  ),
        .iWriteData     (iSPWriteData           ),
        .iWriteValid    (iSPWriteValid          ),
        .oWriteAck      (oSPWriteAck            ),
        .iReadAddress   (wTranslatedSPRAddress  ),
        .oReadData      (oSPReadData            ),
        .iReadValid     (iSPReadValid           ),
        .oReadAck       (oSPReadAck             ),
        .oBRAMAddress   (wPopSideAddress        ),
        .oBRAMWriteData (wPopSideWriteData      ),
        .iBRAMReadData  (wPopSideReadData       ),
        .oBRAMEn        (wPopSideEn             ),
        .oBRAMWEnable   (wPopSideWEnable        )
    );

    tdpram_32x1024 u_tdpram (
         .clk    (iClock),
        .rst_a  (1'b0),
        .rst_b  (1'b0),
        .en_a   (wPushSideEn),
        .en_b   (wPopSideEn),
        .wea    (wPushSideWEnable ),
        .web    (wPopSideWEnable),
        .addra  (wPushSideAddress[9:0]),
        .addrb  (wPopSideAddress[9:0]),
        .dina   (wPushSideWriteData),
        .dinb   (wPopSideWriteData),
        .douta  (wPushSideReadData),
        .doutb  (wPopSideReadData)
    );

   

endmodule

