module A_TOP
#(
    parameter IDelayValue           =   0   ,
    parameter DQIDelayValue         =   0   ,
    parameter InputClockBufferType  =   0   ,
    parameter NumberOfWays          =   8   ,
    parameter BufferType            =   0   ,
    parameter IDelayCtrlInst        =   1   ,
    parameter DQIDelayInst          =   0   ,
    parameter   NumberOfWays        = 8     ,
    parameter   BCHDecMulti         = 2     ,
    parameter   GaloisFieldDegree   = 12    ,
    parameter   MaxErrorCountBits   = 9     ,
    parameter   Syndromes           = 27   	,
    parameter   ELPCoefficients     = 15    ,
     parameter   Channel             = 4,
    parameter   Multi               = 2,
    parameter   GaloisFieldDegree   = 12,
    parameter   MaxErrorCountBits   = 9,
    parameter   Syndromes           = 27,
    parameter   ELPCoefficients     = 15,

    parameter C_S0_AXI_ADDR_WIDTH			= 32,
	parameter C_S0_AXI_DATA_WIDTH			= 32,
	parameter C_S0_AXI_BASEADDR				= 32'hA0000000,
	parameter C_S0_AXI_HIGHADDR				= 32'hA001FFFF,

	parameter C_M0_AXI_ADDR_WIDTH			= 32,
	parameter C_M0_AXI_DATA_WIDTH			= 64,
	parameter C_M0_AXI_ID_WIDTH				= 1,
	parameter C_M0_AXI_AWUSER_WIDTH			= 1,
	parameter C_M0_AXI_WUSER_WIDTH			= 1,
	parameter C_M0_AXI_BUSER_WIDTH			= 1,
	parameter C_M0_AXI_ARUSER_WIDTH			= 1,
	parameter C_M0_AXI_RUSER_WIDTH			= 1,
	parameter C_PCIE_DATA_WIDTH				= 512,
	parameter [4:0]    PL_LINK_CAP_MAX_LINK_WIDTH     = 16,  // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
	parameter          AXISTEN_IF_MC_RX_STRADDLE      = 0,
	parameter          PL_LINK_CAP_MAX_LINK_SPEED     = 4,  // 1- GEN1, 2 - GEN2, 4 - GEN3, 8 - GEN4
	parameter          KEEP_WIDTH                     = C_PCIE_DATA_WIDTH / 32,
	parameter          EXT_PIPE_SIM                   = "FALSE",  // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
	parameter          AXISTEN_IF_CC_ALIGNMENT_MODE   = "FALSE",
	parameter          AXISTEN_IF_CQ_ALIGNMENT_MODE   = "FALSE",
	parameter          AXISTEN_IF_RQ_ALIGNMENT_MODE   = "FALSE",
	parameter          AXISTEN_IF_RC_ALIGNMENT_MODE   = "FALSE",
	parameter          AXI4_CQ_TUSER_WIDTH            = 183,
	parameter          AXI4_CC_TUSER_WIDTH            = 81,
	parameter          AXI4_RQ_TUSER_WIDTH            = 137,
	parameter          AXI4_RC_TUSER_WIDTH            = 161,
	parameter          AXISTEN_IF_ENABLE_CLIENT_TAG   = 1,
	parameter          RQ_AVAIL_TAG_IDX               = 8,
	parameter          RQ_AVAIL_TAG                   = 256,
	parameter          AXISTEN_IF_RQ_PARITY_CHECK     = 0,
	parameter          AXISTEN_IF_CC_PARITY_CHECK     = 0,
	parameter          AXISTEN_IF_RC_PARITY_CHECK     = 0,
	parameter          AXISTEN_IF_CQ_PARITY_CHECK     = 0,
	parameter          AXISTEN_IF_ENABLE_RX_MSG_INTFC = "FALSE",
	parameter   [17:0] AXISTEN_IF_ENABLE_MSG_ROUTE    = 18'h2FFFF,	
	parameter P_SLOT_TAG_WIDTH				=  10, //slot_modified
	parameter P_SLOT_WIDTH					=1024 //slot_modified

)
(
    //nfcv2_io
    iSystemClock        ,
    iDelayRefClock      ,
    iOutputDrivingClock ,
    iOutputStrobeClock  ,
    iReset              ,
    iOpcode             ,
    iTargetID           ,
    iSourceID           ,
    iAddress            ,
    iLength             ,
    iCMDValid           ,
    oCMDReady           ,
    iWriteData          ,
    iWriteLast          ,
    iWriteValid         ,
    oWriteReady         ,
    oReadData           ,
    oReadLast           ,
    oReadValid          ,
    iReadReady          ,
    oReadyBusy          ,
    IO_NAND_DQS_P       ,
    IO_NAND_DQS_N       ,
    IO_NAND_DQ          ,
    O_NAND_CE           ,
    O_NAND_WE           ,
    O_NAND_RE_P         ,
    O_NAND_RE_N         ,
    O_NAND_ALE          ,
    O_NAND_CLE          ,
    I_NAND_RB           ,
    O_NAND_WP           ,
    iDQSIDelayTap       ,
    iDQSIDelayTapLoad   ,
    iDQ0IDelayTap       ,
    iDQ0IDelayTapLoad   ,
    iDQ1IDelayTap       ,
    iDQ1IDelayTapLoad   ,
    iDQ2IDelayTap       ,
    iDQ2IDelayTapLoad   ,
    iDQ3IDelayTap       ,
    iDQ3IDelayTapLoad   ,
    iDQ4IDelayTap       ,
    iDQ4IDelayTapLoad   ,
    iDQ5IDelayTap       ,
    iDQ5IDelayTapLoad   ,
    iDQ6IDelayTap       ,
    iDQ6IDelayTapLoad   ,
    iDQ7IDelayTap       ,
    iDQ7IDelayTapLoad   ,
    ext_fifo_dout           ,
    ext_fifo_empty          ,
    ext_fifo_full           ,
    ext_fifo_din            ,
    ext_fifo_rd_clk         ,
    ext_fifo_rd_en          ,
    ext_fifo_wr_clk         ,
    ext_fifo_wr_en          ,
    ext_fifo_rst            ,
    //nfcv4
    //iClock              ,

    C_AWVALID           ,
    C_AWREADY           ,
    C_AWADDR            ,
    C_AWPROT            ,
    C_WVALID            ,
    C_WREADY            ,
    C_WDATA             ,
    C_WSTRB             ,
    C_BVALID            ,
    C_BREADY            ,
    C_BRESP             ,
    C_ARVALID           ,
    C_ARREADY           ,
    C_ARADDR            ,
    C_ARPROT            ,
    C_RVALID            ,
    C_RREADY            ,
    C_RDATA             ,
    C_RRESP             ,
    D_AWADDR            ,
    D_AWLEN             ,
    D_AWSIZE            ,
    D_AWBURST           ,
    D_AWCACHE           ,
    D_AWPROT            ,
    D_AWVALID           ,
    D_AWREADY           ,
    D_WDATA             ,
    D_WSTRB             ,
    D_WLAST             ,
    D_WVALID            ,
    D_WREADY            ,
    D_BRESP             ,
    D_BVALID            ,
    D_BREADY            ,
    D_ARADDR            ,
    D_ARLEN             ,
    D_ARSIZE            ,
    D_ARBURST           ,
    D_ARCACHE           ,
    D_ARPROT            ,
    D_ARVALID           ,
    D_ARREADY           ,
    D_RDATA             ,
    D_RRESP             ,
    D_RLAST             ,
    D_RVALID            ,
    D_RREADY            ,
    oOpcode             ,
    oTargetID           ,
    oSourceID           ,
    oAddress            ,
    oLength             ,
    oCMDValid           ,
    iCMDReady           ,
    oWriteData          ,
    oWriteLast          ,
    oWriteValid         ,
    iWriteReady         ,
    iReadData           ,
    iReadLast           ,
    iReadValid          ,
    oReadReady          ,
    iReadyBusy          ,
    oROMClock           ,
    oROMReset           ,
    oROMAddr            ,
    oROMRW              ,
    oROMEnable          ,
    oROMWData           ,
    iROMRData           ,
    oToECCWOpcode       ,
    oToECCWTargetID     ,
    oToECCWSourceID     ,
    oToECCWAddress      ,
    oToECCWLength       ,
    oToECCWCmdValid     ,
    iToECCWCmdReady     ,
    oToECCWData         ,
    oToECCWValid        ,
    oToECCWLast         ,
    iToECCWReady        ,
    oToECCROpcode       ,
    oToECCRTargetID     ,
    oToECCRSourceID     ,
    oToECCRAddress      ,
    oToECCRLength       ,
    oToECCRCmdValid     ,
    iToECCRCmdReady     ,
    iToECCRData         ,
    iToECCRValid        ,
    iToECCRLast         ,
    oToECCRReady        ,
    ifromECCWOpcode     ,
    ifromECCWTargetID   ,
    ifromECCWSourceID   ,
    ifromECCWAddress    ,
    ifromECCWLength     ,
    ifromECCWCmdValid   ,
    ofromECCWCmdReady   ,
    ifromECCWData       ,
    ifromECCWValid      ,
    ifromECCWLast       ,
    ofromECCWReady      ,
    ifromECCROpcode     ,
    ifromECCRTargetID   ,
    ifromECCRSourceID   ,
    ifromECCRAddress    ,
    ifromECCRLength     ,
    ifromECCRCmdValid   ,
    ofromECCRCmdReady   ,
    ofromECCRData       ,
    ofromECCRValid      ,
    ofromECCRLast       ,
    ifromECCRReady      ,
    O_DEBUG             ,
    //sccs_bch
  
    iToECCWOpcode       ,
    iToECCWTargetID     ,
    iToECCWSourceID     ,
    iToECCWAddress      ,
    iToECCWLength       ,
    iToECCWCmdValid     ,
    oToECCWCmdReady     ,
    iToECCWData         ,
    iToECCWValid        ,
    iToECCWLast         ,
    oToECCWReady        ,
    iToECCROpcode       ,
    iToECCRTargetID     ,
    iToECCRSourceID     ,
    iToECCRAddress      ,
    iToECCRLength       ,
    iToECCRCmdValid     ,
    oToECCRCmdReady     ,
    oToECCRData         ,
    oToECCRValid        ,
    oToECCRLast         ,
    iToECCRReady        ,
    ofromECCWOpcode     ,
    ofromECCWTargetID   ,
    ofromECCWSourceID   ,
    ofromECCWAddress    ,
    ofromECCWLength     ,
    ofromECCWCmdValid   ,
    ifromECCWCmdReady   ,
    ofromECCWData       ,
    ofromECCWValid      ,
    ofromECCWLast       ,
    ifromECCWReady      ,
    ofromECCROpcode     ,
    ofromECCRTargetID   ,
    ofromECCRSourceID   ,
    ofromECCRAddress    ,
    ofromECCRLength     ,
    ofromECCRCmdValid   ,
    ifromECCRCmdReady   ,
    ifromECCRData       ,
    ifromECCRValid      ,
    ifromECCRLast       ,
    ofromECCRReady      ,
    iSharedKESReady     ,
    oErrorDetectionEnd  ,
    oDecodeNeeded       ,
    oSyndromes          ,
    iIntraSharedKESEnd  ,
    iErroredChunk       ,
    iCorrectionFail     ,
    iErrorCount         ,
    iELPCoefficients    ,
    oCSAvailable        ,
    //skes_bch
     //iClock                  ,

    
    oSharedKESReady_0       ,
    iErrorDetectionEnd_0    ,
    iDecodeNeeded_0         ,
    iSyndromes_0            ,
    iCSAvailable_0          ,
    oIntraSharedKESEnd_0    ,
    oErroredChunk_0         ,
    oCorrectionFail_0       ,
    oClusterErrorCount_0    ,
    oELPCoefficients_0      ,
    
    oSharedKESReady_1       ,
    iErrorDetectionEnd_1    ,
    iDecodeNeeded_1         ,
    iSyndromes_1            ,
    iCSAvailable_1          ,
    oIntraSharedKESEnd_1    ,
    oErroredChunk_1         ,
    oCorrectionFail_1       ,
    oClusterErrorCount_1    ,
    oELPCoefficients_1      ,
    
    oSharedKESReady_2       ,
    iErrorDetectionEnd_2    ,
    iDecodeNeeded_2         ,
    iSyndromes_2            ,
    iCSAvailable_2          ,
    oIntraSharedKESEnd_2    ,
    oErroredChunk_2         ,
    oCorrectionFail_2       ,
    oClusterErrorCount_2    ,
    oELPCoefficients_2      ,
    
    oSharedKESReady_3       ,
    iErrorDetectionEnd_3    ,
    iDecodeNeeded_3         ,
    iSyndromes_3            ,
    iCSAvailable_3          ,
    oIntraSharedKESEnd_3    ,
    oErroredChunk_3         ,
    oCorrectionFail_3       ,
    oClusterErrorCount_3    ,
    oELPCoefficients_3      ,


    //nvme
    s0_axi_aclk,
    s0_axi_aresetn,
    s0_axi_awaddr,
    s0_axi_awready,
    s0_axi_awvalid,
    s0_axi_awprot,
    s0_axi_wvalid,
    s0_axi_wready,
    s0_axi_wdata,
    s0_axi_wstrb,
    s0_axi_bvalid,
    s0_axi_bready,
    s0_axi_bresp,
    s0_axi_arvalid,
    s0_axi_arready,
    s0_axi_araddr,
    s0_axi_arprot,
    s0_axi_rvalid,
    s0_axi_rready,
    s0_axi_rdata,
    s0_axi_rresp,
    ////////////////////
    m0_axi_aclk,
    m0_axi_aresetn,
    m0_axi_awid,
    m0_axi_awaddr,
    m0_axi_awlen,
    m0_axi_awsize,
    m0_axi_awburst,
    m0_axi_awlock,
    m0_axi_awcache,
    m0_axi_awprot,
    m0_axi_awregion,
    m0_axi_awqos,
    m0_axi_awuser,
    m0_axi_awvalid,
    m0_axi_awready,
    m0_axi_wid,
    m0_axi_wdata,
    m0_axi_wstrb,
    m0_axi_wlast,
    m0_axi_wuser,
    m0_axi_wvalid,
    m0_axi_wready,
    m0_axi_bid,
    m0_axi_bresp,
    m0_axi_bvalid,
    m0_axi_buser,
    m0_axi_bready,
    m0_axi_arid,
    m0_axi_araddr,
    m0_axi_arlen,
    m0_axi_arsize,
    m0_axi_arburst,
    m0_axi_arlock,
    m0_axi_arcache,
    m0_axi_arprot,
    m0_axi_arregion,
    m0_axi_arqos,
    m0_axi_aruser,
    m0_axi_arvalid,
    m0_axi_arready,
    m0_axi_rid,
    m0_axi_rdata,
    m0_axi_rresp,
    m0_axi_rlast,
    m0_axi_ruser,
    m0_axi_rvalid,
    m0_axi_rready,
    dev_irq_assert,
    pcie_ref_clk_p,
    pcie_ref_clk_n,
    pcie_perst_n,
    pci_exp_txp,
    pci_exp_txn,
    pci_exp_rxp,
    pci_exp_rxn,
    user_lnk_up,
    user_clk_out,
    user_reset_out,
    phy_rdy_out,
    s_axis_rq_tlast,
    s_axis_rq_tdata,
    s_axis_rq_tuser,
    s_axis_rq_tkeep,
    s_axis_rq_tready,
    s_axis_rq_tvalid,
    m_axis_rc_tdata,
    m_axis_rc_tuser,
    m_axis_rc_tlast,
    m_axis_rc_tkeep,
    m_axis_rc_tvalid,
    m_axis_rc_tready,
    m_axis_cq_tdata,
    m_axis_cq_tuser,
    m_axis_cq_tlast,
    m_axis_cq_tkeep,
    m_axis_cq_tvalid,
    m_axis_cq_tready,
    s_axis_cc_tdata,
    s_axis_cc_tuser,
    s_axis_cc_tlast,
    s_axis_cc_tkeep,
    s_axis_cc_tvalid,
    s_axis_cc_tready,
    pcie_tfc_nph_av,
    pcie_tfc_npd_av,
    pcie_rq_seq_num0,
    pcie_rq_seq_num_vld0,
    pcie_rq_seq_num1,
    pcie_rq_seq_num_vld1,
    cfg_phy_link_down,
    cfg_negotiated_width,
    cfg_current_speed,
    cfg_max_payload,
    cfg_max_read_req,
     cfg_function_status,
     cfg_function_power_state,
     cfg_vf_status,
    cfg_link_power_state,
      cfg_err_cor_out,
     cfg_err_nonfatal_out,
     cfg_err_fatal_out,
    cfg_ltssm_state,
    cfg_rcb_status,
    cfg_obff_enable,
    cfg_pl_status_change,
    cfg_mgmt_addr,
     cfg_mgmt_write,
     cfg_mgmt_write_data,
     cfg_mgmt_byte_enable,
     cfg_mgmt_read,
    cfg_mgmt_read_data,
    cfg_mgmt_read_write_done,
    cfg_msg_received,
    cfg_msg_received_data,
     cfg_msg_received_type,
    cfg_msg_transmit,
      cfg_msg_transmit_type,
      cfg_msg_transmit_data,
     cfg_msg_transmit_done,
     cfg_fc_ph,
     cfg_fc_pd,
     cfg_fc_nph,
      cfg_fc_npd,
      cfg_fc_cplh,
      cfg_fc_cpld,
       cfg_fc_sel
   );    

  
    input                           iSystemClock            ; // SDR 100MHz
    input                           iDelayRefClock          ; // SDR 200Mhz
    input                           iOutputDrivingClock     ; // SDR 200Mhz
    input                           iOutputStrobeClock      ;
    input                           iReset                  ;
    input   [5:0]                   iOpcode                 ;
    input   [4:0]                   iTargetID               ;
    input   [4:0]                   iSourceID               ;
    input   [31:0]                  iAddress                ;
    input   [15:0]                  iLength                 ;
    input                           iCMDValid               ;
    output                          oCMDReady               ;
    input   [31:0]                  iWriteData              ;
    input                           iWriteLast              ;
    input                           iWriteValid             ;
    output                          oWriteReady             ;
    output  [31:0]                  oReadData               ;
    output                          oReadLast               ;
    output                          oReadValid              ;
    input                           iReadReady              ;
    output  [NumberOfWays - 1:0]    oReadyBusy              ; // bypass
    inout                           IO_NAND_DQS_P           ; // Differential: Positive
    inout                           IO_NAND_DQS_N           ; // Differential: Negative
    inout   [7:0]                   IO_NAND_DQ              ;
    output  [NumberOfWays - 1:0]    O_NAND_CE               ;
    output                          O_NAND_WE               ;
    output                          O_NAND_RE_P             ; // Differential: Positive
    output                          O_NAND_RE_N             ; // Differential: Negative
    output                          O_NAND_ALE              ;
    output                          O_NAND_CLE              ;
    input   [NumberOfWays - 1:0]    I_NAND_RB               ;
    output                          O_NAND_WP               ;
    
    input   [8:0]                   iDQSIDelayTap           ;
    input   [1:0]                        iDQSIDelayTapLoad       ;
    input   [8:0]                   iDQ0IDelayTap           ;
    input   [1:0]                        iDQ0IDelayTapLoad       ;
    input   [8:0]                   iDQ1IDelayTap           ;
    input   [1:0]                        iDQ1IDelayTapLoad       ;
    input   [8:0]                   iDQ2IDelayTap           ;
    input   [1:0]                        iDQ2IDelayTapLoad       ;
    input   [8:0]                   iDQ3IDelayTap           ;
    input   [1:0]                        iDQ3IDelayTapLoad       ;
    input   [8:0]                   iDQ4IDelayTap           ;
    input   [1:0]                        iDQ4IDelayTapLoad       ;
    input   [8:0]                   iDQ5IDelayTap           ;
    input   [1:0]                        iDQ5IDelayTapLoad       ;
    input   [8:0]                   iDQ6IDelayTap           ;
    input   [1:0]                        iDQ6IDelayTapLoad       ;
    input   [8:0]                   iDQ7IDelayTap           ;
    input   [1:0]                        iDQ7IDelayTapLoad       ;

      //FPGA IP
    input   [15:0]  ext_fifo_dout       ;
    input           ext_fifo_empty      ;
    input           ext_fifo_full       ;

    output  [15:0]  ext_fifo_din        ;
    output          ext_fifo_rd_clk     ;
    output          ext_fifo_rd_en      ;
    output          ext_fifo_wr_clk     ;
    output          ext_fifo_wr_en      ;
    output          ext_fifo_rst        ;

    //nfct4

    input                           C_AWVALID               ;
    output                          C_AWREADY               ;
    input   [31:0]                  C_AWADDR                ;
    input   [2:0]                   C_AWPROT                ;
    input                           C_WVALID                ;
    output                          C_WREADY                ;
    input   [31:0]                  C_WDATA                 ;
    input   [3:0]                   C_WSTRB                 ;
    output                          C_BVALID                ;
    input                           C_BREADY                ;
    output  [1:0]                   C_BRESP                 ;
    input                           C_ARVALID               ;
    output                          C_ARREADY               ;
    input   [31:0]                  C_ARADDR                ;
    input   [2:0]                   C_ARPROT                ;
    output                          C_RVALID                ;
    input                           C_RREADY                ;
    output  [31:0]                  C_RDATA                 ;
    output  [1:0]                   C_RRESP                 ;
    
    output  [31:0]                  D_AWADDR                ;
    output  [7:0]                   D_AWLEN                 ;
    output  [2:0]                   D_AWSIZE                ;
    output  [1:0]                   D_AWBURST               ;
    output  [3:0]                   D_AWCACHE               ;
    output  [2:0]                   D_AWPROT                ;
    output                          D_AWVALID               ;
    input                           D_AWREADY               ;
    output  [31:0]                  D_WDATA                 ;
    output  [3:0]                   D_WSTRB                 ;
    output                          D_WLAST                 ;
    output                          D_WVALID                ;
    input                           D_WREADY                ;
    input   [1:0]                   D_BRESP                 ;
    input                           D_BVALID                ;
    output                          D_BREADY                ;
    
    output  [31:0]                  D_ARADDR                ;
    output  [7:0]                   D_ARLEN                 ;
    output  [2:0]                   D_ARSIZE                ;
    output  [1:0]                   D_ARBURST               ;
    output  [3:0]                   D_ARCACHE               ;
    output  [2:0]                   D_ARPROT                ;
    output                          D_ARVALID               ;
    input                           D_ARREADY               ;
    input   [31:0]                  D_RDATA                 ;
    input   [1:0]                   D_RRESP                 ;
    input                           D_RLAST                 ;
    input                           D_RVALID                ;
    output                          D_RREADY                ;
    
    output  [5:0]                   oOpcode                 ;
    output  [4:0]                   oTargetID               ;
    output  [4:0]                   oSourceID               ;
    output  [31:0]                  oAddress                ;
    output  [15:0]                  oLength                 ;
    output                          oCMDValid               ;
    input                           iCMDReady               ;
    output  [31:0]                  oWriteData              ;
    output                          oWriteLast              ;
    output                          oWriteValid             ;
    input                           iWriteReady             ;
    input   [31:0]                  iReadData               ;
    input                           iReadLast               ;
    input                           iReadValid              ;
    output                          oReadReady              ;
    input   [NumberOfWays - 1:0]    iReadyBusy              ;
    
    output                          oROMClock               ;
    output                          oROMReset               ;
    output  [31:0]                  oROMAddr                ;
    output                          oROMRW                  ;
    output                          oROMEnable              ;
    output  [31:0]                  oROMWData               ;
    input   [31:0]                  iROMRData               ;
    
    output  [5:0]                   oToECCWOpcode           ;
    output  [4:0]                   oToECCWTargetID         ;
    output  [4:0]                   oToECCWSourceID         ;
    output  [31:0]                  oToECCWAddress          ;
    output  [15:0]                  oToECCWLength           ;
    output                          oToECCWCmdValid         ;
    input                           iToECCWCmdReady         ;
    output  [31:0]                  oToECCWData             ;
    output                          oToECCWValid            ;
    output                          oToECCWLast             ;
    input                           iToECCWReady            ;
    output  [5:0]                   oToECCROpcode           ;
    output  [4:0]                   oToECCRTargetID         ;
    output  [4:0]                   oToECCRSourceID         ;
    output  [31:0]                  oToECCRAddress          ;
    output  [15:0]                  oToECCRLength           ;
    output                          oToECCRCmdValid         ;
    input                           iToECCRCmdReady         ;
    input   [31:0]                  iToECCRData             ;
    input                           iToECCRValid            ;
    input                           iToECCRLast             ;
    output                          oToECCRReady            ;
    
    input   [5:0]                   ifromECCWOpcode         ;
    input   [4:0]                   ifromECCWTargetID       ;
    input   [4:0]                   ifromECCWSourceID       ;
    input   [31:0]                  ifromECCWAddress        ;
    input   [15:0]                  ifromECCWLength         ;
    input                           ifromECCWCmdValid       ;
    output                          ofromECCWCmdReady       ;
    input   [31:0]                  ifromECCWData           ;
    input                           ifromECCWValid          ;
    input                           ifromECCWLast           ;
    output                          ofromECCWReady          ;
    input  [5:0]                    ifromECCROpcode         ;
    input  [4:0]                    ifromECCRTargetID       ;
    input  [4:0]                    ifromECCRSourceID       ;
    input  [31:0]                   ifromECCRAddress        ;
    input  [15:0]                   ifromECCRLength         ;
    input                           ifromECCRCmdValid       ;
    output                          ofromECCRCmdReady       ;
    output   [31:0]                 ofromECCRData           ;
    output                          ofromECCRValid          ;
    output                          ofromECCRLast           ;
    input                           ifromECCRReady          ;
    
    output  [31:0]                  O_DEBUG                 ;

    //sccs_bch
               ;
    
    input   [5:0]                                                   iToECCWOpcode           ;
    input   [4:0]                                                   iToECCWTargetID         ;
    input   [4:0]                                                   iToECCWSourceID         ;
    input   [31:0]                                                  iToECCWAddress          ;
    input   [15:0]                                                  iToECCWLength           ;
    input                                                           iToECCWCmdValid         ;
    output                                                          oToECCWCmdReady         ;
    input   [31:0]                                                  iToECCWData             ;
    input                                                           iToECCWValid            ;
    input                                                           iToECCWLast             ;
    output                                                          oToECCWReady            ;
    input   [5:0]                                                   iToECCROpcode           ;
    input   [4:0]                                                   iToECCRTargetID         ;
    input   [4:0]                                                   iToECCRSourceID         ;
    input   [31:0]                                                  iToECCRAddress          ;
    input   [15:0]                                                  iToECCRLength           ;
    input                                                           iToECCRCmdValid         ;
    output                                                          oToECCRCmdReady         ;
    output  [31:0]                                                  oToECCRData             ;
    output                                                          oToECCRValid            ;
    output                                                          oToECCRLast             ;
    input                                                           iToECCRReady            ;
    
    output  [5:0]                                                   ofromECCWOpcode         ;
    output  [4:0]                                                   ofromECCWTargetID       ;
    output  [4:0]                                                   ofromECCWSourceID       ;
    output  [31:0]                                                  ofromECCWAddress        ;
    output  [15:0]                                                  ofromECCWLength         ;
    output                                                          ofromECCWCmdValid       ;
    input                                                           ifromECCWCmdReady       ;
    output  [31:0]                                                  ofromECCWData           ;
    output                                                          ofromECCWValid          ;
    output                                                          ofromECCWLast           ;
    input                                                           ifromECCWReady          ;
    output [5:0]                                                    ofromECCROpcode         ;
    output [4:0]                                                    ofromECCRTargetID       ;
    output [4:0]                                                    ofromECCRSourceID       ;
    output [31:0]                                                   ofromECCRAddress        ;
    output [15:0]                                                   ofromECCRLength         ;
    output                                                          ofromECCRCmdValid       ;
    input                                                           ifromECCRCmdReady       ;
    input    [31:0]                                                 ifromECCRData           ;
    input                                                           ifromECCRValid          ;
    input                                                           ifromECCRLast           ;
    output                                                          ofromECCRReady          ;
    
    input                                                           iSharedKESReady         ;
    output  [BCHDecMulti - 1:0]                                     oErrorDetectionEnd      ;
    output  [BCHDecMulti - 1:0]                                     oDecodeNeeded           ;
    output  [BCHDecMulti*GaloisFieldDegree*Syndromes - 1:0]         oSyndromes              ;
    input                                                           iIntraSharedKESEnd      ;
    input   [BCHDecMulti - 1:0]                                     iErroredChunk           ;
    input   [BCHDecMulti - 1:0]                                     iCorrectionFail         ;
    input   [BCHDecMulti*MaxErrorCountBits - 1:0]                   iErrorCount             ;
    input   [BCHDecMulti*GaloisFieldDegree*ELPCoefficients - 1:0]   iELPCoefficients        ;
    output                                                          oCSAvailable            ;

    //skes_bch
    // input                                               
    output                                                            oSharedKESReady_0     ;
    input   [Multi - 1:0]                                             iErrorDetectionEnd_0  ;
    input   [Multi - 1:0]                                             iDecodeNeeded_0       ;
    input   [Multi*GaloisFieldDegree*Syndromes - 1:0]                 iSyndromes_0          ;
    input                                                             iCSAvailable_0        ;
    output                                                            oIntraSharedKESEnd_0  ;
    output  [Multi - 1:0]                                             oErroredChunk_0       ;
    output  [Multi - 1:0]                                             oCorrectionFail_0     ;
    output  [Multi*MaxErrorCountBits - 1:0]                           oClusterErrorCount_0  ;
    output  [Multi*GaloisFieldDegree*ELPCoefficients - 1:0]           oELPCoefficients_0    ;
    
    output                                                            oSharedKESReady_1     ;
    input   [Multi - 1:0]                                             iErrorDetectionEnd_1  ;
    input   [Multi - 1:0]                                             iDecodeNeeded_1       ;
    input   [Multi*GaloisFieldDegree*Syndromes - 1:0]                 iSyndromes_1          ;
    input                                                             iCSAvailable_1        ;
    output                                                            oIntraSharedKESEnd_1  ;
    output  [Multi - 1:0]                                             oErroredChunk_1       ;
    output  [Multi - 1:0]                                             oCorrectionFail_1     ;
    output  [Multi*MaxErrorCountBits - 1:0]                           oClusterErrorCount_1  ;
    output  [Multi*GaloisFieldDegree*ELPCoefficients - 1:0]           oELPCoefficients_1    ;
    
    output                                                            oSharedKESReady_2     ;
    input   [Multi - 1:0]                                             iErrorDetectionEnd_2  ;
    input   [Multi - 1:0]                                             iDecodeNeeded_2       ;
    input   [Multi*GaloisFieldDegree*Syndromes - 1:0]                 iSyndromes_2          ;
    input                                                             iCSAvailable_2        ;
    output                                                            oIntraSharedKESEnd_2  ;
    output  [Multi - 1:0]                                             oErroredChunk_2       ;
    output  [Multi - 1:0]                                             oCorrectionFail_2     ;
    output  [Multi*MaxErrorCountBits - 1:0]                           oClusterErrorCount_2  ;
    output  [Multi*GaloisFieldDegree*ELPCoefficients - 1:0]           oELPCoefficients_2    ;
    
    output                                                            oSharedKESReady_3     ;
    input   [Multi - 1:0]                                             iErrorDetectionEnd_3  ;
    input   [Multi - 1:0]                                             iDecodeNeeded_3       ;
    input   [Multi*GaloisFieldDegree*Syndromes - 1:0]                 iSyndromes_3          ;
    input                                                             iCSAvailable_3        ;
    output                                                            oIntraSharedKESEnd_3  ;
    output  [Multi - 1:0]                                             oErroredChunk_3       ;
    output  [Multi - 1:0]                                             oCorrectionFail_3     ;
    output  [Multi*MaxErrorCountBits - 1:0]                           oClusterErrorCount_3  ;
    output  [Multi*GaloisFieldDegree*ELPCoefficients - 1:0]           oELPCoefficients_3    ;
    


    //nvme
    ////////////////////////////////////////////////////////////////
//AXI4-lite slave interface signals
	input									s0_axi_aclk;
	input									s0_axi_aresetn;

//Write address channel
	input	[C_S0_AXI_ADDR_WIDTH-1 : 0]		s0_axi_awaddr;
	output									s0_axi_awready;
	input									s0_axi_awvalid;
	input	[2 : 0]							s0_axi_awprot;

//Write data channel
	input									s0_axi_wvalid;
	output									s0_axi_wready;
	input	[C_S0_AXI_DATA_WIDTH-1 : 0]		s0_axi_wdata;
	input	[(C_S0_AXI_DATA_WIDTH/8)-1 : 0]	s0_axi_wstrb;

//Write response channel
	output									s0_axi_bvalid;
	input									s0_axi_bready;
	output	[1 : 0]							s0_axi_bresp;

//Read address channel
	input									s0_axi_arvalid;
	output									s0_axi_arready;
	input	[C_S0_AXI_ADDR_WIDTH-1 : 0]		s0_axi_araddr;
	input	[2 : 0]							s0_axi_arprot;

//Read data channel
	output									s0_axi_rvalid;
	input									s0_axi_rready;
	output	[C_S0_AXI_DATA_WIDTH-1 : 0]		s0_axi_rdata;
	output	[1 : 0]							s0_axi_rresp;


////////////////////////////////////////////////////////////////
//AXI4 master interface signals
	input									m0_axi_aclk;
	input									m0_axi_aresetn;

// Write address channel
	output	[C_M0_AXI_ID_WIDTH-1:0]			m0_axi_awid;
	output	[C_M0_AXI_ADDR_WIDTH-1:0]		m0_axi_awaddr;
	output	[7:0]							m0_axi_awlen;
	output	[2:0]							m0_axi_awsize;
	output	[1:0]							m0_axi_awburst;
	output									m0_axi_awlock;
	output	[3:0]							m0_axi_awcache;
	output	[2:0]							m0_axi_awprot;
	output	[3:0]							m0_axi_awregion;
	output	[3:0]							m0_axi_awqos;
	output	[C_M0_AXI_AWUSER_WIDTH-1:0]		m0_axi_awuser;
	output									m0_axi_awvalid;
	input									m0_axi_awready;

// Write data channel
	output	[C_M0_AXI_ID_WIDTH-1:0]			m0_axi_wid;
	output	[C_M0_AXI_DATA_WIDTH-1:0]		m0_axi_wdata;
	output	[(C_M0_AXI_DATA_WIDTH/8)-1:0]	m0_axi_wstrb;
	output									m0_axi_wlast;
	output	[C_M0_AXI_WUSER_WIDTH-1:0]		m0_axi_wuser;
	output									m0_axi_wvalid;
	input									m0_axi_wready;

// Write response channel
	input	[C_M0_AXI_ID_WIDTH-1:0]			m0_axi_bid;
	input	[1:0]							m0_axi_bresp;
	input									m0_axi_bvalid;
	input	[C_M0_AXI_BUSER_WIDTH-1:0]		m0_axi_buser;
	output									m0_axi_bready;

// Read address channel
	output	[C_M0_AXI_ID_WIDTH-1:0]			m0_axi_arid;
	output	[C_M0_AXI_ADDR_WIDTH-1:0]		m0_axi_araddr;
	output	[7:0]							m0_axi_arlen;
	output	[2:0]							m0_axi_arsize;
	output	[1:0]							m0_axi_arburst;
	output									m0_axi_arlock;
	output	[3:0]							m0_axi_arcache;
	output	[2:0]							m0_axi_arprot;
	output	[3:0]							m0_axi_arregion;
	output	[3:0] 							m0_axi_arqos;
	output	[C_M0_AXI_ARUSER_WIDTH-1:0]		m0_axi_aruser;
	output									m0_axi_arvalid;
	input									m0_axi_arready;

// Read data channel
	input	[C_M0_AXI_ID_WIDTH-1:0]			m0_axi_rid;
	input	[C_M0_AXI_DATA_WIDTH-1:0]		m0_axi_rdata;
	input	[1:0]							m0_axi_rresp;
	input									m0_axi_rlast;
	input	[C_M0_AXI_RUSER_WIDTH-1:0]		m0_axi_ruser;
	input									m0_axi_rvalid;
	output 									m0_axi_rready;

	output									dev_irq_assert;

	input									pcie_ref_clk_p;
	input									pcie_ref_clk_n;
	input									pcie_perst_n;

	input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txp;
	input  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_txn;
	output   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxp;
	output   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  pci_exp_rxn;
//修改后
	input									user_lnk_up;

	input                                       user_clk_out;
	input 										user_reset_out;
	input                                       phy_rdy_out;
	output                                       s_axis_rq_tlast;
	output            [C_PCIE_DATA_WIDTH-1:0]    s_axis_rq_tdata;
	output          [AXI4_RQ_TUSER_WIDTH-1:0]    s_axis_rq_tuser;
	output                   [KEEP_WIDTH-1:0]    s_axis_rq_tkeep;
	input                              [3:0]    s_axis_rq_tready;
	output                                       s_axis_rq_tvalid;
	
	input             [C_PCIE_DATA_WIDTH-1:0]    m_axis_rc_tdata;
	input           [AXI4_RC_TUSER_WIDTH-1:0]    m_axis_rc_tuser;
	input                                        m_axis_rc_tlast;
	input                    [KEEP_WIDTH-1:0]    m_axis_rc_tkeep;
	output                                       m_axis_rc_tvalid;
	input                                       m_axis_rc_tready;
	
	input            [C_PCIE_DATA_WIDTH-1:0]    m_axis_cq_tdata;
	input          [AXI4_CQ_TUSER_WIDTH-1:0]    m_axis_cq_tuser;
	input                                       m_axis_cq_tlast;
	input                   [KEEP_WIDTH-1:0]    m_axis_cq_tkeep;
	output                                       m_axis_cq_tvalid;
	input                                       m_axis_cq_tready;

	
	output             [C_PCIE_DATA_WIDTH-1:0]    s_axis_cc_tdata;
	output           [AXI4_CC_TUSER_WIDTH-1:0]    s_axis_cc_tuser;
	output                                        s_axis_cc_tlast;
	output                    [KEEP_WIDTH-1:0]    s_axis_cc_tkeep;
	output                                       s_axis_cc_tvalid;
	input                               [3:0]    s_axis_cc_tready;

	input                              [3:0]    pcie_tfc_nph_av;
	input                              [3:0]    pcie_tfc_npd_av;

	input                              [5:0]    pcie_rq_seq_num0;
	input                                       pcie_rq_seq_num_vld0;
	input                              [5:0]    pcie_rq_seq_num1;
	input                                       pcie_rq_seq_num_vld1;
	
	input                                       cfg_phy_link_down;
	input                              [2:0]    cfg_negotiated_width;
	input                              [1:0]    cfg_current_speed;
	input                              [1:0]    cfg_max_payload;
	input                              [2:0]    cfg_max_read_req;
	input                              [15:0]    cfg_function_status;
	input                              [11:0]    cfg_function_power_state;
	input                             [503:0]    cfg_vf_status;
	input                              [1:0]    cfg_link_power_state;

		// Error Reporting Interface
	input                                         cfg_err_cor_out;
	input                                        cfg_err_nonfatal_out;
	input                                        cfg_err_fatal_out;

	input                              [5:0]    cfg_ltssm_state;
	input                              [3:0]    cfg_rcb_status;
	input                              [1:0]    cfg_obff_enable;
	input                                       cfg_pl_status_change;

	// Management Interface
	output                             [9:0]    cfg_mgmt_addr;
	output                                       cfg_mgmt_write;
	output                             [31:0]    cfg_mgmt_write_data;
	output                              [3:0]    cfg_mgmt_byte_enable;
	output                                       cfg_mgmt_read;
	input                             [31:0]    cfg_mgmt_read_data;
	input                                       cfg_mgmt_read_write_done;
	input                                       cfg_msg_received;
	input                              [7:0]    cfg_msg_received_data;
	input                              [4:0]    cfg_msg_received_type;
	output                                     cfg_msg_transmit;
	output                              [2:0]    cfg_msg_transmit_type;
	output                             [31:0]    cfg_msg_transmit_data;
	input                                       cfg_msg_transmit_done;
	input                              [7:0]    cfg_fc_ph;
	input                             [11:0]    cfg_fc_pd;
	input                              [7:0]    cfg_fc_nph;
	input                             [11:0]    cfg_fc_npd;
	input                              [7:0]    cfg_fc_cplh;
	input                             [11:0]    cfg_fc_cpld;
	output                              [2:0]    cfg_fc_sel;

    s_axi_nvme u_s_axi_nvme (
    .s0_axi_aclk(s0_axi_aclk),
    .s0_axi_aresetn(s0_axi_aresetn),
    .s0_axi_awaddr(s0_axi_awaddr),
    .s0_axi_awready(s0_axi_awready),
    .s0_axi_awvalid(s0_axi_awvalid),
    .s0_axi_awprot(s0_axi_awprot),
    .s0_axi_wvalid(s0_axi_wvalid),
    .s0_axi_wready(s0_axi_wready),
    .s0_axi_wdata(s0_axi_wdata),
    .s0_axi_wstrb(s0_axi_wstrb),
    .s0_axi_bvalid(s0_axi_bvalid),
    .s0_axi_bready(s0_axi_bready),
    .s0_axi_bresp(s0_axi_bresp),
    .s0_axi_arvalid(s0_axi_arvalid),
    .s0_axi_arready(s0_axi_arready),
    .s0_axi_araddr(s0_axi_araddr),
    .s0_axi_arprot(s0_axi_arprot),
    .s0_axi_rvalid(s0_axi_rvalid),
    .s0_axi_rready(s0_axi_rready),
    .s0_axi_rdata(s0_axi_rdata),
    .s0_axi_rresp(s0_axi_rresp),
    .m0_axi_aclk(m0_axi_aclk),
    .m0_axi_aresetn(m0_axi_aresetn),
    .m0_axi_awid(m0_axi_awid),
    .m0_axi_awaddr(m0_axi_awaddr),
    .m0_axi_awlen(m0_axi_awlen),
    .m0_axi_awsize(m0_axi_awsize),
    .m0_axi_awburst(m0_axi_awburst),
    .m0_axi_awlock(m0_axi_awlock),
    .m0_axi_awcache(m0_axi_awcache),
    .m0_axi_awprot(m0_axi_awprot),
    .m0_axi_awregion(m0_axi_awregion),
    .m0_axi_awqos(m0_axi_awqos),
    .m0_axi_awuser(m0_axi_awuser),
    .m0_axi_awvalid(m0_axi_awvalid),
    .m0_axi_awready(m0_axi_awready),
    .m0_axi_wid(m0_axi_wid),
    .m0_axi_wdata(m0_axi_wdata),
    .m0_axi_wstrb(m0_axi_wstrb),
    .m0_axi_wlast(m0_axi_wlast),
    .m0_axi_wuser(m0_axi_wuser),
    .m0_axi_wvalid(m0_axi_wvalid),
    .m0_axi_wready(m0_axi_wready),
    .m0_axi_bid(m0_axi_bid),
    .m0_axi_bresp(m0_axi_bresp),
    .m0_axi_bvalid(m0_axi_bvalid),
    .m0_axi_buser(m0_axi_buser),
    .m0_axi_bready(m0_axi_bready),
    .m0_axi_arid(m0_axi_arid),
    .m0_axi_araddr(m0_axi_araddr),
    .m0_axi_arlen(m0_axi_arlen),
    .m0_axi_arsize(m0_axi_arsize),
    .m0_axi_arburst(m0_axi_arburst),
    .m0_axi_arlock(m0_axi_arlock),
    .m0_axi_arcache(m0_axi_arcache),
    .m0_axi_arprot(m0_axi_arprot),
    .m0_axi_arregion(m0_axi_arregion),
    .m0_axi_arqos(m0_axi_arqos),
    .m0_axi_aruser(m0_axi_aruser),
    .m0_axi_arvalid(m0_axi_arvalid),
    .m0_axi_arready(m0_axi_arready),
    .m0_axi_rid(m0_axi_rid),
    .m0_axi_rdata(m0_axi_rdata),
    .m0_axi_rresp(m0_axi_rresp),
    .m0_axi_rlast(m0_axi_rlast),
    .m0_axi_ruser(m0_axi_ruser),
    .m0_axi_rvalid(m0_axi_rvalid),
    .m0_axi_rready(m0_axi_rready),
    .dev_irq_assert(dev_irq_assert),
    .pcie_ref_clk_p(pcie_ref_clk_p),
    .pcie_ref_clk_n(pcie_ref_clk_n),
    .pcie_perst_n(pcie_perst_n),
    .pci_exp_txp(pci_exp_txp),
    .pci_exp_txn(pci_exp_txn),
    .pci_exp_rxp(pci_exp_rxp),
    .pci_exp_rxn(pci_exp_rxn),
    .user_lnk_up(user_lnk_up),
    .user_clk_out(user_clk_out),
    .user_reset_out(user_reset_out),
    .phy_rdy_out(phy_rdy_out),
    .s_axis_rq_tlast(s_axis_rq_tlast),
    .s_axis_rq_tdata(s_axis_rq_tdata),
    .s_axis_rq_tuser(s_axis_rq_tuser),
    .s_axis_rq_tkeep(s_axis_rq_tkeep),
    .s_axis_rq_tready(s_axis_rq_tready),
    .s_axis_rq_tvalid(s_axis_rq_tvalid),
    .m_axis_rc_tdata(m_axis_rc_tdata),
    .m_axis_rc_tuser(m_axis_rc_tuser),
    .m_axis_rc_tlast(m_axis_rc_tlast),
    .m_axis_rc_tkeep(m_axis_rc_tkeep),
    .m_axis_rc_tvalid(m_axis_rc_tvalid),
    .m_axis_rc_tready(m_axis_rc_tready),
    .m_axis_cq_tdata(m_axis_cq_tdata),
    .m_axis_cq_tuser(m_axis_cq_tuser),
    .m_axis_cq_tlast(m_axis_cq_tlast),
    .m_axis_cq_tkeep(m_axis_cq_tkeep),
    .m_axis_cq_tvalid(m_axis_cq_tvalid),
    .m_axis_cq_tready(m_axis_cq_tready),
    .s_axis_cc_tdata(s_axis_cc_tdata),
    .s_axis_cc_tuser(s_axis_cc_tuser),
    .s_axis_cc_tlast(s_axis_cc_tlast),
    .s_axis_cc_tkeep(s_axis_cc_tkeep),
    .s_axis_cc_tvalid(s_axis_cc_tvalid),
    .s_axis_cc_tready(s_axis_cc_tready),
    .pcie_tfc_nph_av(pcie_tfc_nph_av),
    .pcie_tfc_npd_av(pcie_tfc_npd_av),
    .pcie_rq_seq_num0(pcie_rq_seq_num0),
    .pcie_rq_seq_num_vld0(pcie_rq_seq_num_vld0),
    .pcie_rq_seq_num1(pcie_rq_seq_num1),
    .pcie_rq_seq_num_vld1(pcie_rq_seq_num_vld1),
    .cfg_phy_link_down(cfg_phy_link_down),
    .cfg_negotiated_width(cfg_negotiated_width),
    .cfg_current_speed(cfg_current_speed),
    .cfg_max_payload(cfg_max_payload),
    .cfg_max_read_req(cfg_max_read_req),
    .cfg_function_status(cfg_function_status),
    .cfg_function_power_state(cfg_function_power_state),
    .cfg_vf_status(cfg_vf_status),
    .cfg_link_power_state(cfg_link_power_state),
    .cfg_err_cor_out(cfg_err_cor_out),
    .cfg_err_nonfatal_out(cfg_err_nonfatal_out),
    .cfg_err_fatal_out(cfg_err_fatal_out),
    .cfg_ltssm_state(cfg_ltssm_state),
    .cfg_rcb_status(cfg_rcb_status),
    .cfg_obff_enable(cfg_obff_enable),
    .cfg_pl_status_change(cfg_pl_status_change),
    .cfg_mgmt_addr(cfg_mgmt_addr),
    .cfg_mgmt_write(cfg_mgmt_write),
    .cfg_mgmt_write_data(cfg_mgmt_write_data),
    .cfg_mgmt_byte_enable(cfg_mgmt_byte_enable),
    .cfg_mgmt_read(cfg_mgmt_read),
    .cfg_mgmt_read_data(cfg_mgmt_read_data),
    .cfg_mgmt_read_write_done(cfg_mgmt_read_write_done),
    .cfg_msg_received(cfg_msg_received),
    .cfg_msg_received_data(cfg_msg_received_data),
    .cfg_msg_received_type(cfg_msg_received_type),
    .cfg_msg_transmit(cfg_msg_transmit),
    .cfg_msg_transmit_type(cfg_msg_transmit_type),
    .cfg_msg_transmit_data(cfg_msg_transmit_data),
    .cfg_msg_transmit_done(cfg_msg_transmit_done),
    .cfg_fc_ph(cfg_fc_ph),
    .cfg_fc_pd(cfg_fc_pd),
    .cfg_fc_nph(cfg_fc_nph),
    .cfg_fc_npd(cfg_fc_npd),
    .cfg_fc_cplh(cfg_fc_cplh),
    .cfg_fc_cpld(cfg_fc_cpld),
    .cfg_fc_sel(cfg_fc_sel),
    .cfg_dsn(cfg_dsn),
    .cfg_power_state_change_interrupt(cfg_power_state_change_interrupt),
    .cfg_power_state_change_ack(cfg_power_state_change_ack),
    .cfg_err_cor_in(cfg_err_cor_in),
    .cfg_err_uncor_in(cfg_err_uncor_in),
    .cfg_flr_in_process(cfg_flr_in_process),
    .cfg_flr_done(cfg_flr_done),
    .cfg_vf_flr_in_process(cfg_vf_flr_in_process),
    .cfg_vf_flr_done(cfg_vf_flr_done),
    .cfg_vf_flr_func_num(cfg_vf_flr_func_num),
    .cfg_link_training_enable(cfg_link_training_enable),
    .cfg_interrupt_int(cfg_interrupt_int),
    .cfg_interrupt_pending(cfg_interrupt_pending),
    .cfg_interrupt_sent(cfg_interrupt_sent),
    .cfg_interrupt_msi_enable(cfg_interrupt_msi_enable),
    .cfg_interrupt_msi_mmenable(cfg_interrupt_msi_mmenable),
    .cfg_interrupt_msi_mask_update(cfg_interrupt_msi_mask_update),
    .cfg_interrupt_msi_data(cfg_interrupt_msi_data),
    .cfg_interrupt_msi_select(cfg_interrupt_msi_select),
    .cfg_interrupt_msi_int(cfg_interrupt_msi_int),
    .cfg_interrupt_msi_pending_status(cfg_interrupt_msi_pending_status),
    .cfg_interrupt_msi_sent(cfg_interrupt_msi_sent),
    .cfg_interrupt_msi_fail(cfg_interrupt_msi_fail),
    .cfg_interrupt_msi_attr(cfg_interrupt_msi_attr),
    .cfg_interrupt_msi_tph_present(cfg_interrupt_msi_tph_present),
    .cfg_interrupt_msi_tph_type(cfg_interrupt_msi_tph_type),
    .cfg_interrupt_msi_tph_st_tag(cfg_interrupt_msi_tph_st_tag),
    .cfg_interrupt_msi_function_number(cfg_interrupt_msi_function_number),
    .cfg_interrupt_msi_pending_status_data_enable(cfg_interrupt_msi_pending_status_data_enable),
    .cfg_hot_reset_out(cfg_hot_reset_out),
    .cfg_config_space_enable(cfg_config_space_enable),
    .cfg_req_pm_transition_l23_ready(cfg_req_pm_transition_l23_ready),
    .cfg_hot_reset_in(cfg_hot_reset_in),
    .cfg_ds_port_number(cfg_ds_port_number),
    .cfg_ds_bus_number(cfg_ds_bus_number),
    .cfg_ds_device_number(cfg_ds_device_number),
    .sys_clk(sys_clk),
    .sys_clk_gt(sys_clk_gt),
    .pcie_perst_n_c(pcie_perst_n_c)
);

//sccs
BCHSCCS u_BCHSCCS (
    .iClock(iClock),
    .iReset(iReset),
    .iToECCWOpcode(iToECCWOpcode),
    .iToECCWTargetID(iToECCWTargetID),
    .iToECCWSourceID(iToECCWSourceID),
    .iToECCWAddress(iToECCWAddress),
    .iToECCWLength(iToECCWLength),
    .iToECCWCmdValid(iToECCWCmdValid),
    .oToECCWCmdReady(oToECCWCmdReady),
    .iToECCWData(iToECCWData),
    .iToECCWValid(iToECCWValid),
    .iToECCWLast(iToECCWLast),
    .oToECCWReady(oToECCWReady),
    .iToECCROpcode(iToECCROpcode),
    .iToECCRTargetID(iToECCRTargetID),
    .iToECCRSourceID(iToECCRSourceID),
    .iToECCRAddress(iToECCRAddress),
    .iToECCRLength(iToECCRLength),
    .iToECCRCmdValid(iToECCRCmdValid),
    .oToECCRCmdReady(oToECCRCmdReady),
    .oToECCRData(oToECCRData),
    .oToECCRValid(oToECCRValid),
    .oToECCRLast(oToECCRLast),
    .iToECCRReady(iToECCRReady),
    .ofromECCWOpcode(ofromECCWOpcode),
    .ofromECCWTargetID(ofromECCWTargetID),
    .ofromECCWSourceID(ofromECCWSourceID),
    .ofromECCWAddress(ofromECCWAddress),
    .ofromECCWLength(ofromECCWLength),
    .ofromECCWCmdValid(ofromECCWCmdValid),
    .ifromECCWCmdReady(ifromECCWCmdReady),
    .ofromECCWData(ofromECCWData),
    .ofromECCWValid(ofromECCWValid),
    .ofromECCWLast(ofromECCWLast),
    .ifromECCWReady(ifromECCWReady),
    .ofromECCROpcode(ofromECCROpcode),
    .ofromECCRTargetID(ofromECCRTargetID),
    .ofromECCRSourceID(ofromECCRSourceID),
    .ofromECCRAddress(ofromECCRAddress),
    .ofromECCRLength(ofromECCRLength),
    .ofromECCRCmdValid(ofromECCRCmdValid),
    .ifromECCRCmdReady(ifromECCRCmdReady),
    .ifromECCRData(ifromECCRData),
    .ifromECCRValid(ifromECCRValid),
    .ifromECCRLast(ifromECCRLast),
    .ofromECCRReady(ofromECCRReady),
    .iSharedKESReady(iSharedKESReady),
    .oErrorDetectionEnd(oErrorDetectionEnd),
    .oDecodeNeeded(oDecodeNeeded),
    .oSyndromes(oSyndromes),
    .iIntraSharedKESEnd(iIntraSharedKESEnd),
    .iErroredChunk(iErroredChunk),
    .iCorrectionFail(iCorrectionFail),
    .iErrorCount(iErrorCount),
    .iELPCoefficients(iELPCoefficients),
    .oCSAvailable(oCSAvailable)
);

//skes
SharedKESTop u_SharedKESTop (
    .iClock(iClock),
    .iReset(iReset),

    .oSharedKESReady_0(oSharedKESReady_0),
    .iErrorDetectionEnd_0(iErrorDetectionEnd_0),
    .iDecodeNeeded_0(iDecodeNeeded_0),
    .iSyndromes_0(iSyndromes_0),
    .iCSAvailable_0(iCSAvailable_0),
    .oIntraSharedKESEnd_0(oIntraSharedKESEnd_0),
    .oErroredChunk_0(oErroredChunk_0),
    .oCorrectionFail_0(oCorrectionFail_0),
    .oClusterErrorCount_0(oClusterErrorCount_0),
    .oELPCoefficients_0(oELPCoefficients_0),

    .oSharedKESReady_1(oSharedKESReady_1),
    .iErrorDetectionEnd_1(iErrorDetectionEnd_1),
    .iDecodeNeeded_1(iDecodeNeeded_1),
    .iSyndromes_1(iSyndromes_1),
    .iCSAvailable_1(iCSAvailable_1),
    .oIntraSharedKESEnd_1(oIntraSharedKESEnd_1),
    .oErroredChunk_1(oErroredChunk_1),
    .oCorrectionFail_1(oCorrectionFail_1),
    .oClusterErrorCount_1(oClusterErrorCount_1),
    .oELPCoefficients_1(oELPCoefficients_1),

    .oSharedKESReady_2(oSharedKESReady_2),
    .iErrorDetectionEnd_2(iErrorDetectionEnd_2),
    .iDecodeNeeded_2(iDecodeNeeded_2),
    .iSyndromes_2(iSyndromes_2),
    .iCSAvailable_2(iCSAvailable_2),
    .oIntraSharedKESEnd_2(oIntraSharedKESEnd_2),
    .oErroredChunk_2(oErroredChunk_2),
    .oCorrectionFail_2(oCorrectionFail_2),
    .oClusterErrorCount_2(oClusterErrorCount_2),
    .oELPCoefficients_2(oELPCoefficients_2),

    .oSharedKESReady_3(oSharedKESReady_3),
    .iErrorDetectionEnd_3(iErrorDetectionEnd_3),
    .iDecodeNeeded_3(iDecodeNeeded_3),
    .iSyndromes_3(iSyndromes_3),
    .iCSAvailable_3(iCSAvailable_3),
    .oIntraSharedKESEnd_3(oIntraSharedKESEnd_3),
    .oErroredChunk_3(oErroredChunk_3),
    .oCorrectionFail_3(oCorrectionFail_3),
    .oClusterErrorCount_3(oClusterErrorCount_3),
    .oELPCoefficients_3(oELPCoefficients_3)
);


//nfct4
FMCTop u_FMCTop (
    .iClock(iClock),
    .iReset(iReset),
    .C_AWVALID(C_AWVALID),
    .C_AWREADY(C_AWREADY),
    .C_AWADDR(C_AWADDR),
    .C_AWPROT(C_AWPROT),
    .C_WVALID(C_WVALID),
    .C_WREADY(C_WREADY),
    .C_WDATA(C_WDATA),
    .C_WSTRB(C_WSTRB),
    .C_BVALID(C_BVALID),
    .C_BREADY(C_BREADY),
    .C_BRESP(C_BRESP),
    .C_ARVALID(C_ARVALID),
    .C_ARREADY(C_ARREADY),
    .C_ARADDR(C_ARADDR),
    .C_ARPROT(C_ARPROT),
    .C_RVALID(C_RVALID),
    .C_RREADY(C_RREADY),
    .C_RDATA(C_RDATA),
    .C_RRESP(C_RRESP),
    .D_AWADDR(D_AWADDR),
    .D_AWLEN(D_AWLEN),
    .D_AWSIZE(D_AWSIZE),
    .D_AWBURST(D_AWBURST),
    .D_AWCACHE(D_AWCACHE),
    .D_AWPROT(D_AWPROT),
    .D_AWVALID(D_AWVALID),
    .D_AWREADY(D_AWREADY),
    .D_WDATA(D_WDATA),
    .D_WSTRB(D_WSTRB),
    .D_WLAST(D_WLAST),
    .D_WVALID(D_WVALID),
    .D_WREADY(D_WREADY),
    .D_BRESP(D_BRESP),
    .D_BVALID(D_BVALID),
    .D_BREADY(D_BREADY),
    .D_ARADDR(D_ARADDR),
    .D_ARLEN(D_ARLEN),
    .D_ARSIZE(D_ARSIZE),
    .D_ARBURST(D_ARBURST),
    .D_ARCACHE(D_ARCACHE),
    .D_ARPROT(D_ARPROT),
    .D_ARVALID(D_ARVALID),
    .D_ARREADY(D_ARREADY),
    .D_RDATA(D_RDATA),
    .D_RRESP(D_RRESP),
    .D_RLAST(D_RLAST),
    .D_RVALID(D_RVALID),
    .D_RREADY(D_RREADY),
    .oOpcode(oOpcode),
    .oTargetID(oTargetID),
    .oSourceID(oSourceID),
    .oAddress(oAddress),
    .oLength(oLength),
    .oCMDValid(oCMDValid),
    .iCMDReady(iCMDReady),
    .oWriteData(oWriteData),
    .oWriteLast(oWriteLast),
    .oWriteValid(oWriteValid),
    .iWriteReady(iWriteReady),
    .iReadData(iReadData),
    .iReadLast(iReadLast),
    .iReadValid(iReadValid),
    .oReadReady(oReadReady),
    .iReadyBusy(iReadyBusy),
    .oROMClock(oROMClock),
    .oROMReset(oROMReset),
    .oROMAddr(oROMAddr),
    .oROMRW(oROMRW),
    .oROMEnable(oROMEnable),
    .oROMWData(oROMWData),
    .iROMRData(iROMRData),
    .oToECCWOpcode(oToECCWOpcode),
    .oToECCWTargetID(oToECCWTargetID),
    .oToECCWSourceID(oToECCWSourceID),
    .oToECCWAddress(oToECCWAddress),
    .oToECCWLength(oToECCWLength),
    .oToECCWCmdValid(oToECCWCmdValid),
    .iToECCWCmdReady(iToECCWCmdReady),
    .oToECCWData(oToECCWData),
    .oToECCWValid(oToECCWValid),
    .oToECCWLast(oToECCWLast),
    .iToECCWReady(iToECCWReady),
    .oToECCROpcode(oToECCROpcode),
    .oToECCRTargetID(oToECCRTargetID),
    .oToECCRSourceID(oToECCRSourceID),
    .oToECCRAddress(oToECCRAddress),
    .oToECCRLength(oToECCRLength),
    .oToECCRCmdValid(oToECCRCmdValid),
    .iToECCRCmdReady(iToECCRCmdReady),
    .iToECCRData(iToECCRData),
    .iToECCRValid(iToECCRValid),
    .iToECCRLast(iToECCRLast),
    .oToECCRReady(oToECCRReady),
    .ifromECCWOpcode(ifromECCWOpcode),
    .ifromECCWTargetID(ifromECCWTargetID),
    .ifromECCWSourceID(ifromECCWSourceID),
    .ifromECCWAddress(ifromECCWAddress),
    .ifromECCWLength(ifromECCWLength),
    .ifromECCWCmdValid(ifromECCWCmdValid),
    .ofromECCWCmdReady(ofromECCWCmdReady),
    .ifromECCWData(ifromECCWData),
    .ifromECCWValid(ifromECCWValid),
    .ifromECCWLast(ifromECCWLast),
    .ofromECCWReady(ofromECCWReady),
    .ifromECCROpcode(ifromECCROpcode),
    .ifromECCRTargetID(ifromECCRTargetID),
    .ifromECCRSourceID(ifromECCRSourceID),
    .ifromECCRAddress(ifromECCRAddress),
    .ifromECCRLength(ifromECCRLength),
    .ifromECCRCmdValid(ifromECCRCmdValid),
    .ofromECCRCmdReady(ofromECCRCmdReady),
    .ofromECCRData(ofromECCRData),
    .ofromECCRValid(ofromECCRValid),
    .ofromECCRLast(ofromECCRLast),
    .ifromECCRReady(ifromECCRReady),
    .O_DEBUG(O_DEBUG)
);

  NFC_Toggle_Top_DDR100 u_NFC_Toggle_Top_DDR100 (
    .iSystemClock(iSystemClock),
    .iDelayRefClock(iDelayRefClock),
    .iOutputDrivingClock(iOutputDrivingClock),
    .iOutputStrobeClock(iOutputStrobeClock),
    .iReset(iReset),
    .iOpcode(iOpcode),
    .iTargetID(iTargetID),
    .iSourceID(iSourceID),
    .iAddress(iAddress),
    .iLength(iLength),
    .iCMDValid(iCMDValid),
    .oCMDReady(oCMDReady),
    .iWriteData(iWriteData),
    .iWriteLast(iWriteLast),
    .iWriteValid(iWriteValid),
    .oWriteReady(oWriteReady),
    .oReadData(oReadData),
    .oReadLast(oReadLast),
    .oReadValid(oReadValid),
    .iReadReady(iReadReady),
    .oReadyBusy(oReadyBusy),
    .IO_NAND_DQS_P(IO_NAND_DQS_P),
    .IO_NAND_DQS_N(IO_NAND_DQS_N),
    .IO_NAND_DQ(IO_NAND_DQ),
    .O_NAND_CE(O_NAND_CE),
    .O_NAND_WE(O_NAND_WE),
    .O_NAND_RE_P(O_NAND_RE_P),
    .O_NAND_RE_N(O_NAND_RE_N),
    .O_NAND_ALE(O_NAND_ALE),
    .O_NAND_CLE(O_NAND_CLE),
    .I_NAND_RB(I_NAND_RB),
    .O_NAND_WP(O_NAND_WP),
    .iDQSIDelayTap(iDQSIDelayTap),
    .iDQSIDelayTapLoad(iDQSIDelayTapLoad),
    .iDQ0IDelayTap(iDQ0IDelayTap),
    .iDQ0IDelayTapLoad(iDQ0IDelayTapLoad),
    .iDQ1IDelayTap(iDQ1IDelayTap),
    .iDQ1IDelayTapLoad(iDQ1IDelayTapLoad),
    .iDQ2IDelayTap(iDQ2IDelayTap),
    .iDQ2IDelayTapLoad(iDQ2IDelayTapLoad),
    .iDQ3IDelayTap(iDQ3IDelayTap),
    .iDQ3IDelayTapLoad(iDQ3IDelayTapLoad),
    .iDQ4IDelayTap(iDQ4IDelayTap),
    .iDQ4IDelayTapLoad(iDQ4IDelayTapLoad),
    .iDQ5IDelayTap(iDQ5IDelayTap),
    .iDQ5IDelayTapLoad(iDQ5IDelayTapLoad),
    .iDQ6IDelayTap(iDQ6IDelayTap),
    .iDQ6IDelayTapLoad(iDQ6IDelayTapLoad),
    .iDQ7IDelayTap(iDQ7IDelayTap),
    .iDQ7IDelayTapLoad(iDQ7IDelayTapLoad),
    .ext_fifo_dout(ext_fifo_dout),
    .ext_fifo_empty(ext_fifo_empty),
    .ext_fifo_full(ext_fifo_full),
    .ext_fifo_din(ext_fifo_din),
    .ext_fifo_rd_clk(ext_fifo_rd_clk),
    .ext_fifo_rd_en(ext_fifo_rd_en),
    .ext_fifo_wr_clk(ext_fifo_wr_clk),
    .ext_fifo_wr_en(ext_fifo_wr_en),
    .ext_fifo_rst(ext_fifo_rst)
);

endmodule
