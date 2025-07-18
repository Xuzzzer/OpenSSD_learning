

`timescale 1ns / 1ps

module NPCG_Toggle_MNC_getFT
#
(
    parameter NumberOfWays    =   4
)
(
    iSystemClock        ,
    iReset              ,
    iOpcode             ,
    iTargetID           ,
    iSourceID           ,
    iLength             , 
    iCMDValid           ,
    oCMDReady           ,
    oReadData           ,
    oReadLast           ,
    oReadValid          ,
    iReadReady          ,
    iWaySelect          ,
    oStart              ,
    oLastStep           ,
    iPM_Ready           ,
    iPM_LastStep        ,
    oPM_PCommand        ,
    oPM_PCommandOption  ,
    oPM_TargetWay       ,
    oPM_NumOfData       ,
    oPM_CASelect        ,
    oPM_CAData          ,
    iPM_ReadData        ,
    iPM_ReadLast        ,
    iPM_ReadValid       ,
    oPM_ReadReady
);
    input                           iSystemClock            ;
    input                           iReset                  ;
    input   [5:0]                   iOpcode                 ;
    input   [4:0]                   iTargetID               ;
    input   [4:0]                   iSourceID               ;
    input   [7:0]                   iLength                 ; 
    input                           iCMDValid               ;
    output                          oCMDReady               ;
    output  [31:0]                  oReadData               ;
    output                          oReadLast               ;
    output                          oReadValid              ;
    input                           iReadReady              ;
    input   [NumberOfWays - 1:0]    iWaySelect              ;
    output                          oStart                  ;
    output                          oLastStep               ;
    input   [7:0]                   iPM_Ready               ;
    input   [7:0]                   iPM_LastStep            ;
    output  [7:0]                   oPM_PCommand            ;
    output  [2:0]                   oPM_PCommandOption      ;
    output  [NumberOfWays - 1:0]    oPM_TargetWay           ;
    output  [15:0]                  oPM_NumOfData           ;
    output                          oPM_CASelect            ;
    output  [7:0]                   oPM_CAData              ;
    input   [31:0]                  iPM_ReadData            ;
    input                           iPM_ReadLast            ;
    input                           iPM_ReadValid           ;
    output                          oPM_ReadReady           ;
    
    // FSM Parameters/Wires/Regs
    localparam gFT_FSM_BIT = 11; // set Feature
    localparam gFT_RESET = 11'b000000_00001;
    localparam gFT_READY = 11'b000000_00010;
    localparam gFT_CALST = 11'b000000_00100; // capture, CAL start
    localparam gFT_CALD0 = 11'b000000_01000; // CA data 0
    localparam gFT_CALDL = 11'b000000_10000; // CA data LUN
    localparam gFT_CALD1 = 11'b000001_00000; // CA data 1
    localparam gFT_TM1ST = 11'b000010_00000; // Timer1 start
    localparam gFT_DI_ST = 11'b000100_00000; // DI start
    localparam gFT_TM2ST = 11'b001000_00000; // Timer2 start
    localparam gFT_WTMDN = 11'b010000_00000; // wait for Timer2 done
    localparam gFT_WAITD = 11'b100000_00000; // wait for request done
    
    reg     [gFT_FSM_BIT-1:0]       r_gFT_cur_state         ;
    reg     [gFT_FSM_BIT-1:0]       r_gFT_nxt_state         ;
    
    localparam pTF_FSM_BIT = 8; // parameter TransFer
    localparam pTF_RESET = 8'b0000_0001;
    localparam pTF_READY = 8'b0000_0010;
    localparam pTF_STDB0 = 8'b0000_0100; // standby 0
    localparam pTF_CPTP0 = 8'b0000_1000; // parameter capture 0: R-P0, R-P1
    localparam pTF_STDB1 = 8'b0001_0000; // standby 1
    localparam pTF_CPTP1 = 8'b0010_0000; // parameter capture 1: R-P2, R-P3
    localparam pTF_PTRSF = 8'b0100_0000; // parameter transfer: R-P0, R-P1, R-P2, R-P3
    localparam pTF_WAITD = 8'b1000_0000; // wait for request done
    
    reg     [pTF_FSM_BIT-1:0]       r_pTF_cur_state         ;
    reg     [pTF_FSM_BIT-1:0]       r_pTF_nxt_state         ;
    
    
    
    // Internal Wires/Regs
    reg     [4:0]                   rSourceID               ;
    
    reg     [7:0]                   rLength                 ;
    
    reg                             rCMDReady               ;
    
    reg     [31:0]                  rReadData               ;
    reg                             rReadLast               ;
    reg                             rReadValid              ;
    
    reg     [NumberOfWays - 1:0]    rWaySelect              ;
    
    wire                            wLastStep               ;
    
    reg     [7:0]                   rPM_PCommand            ;
    reg     [2:0]                   rPM_PCommandOption      ;
    reg     [15:0]                  rPM_NumOfData           ;
    
    reg                             rPM_CASelect            ;
    reg     [7:0]                   rPM_CAData              ;
    
    reg                             rPM_ReadReady           ;
    
    // parameter
    reg     [31:0]                  rParameter              ;
    
    // control signal
    wire                            wPCGStart               ;
    wire                            wCapture                ;
    
    wire                            wPMReady                ;
    
    wire                            wCALReady               ;
    wire                            wCALStart               ;
    wire                            wCALDone                ;
    
    wire                            wTMReady                ;
    wire                            wTMStart                ;
    wire                            wTMDone                 ;
    
    wire                            wDIReady                ;
    wire                            wDIStart                ;
    wire                            wDIDone                 ;
    
    wire    [1:0]                   wIsLunGetFeatures       ;
    wire    [1:0]                   wLunGetFeaturesFromSID  ;
    
    
    
    // Control Signals
    // Flow Contorl
    assign wPCGStart = (iOpcode[5:0] == 6'b100101) & (iTargetID[4:0] == 5'b00101) & iCMDValid;
    assign wCapture = (r_gFT_cur_state[gFT_FSM_BIT-1:0] == gFT_READY);
    
    assign wPMReady = (iPM_Ready[6:0] == 7'b1111111);
    
    assign wCALReady = wPMReady;
    assign wCALStart = wCALReady & rPM_PCommand[3];
    assign wCALDone = iPM_LastStep[3];
    
    assign wTMReady = wPMReady;
    assign wTMStart = wTMReady & rPM_PCommand[0];
    assign wTMDone = iPM_LastStep[0];
    
    assign wDIReady = wPMReady;
    assign wDIStart = wDIReady & rPM_PCommand[1];
    assign wDIDone = iPM_LastStep[1];
    
    assign wLastStep = (r_gFT_cur_state[gFT_FSM_BIT-1:0] == gFT_WAITD) & (r_pTF_cur_state[pTF_FSM_BIT-1:0] == pTF_WAITD);
    
    assign wIsLunGetFeatures = ((wCapture & iSourceID[0]) | rSourceID[0]);
    assign wLunGetFeaturesFromSID = rSourceID[2:1];
    
    
    // FSM: read STatus
    
    // update current state to next state
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            r_gFT_cur_state <= gFT_RESET;
        end else begin
            r_gFT_cur_state <= r_gFT_nxt_state;
        end
    end
    
    // deside next state
    always @ ( * ) begin
        case (r_gFT_cur_state)
        gFT_RESET: begin
            r_gFT_nxt_state <= gFT_READY;
        end
        gFT_READY: begin
            r_gFT_nxt_state <= (wPCGStart)? gFT_CALST:gFT_READY;
        end
        gFT_CALST: begin
            r_gFT_nxt_state <= (wCALStart)? gFT_CALD0:gFT_CALST;
        end
        gFT_CALD0: begin
            r_gFT_nxt_state <= (wIsLunGetFeatures)?gFT_CALDL:gFT_CALD1;
        end
        gFT_CALDL: begin
            r_gFT_nxt_state <= gFT_TM1ST;
        end
        gFT_CALD1: begin
            r_gFT_nxt_state <= gFT_TM1ST;
        end
        gFT_TM1ST: begin
            r_gFT_nxt_state <= (wTMStart)? gFT_DI_ST:gFT_TM1ST;
        end
        gFT_DI_ST: begin
            r_gFT_nxt_state <= (wDIStart)? gFT_TM2ST:gFT_DI_ST;
        end
        gFT_TM2ST: begin
            r_gFT_nxt_state <= (wTMStart)? gFT_WTMDN:gFT_TM2ST;
        end
        gFT_WTMDN: begin
            r_gFT_nxt_state <= (wTMDone)? gFT_WAITD:gFT_WTMDN;
        end
        gFT_WAITD: begin
            r_gFT_nxt_state <= (wLastStep)? gFT_READY:gFT_WAITD;
        end
        default:
            r_gFT_nxt_state <= gFT_READY;
        endcase
    end
    
    // state behaviour
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            rSourceID[4:0]                  <= 0;
            rLength[7:0]                    <= 0;
            rCMDReady                       <= 0;
            rWaySelect[NumberOfWays - 1:0]  <= 0;
            
            rPM_PCommand[7:0]               <= 0;
            rPM_PCommandOption[2:0]         <= 0;
            rPM_NumOfData[15:0]             <= 0;
            
            rPM_CASelect                    <= 0;
            rPM_CAData[7:0]                 <= 0;
        end else begin
            case (r_gFT_nxt_state)
                gFT_RESET: begin
                    rSourceID[4:0]                  <= 0;
                    rLength[7:0]                    <= 0;
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= 0;
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_READY: begin
                    rSourceID[4:0]                  <= 0;
                    rLength[7:0]                    <= 0;
                    rCMDReady                       <= 1;
                    rWaySelect[NumberOfWays - 1:0]  <= 0;
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_CALST: begin
                    rSourceID[4:0]                  <= (wCapture)? iSourceID[4:0]:rSourceID[4:0];
                    rLength[7:0]                    <= (wCapture)? iLength[7:0]:rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= (wCapture)? iWaySelect[NumberOfWays - 1:0]:rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 8'b0000_1000;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= (wIsLunGetFeatures)?16'd2:16'd1;
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_CALD0: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 1'b0; // command
                    rPM_CAData[7:0]                 <= (wIsLunGetFeatures)?8'hD4:8'hEE;
                end
                gFT_CALDL: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 1'b1; // address
                    rPM_CAData[7:0]                 <= {6'b0, wLunGetFeaturesFromSID};
                end
                gFT_CALD1: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 1'b1; // address
                    rPM_CAData[7:0]                 <= rLength[7:0];
                end
                gFT_TM1ST: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 8'b0000_0001;
                    rPM_PCommandOption[2:0]         <= 3'b001; // CE on
                    rPM_NumOfData[15:0]             <= 16'd149; // 1500 ns
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_DI_ST: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 8'b0000_0010;
                    rPM_PCommandOption[2:0]         <= 3'b000; // byte input
                    rPM_NumOfData[15:0]             <= 16'd7; // 8
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_TM2ST: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 8'b0000_0001;
                    rPM_PCommandOption[2:0]         <= 3'b100;
                    rPM_NumOfData[15:0]             <= 16'd3; // 40 ns
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_WTMDN: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
                gFT_WAITD: begin
                    rSourceID[4:0]                  <= rSourceID[4:0];
                    rLength[7:0]                    <= rLength[7:0];
                    rCMDReady                       <= 0;
                    rWaySelect[NumberOfWays - 1:0]  <= rWaySelect[NumberOfWays - 1:0];
                    
                    rPM_PCommand[7:0]               <= 0;
                    rPM_PCommandOption[2:0]         <= 0;
                    rPM_NumOfData[15:0]             <= 0;
                    
                    rPM_CASelect                    <= 0;
                    rPM_CAData[7:0]                 <= 0;
                end
            endcase
        end
    end
    
    
    
    // FSM: parameter TransFer
    
    // update current state to next state
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            r_pTF_cur_state <= pTF_RESET;
        end else begin
            r_pTF_cur_state <= r_pTF_nxt_state;
        end
    end
    
    // deside next state
    always @ ( * ) begin
        case (r_pTF_cur_state)
        pTF_RESET: begin
            r_pTF_nxt_state <= pTF_READY;
        end
        pTF_READY: begin
            r_pTF_nxt_state <= (wPCGStart)? pTF_STDB0:pTF_READY;
        end
        pTF_STDB0: begin
            r_pTF_nxt_state <= (iPM_ReadValid)? pTF_CPTP0:pTF_STDB0;
        end
        pTF_CPTP0: begin
            r_pTF_nxt_state <= (iPM_ReadValid)? pTF_CPTP1:pTF_STDB1;
        end
        pTF_STDB1: begin
            r_pTF_nxt_state <= (iPM_ReadValid)? pTF_CPTP1:pTF_STDB1;
        end
        pTF_CPTP1: begin
            r_pTF_nxt_state <= pTF_PTRSF;
        end
        pTF_PTRSF: begin
            r_pTF_nxt_state <= (iReadReady)? pTF_WAITD:pTF_PTRSF;
        end
        pTF_WAITD: begin
            r_pTF_nxt_state <= (wLastStep)? pTF_READY:pTF_WAITD;
        end
        default:
            r_pTF_nxt_state <= pTF_READY;
        endcase
    end
    
    // state behaviour
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            rReadData[31:0]     <= 0;
            rReadLast           <= 0;
            rReadValid          <= 0;
            
            rParameter[31:0]    <= 0;
            
            rPM_ReadReady       <= 0;
        end else begin
            case (r_pTF_nxt_state)
                pTF_RESET: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= 0;
                    
                    rPM_ReadReady       <= 0;
                end
                pTF_READY: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= 0;
                    
                    rPM_ReadReady       <= 0;
                end
                pTF_STDB0: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= 0;
                    
                    rPM_ReadReady       <= 1'b1;
                end
                pTF_CPTP0: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= { 16'h0000, iPM_ReadData[31:24], iPM_ReadData[15:8] };
                    
                    rPM_ReadReady       <= 1'b1;
                end
                pTF_STDB1: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= rParameter[31:0];
                    
                    rPM_ReadReady       <= 1'b1;
                end
                pTF_CPTP1: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= { iPM_ReadData[31:24], iPM_ReadData[15:8], rParameter[15:0] };
                    
                    rPM_ReadReady       <= 0;
                end
                pTF_PTRSF: begin
                    rReadData[31:0]     <= rParameter[31:0];
                    rReadLast           <= 1'b1;
                    rReadValid          <= 1'b1;
                    
                    rParameter[31:0]    <= rParameter[31:0];
                    
                    rPM_ReadReady       <= 0;
                end
                pTF_WAITD: begin
                    rReadData[31:0]     <= 0;
                    rReadLast           <= 0;
                    rReadValid          <= 0;
                    
                    rParameter[31:0]    <= rParameter[31:0];
                    
                    rPM_ReadReady       <= 0;
                end
            endcase
        end
    end
    
    
    
    // Output
    assign oCMDReady = rCMDReady;
    
    assign oReadData[31:0] = rReadData;
    assign oReadLast = rReadLast;
    assign oReadValid = rReadValid;
    
    assign oStart = wPCGStart;
    assign oLastStep = wLastStep;
    
    assign oPM_PCommand[7:0] = rPM_PCommand[7:0];
    assign oPM_PCommandOption[2:0] = rPM_PCommandOption[2:0];
    assign oPM_TargetWay[NumberOfWays - 1:0] = rWaySelect[NumberOfWays - 1:0];
    assign oPM_NumOfData[15:0] = rPM_NumOfData[15:0];
    
    assign oPM_CASelect = rPM_CASelect;
    assign oPM_CAData[7:0] = rPM_CAData[7:0]; 
    
    assign oPM_ReadReady = rPM_ReadReady;
    
endmodule
