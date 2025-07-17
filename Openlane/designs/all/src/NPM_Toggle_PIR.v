

`timescale 1ns / 1ps

module NPM_Toggle_PIR
(
    iSystemClock            ,
    iReset                  ,
    oReady                  ,
    oLastStep               ,
    iStart                  ,
    oPI_Reset               ,
    iPIDelayReady
);
    input                           iSystemClock            ;
    input                           iReset                  ;
    output                          oReady                  ;
    output                          oLastStep               ;
    input                           iStart                  ;
    output                          oPI_Reset               ;
    input                           iPIDelayReady           ;
    
    // FSM Parameters/Wires/Regs
    parameter PIR_FSM_BIT = 6;
    parameter PIR_RESET = 6'b00_0001;
    parameter PIR_READY = 6'b00_0010;
    parameter PIR_RFRST = 6'b00_0100; // reset first
    parameter PIR_RLOOP = 6'b00_1000; // reset loop
    parameter PIR_RDRDF = 6'b01_0000; // ready ready first
    parameter PIR_RDRDL = 6'b10_0000; // ready ready loop
    
    reg     [PIR_FSM_BIT-1:0]       rPIR_cur_state          ;
    reg     [PIR_FSM_BIT-1:0]       rPIR_nxt_state          ;
    
    
    
    // Internal Wires/Regs
    reg                             rReady                  ;
    
    reg     [9:0]                   rTimer                  ;
    
    wire                            wResetDone              ;
    wire                            wJOBDone                ;
    
    reg                             rPI_Reset                ;
    
    
    
    // Control Signals
    
    // Flow Control
    
    assign wResetDone = (10'b00_0000_1001 == rTimer[9:0]); // 1 + '9' = 10 cycles
    assign wJOBDone = (10'b01_1000_1111 == rTimer[9:0]); // 1 + "399" = 400 cycles
    
    
    
    // FSM
    
    // update current state to next state
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            rPIR_cur_state <= PIR_RESET;
        end else begin
            rPIR_cur_state <= rPIR_nxt_state;
        end
    end
    
    // deside next state
    always @ ( * ) begin
        case (rPIR_cur_state)
            PIR_RESET: begin
                rPIR_nxt_state <= PIR_READY;
            end
            PIR_READY: begin
                rPIR_nxt_state <= (iStart)? PIR_RFRST:PIR_READY;
            end
            PIR_RFRST: begin
                rPIR_nxt_state <= PIR_RLOOP;
            end
            PIR_RLOOP: begin
                rPIR_nxt_state <= (wResetDone)? PIR_RDRDF:PIR_RLOOP;
            end
            PIR_RDRDF: begin
                rPIR_nxt_state <= PIR_RDRDL;
            end
            PIR_RDRDL: begin
                rPIR_nxt_state <= (wJOBDone)? ((iStart)? PIR_RFRST:PIR_READY):PIR_RDRDL;
            end
            default:
                rPIR_nxt_state <= PIR_READY;
        endcase
    end
    
    // state behaviour
    always @ (posedge iSystemClock, posedge iReset) begin
        if (iReset) begin
            rReady          <= 0;
            rTimer[9:0]     <= 0;
            rPI_Reset       <= 0;
        end else begin
            case (rPIR_nxt_state)
                PIR_RESET: begin
                    rReady          <= 0;
                    rTimer[9:0]     <= 0;
                    rPI_Reset       <= 0;
                end
                PIR_READY: begin
                    rReady          <= 1;
                    rTimer[9:0]     <= 0;
                    rPI_Reset       <= 0;
                end
                PIR_RFRST: begin
                    rReady          <= 0;
                    rTimer[9:0]     <= 10'b00_0000_0000;
                    rPI_Reset       <= 1;
                end
                PIR_RLOOP: begin
                    rReady          <= 0;
                    rTimer[9:0]     <= rTimer[9:0] + 1'b1;
                    rPI_Reset       <= 1;
                end
                PIR_RDRDF: begin
                    rReady          <= 0;
                    rTimer[9:0]     <= 10'b00_0000_0000;
                    rPI_Reset       <= 0;
                end
                PIR_RDRDL: begin
                    rReady          <= 0;
                    rTimer[9:0]     <= rTimer[9:0] + 1'b1;
                    rPI_Reset       <= 0;
                end
            endcase
        end
    end
    
    
    
    // Output
    
    assign oReady               = rReady | wJOBDone     ;
    assign oLastStep            = wJOBDone              ;
    
    assign oPI_Reset            = rPI_Reset              ;
    
endmodule
