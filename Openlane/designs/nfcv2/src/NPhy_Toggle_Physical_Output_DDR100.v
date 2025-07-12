//////////////////////////////////////////////////////////////////////////////////
// NPhy_Toggle_Physical_Output_DDR100 for Cosmos OpenSSD
// Copyright (c) 2015 Hanyang University ENC Lab.
// Contributed by Ilyong Jung <iyjung@enc.hanyang.ac.kr>
//                Kibin Park <kbpark@enc.hanyang.ac.kr>
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
// Engineer: Ilyong Jung <iyjung@enc.hanyang.ac.kr>, Kibin Park <kbpark@enc.hanyang.ac.kr>
// 
// Project Name: Cosmos OpenSSD
// Design Name: NPhy_Toggle_Physical_Output_DDR100
// Module Name: NPhy_Toggle_Physical_Output_DDR100
// File Name: NPhy_Toggle_Physical_Output_DDR100.v
//
// Version: v1.0.0
//
// Description: NFC phy output module
//
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Revision History:
//
// * v1.0.0
//   - first draft
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module NPhy_Toggle_Physical_Output_DDR100
#
(
    parameter NumberOfWays    =   4
)
(
    iSystemClock            ,
    iOutputDrivingClock     ,
    iOutputStrobeClock      ,
    iModuleReset            ,
    iDQSOutEnable           ,
    iDQOutEnable            ,
    iPO_DQStrobe            ,
    iPO_DQ                  ,
    iPO_ChipEnable          ,
    iPO_ReadEnable          ,
    iPO_WriteEnable         ,
    iPO_AddressLatchEnable  ,
    iPO_CommandLatchEnable  ,
    oDQSOutEnableToPinpad   ,
    oDQOutEnableToPinpad    ,
    oDQSToNAND              ,
    oDQToNAND               ,
    oCEToNAND               ,
    oWEToNAND               ,
    oREToNAND               ,
    oALEToNAND              ,
    oCLEToNAND
);
    // Data Width (DQ): 8 bit
    
    // 4:1 DDR Serialization with OSERDESE2
    // OSERDESE2, 4:1 DDR Serialization
    //            CLKDIV: SDR 100MHz CLK: SDR 200MHz OQ: DDR 200MHz
    //            output resolution: 2.50 ns
    input                           iSystemClock            ;
    input                           iOutputDrivingClock     ;
    input                           iOutputStrobeClock      ;
    input                           iModuleReset            ;
    input                           iDQSOutEnable           ;
    input                           iDQOutEnable            ;
    input   [7:0]                   iPO_DQStrobe            ; // DQS, full res.
    input   [31:0]                  iPO_DQ                  ; // DQ, half res., 2 bit * 8 bit data width = 16 bit interface width
    input   [2*NumberOfWays - 1:0]  iPO_ChipEnable          ; // CE, quater res., 1 bit * 4 way = 4 bit interface width
    input   [3:0]                   iPO_ReadEnable          ; // RE, half res.
    input   [3:0]                   iPO_WriteEnable         ; // WE, half res.
    input   [3:0]                   iPO_AddressLatchEnable  ; // ALE, half res.
    input   [3:0]                   iPO_CommandLatchEnable  ; // CLE, half res.
    output                          oDQSOutEnableToPinpad   ;
    output  [7:0]                   oDQOutEnableToPinpad    ;
    output                          oDQSToNAND              ;
    output  [7:0]                   oDQToNAND               ;
    output  [NumberOfWays - 1:0]    oCEToNAND               ;
    output                          oWEToNAND               ;
    output                          oREToNAND               ;
    output                          oALEToNAND              ;
    output                          oCLEToNAND              ;
    
    
    reg     rDQSOutEnable_buffer;
    reg     rDQSOut_IOBUF_T;
    reg     rDQOutEnable_buffer;
    reg     rDQOut_IOBUF_T;
    
    always @ (posedge iSystemClock) begin
        if (iModuleReset) begin
            rDQSOutEnable_buffer <= 0;
            rDQSOut_IOBUF_T      <= 1;
            rDQOutEnable_buffer  <= 0;
            rDQOut_IOBUF_T       <= 1;
        end else begin
            rDQSOutEnable_buffer <= iDQSOutEnable;
            rDQSOut_IOBUF_T      <= ~rDQSOutEnable_buffer;
            rDQOutEnable_buffer  <= iDQOutEnable;
            rDQOut_IOBUF_T       <= ~rDQOutEnable_buffer;
        end       
    end
    
    genvar c, d;

    ASIC_SERDES #(
                .DATA_WIDTH(8)
    ) Inst_DQSOSERDES (
                .iSystemClock(iSystemClock),
                .iOutputDrivingClock(iOutputStrobeClock),
                .iReset(iModuleReset),
                .iDataParallel(iPO_DQStrobe[7:0]),
                .iTriStateEnable     (rDQSOut_IOBUF_T),
                .oSerialOut(oDQSToNAND),
                .oTriStateOut        (oDQSOutEnableToPinpad)

    );    

    generate
    for (c = 0; c < 8; c = c + 1)
        begin : DQOSERDESBits
            ASIC_SERDES #(
                .DATA_WIDTH(8) // 因为输入是8位
            ) Inst_DQOSERDES (
                .iSystemClock        (iSystemClock),
                .iOutputDrivingClock (iOutputDrivingClock),
                .iReset              (iModuleReset),

                .iDataParallel       ({
                                        iPO_DQ[24 + c],
                                        iPO_DQ[24 + c],
                                        iPO_DQ[16 + c],
                                        iPO_DQ[16 + c],
                                        iPO_DQ[ 8 + c],
                                        iPO_DQ[ 8 + c],
                                        iPO_DQ[ 0 + c],
                                        iPO_DQ[ 0 + c]
                                      }),
                .iTriStateEnable     (rDQOut_IOBUF_T),

                .oSerialOut          (oDQToNAND[c]),
                .oTriStateOut        (oDQOutEnableToPinpad[c])
            );
        end
    endgenerate
    
    generate
    for (d = 0; d < NumberOfWays; d = d + 1)
        begin : CEOSERDESBits
            ASIC_SERDES #(
                .DATA_WIDTH(8) // 因为输入是8位
            ) Inst_CEOSERDES (
                .iSystemClock        (iSystemClock),
                .iOutputDrivingClock (iOutputDrivingClock),
                .iReset              (iModuleReset),

                .iDataParallel       (~{iPO_ChipEnable[NumberOfWays + d],
                            iPO_ChipEnable[NumberOfWays + d],
                            iPO_ChipEnable[NumberOfWays + d],
                            iPO_ChipEnable[NumberOfWays + d],
                            iPO_ChipEnable[0 + d],
                            iPO_ChipEnable[0 + d],
                            iPO_ChipEnable[0 + d],
                          iPO_ChipEnable[0 + d]}),
                .iTriStateEnable     (1'b0),

                .oSerialOut          (oCEToNAND[d]),
                .oTriStateOut        ()
            );
        end
    endgenerate


    ASIC_SERDES #(
                .DATA_WIDTH(8)
    ) Inst_REOSERDES (
                .iSystemClock(iSystemClock),
                .iOutputDrivingClock(iOutputDrivingClock),
                .iReset(iModuleReset),
                .iDataParallel({iPO_ReadEnable[3],
                      iPO_ReadEnable[3],
                      iPO_ReadEnable[2],
                      iPO_ReadEnable[2],
                      iPO_ReadEnable[1],
                      iPO_ReadEnable[1],
                      iPO_ReadEnable[0],
                      iPO_ReadEnable[0]}),
                .iTriStateEnable     (1'b0),
                .oSerialOut(oREToNAND),
                .oTriStateOut        ()
    );

    
    ASIC_SERDES #(
                .DATA_WIDTH(8)
    ) Inst_WEOSERDES (
                .iSystemClock(iSystemClock),
                .iOutputDrivingClock(iOutputDrivingClock),
                .iReset(iModuleReset),
                .iDataParallel(~{iPO_WriteEnable[3],
                      iPO_WriteEnable[3],
                      iPO_WriteEnable[2],
                      iPO_WriteEnable[2],
                      iPO_WriteEnable[1],
                      iPO_WriteEnable[1],
                      iPO_WriteEnable[0],
                      iPO_WriteEnable[0]} ),
                .iTriStateEnable     (1'b0),
                .oSerialOut(oWEToNAND),
                .oTriStateOut        ()
    );     
               

    ASIC_SERDES #(
                .DATA_WIDTH(8)
    ) Inst_ALEOSERDES1 (
                .iSystemClock(iSystemClock),
                .iOutputDrivingClock(iOutputDrivingClock),
                .iReset(iModuleReset),
                .iDataParallel({iPO_AddressLatchEnable[3],
                      iPO_AddressLatchEnable[3],
                      iPO_AddressLatchEnable[2],
                      iPO_AddressLatchEnable[2],
                      iPO_AddressLatchEnable[1],
                      iPO_AddressLatchEnable[1],
                      iPO_AddressLatchEnable[0],
                      iPO_AddressLatchEnable[0]} ),
                .iTriStateEnable     (1'b0),
                .oSerialOut(oALEToNAND),
                .oTriStateOut        ()
    );     
       
    
    ASIC_SERDES #(
                .DATA_WIDTH(8)
    ) Inst_ALEOSERDES2 (
                .iSystemClock(iSystemClock),
                .iOutputDrivingClock(iOutputDrivingClock),
                .iReset(iModuleReset),
                .iDataParallel({iPO_CommandLatchEnable[3],
                      iPO_CommandLatchEnable[3],
                      iPO_CommandLatchEnable[2],
                      iPO_CommandLatchEnable[2],
                      iPO_CommandLatchEnable[1],
                      iPO_CommandLatchEnable[1],
                      iPO_CommandLatchEnable[0],
                      iPO_CommandLatchEnable[0]} ),
                .iTriStateEnable     (1'b0),
                .oSerialOut(oCLEToNAND),
                .oTriStateOut        ()
    );     
endmodule

module ASIC_SERDES #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  iSystemClock,        // 采样并行数据时钟（慢）
    input  wire                  iOutputDrivingClock, // 串行输出时钟（快）
    input  wire                  iReset,
    input  wire [DATA_WIDTH-1:0] iDataParallel,       // 并行输入
    input  wire                  iTriStateEnable,     // 输出使能，等效于 .T
    output wire                  oSerialOut,          // 串行输出
    output wire                  oTriStateOut         // 控制外部 IOBUF 三态
);

    reg [DATA_WIDTH-1:0] shift_reg;
    reg [$clog2(DATA_WIDTH)-1:0] bit_cnt;

    // 采样并行数据
    always @(posedge iSystemClock or posedge iReset) begin
        if (iReset)
            shift_reg <= 0;
        else
            shift_reg <= iDataParallel; // 加载数据
    end

    // 串行输出控制
    always @(posedge iOutputDrivingClock or posedge iReset) begin
        if (iReset) begin
            bit_cnt <= 0;
        end else begin
            shift_reg <= {1'b0, shift_reg[DATA_WIDTH-1:1]}; // 右移，LSB优先
            bit_cnt <= (bit_cnt == DATA_WIDTH-1) ? 0 : bit_cnt + 1;
        end
    end

    assign oSerialOut = shift_reg[0]; // LSB 先输出
    assign oTriStateOut = iTriStateEnable;

endmodule
