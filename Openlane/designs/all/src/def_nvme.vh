

`define		D_CAP_MQES					16'hFF			//Max queue entries: 256
`define		D_CAP_CQR					1'h1			//Queues are required to be physically contiguous memory
`define		D_CAP_AMS					2'h0			//Not Support Weighted Round Robin with Urgent and Vendor Specific
`define		D_CAP_TO					8'h20			//Timeout: (32 * 500) ms

//DWORD 01
`define		D_CAP_DSTRD					4'h0			//Doorbell stride of (2 ^ (2 + 0)): 4
`define		D_CAP_NSSRS					1'h0			//Not support NVM Subsystem Reset
`define		D_CAP_CSS					8'h1			//Support NVM command set
`define		D_CAP_MPSMIN				4'h0			//Max memory page size: (2 ^ (12 + 0)) : 4KB
`define		D_CAP_MPSMAX				4'h0			//Min memory page size: (2 ^ (12 + 0)) : 4KB

//08h ~ 0Bh, Version,VS
//DWORD 02
`define		D_VS_MNR					8'h1
`define		D_VS_MJR					16'h1

//0Ch ~ 0Fh, Interrupt Mask Set, INTMS
//DWORD 03
`define		D_INTMS						32'h0

//10h ~ 13h, Interrupt Mask Clear, INTMC
//DWORD 04

//14h ~ 17h, Controller Configuration, CC
//DWORD 05
`define		D_CC_IOCQES					32'h0

//18h ~ 1Bh, Reserved ,Reserved
//DWORD 06

//1Ch ~ 1Fh, Controller Status, CSTS
//DWORD 07
`define		D_CSTS_RDY					1'h0
`define		D_CSTS_CFS					1'h0
`define		D_CSTS_SHST					2'h0
`define		D_CSTS_NSSRO				1'h0

//20h ~ 23h, NVM Subsystem Reset (Optional), NSSR
//DWORD 08
`define		D_NSSR						32'h4E564D65

//24h ~ 27h, Admin Queue Attributes, AQA
//DWORD 09
`define		D_AQA_ASQS					12'h0
`define		D_AQA_ACQS					12'h0


//28h ~ 2Fh, Admin Submission Queue Base Address, ASQ
//DWORD 0A
`define		D_ASQ_ASQB					52'h0

//30h ~ 37h, Admin Completion Queue Base Address, ACQ
//DWORD 0C
`define		D_ACQ_ACQB					52'h0

`define		D_DWORD_00					{`D_CAP_TO, 4'h0, `D_CAP_AMS, `D_CAP_CQR, `D_CAP_MQES}
`define		D_DWORD_01					{8'h0, `D_CAP_MPSMAX, `D_CAP_MPSMIN, 3'h0, `D_CAP_CSS, `D_CAP_NSSRS, `D_CAP_DSTRD}
`define		D_DWORD_02					{`D_VS_MJR, `D_VS_MNR, 8'b0}
`define		D_DWORD_03					{`D_INTMS}
`define		D_DWORD_05					{`D_CC}
`define		D_DWORD_07					{27'h0, `D_CSTS_NSSRO, `D_CSTS_SHST, `D_CSTS_CFS, `D_CSTS_RDY}
`define		D_DWORD_09					{4'h0, `D_AQA_ACQS, 4'h0, `D_AQA_ASQS}
`define		D_DWORD_0A					{`D_ASQ_ASQB, 12'h0}
`define		D_DWORD_0C					{`D_ACQ_ACQB, 12'h0}


