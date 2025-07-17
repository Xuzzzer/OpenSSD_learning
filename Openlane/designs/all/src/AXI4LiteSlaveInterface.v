

`timescale 1ns / 1ps

module AXI4LiteSlaveInterface
#
(
    parameter AddressWidth = 32,
    parameter DataWidth = 32
)
(
    ACLK            ,
    ARESETN         ,
    AWVALID         ,
    AWREADY         ,
    AWADDR          ,
    AWPROT          ,
    WVALID          ,
    WREADY          ,
    WDATA           ,
    WSTRB           ,
    BVALID          ,
    BREADY          ,
    BRESP           ,
    ARVALID         ,
    ARREADY         ,
    ARADDR          ,
    ARPROT          ,
    RVALID          ,
    RREADY          ,
    RDATA           ,
    RRESP           ,
    oWriteAddress   ,
    oReadAddress    ,
    oWriteData      ,
    iReadData       ,
    oWriteValid     ,
    oReadValid      ,
    iWriteAck       ,
    iReadAck
);
    // AXI4 Lite Interface
    input                           ACLK            ;
    input                           ARESETN         ;
    input                           AWVALID         ;
    output                          AWREADY         ;
    input   [AddressWidth - 1:0]    AWADDR          ;
    input   [2:0]                   AWPROT          ;
    input                           WVALID          ;
    output                          WREADY          ;
    input   [DataWidth - 1:0]       WDATA           ;
    input   [DataWidth/8 - 1:0]     WSTRB           ;
    output                          BVALID          ;
    input                           BREADY          ;
    output  [1:0]                   BRESP           ;
    input                           ARVALID         ;
    output                          ARREADY         ;
    input   [AddressWidth - 1:0]    ARADDR          ;
    input   [2:0]                   ARPROT          ;
    output                          RVALID          ;
    input                           RREADY          ;
    output  [DataWidth - 1:0]       RDATA           ;
    output  [1:0]                   RRESP           ;
        
    // Inner AXI-like Interface
    output  [AddressWidth - 1:0]    oWriteAddress   ;
    output  [AddressWidth - 1:0]    oReadAddress    ;
    output  [DataWidth - 1:0]       oWriteData      ;
    input   [DataWidth - 1:0]       iReadData       ;
    output                          oWriteValid     ;
    output                          oReadValid      ;
    input                           iWriteAck       ;
    input                           iReadAck        ;

    AXI4LiteSlaveInterfaceWriteChannel
    #
    (
        .AddressWidth   (AddressWidth   ),
        .DataWidth      (DataWidth      )
    )
    Inst_AXI4LiteSlaveInterfaceWriteChannel
    (
        .ACLK           (ACLK           ),
        .ARESETN        (ARESETN        ),
        .AWVALID        (AWVALID        ),
        .AWREADY        (AWREADY        ),
        .AWADDR         (AWADDR         ),
        .AWPROT         (AWPROT         ),
        .WVALID         (WVALID         ),
        .WREADY         (WREADY         ),
        .WDATA          (WDATA          ),
        .WSTRB          (WSTRB          ),
        .BVALID         (BVALID         ),
        .BREADY         (BREADY         ),
        .BRESP          (BRESP          ),
        .oWriteAddress  (oWriteAddress  ),
        .oWriteData     (oWriteData     ),
        .oWriteValid    (oWriteValid    ),
        .iWriteAck      (iWriteAck      )
    );
    
    AXI4LiteSlaveInterfaceReadChannel
    #
    (
        .AddressWidth   (AddressWidth   ),
        .DataWidth      (DataWidth      )
    )
    Inst_AXI4LiteSlaveInterfaceReadChannel
    (
        .ACLK           (ACLK           ),
        .ARESETN        (ARESETN        ),
        .ARVALID        (ARVALID        ),
        .ARREADY        (ARREADY        ),
        .ARADDR         (ARADDR         ),
        .ARPROT         (ARPROT         ),
        .RVALID         (RVALID         ),
        .RREADY         (RREADY         ),
        .RDATA          (RDATA          ),
        .RRESP          (RRESP          ),
        .oReadAddress   (oReadAddress   ),
        .iReadData      (iReadData      ),
        .oReadValid     (oReadValid     ),
        .iReadAck       (iReadAck       )
    );
    
endmodule
