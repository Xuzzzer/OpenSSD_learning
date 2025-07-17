

`timescale 1ns / 1ps

module DispALU
(
    iClock          ,
    iReset          ,
    iEnable         ,
    iOperand0       ,
    iOperand1       ,
    oResult         ,
    iArithOpcode    ,
    oCarry          ,
    oNegative       ,
    oOverflow       ,
    oZero
);
    input           iClock          ;
    input           iReset          ;
    input           iEnable         ;
    input   [31:0]  iOperand0       ;
    input   [31:0]  iOperand1       ;
    output  [31:0]  oResult         ;
    input   [2:0]   iArithOpcode    ;
    output          oCarry          ;
    output          oNegative       ;
    output          oOverflow       ;
    output          oZero           ;
    
    reg     [31:0]  rResult         ;
    wire            wCarry          ;
    wire            wNegative       ;
    wire            wOverflow       ;
    reg             rZero           ;
    
    reg     [32:0]  rCmpResult      ;
    
    always @ (posedge iClock)
        if (iReset)
            rResult <= 33'b0;
        else
            if (iEnable)
                case (iArithOpcode)
                3'd000:
                    rResult <= iOperand0 + iOperand1;
                3'd001:
                    rResult <= iOperand0 - iOperand1;
                3'd002:
                    rResult <= rResult;
                3'd003:
                    rResult <= iOperand0 & iOperand1;
                3'd004:
                    rResult <= iOperand0 | iOperand1;
                3'd005:
                    rResult <= iOperand0 ^ iOperand1;
                3'd006:
                    rResult <= iOperand0 << iOperand1;
                3'd007:
                    rResult <= iOperand0 >> iOperand1;
                default:
                    rResult <= 32'b0;
                endcase
    
    always @ (posedge iClock)
        if (iReset)
        begin
            {rZero, rCmpResult} <= 34'b0;
        end
        else
        begin
            if (iEnable)
                case (iArithOpcode)
                3'd002:
                begin
                    rZero <= (iOperand0 == iOperand1)?1'b1:1'b0;
                    rCmpResult <= iOperand0 - iOperand1;
                end
                endcase
        end
    
    assign wOverflow    = rCmpResult[32] ^ rCmpResult[31];
    assign wNegative    = rCmpResult[31];
    assign wCarry       = rCmpResult[32];
    
    assign oResult      = rResult;
    assign oCarry       = wCarry;
    assign oNegative    = wNegative;
    assign oOverflow    = wOverflow;
    assign oZero        = rZero;

endmodule
