




`define D_BCH_ENC_P_LVL 8 // data area BCH encoder parallel level, 8bit I/F with NAND

`define D_BCH_ENC_I_CNT 256 // data area BCH encoder input loop count, 256B chunk / 8b = 256
`define D_BCH_ENC_I_CNT_BIT 9 // must be bigger than D_BCH_ENC_I_CNT, 2^8 = 256

`define D_BCH_ENC_PRT_LENGTH 168 // data area parity length, 14b * 12b/b = 168b
`define D_BCH_ENC_O_CNT 21 // data area BCH encoder output loop count, 168b / 8b = 21
