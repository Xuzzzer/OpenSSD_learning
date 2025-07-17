

`timescale 1ns / 1ps

module BCHEncoderX
#
(
    parameter Multi = 2
)
(
    iClock          ,
    iReset          ,
    iEnable         ,
    iData           ,
    iDataValid      ,
    oDataReady      ,
    oDataLast       ,
    oParityData     ,
    oParityValid    ,
    oParityLast     ,
    iParityReady    
);
    input                       iClock          ;
    input                       iReset          ;
    input                       iEnable         ;
    input   [8*Multi - 1:0]     iData           ;
    input                       iDataValid      ;
    output                      oDataReady      ;
    output                      oDataLast       ;
    output  [8*Multi - 1:0]     oParityData     ;
    output                      oParityValid    ;
    output                      oParityLast     ;
    input                       iParityReady    ;
    
    wire    [Multi - 1:0]       wDataReady      ;
    wire    [Multi - 1:0]       wDataLast       ;
    wire    [Multi - 1:0]       wParityStrobe   ;
    wire    [Multi - 1:0]       wParityLast     ;
    
    genvar c;
    
    generate
        for (c = 0; c < Multi; c = c + 1)
        begin
            d_BCH_encoder_top
            BCHPEncoder
            (
                .i_clk                  (iClock                             ),
                .i_nRESET               (!iReset                            ),
                .i_exe_encoding         (iEnable                            ),
                .i_message_valid        (iDataValid                         ),
                .i_message              (iData[(c + 1) * 8 - 1:c * 8]       ),
                .o_message_ready        (wDataReady[c]                      ),
                .i_parity_ready         (iParityReady                       ),
                .o_encoding_start       (                                   ),
                .o_last_m_block_rcvd    (wDataLast[c]                       ),
                .o_encoding_cmplt       (                                   ),
                .o_parity_valid         (wParityStrobe[c]                   ),
                .o_parity_out_start     (                                   ),
                .o_parity_out_cmplt     (wParityLast[c]                     ),
                .o_parity_out           (oParityData[(c + 1) * 8 - 1:c * 8] )
            );
        end
    endgenerate
    
    assign oDataLast    = wDataLast[0]      ;
    assign oParityValid = wParityStrobe[0]  ;
    assign oParityLast  = wParityLast[0]    ;
    assign oDataReady   = wDataReady[0]     ;
    
endmodule
