

`timescale 1ns / 1ps

module DispAddressDecoder
(
    iClock                  ,
    iReset                  ,
    iCPLWriteAddress        ,
    iCPLWriteData           ,
    iCPLWriteValid          ,
    oCPLWriteAck            ,
    iCPLReadAddress         ,
    oCPLReadData            ,
    iCPLReadValid           ,
    oCPLReadAck             ,
    oIDWriteAddress         ,
    oIDWriteData            ,
    oIDWriteValid           ,
    iIDWriteAck             ,
    oIDReadAddress          ,
    iIDReadData             ,
    oIDReadValid            ,
    iIDReadAck              ,
    oConfWriteAddress       ,
    oConfWriteData          ,
    oConfWriteValid         ,
    iConfWriteAck           ,
    oConfReadAddress        ,
    iConfReadData           ,
    oConfReadValid          ,
    iConfReadAck            ,
    oExtWriteAddress        ,
    oExtWriteData           ,
    oExtWriteValid          ,
    iExtWriteAck            ,
    oExtReadAddress         ,
    iExtReadData            ,
    oExtReadValid           ,
    iExtReadAck             ,
    oCoreAccWriteAddress    ,
    oCoreAccWriteData       ,
    oCoreAccWriteValid      ,
    iCoreAccWriteAck        ,
    oCoreAccReadAddress     ,
    iCoreAccReadData        ,
    oCoreAccReadValid       ,
    iCoreAccReadAck         ,
    oSigBPWriteAddress      ,
    oSigBPWriteData         ,
    oSigBPWriteValid        ,
    iSigBPWriteAck          ,
    oSigBPReadAddress       ,
    iSigBPReadData          ,
    oSigBPReadValid         ,
    iSigBPReadAck           ,
    oSPadWriteAddress       ,
    oSPadWriteData          ,
    oSPadWriteValid         ,
    iSPadWriteAck           ,
    oSPadReadAddress        ,
    iSPadReadData           ,
    oSPadReadValid          ,
    iSPadReadAck
);
    input           iClock                  ;
    input           iReset                  ;
    input   [31:0]  iCPLWriteAddress        ;
    input   [31:0]  iCPLWriteData           ;
    input           iCPLWriteValid          ;
    output          oCPLWriteAck            ;
    input   [31:0]  iCPLReadAddress         ;
    output  [31:0]  oCPLReadData            ;
    input           iCPLReadValid           ;
    output          oCPLReadAck             ;
    output  [31:0]  oIDWriteAddress         ;
    output  [31:0]  oIDWriteData            ;
    output          oIDWriteValid           ;
    input           iIDWriteAck             ;
    output  [31:0]  oIDReadAddress          ;
    input   [31:0]  iIDReadData             ;
    output          oIDReadValid            ;
    input           iIDReadAck              ;
    output  [31:0]  oConfWriteAddress       ;
    output  [31:0]  oConfWriteData          ;
    output          oConfWriteValid         ;
    input           iConfWriteAck           ;
    output  [31:0]  oConfReadAddress        ;
    input   [31:0]  iConfReadData           ;
    output          oConfReadValid          ;
    input           iConfReadAck            ;
    output  [31:0]  oExtWriteAddress        ;
    output  [31:0]  oExtWriteData           ;
    output          oExtWriteValid          ;
    input           iExtWriteAck            ;
    output  [31:0]  oExtReadAddress         ;
    input   [31:0]  iExtReadData            ;
    output          oExtReadValid           ;
    input           iExtReadAck             ;
    output  [31:0]  oCoreAccWriteAddress    ;
    output  [31:0]  oCoreAccWriteData       ;
    output          oCoreAccWriteValid      ;
    input           iCoreAccWriteAck        ;
    output  [31:0]  oCoreAccReadAddress     ;
    input   [31:0]  iCoreAccReadData        ;
    output          oCoreAccReadValid       ;
    input           iCoreAccReadAck         ;
    output  [31:0]  oSigBPWriteAddress      ;
    output  [31:0]  oSigBPWriteData         ;
    output          oSigBPWriteValid        ;
    input           iSigBPWriteAck          ;
    output  [31:0]  oSigBPReadAddress       ;
    input   [31:0]  iSigBPReadData          ;
    output          oSigBPReadValid         ;
    input           iSigBPReadAck           ;
    output  [31:0]  oSPadWriteAddress       ;
    output  [31:0]  oSPadWriteData          ;
    output          oSPadWriteValid         ;
    input           iSPadWriteAck           ;
    output  [31:0]  oSPadReadAddress        ;
    input   [31:0]  iSPadReadData           ;
    output          oSPadReadValid          ;
    input           iSPadReadAck            ;
    
    reg             rIDWriteValid           ;
    reg             rConfWriteValid         ;
    reg             rExtWriteValid          ;
    reg             rCoreAccWriteValid      ;
    reg             rSigBPWriteValid        ;
    reg             rSPadWriteValid         ;
    
    reg             rIDReadValid            ;
    reg             rConfReadValid          ;
    reg             rExtReadValid           ;
    reg             rCoreAccReadValid       ;
    reg             rSigBPReadValid         ;
    reg             rSPadReadValid          ;
    
    wire            wWriteAckFromModules    ;
    wire            wReadAckFromModules     ;

    assign oIDWriteAddress      = {20'b0, iCPLWriteAddress[11:0]};
    assign oConfWriteAddress    = {20'b0, iCPLWriteAddress[11:0]};
    assign oExtWriteAddress     = {20'b0, iCPLWriteAddress[11:0]};
    assign oCoreAccWriteAddress = {21'b0, iCPLWriteAddress[10:0]};
    assign oSigBPWriteAddress   = {21'b0, iCPLWriteAddress[10:0]};
    assign oSPadWriteAddress    = {20'b0, iCPLWriteAddress[11:0]};
    
    assign oIDReadAddress       = {20'b0, iCPLReadAddress[11:0]};
    assign oConfReadAddress     = {20'b0, iCPLReadAddress[11:0]};
    assign oExtReadAddress      = {20'b0, iCPLReadAddress[11:0]};
    assign oCoreAccReadAddress  = {21'b0, iCPLReadAddress[10:0]};
    assign oSigBPReadAddress    = {21'b0, iCPLReadAddress[10:0]};
    assign oSPadReadAddress     = {20'b0, iCPLReadAddress[11:0]};
    
    assign oIDWriteData         = iCPLWriteData;
    assign oConfWriteData       = iCPLWriteData;
    assign oExtWriteData        = iCPLWriteData;
    assign oCoreAccWriteData    = iCPLWriteData;
    assign oSigBPWriteData      = iCPLWriteData;
    assign oSPadWriteData       = iCPLWriteData;
    
    assign oIDWriteValid        = rIDWriteValid     ;
    assign oConfWriteValid      = rConfWriteValid   ;
    assign oExtWriteValid       = rExtWriteValid    ;
    assign oCoreAccWriteValid   = rCoreAccWriteValid;
    assign oSigBPWriteValid     = rSigBPWriteValid  ;
    assign oSPadWriteValid      = rSPadWriteValid   ;
    
    assign oIDReadValid         = rIDReadValid      ;
    assign oConfReadValid       = rConfReadValid    ;
    assign oExtReadValid        = rExtReadValid     ;
    assign oCoreAccReadValid    = rCoreAccReadValid ;
    assign oSigBPReadValid      = rSigBPReadValid   ;
    assign oSPadReadValid       = rSPadReadValid    ;
    
    reg     [31:0]                rReadData         ;
    
    assign wWriteAckFromModules = (iIDWriteAck | iConfWriteAck | iExtWriteAck | iCoreAccWriteAck | iSigBPWriteAck | iSPadWriteAck);
    assign wReadAckFromModules = (iIDReadAck | iConfReadAck | iExtReadAck | iCoreAccReadAck | iSigBPReadAck | iSPadReadAck);
    
    localparam  State_WIdle     = 1'b0;
    localparam  State_WWait     = 1'b1;
    
    reg         rCurWState;
    reg         rNextWState;
    
    always @ (posedge iClock)
        if (iReset)
            rCurWState <= State_WIdle;
        else
            rCurWState <= rNextWState;
    
    always @ (*)
        case (rCurWState)
        State_WIdle:
            rNextWState <= (iCPLWriteValid)?State_WWait:State_WIdle;
        State_WWait:
            rNextWState <= (wWriteAckFromModules)?State_WIdle:State_WWait;
        endcase
    
    assign oCPLWriteAck = ((rCurWState == State_WWait) && wWriteAckFromModules);
    
    always @ (posedge iClock)
        if (iReset)
        begin
            rIDWriteValid       <= 1'b0;
            rConfWriteValid     <= 1'b0;
            rExtWriteValid      <= 1'b0;
            rCoreAccWriteValid  <= 1'b0;
            rSigBPWriteValid    <= 1'b0;
            rSPadWriteValid     <= 1'b0;
        end
        else
        begin
            if (rNextWState == State_WWait)
            begin
                if (iCPLWriteAddress[31:12] == 20'd0)
                    rIDWriteValid <= 1'b1;
                if (iCPLWriteAddress[31:12] == 20'd1)
                    rConfWriteValid <= 1'b1;
                if (iCPLWriteAddress[31:12] == 20'd2)
                    rExtWriteValid <= 1'b1;
                if (iCPLWriteAddress[31:11] == 21'd6)
                    rCoreAccWriteValid <= 1'b1;
                if (iCPLWriteAddress[31:11] == 20'd7)
                    rSigBPWriteValid <= 1'b1;
                if (iCPLWriteAddress[31:12] == 21'd4)
                    rSPadWriteValid <= 1'b1;
            end
            else
            begin
                rIDWriteValid       <= 1'b0;
                rConfWriteValid     <= 1'b0;
                rExtWriteValid      <= 1'b0;
                rCoreAccWriteValid  <= 1'b0;
                rSigBPWriteValid    <= 1'b0;
                rSPadWriteValid     <= 1'b0;
            end
        end
    
    localparam  State_RIdle     = 1'b0;
    localparam  State_RWait     = 1'b1;
    
    reg         rCurRState;
    reg         rNextRState;
    
    always @ (posedge iClock)
        if (iReset)
            rCurRState <= State_RIdle;
        else
            rCurRState <= rNextRState;
    
    always @ (*)
        case (rCurRState)
        State_RIdle:
            rNextRState <= (iCPLReadValid)?State_RWait:State_RIdle;
        State_RWait:
            rNextRState <= (wReadAckFromModules)?State_RIdle:State_RWait;
        endcase
    
    assign oCPLReadAck = ((rCurRState == State_RWait) && wReadAckFromModules);
    
    always @ (posedge iClock)
        if (iReset)
        begin
            rIDReadValid        <= 1'b0;
            rConfReadValid      <= 1'b0;
            rExtReadValid       <= 1'b0;
            rCoreAccReadValid   <= 1'b0;
            rSigBPReadValid     <= 1'b0;
            rSPadReadValid      <= 1'b0;
        end
        else
        begin
            if (rNextRState == State_RWait)
            begin
                if (iCPLReadAddress[31:12] == 20'd0)
                    rIDReadValid <= 1'b1;
                if (iCPLReadAddress[31:12] == 20'd1)
                    rConfReadValid <= 1'b1;
                if (iCPLReadAddress[31:12] == 20'd2)
                    rExtReadValid <= 1'b1;
                if (iCPLReadAddress[31:11] == 21'd6)
                    rCoreAccReadValid <= 1'b1;
                if (iCPLReadAddress[31:11] == 20'd7)
                    rSigBPReadValid <= 1'b1;
                if (iCPLReadAddress[31:12] == 21'd4)
                    rSPadReadValid <= 1'b1;
            end
            else
            begin
                rIDReadValid        <= 1'b0;
                rConfReadValid      <= 1'b0;
                rExtReadValid       <= 1'b0;
                rCoreAccReadValid   <= 1'b0;
                rSigBPReadValid     <= 1'b0;
                rSPadReadValid      <= 1'b0;
            end
        end
    
    always @ (*)
        if (rCurRState == State_RWait)
        begin
            if (iCPLReadAddress[31:12] == 20'd0)
                rReadData <= iIDReadData;
            else if (iCPLReadAddress[31:12] == 20'd1)
                rReadData <= iConfReadData;
            else if (iCPLReadAddress[31:12] == 20'd2)
                rReadData <= iExtReadData;
            else if (iCPLReadAddress[31:11] == 21'd6)
                rReadData <= iCoreAccReadData;
            else if (iCPLReadAddress[31:11] == 20'd7)
                rReadData <= iSigBPReadData;
            else if (iCPLReadAddress[31:12] == 21'd4)
                rReadData <= iSPadReadData;
            else 
                rReadData <= 32'b0;
        end
        else
            rReadData <= 32'b0;
    
    assign oCPLReadData = rReadData;
    
endmodule
