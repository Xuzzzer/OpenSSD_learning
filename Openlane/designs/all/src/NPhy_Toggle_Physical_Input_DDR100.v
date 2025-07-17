

`timescale 1ns / 1ps

module NPhy_Toggle_Physical_Input_DDR100
#
(
    parameter IDelayValue           = 0,
    parameter DQIDelayValue         = 0,
    parameter InputClockBufferType  = 0,
    parameter BufferType            = 0,
    parameter IDelayCtrlInst        = 1,
    parameter DQIDelayInst          = 0
)
(
    iSystemClock            ,
    iDelayRefClock          ,
    iModuleReset            ,
    iBufferReset            ,
    iPI_Buff_RE             ,
    iPI_Buff_WE             ,
    iPI_Buff_OutSel         ,
    oPI_Buff_Empty          ,
    oPI_DQ                  ,
    oPI_ValidFlag           ,
    iPI_DelayTapLoad        ,
    iPI_DelayTap            ,
    oPI_DelayReady          ,
    iDQSFromNAND            ,
    iDQFromNAND             ,
    iDQSIDelayTap           ,
    iDQSIDelayTapLoad       ,
    iDQ0IDelayTap           ,
    iDQ0IDelayTapLoad       ,
    iDQ1IDelayTap           ,
    iDQ1IDelayTapLoad       ,
    iDQ2IDelayTap           ,
    iDQ2IDelayTapLoad       ,
    iDQ3IDelayTap           ,
    iDQ3IDelayTapLoad       ,
    iDQ4IDelayTap           ,
    iDQ4IDelayTapLoad       ,
    iDQ5IDelayTap           ,
    iDQ5IDelayTapLoad       ,
    iDQ6IDelayTap           ,
    iDQ6IDelayTapLoad       ,
    iDQ7IDelayTap           ,
    iDQ7IDelayTapLoad       ,
    ext_fifo_dout           ,
    ext_fifo_empty          ,
    ext_fifo_full           ,
    ext_fifo_din            ,
    ext_fifo_rd_clk         ,
    ext_fifo_rd_en          ,
    ext_fifo_wr_clk         ,
    ext_fifo_wr_en          ,
    ext_fifo_rst            
);
    input           iSystemClock        ;
    input           iDelayRefClock      ;
    input           iModuleReset        ;
    input           iBufferReset        ;
    input           iPI_Buff_RE         ;
    input           iPI_Buff_WE         ;
    input   [2:0]   iPI_Buff_OutSel     ; // 000: IN_FIFO, 100: Nm4+Nm3, 101: Nm3+Nm2, 110: Nm2+Nm1, 111: Nm1+ZERO
    output          oPI_Buff_Empty      ;
    output  [31:0]  oPI_DQ              ; // DQ, 4 bit * 8 bit data width = 32 bit interface width
    output  [3:0]   oPI_ValidFlag       ; // { Nm1, Nm2, Nm3, Nm4 }
    input           iPI_DelayTapLoad    ;
    input   [4:0]   iPI_DelayTap        ;
    output          oPI_DelayReady      ;
    input           iDQSFromNAND        ;
    input   [7:0]   iDQFromNAND         ;
    
    input   [8:0]   iDQSIDelayTap       ;
    input   [1:0]   iDQSIDelayTapLoad   ;
    input   [8:0]   iDQ0IDelayTap       ;
    input   [1:0]   iDQ0IDelayTapLoad   ;
    input   [8:0]   iDQ1IDelayTap       ;
    input   [1:0]   iDQ1IDelayTapLoad   ;
    input   [8:0]   iDQ2IDelayTap       ;
    input   [1:0]   iDQ2IDelayTapLoad   ;
    input   [8:0]   iDQ3IDelayTap       ;
    input   [1:0]   iDQ3IDelayTapLoad   ;
    input   [8:0]   iDQ4IDelayTap       ;
    input   [1:0]   iDQ4IDelayTapLoad   ;
    input   [8:0]   iDQ5IDelayTap       ;
    input   [1:0]   iDQ5IDelayTapLoad   ;
    input   [8:0]   iDQ6IDelayTap       ;
    input   [1:0]   iDQ6IDelayTapLoad   ;
    input   [8:0]   iDQ7IDelayTap       ;
    input   [1:0]   iDQ7IDelayTapLoad   ;

    input   [15:0]  ext_fifo_dout       ;
    input           ext_fifo_empty      ;
    input           ext_fifo_full       ;

    output  [15:0]  ext_fifo_din        ;
    output          ext_fifo_rd_clk     ;
    output          ext_fifo_rd_en      ;
    output          ext_fifo_wr_clk     ;
    output          ext_fifo_wr_en      ;
    output          ext_fifo_rst        ;
 
    // Input Capture Clock -> delayed DQS signal with IDELAYE2
    // IDELAYE2, REFCLK: SDR 200MHz
    //           Tap resolution: 1/(32*2*200MHz) = 78.125 ps
    //           Initial Tap: 28, 78.125 ps * 28 = 2187.5 ps
    
    // Data Width (DQ): 8 bit
    
    // 1:2 DDR Deserializtion with IDDR
    // IDDR, 1:2 Desirialization
    //       C: delayed DDR 100MHz
    // IN_FIFO
    //          WRCLK: delayed SDR 100MHz RDCLK: SDR 100MHz ARRAY_MODE_4_X_4
    
    // IDELAYCTRL, Minimum Reset Pulse Width: 52 ns
    //             Reset to Ready: 3.22 us
    // IN_FIFO, Maximum Frequency (RDCLK, WRCLK): 533.05 MHz, 1.0 V, -3
    
    // Internal Wires/Regs
    
    wire    [8 * 9 - 1 :0]  wDQIDelayTaps       ;
    wire    [8 - 1 :0]      wDQIDelayTapLoads   ;
    wire    [8 - 1 :0]      wDQIDelayTapVTC     ;
  

    
    assign wDQIDelayTaps = {
        iDQ0IDelayTap,
        iDQ1IDelayTap,
        iDQ2IDelayTap,
        iDQ3IDelayTap,
        iDQ4IDelayTap,
        iDQ5IDelayTap,
        iDQ6IDelayTap,
        iDQ7IDelayTap
    };
    
    assign wDQIDelayTapLoads = {
        iDQ0IDelayTapLoad[0],
        iDQ1IDelayTapLoad[0],
        iDQ2IDelayTapLoad[0],
        iDQ3IDelayTapLoad[0],
        iDQ4IDelayTapLoad[0],
        iDQ5IDelayTapLoad[0],
        iDQ6IDelayTapLoad[0],
        iDQ7IDelayTapLoad[0]
    };

    assign wDQIDelayTapVTC = {
        ~iDQ0IDelayTapLoad[1],
        ~iDQ1IDelayTapLoad[1],
        ~iDQ2IDelayTapLoad[1],
        ~iDQ3IDelayTapLoad[1],
        ~iDQ4IDelayTapLoad[1],
        ~iDQ5IDelayTapLoad[1],
        ~iDQ6IDelayTapLoad[1],
        ~iDQ7IDelayTapLoad[1]
    };
    
    reg     rBufferReset        ;
    
    wire    wDelayedDQS         ;
    wire    wDelayedDQSClock    ;
    wire    wtestFULL;
    
    generate
        if (IDelayCtrlInst == 1)
        begin
           assign oPI_DelayReady = 1'b1;
        end
        else
        begin
            assign oPI_DelayReady = 1'b1;
        end
    endgenerate

    generate
        // InputClockBufferType
        // 0: IBUFG (default)
        // 1: IBUFG + BUFG
        // 2: BUFR
        if (InputClockBufferType == 0)
        begin
            assign wDelayedDQS = iDQSFromNAND;  
            assign wDelayedDQSClock = wDelayedDQS;  
        end
        else if (InputClockBufferType == 1)
        begin
            assign wDelayedDQS = iDQSFromNAND;  
            wire wIBUFGOut;
           
            assign wIBUFGOut = wDelayedDQS;  
            assign wDelayedDQSClock = wIBUFGOut;   
        end
        else if (InputClockBufferType == 3)
        begin
            assign wDelayedDQS = iDQSFromNAND;
            assign wDelayedDQSClock = wDelayedDQS;    
        end
        else if (InputClockBufferType == 2)
        begin
            assign wDelayedDQS = iDQSFromNAND;
            assign wDelayedDQSClock = wDelayedDQS;       
        end
        else
        begin
        end
    endgenerate
    
    genvar c;
    
    wire    [7:0]   wDQAtRising     ;
    wire    [7:0]   wDQAtFalling    ;
    
    generate
    for (c = 0; c < 8; c = c + 1)
    begin: DQIDDRBits
        if (DQIDelayInst == 0)
        begin
            always @(posedge wDelayedDQSClock) begin
                 wDQAtRising[c] <= iDQFromNAND[c];
            end
            always @(negedge wDelayedDQSClock) begin
                 wDQAtFalling[c] <= iDQFromNAND[c];
            end
        end
        else
        begin
            wire wDelayedDQ;
            assign wDelayedDQ = iDQFromNAND[c];

            always @(posedge wDelayedDQSClock) begin
                wDQAtRising[c] <= wDelayedDQ;
            end

            always @(negedge wDelayedDQSClock) begin
                wDQAtFalling[c] <= wDelayedDQ;
            end
        end
    end
    endgenerate
    
    wire    [7:0]   wDQ0  ;
    wire    [7:0]   wDQ1  ;
    wire    [7:0]   wDQ2  ;
    wire    [7:0]   wDQ3  ;
    
    wire wBufferResetSynced;
    
    always @ (*)
        rBufferReset = wBufferResetSynced;
    
    async_reset_sync #(
      .SYNC_STAGES(2)
    ) u_async_reset_sync (
       .clk      (wDelayedDQSClock),
      .arst_in  (iBufferReset),
      .arst_out (wBufferResetSynced)
    );

    
    (* ASYNC_REG = "TRUE" *)
    reg rIN_FIFO_WE_Latch;

    (* ASYNC_REG = "TRUE" *)
    reg rIN_FIFO_WE_Latch_Feedback;
    
    /*
    wire wIN_FIFO_WE_Latch;
    wire wiPI_Buff_WE_Sync;
    xpm_cdc_single
    #
    (
        .DEST_SYNC_FF   (2                  ),
        .INIT_SYNC_FF   (0                  ),
        .SIM_ASSERT_CHK(0),
        .SRC_INPUT_REG(0)
    )
    xpm_cdc_single_inst
    (
        .dest_out       (wiPI_Buff_WE_Sync  ),
        .dest_clk       (wDelayedDQSClock   ),
        .src_clk        (iSystemClock       ),
        .src_in         (iPI_Buff_WE        )
    );*/
    
    always @ (posedge wDelayedDQSClock or posedge rBufferReset) begin
        if (rBufferReset) begin
            rIN_FIFO_WE_Latch <= 0;
        end else begin
            rIN_FIFO_WE_Latch <= iPI_Buff_WE;
        end
    end

    always @ (posedge iSystemClock) begin
        if (iBufferReset) begin
            rIN_FIFO_WE_Latch_Feedback <= 0;
        end else begin
            rIN_FIFO_WE_Latch_Feedback <= rIN_FIFO_WE_Latch;
        end
    end
    
    generate
        if (BufferType == 0)
        begin
           
            assign ext_fifo_din      = { wDQAtRising[3:0], wDQAtRising[7:4], wDQAtFalling[3:0], wDQAtFalling[7:4] };
            assign { wDQ0[3:0], wDQ0[7:4], wDQ1[3:0], wDQ1[7:4] } = ext_fifo_dout;
            assign ext_fifo_rd_clk   = iSystemClock;
            assign ext_fifo_rd_en    = iPI_Buff_RE && !oPI_Buff_Empty;
            assign oPI_Buff_Empty    = ext_fifo_empty;
            assign ext_fifo_wr_clk   = wDelayedDQSClock;
            assign ext_fifo_wr_en    = rIN_FIFO_WE_Latch;
            assign wtestFULL         = ext_fifo_full;
            assign ext_fifo_rst      = rBufferReset;

            
            assign wDQ2 = 8'b0;
            assign wDQ3 = 8'b0;
        end
        else if (BufferType == 1)
        begin

            fifo_async #(
                .DATASIZE(16),
                .ADDRSIZE(4)
            ) u_DQINFIFO16x16 (
                .rdata      ({wDQ0[3:0], wDQ0[7:4], wDQ1[3:0], wDQ1[7:4]}), // 16位
                .wfull      (wtestFULL),
                .rempty     (oPI_Buff_Empty),
                
                .wptr_gray  (),
                .rptr_gray  (),
                .r2wptr     (),
                .w2rptr     (),
                .wdata      ({wDQAtRising[3:0], wDQAtRising[7:4], wDQAtFalling[3:0], wDQAtFalling[7:4]}),
                .wclk       (wDelayedDQSClock),
                .wrst_n     (~iBufferReset), // FIFO是低有效复位
                .w_en       (rIN_FIFO_WE_Latch),
                .rclk       (iSystemClock),
                .rrst_n     (~iBufferReset), // 低有效
                .r_en       (iPI_Buff_RE)
            );
            
            assign wDQ2 = 8'b0;
            assign wDQ3 = 8'b0;
        end
    endgenerate
    
    (* dont_touch = "true" *)
    reg [15:0]  rNm2_Buffer     ;
    (* dont_touch = "true" *)
    reg [15:0]  rNm3_Buffer     ;
    (* dont_touch = "true" *)
    reg [15:0]  rNm4_Buffer     ;
    
    (* dont_touch = "true" *)
    wire        wNm1_ValidFlag  ;
    (* dont_touch = "true" *)
    reg         rNm2_ValidFlag  ;
    (* dont_touch = "true" *)
    reg         rNm3_ValidFlag  ;
    (* dont_touch = "true" *)
    reg         rNm4_ValidFlag  ;
    
    (* dont_touch = "true" *)
    reg [31:0]  rPI_DQ          ;
    
    assign wNm1_ValidFlag = rIN_FIFO_WE_Latch;
    
    always @ (posedge wDelayedDQSClock or posedge rBufferReset) begin
        if (rBufferReset) begin
            rNm2_Buffer[15:0] <= 0;
            rNm3_Buffer[15:0] <= 0;
            rNm4_Buffer[15:0] <= 0;
            
            rNm2_ValidFlag <= 0;
            rNm3_ValidFlag <= 0;
            rNm4_ValidFlag <= 0;
        end else begin
            rNm2_Buffer[15:0] <= { wDQAtFalling[7:0], wDQAtRising[7:0] };
            rNm3_Buffer[15:0] <= rNm2_Buffer[15:0];
            rNm4_Buffer[15:0] <= rNm3_Buffer[15:0];
            
            rNm2_ValidFlag <= wNm1_ValidFlag;
            rNm3_ValidFlag <= rNm2_ValidFlag;
            rNm4_ValidFlag <= rNm3_ValidFlag;
        end
    end
    
    // 000: IN_FIFO, 001 ~ 011: reserved
    // 100: Nm4+Nm3, 101: Nm3+Nm2, 110: Nm2+Nm1, 111: Nm1+ZERO
    
    always @ (*) begin
        case ( iPI_Buff_OutSel[2:0] )
            3'b000: begin // 000: IN_FIFO
                rPI_DQ[ 7: 0] = wDQ0[7:0];
                rPI_DQ[15: 8] = wDQ1[7:0];
                rPI_DQ[23:16] = wDQ2[7:0];
                rPI_DQ[31:24] = wDQ3[7:0];
            end
            3'b100: begin // 100: Nm4+Nm3
                rPI_DQ[ 7: 0] = rNm4_Buffer[ 7: 0];
                rPI_DQ[15: 8] = rNm4_Buffer[15: 8];
                rPI_DQ[23:16] = rNm3_Buffer[ 7: 0];
                rPI_DQ[31:24] = rNm3_Buffer[15: 8];
            end
            3'b101: begin // 101: Nm3+Nm2
                rPI_DQ[ 7: 0] = rNm3_Buffer[ 7: 0];
                rPI_DQ[15: 8] = rNm3_Buffer[15: 8];
                rPI_DQ[23:16] = rNm2_Buffer[ 7: 0];
                rPI_DQ[31:24] = rNm2_Buffer[15: 8];
            end
            3'b110: begin // 110: Nm2+Nm1
                rPI_DQ[ 7: 0] = rNm2_Buffer[ 7: 0];
                rPI_DQ[15: 8] = rNm2_Buffer[15: 8];
                rPI_DQ[23:16] = wDQAtRising[ 7: 0];
                rPI_DQ[31:24] = wDQAtFalling[ 7: 0];
            end
            3'b111: begin // 111: Nm1+ZERO
                rPI_DQ[ 7: 0] = wDQAtRising[ 7: 0];
                rPI_DQ[15: 8] = wDQAtFalling[ 7: 0];
                rPI_DQ[23:16] = 0;
                rPI_DQ[31:24] = 0;
            end
            default: begin // 001 ~ 011: reserved
                rPI_DQ[ 7: 0] = wDQ0[7:0];
                rPI_DQ[15: 8] = wDQ1[7:0];
                rPI_DQ[23:16] = wDQ2[7:0];
                rPI_DQ[31:24] = wDQ3[7:0];
            end
        endcase
    end
    
    assign oPI_DQ[ 7: 0] = rPI_DQ[ 7: 0];
    assign oPI_DQ[15: 8] = rPI_DQ[15: 8];
    assign oPI_DQ[23:16] = rPI_DQ[23:16];
    assign oPI_DQ[31:24] = rPI_DQ[31:24];
    
    assign oPI_ValidFlag[3:0] = { wNm1_ValidFlag, rNm2_ValidFlag, rNm3_ValidFlag, rNm4_ValidFlag };
    
endmodule


module async_reset_sync #(
    parameter SYNC_STAGES = 2
)(
    input  wire clk,         // 目标时钟域
    input  wire arst_in,     // 异步复位输入（高有效）
    output wire arst_out     // 同步到clk域的复位输出（高有效）
);
    reg [SYNC_STAGES-1:0] sync_ff = {SYNC_STAGES{1'b1}};

    always @(posedge clk or posedge arst_in) begin
        if (arst_in)
            sync_ff <= {SYNC_STAGES{1'b1}};
        else
            sync_ff <= {sync_ff[SYNC_STAGES-2:0], 1'b0};
    end

    assign arst_out = sync_ff[SYNC_STAGES-1];
endmodule
