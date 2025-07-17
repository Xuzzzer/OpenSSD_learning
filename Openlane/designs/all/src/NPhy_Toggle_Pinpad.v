

`timescale 1ns / 1ps

module NPhy_Toggle_Pinpad
#
(
    parameter NumberOfWays    =   4
)
(
    iDQSOutEnable   ,
    iDQSToNAND      ,
    oDQSFromNAND    ,
    iDQOutEnable    ,
    iDQToNAND       ,
    oDQFromNAND     ,
    iCEToNAND       ,
    iWEToNAND       ,
    iREToNAND       ,
    iALEToNAND      ,
    iCLEToNAND      ,
    oRBFromNAND     ,
    iWPToNAND       ,
    IO_NAND_DQS_P   ,
    IO_NAND_DQS_N   ,
    IO_NAND_DQ      ,
    O_NAND_CE       ,
    O_NAND_WE       ,
    O_NAND_RE_P     ,
    O_NAND_RE_N     ,
    O_NAND_ALE      ,
    O_NAND_CLE      ,
    I_NAND_RB       ,
    O_NAND_WP 
);
    // Direction Select: 0-read from NAND, 1-write to NAND
    input                           iDQSOutEnable   ;
    input                           iDQSToNAND      ;
    output                          oDQSFromNAND    ;
    input   [7:0]                   iDQOutEnable    ;
    input   [7:0]                   iDQToNAND       ;
    output  [7:0]                   oDQFromNAND     ;
    input   [NumberOfWays - 1:0]    iCEToNAND       ;
    input                           iWEToNAND       ;
    input                           iREToNAND       ;
    input                           iALEToNAND      ;
    input                           iCLEToNAND      ;
    output  [NumberOfWays - 1:0]    oRBFromNAND     ;
    input                           iWPToNAND       ;
    inout                           IO_NAND_DQS_P   ; // Differential: Positive
    inout                           IO_NAND_DQS_N   ; // Differential: Negative
    inout   [7:0]                   IO_NAND_DQ      ;
    output  [NumberOfWays - 1:0]    O_NAND_CE       ;
    output                          O_NAND_WE       ;
    output                          O_NAND_RE_P     ; // Differential: Positive
    output                          O_NAND_RE_N     ; // Differential: Negative
    output                          O_NAND_ALE      ;
    output                          O_NAND_CLE      ;
    input   [NumberOfWays - 1:0]    I_NAND_RB       ;
    output                          O_NAND_WP       ; 
    
    genvar  c, d, e;

    // DQS Pad: Differential signal
    /*
    IBUF
    Inst_DQSIBUF
    (
        .I(IO_NAND_DQS      ),
        .O(oDQSFromNAND     )
    );
    OBUFT
    Inst_DQSOBUF
    (
        .I(iDQSToNAND       ),
        .O(IO_NAND_DQS      ),
        .T(iDQSOutEnable    )
    );
    */
    assign IO_NAND_DQS_P = (iDQSOutEnable == 1'b0) ? iDQSToNAND : 1'bz;
    assign IO_NAND_DQS_N = (iDQSOutEnable == 1'b0) ? ~iDQSToNAND : 1'bz;

    assign oDQSFromNAND = IO_NAND_DQS_P; // 或做差分恢复逻辑，如 IO_NAND_DQS_P - IO_NAND_DQS_N

    
    
    // DQ Pad
    generate
    for (c = 0; c < 8; c = c + 1)
    begin: DQBits
        // 输出控制：T=0时驱动，T=1时高阻
        assign IO_NAND_DQ[c] = (iDQOutEnable[c] == 1'b0) ? iDQToNAND[c] : 1'bz;

    // 输入读取
        assign oDQFromNAND[c] = IO_NAND_DQ[c];
       
    end
    endgenerate
    /*
    // CE Pad
    assign O_NAND_CE = iCEToNAND;
    
    // WE Pad
    assign O_NAND_WE = iWEToNAND;
    
    // RE Pad
    //assign O_NAND_RE = iREToNAND;
    
    // ALE Pad
    assign O_NAND_ALE = iALEToNAND;
    
    // CLE Pad
    assign O_NAND_CLE = iCLEToNAND;
    
    // RB Pad
    assign oRBFromNAND = I_NAND_RB;
    
    // WP Pad
    assign O_NAND_WP = iWPToNAND;
    */
    // CE Pad
    generate
    for (d = 0; d < NumberOfWays; d = d + 1)
    begin: CEs
      assign O_NAND_CE[d] = iCEToNAND[d];   
    end
    endgenerate
    
    
    // WE Pad
   assign O_NAND_WE=iWEToNAND;
    
    // RE Pad: Differential signal
    /*
    OBUF
    Inst_REOBUF
    (
        .I(iREToNAND  ),
        .O(O_NAND_RE  )
    );
    */
   
    assign O_NAND_RE_P = iREToNAND;
    assign O_NAND_RE_N = ~iREToNAND;

    
    // ALE Pad
    
    assign O_NAND_ALE=iALEToNAND;
    
    // CLE Pad
  
    assign O_NAND_CLE=iCLEToNAND;
    
    // RB Pad
    generate
    for (e = 0; e < NumberOfWays; e = e + 1)
    begin: RBs
       
         assign oRBFromNAND[e]=I_NAND_RB[e];
    end
    endgenerate
    
    // WP Pad
    
     assign O_NAND_WP=iWPToNAND;

endmodule

