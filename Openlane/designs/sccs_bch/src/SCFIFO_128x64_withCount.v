//////////////////////////////////////////////////////////////////////////////////
// SCFIFO_64x64_withCount for Cosmos OpenSSD
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
// Design Name: Single clock FIFO (128 width, 64 depth) wrapper
// Module Name: SCFIFO_128x64_withCount
// File Name: SCFIFO_128x64_withCount.v
//
// Version: v1.0.0
//
// Description: Standard FIFO, 1 cycle data out latency
//
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Revision History:
//
// * v1.0.0
//   - first draft 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module SCFIFO_128x64_withCount
(
    input           iClock          ,
    input           iReset          ,

    input   [127:0] iPushData       ,
    input           iPushEnable     ,
    output          oIsFull         ,
    
    output  [127:0] oPopData        ,
    input           iPopEnable      ,
    output          oIsEmpty        ,
    
    output  [5:0]   oDataCount
);

  wire [6:0] data_count_internal;

    FIFO_sync #(
        .DATA_WIDTH(128),
        .FIFO_DEPTH(64)
    ) u2_fifo_sync (
        .clk        (iClock),
        .rst        (iReset),
        .wr_en      (iPushEnable),
        .wr_data    (iPushData),
        .wr_full    (oIsFull),
        .rd_en      (iPopEnable),
        .rd_data    (oPopData),
        .rd_empty   (oIsEmpty),
        .data_count (data_count_internal)
    );
assign oDataCount = data_count_internal[5:0];

endmodule
